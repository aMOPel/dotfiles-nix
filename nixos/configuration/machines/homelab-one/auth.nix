{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "auth";
  cfg = config.myModules."${moduleName}";
in
{
  options.myModules."${moduleName}" = {
    enable = lib.mkEnableOption "${moduleName}";
    # defaultDomain = lib.mkOption {
    #   type = lib.types.str;
    #   example = "";
    #   description = "radicale will be reachable under radicale.$${defaultDomain}";
    # };
    # dataParentDir = lib.mkOption {
    #   type = lib.types.str;
    #   example = "";
    #   description = ''
    #     the parent directory of the data directory.
    #           the data directory will be created inside that directory with the correct permissions.'';
    # };
  };

  config = lib.mkIf cfg.enable (
    let
      hardenedServerExtraConfig = ''
        ssl_stapling off; # because ocsp is not supported by step-ca
        ssl_prefer_server_ciphers on;
        proxy_cookie_path / "/; Secure; HttpOnly; SameSite=Strict";
        server_tokens off; # don't leak server information

        # dos protection
        client_max_body_size 10M;
        client_body_timeout 10s;
        client_header_timeout 10s;
        limit_req zone=global burst=20 nodelay;

        # block external access
        allow 192.168.1.0/24;
        deny all;
      '';

      userGroup = "authelia";

      secretsRuntimePath = "/run/secrets";

      autheliaSecretConfig = {
        owner = "authelia";
        # TODO: maybe restart more units that depend on this
        restartUnits = [ "authelia.service" ];
        sopsFile = ../../../../secrets/authelia.yaml;
      };
    in
    {
      sops.secrets."authelia/jwt_secret" = autheliaSecretConfig;
      sops.secrets."authelia/storage/encryption_key" = autheliaSecretConfig;

      # users = config.extraLib.createSystemUserGroup {
      #   inherit userGroup;
      # };

      # systemd.tmpfiles.settings = config.extraLib.createDirs {
      #   inherit userGroup;
      #   dirs = [
      #     dataDir
      #     collectionsDir
      #   ];
      # };

      services.authelia.instances = {
        main = {
          enable = true;
          user = userGroup;
          group = userGroup;
          secrets.storageEncryptionKeyFile = "${secretsRuntimePath}/authelia/storage/encryption_key";
          secrets.jwtSecretFile = "${secretsRuntimePath}/authelia/jwt_secret";
          settings = {
            server = {
              address = config.extraLib.localUrlWithPort config.ports.authelia;
              endpoints = {
                authz = {
                  auth-request = {
                    implementation = "AuthRequest";
                  };
                };
              };
            };
            theme = "light";
            default_2fa_method = "totp";
            log.level = "debug";
          };
        };
      };

      services.nginx = {
        virtualHosts = {
          "authelia.${cfg.defaultDomain}" = {
            # for acme
            enableACME = true;
            forceSSL = true;

            # don't configure top level to not collide with recommended settings, which breaks config
            extraConfig = hardenedServerExtraConfig;

            locations = {
              "/" = {
                extraConfig = ''
                  ## Headers
                  proxy_set_header Host $host;
                  proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
                  proxy_set_header X-Forwarded-Proto $scheme;
                  proxy_set_header X-Forwarded-Host $http_host;
                  proxy_set_header X-Forwarded-URI $request_uri;
                  proxy_set_header X-Forwarded-Ssl on;
                  proxy_set_header X-Forwarded-For $remote_addr;
                  proxy_set_header X-Real-IP $remote_addr;

                  ## Basic Proxy Configuration
                  client_body_buffer_size 128k;
                  proxy_next_upstream error timeout invalid_header http_500 http_502 http_503; ## Timeout if the real server is dead.
                  proxy_redirect  http://  $scheme://;
                  proxy_http_version 1.1;
                  proxy_cache_bypass $cookie_session;
                  proxy_no_cache $cookie_session;
                  proxy_buffers 64 256k;

                  ## Trusted Proxies Configuration
                  ## Please read the following documentation before configuring this:
                  ##     https://www.authelia.com/integration/proxies/nginx/#trusted-proxies-and-integration-security
                  # set_real_ip_from 10.0.0.0/8;
                  # set_real_ip_from 172.16.0.0/12;
                  # set_real_ip_from 192.168.0.0/16;
                  # set_real_ip_from fc00::/7;
                  real_ip_header X-Forwarded-For;
                  real_ip_recursive on;

                  ## Advanced Proxy Configuration
                  send_timeout 5m;
                  proxy_read_timeout 360;
                  proxy_send_timeout 360;
                  proxy_connect_timeout 360;
                  proxy_pass ${config.extraLib.localUrlWithPort config.ports.authelia};
                '';
              };
              "/api/verify" = {
                extraConfig = ''
                  proxy_pass ${config.extraLib.localUrlWithPort config.ports.authelia};
                '';
              };
              "/api/authz" = {
                extraConfig = ''
                  proxy_pass ${config.extraLib.localUrlWithPort config.ports.authelia};
                '';
              };
            };
          };
        };
      };

    }
  );
}
