{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "forgejo";
  cfg = config.myModules."${moduleName}";
  inherit (config.globals)
    ports
    subdomains
    uids
    gids
    ldap
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
        the parent directory of the data directory.
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

      secretConfig = {
        owner = userGroups.forgejo;
        restartUnits = [ "forgejo.service" ];
        sopsFile = ../../../../secrets/forgejo.yaml;
      };
      userSecretConfig = {
        owner = userGroups.forgejo;
        restartUnits = [ "forgejo.service" ];
        sopsFile = ../../../../secrets/forgejo-users.yaml;
      };

      dataDir = "${cfg.dataParentDir}/forgejo";
      stateDir = "/var/lib/forgejo";
      customDir = "${stateDir}/custom";

    in
    {
      myModules.nginx = {
        enable = true;
      };
      myModules.auth = {
        enable = true;
      };

      sops.secrets."forgejo/db_password" = secretConfig;
      sops.secrets."ldap/services/forgejo/password" = {
        owner = "forgejo";
        restartUnits = [
          "openldap.service"
          "forgejo.service"
        ];
        sopsFile = ../../../../secrets/ldap-service-users.yaml;
      };

      users = config.extraLib.createSystemUserGroup {
        userGroup = userGroups.forgejo;
      };

      systemd.tmpfiles.settings = config.extraLib.createDirs {
        userGroup = userGroups.forgejo;
        dirs = [
          dataDir
        ];
      };

      systemd.services = {
        forgejo.preStart =
          let
            fromFile = file: "$(tr -d '\n' < ${file})";
            forgejoCmd = "${pkgs.forgejo}/bin/forgejo -w ${stateDir} -c ${customDir}/conf/app.ini";
          in
          ''
            echo "init ldap auth";
            ${forgejoCmd} admin auth add-ldap \
              --name 'openldap' \
              --security-protocol 'Unencrypted' \
              --host "${extraLib.localAddress}" \
              --port "${builtins.toString ports.openldap}" \
              --user-search-base "${ldap.DNs.people.root}" \
              --user-filter '(&(uid=%[1]s)(objectClass=inetOrgPerson))' \
              --admin-filter '(cn=admin)' \
              --bind-dn "${ldap.DNs.services.forgejo}" \
              --bind-password "${fromFile config.sops.secrets."ldap/services/forgejo/password".path}" \
              --username-attribute 'uid' \
              --firstname-attribute 'givenName' \
              --surname-attribute 'sn' \
              --email-attribute 'mail' \
              || true;
          '';
      };

      # TODO: forgejo start broken
      services.forgejo = {
        enable = true;
        # inherit
        #   stateDir
        #   customDir
        #   ;
        repositoryRoot = "${dataDir}/repositories";
        lfs = {
          enable = true;
          contentDir = "${dataDir}/lfs";
        };
        database = {
          type = "sqlite3";
          passwordFile = config.sops.secrets."forgejo/db_password".path;
        };
        user = userGroups.forgejo;
        group = userGroups.forgejo;
        dump = {
          enable = false;
        };
        secrets = {
        };
        settings = {
          server = {
            HTTP_ADDR = extraLib.localAddress;
            HTTP_PORT = ports.forgejo;
            ROOT_URL = extraLib.domainAsUrl (extraLib.domainFor "forgejo");
          };
          service = {
            DISABLE_REGISTRATION = false;
            ALLOW_ONLY_EXTERNAL_REGISTRATION = true;
            SHOW_REGISTRATION_BUTTON = false;
          };
          # cache = {
          #   # recommended for small instance
          #   ADAPTER = "twoqueue";
          #   HOST = ''{"size":100, "recent_ratio":0.25, "ghost_ratio":0.5}'';
          # };
          # security = {
          #   LOGIN_REMEMBER_DAYS = 7;
          #   REVERSE_PROXY_TRUSTED_PROXIES = extraLib.localAddress;
          #   DISABLE_WEBHOOKS = true;
          # };
          # repository = {
          #   DISABLE_HTTP_GIT = true;
          # };
          # badges = {
          #   ENABLED = false;
          # };
          # metrics = {
          #   ENABLED = true;
          # };
          # api = {
          #   ENABLE_SWAGGER = false;
          # };
          # i18n = {
          #   LANGS = "en-US";
          # };
          # packages = {
          #   ENABLED = false;
          # };
          # quota = {
          #   ENABLED = true;
          #   TOTAL = "20G";
          # };
          # actions = {
          #   ENABLED = false;
          # };
          # webhook = {
          #   ALLOWED_HOST_LIST = "private";
          # };
        };
      };

      services.nginx = {
        virtualHosts = {
          "${extraLib.domainFor "forgejo"}" = {
            # for acme
            enableACME = true;
            forceSSL = true;

            # don't configure top level to not collide with recommended settings, which breaks config
            # extraConfig = hardenedServerExtraConfig;

            locations = {
              "/" = {
                extraConfig = ''
                  add_header Content-Security-Policy "frame-ancestors 'self'; script-src 'self' 'unsafe-inline'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; connect-src 'self'; base-uri 'self'; form-action 'self';" always;
                  add_header X-Content-Type-Options "nosniff" always;

                  proxy_pass        ${config.extraLib.localUrlWithPortFor "forgejo"};
                  proxy_set_header Connection $http_connection;
                  proxy_set_header Upgrade $http_upgrade;
                  proxy_set_header Host $host;
                  proxy_set_header X-Real-IP $remote_addr;
                  proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_set_header X-Forwarded-Proto $scheme;
                  client_max_body_size 512M;
                '';
              };
            };
          };
        };
      };

    }
  );
}
