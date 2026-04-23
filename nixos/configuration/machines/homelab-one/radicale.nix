{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "radicale";
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

      secretsRuntimePath = "/run/secrets";

      secretConfig = {
        owner = userGroups.radicale;
        restartUnits = [ "radicale.service" ];
        sopsFile = ../../../../secrets/radicale-users.yaml;
      };

      dataDir = "${cfg.dataParentDir}/radicale";
      collectionsDir = "${dataDir}/collections";
    in
    {
      sops.secrets."radicale/users" = secretConfig;

      users = config.extraLib.createSystemUserGroup {
        userGroup = userGroups.radicale;
      };

      systemd.tmpfiles.settings = config.extraLib.createDirs {
        userGroup = userGroups.radicale;
        dirs = [
          dataDir
          collectionsDir
        ];
      };

      environment.systemPackages = with pkgs; [
        apacheHttpd # for htpasswd
      ];

      services.radicale = {
        enable = true;
        settings = {
          server = {
            hosts = [
              (config.extraLib.localAddressWithPortFor "radicale")
            ];
            max_connections = 20;
            max_content_length = 100000000; # 100 Megabyte
            timeout = 30; # 30 seconds
          };
          auth = {
            # type = "none";
            type = "htpasswd";
            htpasswd_filename = "${secretsRuntimePath}/radicale/users";
            htpasswd_encryption = "autodetect";
            delay = 1; # Average delay after failed login attempts in seconds
          };
          storage = {
            filesystem_folder = "${collectionsDir}";
          };
        };
      };

      services.nginx = {
        virtualHosts = {
          "${extraLib.domainFor "radicale"}" = {
            # for acme
            enableACME = true;
            forceSSL = true;

            # don't configure top level to not collide with recommended settings, which breaks config
            extraConfig = hardenedServerExtraConfig;

            locations = {
              "/" = {
                extraConfig = ''
                  proxy_pass        ${config.extraLib.localUrlWithPortFor "radicale"};
                  proxy_set_header  X-Forwarded-For $proxy_add_x_forwarded_for;
                  proxy_set_header  X-Forwarded-Host $host;
                  proxy_set_header  X-Forwarded-Port $server_port;
                  proxy_set_header  X-Forwarded-Proto $scheme;
                  proxy_set_header  Host $host;
                  proxy_pass_header Authorization;
                '';
              };
            };
          };
        };
      };

    }
  );
}
