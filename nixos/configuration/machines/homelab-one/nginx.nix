{
  config,
  lib,
  ...
}:
let
  moduleName = "nginx";
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
    defaultDomain = lib.mkOption {
      type = lib.types.str;
      example = "";
      description = "leads to landing page";
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
      networking.firewall = {
        enable = true;
        allowedTCPPorts = [
          443 # HTTPS
        ];
      };

      services.nginx = {
        enable = true;

        # for acme
        recommendedProxySettings = true;
        recommendedTlsSettings = true;

        recommendedGzipSettings = false;
        recommendedOptimisation = true;
        recommendedUwsgiSettings = true;
        recommendedBrotliSettings = false;

        appendHttpConfig = ''
          # Strict Transport Security (HSTS)
          add_header Strict-Transport-Security "max-age=31536000; includeSubDomains;" always;
          # Content Security Policy (CSP)
          add_header Content-Security-Policy "frame-ancestors 'self'; default-src 'self'; script-src 'self'; style-src 'self' 'unsafe-inline'; img-src 'self' data:; font-src 'self'; connect-src 'self'; base-uri 'self'; form-action 'self';" always;

          add_header Referrer-Policy "strict-origin-when-cross-origin" always;
          add_header X-Content-Type-Options "nosniff" always;
          add_header Permissions-Policy "geolocation=(), microphone=(), camera=()" always;
          # CORS
          # add_header Access-Control-Allow-Origin "https://${defaultDomain}" always;
          add_header Cross-Origin-Opener-Policy "same-origin" always;
          add_header Cross-Origin-Resource-Policy "same-site" always;
          add_header Cross-Origin-Embedder-Policy "unsafe-none" always;

          # dos protection
          limit_req_zone $binary_remote_addr zone=global:10m rate=10r/s;
        '';

        statusPage = true; # for prometheus nginx exporter

        virtualHosts = {
          "${defaultDomain}" = {
            root = "/srv/www/";

            # for acme
            enableACME = true;
            forceSSL = true;

            # don't configure top level to not collide with recommended settings, which breaks config
            extraConfig = hardenedServerExtraConfig;

            locations = {
              "/" = {
                extraConfig = ''
                  index index.html;
                '';
              };
            };
          };
        };
      };
    }
  );
}
