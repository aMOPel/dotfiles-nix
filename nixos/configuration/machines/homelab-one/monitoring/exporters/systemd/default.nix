{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "systemd";
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
    users = extraLib.createSystemUserGroups [
      userGroups.systemd-exporter
    ];

    services.prometheus.exporters = {
      systemd = {
        enable = true;
        port = ports.systemd-exporter;
        listenAddress = extraLib.localAddress;
        openFirewall = false;
        extraFlags = [
          "--systemd.collector.enable-ip-accounting"
          "--systemd.collector.enable-restart-count"
        ];
      };
    };

    systemd.services = {
      "prometheus-systemd-exporter" = {
        serviceConfig = {
          DynamicUser = false; # `= true` breaks the exporter
        };
      };
    };

    services.prometheus = {
      scrapeConfigs = lib.mkAfter [
        {
          job_name = "systemd";
          scrape_interval = "9s";
          static_configs = [
            {
              targets = [
                (extraLib.localAddressWithPortFor "systemd-exporter")
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
              name = "systemd-exporter";
              options.path = ./systemd-exporter-dashboard_22872_rev1.json;
              type = "file";
            }
          ];
        };
      };
    };

  });
}
