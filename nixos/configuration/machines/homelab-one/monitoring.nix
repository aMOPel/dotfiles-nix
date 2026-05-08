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
    ldap
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

      # make sure dashboard file names end in `.json` or grafana won't detect them
      dashboards = {
        node-exporter = "${
          pkgs.fetchFromGitHub {
            name = "grafana-dashboard-node-exporter";
            owner = "rfmoz";
            repo = "grafana-dashboards";
            rev = "fa9f41fa3efed31d5c2de73cd332a340797c0ec7";
            sha256 = "sha256-phqtDu/oLwqB+R+Dn9WyHyYbNcKR43uIy+F3BrAvwg4=";
          }
        }/prometheus/node-exporter-full.json";
        smartctl-exporter = pkgs.stdenvNoCC.mkDerivation {
          name = "grafana-dashboard-smartctl-exporter-patched.json";
          unpackCmd = ''
            mkdir -p ./src
            cp $curSrc ./src/file.json
          '';
          src = pkgs.fetchurl {
            name = "grafana-dashboard-smartctl-exporter.json";
            url = "https://grafana.com/api/dashboards/22604/revisions/2/download";
            hash = "sha256-ci8WE23fZ+ltEKFoUdNNVXsUIV0jqtas79ia2lYIo88=";
          };
          nativeBuildInputs = with pkgs; [
            jq
          ];
          # some dashboards don't autodetect the datasource, and thus won't work. this adds autodetection
          buildPhase = ''
            jq '.templating.list += [{"current": {}, "includeAll": false, "label": "Datasource", "name": "DS_PROMETHEUS", "options": [], "query": "prometheus", "refresh": 1, "regex": "", "type": "datasource"}]' file.json > file2.json
          '';
          installPhase = ''
            cp file2.json $out
          '';
        };
        nginx-exporter = pkgs.stdenvNoCC.mkDerivation {
          name = "grafana-dashboard-nginx-exporter-patched.json";
          unpackCmd = ''
            mkdir -p ./src
            cp $curSrc ./src/file.json
          '';
          src = pkgs.fetchurl {
            name = "grafana-dashboard-nginx-exporter.json";
            url = "https://grafana.com/api/dashboards/11199/revisions/1/download";
            hash = "sha256-RtMI3aMbxqwIqdIIbaj71jr/twtrnY/r/Y5ghoRvu1M=";
          };
          nativeBuildInputs = with pkgs; [
            jq
          ];
          # some dashboards don't autodetect the datasource, and thus won't work. this adds autodetection
          buildPhase = ''
            jq '.templating.list += [{"current": {}, "includeAll": false, "label": "Datasource", "name": "DS_PROMETHEUS", "options": [], "query": "prometheus", "refresh": 1, "regex": "", "type": "datasource"}]' file.json > file2.json
          '';
          installPhase = ''
            cp file2.json $out
          '';
        };

        dnsmasq-exporter = pkgs.stdenvNoCC.mkDerivation {
          name = "grafana-dashboard-dnsmasq-exporter-patched.json";
          unpackCmd = ''
            mkdir -p ./src
            cp $curSrc ./src/file.json
          '';
          src = pkgs.fetchurl {
            name = "grafana-dashboard-dnsmasq-exporter.json";
            url = "https://grafana.com/api/dashboards/18796/revisions/1/download";
            hash = "sha256-QoHeeu08Ct8NTyED6G+zRg4XTToh06oXI03gg9e2xNo=";
          };
          nativeBuildInputs = with pkgs; [
            jq
          ];
          # some dashboards don't autodetect the datasource, and thus won't work. this adds autodetection
          buildPhase = ''
            jq 'del(.templating.list[] | select(.query == "prometheus" and .type == "datasource"))' file.json > file2.json
            jq '.templating.list += [{"current": {}, "includeAll": false, "label": "Datasource", "name": "DS_PROMETHEUS", "options": [], "query": "prometheus", "refresh": 1, "regex": "", "type": "datasource"}]' file2.json > file3.json
          '';
          installPhase = ''
            cp file3.json $out
          '';
        };

        systemd-exporter = pkgs.stdenvNoCC.mkDerivation {
          name = "grafana-dashboard-systemd-exporter-patched.json";
          unpackCmd = ''
            mkdir -p ./src
            cp $curSrc ./src/file.json
          '';
          src = pkgs.fetchurl {
            name = "grafana-dashboard-systemd-exporter.json";
            url = "https://grafana.com/api/dashboards/22872/revisions/1/download";
            hash = "sha256-ZlvD6Gt5dJsv2ud4f0t1AuAIMImL9I9zxoE0Rx9yvzM=";
          };
          nativeBuildInputs = with pkgs; [
            jq
          ];
          # some dashboards don't autodetect the datasource, and thus won't work. this adds autodetection
          buildPhase = ''
            jq 'del(.templating.list[] | select(.query == "prometheus" and .type == "datasource"))' file.json > file2.json
            jq '.templating.list += [{"current": {}, "includeAll": false, "label": "Datasource", "name": "DS_PROMETHEUS", "options": [], "query": "prometheus", "refresh": 1, "regex": "", "type": "datasource"}]' file2.json > file3.json
          '';
          installPhase = ''
            cp file3.json $out
          '';
        };

        # "read bytes" and "write bytes" charts are broken, they require root access
        process-exporter = pkgs.stdenvNoCC.mkDerivation {
          name = "grafana-dashboard-process-exporter-patched.json";
          unpackCmd = ''
            mkdir -p ./src
            cp $curSrc ./src/file.json
          '';
          src = pkgs.fetchurl {
            name = "grafana-dashboard-process-exporter.json";
            url = "https://grafana.com/api/dashboards/13882/revisions/10/download";
            hash = "sha256-W1vhd51DpCJzWVUNRHY/duWrInme5Opyw2d40Sfx4ZQ=";
          };
          nativeBuildInputs = with pkgs; [
            jq
          ];
          buildPhase = ''
            # `proportionalResident` requires root access, which we don't give the process exporter
            # `resident` double counts memory of shared libs, so might overcount
            sed -i 's/proportionalResident/resident/g' file.json
            sed -i 's/proportional resident/resident/g' file.json
          '';
          installPhase = ''
            cp file.json $out
          '';
        };

      };

    in
    {
      users = extraLib.createSystemUserGroups [
        userGroups.grafana
        userGroups.prometheus
        userGroups.systemd-exporter
      ];

      sops.secrets."ldap/services/grafana/password" = {
        owner = "grafana";
        restartUnits = [
          "openldap.service"
          "grafana.service"
        ];
        sopsFile = ../../../../secrets/ldap-service-users.yaml;
      };

      systemd.tmpfiles.settings = extraLib.createDirs {
        userGroup = userGroups.grafana;
        dirs = [
          dataDir
        ];
      };

      services.prometheus.exporters = {
        node = {
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
        smartctl = {
          enable = true;
          port = ports.smartctl-exporter;
          listenAddress = extraLib.localAddress;
          openFirewall = false;
          devices = [
            config.disko.devices.disk.disk0.device
            config.disko.devices.disk.disk1.device
            config.disko.devices.disk.disk2.device
          ];
        };
        nginx = {
          enable = true;
          port = ports.nginx-exporter;
          listenAddress = extraLib.localAddress;
          openFirewall = false;
          scrapeUri = "${extraLib.localUrl}/nginx_status";
        };
        dnsmasq = {
          enable = true;
          port = ports.dnsmasq-exporter;
          listenAddress = extraLib.localAddress;
          openFirewall = false;
          dnsmasqListenAddress = extraLib.localHostnameWithPortFor "dnsmasq";
        };
        systemd = {
          enable = true;
          port = ports.systemd-exporter;
          listenAddress = extraLib.localAddress;
          openFirewall = false;
          extraFlags = [
            "--systemd.collector.enable-ip-accounting"
            "--systemd.collector.enable-restart-count"
          ];
        };
        process = {
          enable = true;
          port = ports.process-exporter;
          listenAddress = extraLib.localAddress;
          openFirewall = false;
          settings = {
            process_names = [
              {
                name = "{{.Comm}}";
                cmdline = [ ".+" ];
              }
            ];
          };
        };
      };

      systemd.services = {
        "prometheus-systemd-exporter" = {
          serviceConfig = {
            DynamicUser = false; # `= true` breaks the exporter
          };
        };
      };

      services.prometheus = {
        enable = true;
        port = ports.prometheus;
        listenAddress = extraLib.localAddress;
        retentionTime = "30d";
        globalConfig = {
          scrape_interval = "30s";
        };
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
          {
            job_name = "smartctl";
            static_configs = [
              {
                targets = [
                  (extraLib.localAddressWithPortFor "smartctl-exporter")
                ];
              }
            ];
          }
          {
            job_name = "nginx";
            static_configs = [
              {
                targets = [
                  (extraLib.localAddressWithPortFor "nginx-exporter")
                ];
              }
            ];
          }
          {
            job_name = "dnsmasq";
            static_configs = [
              {
                targets = [
                  (extraLib.localAddressWithPortFor "dnsmasq-exporter")
                ];
              }
            ];
          }
          {
            job_name = "systemd";
            scrape_interval = "9s";
            static_configs = [
              {
                targets = [
                  (extraLib.localAddressWithPortFor "systemd-exporter")
                ];
              }
            ];
          }
          {
            job_name = "process";
            static_configs = [
              {
                targets = [
                  (extraLib.localAddressWithPortFor "process-exporter")
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
          "auth.ldap" = {
            enabled = true;
            config_file = "${pkgs.writeTextFile {
              name = "grafana-ldap.toml";
              text = ''
                [[servers]]
                # Ldap server host (specify multiple hosts space separated)
                host = "${extraLib.localAddress}"
                # Default port is 389 or 636 if use_ssl = true
                port = ${builtins.toString ports.openldap}
                # Set to true if LDAP server should use an encrypted TLS connection (either with STARTTLS or LDAPS)
                use_ssl = false

                # Search user bind dn
                bind_dn = "${ldap.DNs.services.grafana}"
                # Search user bind password
                bind_password = '$__file{${config.sops.secrets."ldap/services/grafana/password".path}}'

                # Timeout in seconds. Applies to each host specified in the 'host' entry (space separated).
                timeout = 10

                search_filter = "(&(uid=%s)(objectClass=inetOrgPerson))"

                # An array of base dns to search through
                search_base_dns = ["${ldap.DNs.defaultDomain}"]

                group_search_filter = "(&(member=%s)(objectClass=groupOfNames))"
                group_search_filter_user_attribute = "dn"
                group_search_base_dns = ["${ldap.DNs.groups.root}"]

                [[servers.group_mappings]]
                group_dn = "${ldap.DNs.groups.admin}"
                org_role = "Admin"
                grafana_admin = true

                # Specify names of the LDAP attributes your LDAP uses
                [servers.attributes]
                email = "mail"
                name = "givenName"
                surname = "sn"
                username = "uid"
              '';
            }}";
            allow_sign_up = true;
            skip_org_role_sync = false;
          };
        };
        provision = {
          dashboards.settings = {
            apiVersion = 1;
            providers = [
              {
                name = "node-exporter";
                options.path = dashboards.node-exporter;
                type = "file";
              }
              {
                name = "smartctl-exporter";
                options.path = dashboards.smartctl-exporter;
                type = "file";
              }
              {
                name = "nginx-exporter";
                options.path = dashboards.nginx-exporter;
                type = "file";
              }
              {
                name = "dnsmasq-exporter";
                options.path = dashboards.dnsmasq-exporter;
                type = "file";
              }
              {
                name = "systemd-exporter";
                options.path = dashboards.systemd-exporter;
                type = "file";
              }
              {
                name = "process-exporter";
                options.path = dashboards.process-exporter;
                type = "file";
              }
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
                    proxy_pass ${extraLib.localUrlWithPortFor "prometheus"};
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
                  add_header Content-Security-Policy "frame-ancestors 'self'; default-src 'self'; script-src 'self' 'unsafe-inline' 'unsafe-eval'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self'; connect-src 'self'; base-uri 'self'; form-action 'self';" always;
                  add_header X-Content-Type-Options "nosniff" always;
                  proxy_pass ${extraLib.localUrlWithPortFor "grafana"};
                '';
              };
              # Proxy Grafana Live WebSocket connections.
              "/api/live/" = {
                extraConfig = ''
                  proxy_set_header Upgrade $http_upgrade;
                  proxy_set_header Connection $connection_upgrade;
                  proxy_pass ${extraLib.localUrlWithPortFor "grafana"};
                '';
              };
            };
          };
        };
      };

    }
  );
}
