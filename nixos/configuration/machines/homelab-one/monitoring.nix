{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "monitoring";
  cfg = config.myModules."${moduleName}";
in
{
  options.myModules."${moduleName}" = {
    enable = lib.mkEnableOption "${moduleName}";
    defaultDomain = lib.mkOption {
      type = lib.types.str;
      example = "";
      description = "grafana and prometheus will be reachable under grafana.$${defaultDomain} and prometheus.$${defaultDomain}";
    };
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

      # dataDir = "${cfg.dataParentDir}/radicale";
      # collectionsDir = "${dataDir}/collections";

      localAddress = "127.0.0.1";
      localUrl = "http://${localAddress}";
      localAddressWithPort = port: "${localAddress}:${port}";
      localUrlWithPort = port: "${localUrl}:${port}";
      ports = {
        prometheus = 9090;
        grafana = 3000;
        exporters.node = 9100;
      };
      subdomains = {
        prometheus = "prometheus.${cfg.defaultDomain}";
        grafana = "grafana.${cfg.defaultDomain}";
      };
    in
    {

      # # ensure the directories for radicale exist after boot
      # systemd.tmpfiles.rules = [
      #   "d ${dataDir} ${cfg.filePermissionMask} radicale radicale -"
      #   "d ${collectionsDir} ${cfg.filePermissionMask} radicale radicale -"
      # ];

      services.prometheus.exporters.node = {
        enable = true;
        port = ports.exporters.node;
        listenAddress = localAddress;
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
        listenAddress = localAddress;
        stateDir = "${cfg.dataParentDir}/prometheus";
        scrapeConfigs = [
          {
            job_name = "node";
            static_configs = [
              {
                targets = [
                  (localAddressWithPort ports.exporters.node)
                ];
              }
            ];
          }
        ];
      };

      services.grafana = {
        enable = false;
        dataDir = "${cfg.dataParentDir}/grafana";
        settings = {
          server = {
            http_addr = localAddress;
            http_port = ports.grafana;
            domain = subdomains.grafana;
            root_url = "https://${subdomains.grafana}";
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
                  url = localUrlWithPort ports.prometheus;
                }
              ];
            };
          };
        };
      };

      services.nginx = {
        virtualHosts = {
          "${subdomains.prometheus}" = {
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
                  proxy_pass        ${localUrlWithPort ports.prometheus};
                '';
              };
            };
          };
          "${subdomains.prometheus}" = {
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
                  proxy_pass        ${localUrlWithPort ports.grafana};
                '';
              };
              # Proxy Grafana Live WebSocket connections.
              "/api/live/" = {
                extraConfig = ''
                  proxy_http_version 1.1;
                  proxy_set_header Upgrade $http_upgrade;
                  proxy_set_header Connection $connection_upgrade;
                  proxy_set_header Host $host;
                  proxy_pass        ${localUrlWithPort ports.grafana};
                '';
              };
            };
          };
        };
      };

    }
  );
}
