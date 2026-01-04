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
    stepCaPort = lib.mkOption {
      type = lib.types.int;
      default = 8443;
      example = '''';
      description = "step-ca serves acme-server endpoint on 127.0.0.1:\${cfg.stepCaPort}";
    };
    rootCaCrtPath = lib.mkOption {
      type = lib.types.path;
      example = ''../root-ca.crt'';
      description = "path in repo to the root-ca.crt, clients should trust this";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      hostname = "localhost";
      hostnamePort = "${hostname}:${builtins.toString cfg.stepCaPort}";
    in
    {
      # make secrets available
      sops.secrets."root-ca/public-cert" = {
        sopsFile = ../../../../secrets/step-ca.yaml;
        owner = "step-ca";
      };
      sops.secrets."intermediate-ca/public-cert" = {
        sopsFile = ../../../../secrets/step-ca.yaml;
        owner = "step-ca";
      };
      sops.secrets."intermediate-ca/private-password" = {
        sopsFile = ../../../../secrets/step-ca.yaml;
        owner = "step-ca";
      };
      sops.secrets."intermediate-ca/private-key" = {
        sopsFile = ../../../../secrets/step-ca.yaml;
        owner = "step-ca";
      };

      services.step-ca = {
        enable = true;
        openFirewall = false;
        # overrides config
        address = "127.0.0.1";
        port = cfg.stepCaPort;
        intermediatePasswordFile = "/run/secrets/intermediate-ca/private-password";
        package = pkgs.step-ca;
        settings = {
          root = "/run/secrets/root-ca/public-cert";
          crt = "/run/secrets/intermediate-ca/public-cert";
          key = "/run/secrets/intermediate-ca/private-key";
          dnsNames = [
            hostname
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
              }
            ];
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

      # trust root cert on this machine
      security.pki.certificateFiles = [
        cfg.rootCaCrtPath
      ];

      # acme client
      security.acme = {
        acceptTerms = true;
        defaults = {
          email = "admin@${hostnamePort}";
          server = "https://${hostnamePort}/acme/acme/directory";
        };
      };

    }

  );
}
