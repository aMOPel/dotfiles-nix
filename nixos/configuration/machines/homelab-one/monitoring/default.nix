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
    exporters = lib.mkOption {
      type = lib.types.submodule { freeformType = lib.types.attrs; };
      example = "";
      description = "";
    };
  };

  imports = [
    ./exporters/dnsmasq/default.nix
    ./exporters/systemd/default.nix
    ./exporters/process/default.nix
    ./exporters/node/default.nix
    ./exporters/smartctl/default.nix
    ./exporters/nginx/default.nix
  ];

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
      myModules = {
        auth = {
          enable = true;
        };
        nginx = {
          enable = true;
        };
      };

      users = extraLib.createSystemUserGroups [
        userGroups.grafana
        userGroups.prometheus
      ];

      sops.secrets."ldap/services/grafana/password" = {
        owner = "grafana";
        restartUnits = [
          "openldap.service"
          "grafana.service"
        ];
        sopsFile = ../../../../../secrets/ldap-service-users.yaml;
      };

      systemd.tmpfiles.settings = extraLib.createDirs {
        userGroup = userGroups.grafana;
        dirs = [
          dataDir
        ];
      };

      services.prometheus = {
        enable = true;
        port = ports.prometheus;
        listenAddress = extraLib.localAddress;
        retentionTime = "30d";
        globalConfig = {
          scrape_interval = "30s";
        };
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
