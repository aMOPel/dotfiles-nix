{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "auth";
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
  };
  options = {
    nginxConfs = lib.mkOption {
      internal = true;
      description = ''
        exported nginx config snippets to be used in services protected by authelia
      '';
      type = lib.types.attrs;
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

      nginxConfs = {
        proxy = ''
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
        '';
        autheliaLocation = ''
          ## Essential Proxy Configuration
          internal;
          proxy_pass ${extraLib.domainAsUrl (extraLib.domainFor "authelia")}/api/authz/auth-request;

          ## Headers
          ## The headers starting with X-* are required.
          proxy_set_header X-Original-Method $request_method;
          proxy_set_header X-Original-URL $scheme://$http_host$request_uri;
          proxy_set_header X-Forwarded-For $remote_addr;
          proxy_set_header Content-Length "";
          proxy_set_header Connection "";

          ## Basic Proxy Configuration
          proxy_pass_request_body off;
          proxy_next_upstream error timeout invalid_header http_500 http_502 http_503; # Timeout if the real server is dead
          proxy_redirect http:// $scheme://;
          proxy_http_version 1.1;
          proxy_cache_bypass $cookie_session;
          proxy_no_cache $cookie_session;
          proxy_buffers 4 32k;
          client_body_buffer_size 128k;

          ## Advanced Proxy Configuration
          send_timeout 5m;
          proxy_read_timeout 240;
          proxy_send_timeout 240;
          proxy_connect_timeout 240;
        '';
        autheliaAuthrequest = ''
          ## Send a subrequest to Authelia to verify if the user is authenticated and has permission to access the resource.
          auth_request /internal/authelia/authz;

          ## Save the upstream metadata response headers from Authelia to variables.
          auth_request_set $user $upstream_http_remote_user;
          auth_request_set $groups $upstream_http_remote_groups;
          auth_request_set $name $upstream_http_remote_name;
          auth_request_set $email $upstream_http_remote_email;

          ## Inject the metadata response headers from the variables into the request made to the backend.
          proxy_set_header Remote-User $user;
          proxy_set_header Remote-Groups $groups;
          proxy_set_header Remote-Email $email;
          proxy_set_header Remote-Name $name;

          ## Configure the redirection when the authz failure occurs. Lines starting with 'Modern Method' and 'Legacy Method'
          ## should be commented / uncommented as pairs. The modern method uses the session cookies configuration's authelia_url
          ## value to determine the redirection URL here. It's much simpler and compatible with the multi-cookie domain easily.

          ## Modern Method: Set the $redirection_url to the Location header of the response to the Authz endpoint.
          auth_request_set $redirection_url $upstream_http_location;

          ## Modern Method: When there is a 401 response code from the authz endpoint redirect to the $redirection_url.
          error_page 401 =302 $redirection_url;

          ## Legacy Method: Set $target_url to the original requested URL.
          ## This requires http_set_misc module, replace 'set_escape_uri' with 'set' if you don't have this module.
          # set_escape_uri $target_url $scheme://$http_host$request_uri;

          ## Legacy Method: When there is a 401 response code from the authz endpoint redirect to the portal with the 'rd'
          ## URL parameter set to $target_url. This requires users update 'auth.example.com/' with their external authelia URL.
          # error_page 401 =302 https://subdomain/?rd=$target_url;
        '';
      };

      secretsRuntimePath = "/run/secrets";

      autheliaSecretConfig = {
        owner = userGroups.authelia;
        restartUnits = [ "authelia-${serviceInstance}.service" ];
        sopsFile = ../../../../secrets/authelia.yaml;
      };

      serviceInstance = "main";
      userDir = "/var/lib/authelia-${serviceInstance}";
    in
    {
      inherit nginxConfs;

      sops.secrets."authelia/jwt_secret" = autheliaSecretConfig;
      sops.secrets."authelia/storage/encryption_key" = autheliaSecretConfig;
      sops.secrets."authelia/session/secret" = autheliaSecretConfig;
      sops.secrets."authelia/users.yaml" = autheliaSecretConfig // {
        sopsFile = ../../../../secrets/authelia-users.yaml;
      };

      users = extraLib.createSystemUserGroup {
        userGroup = userGroups.authelia;
      };

      services.authelia.instances = {
        "${serviceInstance}" = {
          enable = true;
          user = userGroups.authelia;
          group = userGroups.authelia;
          secrets = {
            storageEncryptionKeyFile = "${secretsRuntimePath}/authelia/storage/encryption_key";
            jwtSecretFile = "${secretsRuntimePath}/authelia/jwt_secret";
            sessionSecretFile = "${secretsRuntimePath}/authelia/jwt_secret";
          };
          settings = {
            server = {
              address = "tcp://${extraLib.localAddressWithPortFor "authelia"}";
              endpoints = {
                authz = {
                  auth-request = {
                    implementation = "AuthRequest";
                  };
                };
              };
            };
            storage = {
              local = {
                path = "${userDir}/db.sqlite";
              };
            };
            session = {
              cookies = [
                {
                  domain = defaultDomain;
                  authelia_url = extraLib.domainAsUrl (extraLib.domainFor "authelia");
                  default_redirection_url = extraLib.domainAsUrl defaultDomain;
                }
              ];
            };
            notifier = {
              disable_startup_check = false;
              filesystem = {
                filename = "${userDir}/notification.txt";
              };
            };
            authentication_backend = {
              file = {
                path = "${secretsRuntimePath}/authelia/users.yaml";
              };
            };
            access_control = {
              default_policy = "deny";
              rules = [
                {
                  domain = "*.${defaultDomain}";
                  policy = "one_factor";
                }
              ];
            };
            theme = "light";
            default_2fa_method = "totp";
            log.level = "debug";
          };
        };
      };

      services.nginx = {
        virtualHosts = {
          "${extraLib.domainFor "authelia"}" = {
            # for acme
            enableACME = true;
            forceSSL = true;

            # don't configure top level to not collide with recommended settings, which breaks config
            # extraConfig = hardenedServerExtraConfig;

            locations = {
              "/" = {
                extraConfig = nginxConfs.proxy + ''
                  proxy_pass ${extraLib.localUrlWithPortFor "authelia"};
                '';
              };
              "/api/verify" = {
                extraConfig = ''
                  proxy_pass ${extraLib.localUrlWithPortFor "authelia"};
                '';
              };
              "/api/authz" = {
                extraConfig = ''
                  proxy_pass ${extraLib.localUrlWithPortFor "authelia"};
                '';
              };
            };
          };
        };
      };

    }
  );
}
