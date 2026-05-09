{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "smartctl";
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
    };

    services.prometheus = {
      scrapeConfigs = lib.mkAfter [
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
      ];
    };

    services.grafana = {
      provision = {
        dashboards.settings = {
          providers = lib.mkAfter [
            {
              name = "smartctl-exporter";
              options.path = ./smartctl-exporter-dashboard_22604_rev2.json;
              type = "file";
            }
          ];
        };
      };
    };

  });
}
