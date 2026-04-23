{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "monitoring";
  cfg = config.myModules."${moduleName}";
  inherit (config.globals)
    ports
    subdomains
    uids
    gids
    userGroups
    defaultDomain
    ;
  inherit (config) extraLib;
in
{
  options.myModules."${moduleName}" = {
    enable = lib.mkEnableOption "${moduleName}";
    dataParentDir = lib.mkOption {
      type = lib.types.str;
      example = "";
      description = ''
        the parent directory of the data directories for grafana and prometheus.
              the data directory will be created inside that directory with the correct permissions.'';
    };
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

      dataDir = "${cfg.dataParentDir}/grafana";
    in
    {
      users = extraLib.createSystemUserGroups [
        userGroups.grafana
        userGroups.prometheus
      ];

      systemd.tmpfiles.settings = extraLib.createDirs {
        userGroup = userGroups.grafana;
        dirs = [
          dataDir
        ];
      };

      services.prometheus.exporters.node = {
        enable = true;
        port = ports.node-exporter;
        listenAddress = extraLib.localAddress;
        enabledCollectors = [
          "logind"
          "systemd"
        ];
        disabledCollectors = [ "textfile" ];
        openFirewall = false;
      };

      services.prometheus = {
        enable = true;
        port = ports.prometheus;
        listenAddress = extraLib.localAddress;
        scrapeConfigs = [
          {
            job_name = "node";
            static_configs = [
              {
                targets = [
                  (extraLib.localAddressWithPortFor "node-exporter")
                ];
              }
            ];
          }
        ];
      };

      services.grafana = {
        enable = true;
        dataDir = dataDir;
        settings = {
          server = {
            http_addr = extraLib.localAddress;
            http_port = ports.grafana;
            domain = extraLib.domainFor "grafana";
            root_url = extraLib.domainAsUrl (extraLib.domainFor "grafana");
          };
        };
        provision = {
          dashboards.settings = {
            apiVersion = 1;
            providers = [
              # {
              #   name = "node-exporter";
              #   options.path = ./test.json;
              #   type = "file";
              # }
            ];
          };
          datasources = {
            settings = {
              apiVersion = 1;
              datasources = [
                {
                  name = "Prometheus";
                  type = "prometheus";
                  url = extraLib.localUrlWithPortFor "prometheus";
                }
              ];
            };
          };
        };
      };

      services.nginx = {
        virtualHosts = {
          "${extraLib.domainFor "prometheus"}" = {
            # for acme
            enableACME = true;
            forceSSL = true;
            # don't configure top level to not collide with recommended settings, which breaks config
            # extraConfig = hardenedServerExtraConfig;
            locations = {
              "/" = {
                extraConfig =
                  config.nginxConfs.proxy
                  + config.nginxConfs.autheliaAuthrequest
                  + ''
                    # Content Security Policy (CSP)
                    add_header Content-Security-Policy "frame-ancestors 'self'; default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self'; connect-src 'self'; base-uri 'self'; form-action 'self';" always;
                    add_header X-Content-Type-Options "nosniff" always;
                    proxy_pass        ${extraLib.localUrlWithPortFor "prometheus"};
                  '';
              };
              "/internal/authelia/authz" = {
                extraConfig = config.nginxConfs.autheliaLocation;
              };
            };
          };
          "${extraLib.domainFor "grafana"}" = {
            # for acme
            enableACME = true;
            forceSSL = true;
            # don't configure top level to not collide with recommended settings, which breaks config
            # extraConfig = hardenedServerExtraConfig;
            locations = {
              "/" = {
                extraConfig = ''
                  # Content Security Policy (CSP)
                  add_header Content-Security-Policy "frame-ancestors 'self'; default-src 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self'; connect-src 'self'; base-uri 'self'; form-action 'self';" always;
                  add_header X-Content-Type-Options "nosniff" always;
                  proxy_set_header Host $host;
                  proxy_pass        ${extraLib.localUrlWithPortFor "grafana"};
                '';
              };
              # Proxy Grafana Live WebSocket connections.
              "/api/live/" = {
                extraConfig = ''
                  proxy_http_version 1.1;
                  proxy_set_header Upgrade $http_upgrade;
                  proxy_set_header Connection $connection_upgrade;
                  proxy_set_header Host $host;
                  proxy_pass        ${extraLib.localUrlWithPortFor "grafana"};
                '';
              };
            };
          };
        };
      };

    }
  );
}
