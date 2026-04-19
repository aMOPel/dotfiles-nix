{
  config,
  lib,
  ...
}:
let
  moduleName = "radicale";
  cfg = config.myModules."${moduleName}";
in
{
  options.myModules."${moduleName}" = {
    enable = lib.mkEnableOption "${moduleName}";
    defaultDomain = lib.mkOption {
      type = lib.types.str;
      example = '''';
      description = "radicale will be reachable under radicale.$${defaultDomain}";
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
    in
    {
      services.radicale = {
        enable = true;
        settings = {
          server = {
            hosts = [
              "127.0.0.1:5232"
            ];
            max_connections = 20;
            max_content_length = 100000000; # 100 Megabyte
            timeout = 30; # 30 seconds
          };
          auth = {
            # type = "none";
            type = "htpasswd";
            htpasswd_filename = "/var/lib/radicale/users";
            htpasswd_encryption = "autodetect";
            delay = 1; # Average delay after failed login attempts in seconds
          };
          storage = {
            filesystem_folder = "/srv/radicale/collections";
          };
        };
      };

      services.nginx = {
        virtualHosts = {
          "radicale.${cfg.defaultDomain}" = {
            # for acme
            enableACME = true;
            forceSSL = true;

            # don't configure top level to not collide with recommended settings, which breaks config
            extraConfig = hardenedServerExtraConfig;

            locations = {
              "/" = {
                extraConfig = ''
                  proxy_pass        http://127.0.0.1:5232;
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
