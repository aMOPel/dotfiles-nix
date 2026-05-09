{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "dnsmasq";
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
      dnsmasq = {
        enable = true;
        port = ports.dnsmasq-exporter;
        listenAddress = extraLib.localAddress;
        openFirewall = false;
        dnsmasqListenAddress = extraLib.localHostnameWithPortFor "dnsmasq";
      };
    };

    services.prometheus = {
      scrapeConfigs = lib.mkAfter [
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
      ];
    };

    services.grafana = {
      provision = {
        dashboards.settings = {
          providers = lib.mkAfter [
            {
              name = "dnsmasq-exporter";
              options.path = ./dnsmasq-exporter-dashboard_18796_rev1.json;
              type = "file";
            }
          ];
        };
      };
    };

  });
}
