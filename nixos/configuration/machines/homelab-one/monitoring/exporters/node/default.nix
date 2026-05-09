{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "node";
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
    };

    services.prometheus = {
      scrapeConfigs = lib.mkAfter [
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
      provision = {
        dashboards.settings = {
          providers = lib.mkAfter [
            {
              name = "node-exporter";
              options.path = ./node-exporter-dashboard_1860_rev45.json;
              type = "file";
            }
          ];
        };
      };
    };
  });
}
