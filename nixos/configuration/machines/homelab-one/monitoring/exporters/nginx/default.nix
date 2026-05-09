{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "nginx";
  cfg = config.myModules.monitoring.exporters."${moduleName}";
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
  options.myModules.monitoring.exporters."${moduleName}" = {
    enable = lib.mkEnableOption "${moduleName}";
  };

  config = lib.mkIf cfg.enable ({
    services.prometheus.exporters = {
      nginx = {
        enable = true;
        port = ports.nginx-exporter;
        listenAddress = extraLib.localAddress;
        openFirewall = false;
        scrapeUri = "${extraLib.localUrl}/nginx_status";
      };
    };

    services.prometheus = {
      scrapeConfigs = lib.mkAfter [
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
      ];
    };

    services.grafana = {
      provision = {
        dashboards.settings = {
          providers = lib.mkAfter [
            {
              name = "nginx-exporter";
              options.path = ./nginx-exporter-dashboard_11199_rev1.json;
              type = "file";
            }
          ];
        };
      };
    };

  });
}
