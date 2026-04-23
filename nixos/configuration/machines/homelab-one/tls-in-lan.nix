{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "tls-in-lan";
  cfg = config.myModules."${moduleName}";
in
{
  options.myModules."${moduleName}" = {
    enable = lib.mkEnableOption "${moduleName}";
    rootCaCrtPath = lib.mkOption {
      type = lib.types.path;
      example = "./certificates/root-ca.crt";
      description = "path in repo to the root-ca.crt, clients should trust this";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      stepCaSecretConfig = {
        owner = "step-ca";
        # TODO: maybe restart more units that depend on this
        restartUnits = [ "step-ca.service" ];
        sopsFile = ../../../../secrets/step-ca.yaml;
      };
      secretsRuntimePath = "/run/secrets";
      # test with `systemd-analyze security step-ca.service`
      hardenedSystemdConfig = {
        AmbientCapabilities = "";

        ProtectSystem = "strict";
        ProtectHome = true;
        ProtectHostname = true;
        ProtectProc = "noaccess";
        ProcSubset = "pid";
        ProtectClock = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectControlGroups = true;
        ProtectKernelTunables = true;

        NoNewPrivileges = true;
        DynamicUser = true;

        PrivateTmp = true;
        PrivateDevices = true;
        PrivateUsers = true;
        PrivateMounts = true;

        MemoryDenyWriteExecute = true;
        LockPersonality = true;

        RestrictNamespaces = true;

        # TODO: isolate service networks
        RestrictAddressFamilies = "AF_INET"; # only ipv4
        # PrivateNetwork = true; # only loopback
      };

    in
    {
      # make secrets available
      sops.secrets."root-ca/public-cert" = stepCaSecretConfig;
      sops.secrets."intermediate-ca/public-cert" = stepCaSecretConfig;
      sops.secrets."intermediate-ca/private-password" = stepCaSecretConfig;
      sops.secrets."intermediate-ca/private-key" = stepCaSecretConfig;

      services.step-ca = {
        enable = true;
        openFirewall = false;
        # overrides config
        address = config.extraLib.localAddress;
        port = config.globals.ports.stepCa;
        intermediatePasswordFile = "${secretsRuntimePath}/intermediate-ca/private-password";
        package = pkgs.step-ca;
        settings = {
          root = "${secretsRuntimePath}/root-ca/public-cert";
          crt = "${secretsRuntimePath}/intermediate-ca/public-cert";
          key = "${secretsRuntimePath}/intermediate-ca/private-key";
          address = config.extraLib.localAddressWithPortFor "stepCa";
          # it seems the first name in the list decides which hostname has to be used
          # for the acme client setup (email, and server address)
          dnsNames = [
            config.extraLib.localHostname
          ];
          logger = {
            format = "text";
          };
          db = {
            type = "badgerv2";
            dataSource = "/var/lib/step-ca/db";
          };
          authority = {
            provisioners = [
              {
                type = "ACME";
                name = "acme";
                claims = {
                  minTLSCertDuration = "5m";
                  maxTLSCertDuration = "24h";
                  defaultTLSCertDuration = "24h";
                  disableRenewal = false;
                };
              }
            ];
          };
          policy = {
            x509 = {
              allow = {
                dns = [ config.extraLib.localHostname ];
                ip = [ config.extraLib.localAddress ];
              };
              deny = {
                ip = [ "0.0.0.0/0" ];
              };
              allowWildcardNames = false;
            };
          };
          tls = {
            cipherSuites = [
              "TLS_ECDHE_ECDSA_WITH_CHACHA20_POLY1305_SHA256"
              "TLS_ECDHE_ECDSA_WITH_AES_128_GCM_SHA256"
            ];
            minVersion = 1.2;
            maxVersion = 1.3;
          };
        };
      };

      systemd.services.step-ca.serviceConfig = hardenedSystemdConfig;

      # trust root cert on this machine
      security.pki.certificateFiles = [
        cfg.rootCaCrtPath
      ];

      # acme client
      security.acme = {
        acceptTerms = true;
        # these need to hostnames and fit to the `dnsNames` used for the step-ca setup
        defaults = {
          email = "admin@${config.extraLib.localHostname}";
          server = "https://${config.extraLib.localHostnameWithPortFor "stepCa"}/acme/acme/directory";
        };
      };
    }
  );
}
