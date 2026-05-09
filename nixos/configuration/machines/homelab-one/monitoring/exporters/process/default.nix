{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "process";
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

  config = lib.mkIf cfg.enable (
    let
      grafana-treemap-panel = pkgs.grafanaPlugins.grafanaPlugin {
        pname = "marcusolsson-treemap-panel";
        version = "2.1.1";
        zipHash = "sha256-7aNskgqnzpjlKr51J0uhd01ukVc4L5Jb9gxBtYzsflU=";
      };
    in
    {
      services.prometheus.exporters = {
        process = {
          enable = true;
          port = ports.process-exporter;
          listenAddress = extraLib.localAddress;
          openFirewall = false;
          settings = {
            process_names = [
              {
                name = "{{.Comm}}";
                cmdline = [ ".+" ];
              }
            ];
          };
        };
      };

      services.prometheus = {
        scrapeConfigs = lib.mkAfter [
          {
            job_name = "process";
            static_configs = [
              {
                targets = [
                  (extraLib.localAddressWithPortFor "process-exporter")
                ];
              }
            ];
          }
        ];
      };

      services.grafana = {
        declarativePlugins = lib.mkAfter (
          with pkgs.grafanaPlugins;
          [
            grafana-treemap-panel
          ]
        );
        provision = {
          dashboards.settings = {
            providers = [
              {
                name = "process-exporter";
                options.path = ./process-exporter-dashboard_13882_rev10.json;
                type = "file";
              }
            ];
          };
        };
      };

    }
  );
}
