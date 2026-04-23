{
  config,
  lib,
  ...
}:
let
  moduleName = "globals";
  cfg = config."${moduleName}";
in
{
  options."${moduleName}" = {
    ports = lib.mkOption {
      internal = true;
      description = ''
        ports used on localhost by services
      '';
      type = lib.types.attrsOf lib.types.ints.u32;
    };
    uids = lib.mkOption {
      internal = true;
      description = ''
        The user IDs used in NixOS.
      '';
      type = lib.types.attrsOf lib.types.ints.u32;
    };
    gids = lib.mkOption {
      internal = true;
      description = ''
        The group IDs used in NixOS.
      '';
      type = lib.types.attrsOf lib.types.ints.u32;
    };
    subdomains = lib.mkOption {
      internal = true;
      description = ''
        the subdomains under which services are exposed
      '';
      type = lib.types.attrsOf lib.types.str;
    };
    defaultDomain = lib.mkOption {
      description = ''
        root domain under which all services are served
      '';
      type = lib.types.str;
    };
  };

  config."${moduleName}" = rec {
    defaultDomain = cfg.defaultDomain;
    ports = {
      authelia = 9091;
      grafana = 3000;
      node-exporter = 9100;
      prometheus = 9090;
      radicale = 5232;
      stepCa = 8443;
    };
    subdomains = {
      authelia = "authelia";
      grafana = "grafana";
      prometheus = "prometheus";
      radicale = "radicale";
    };
    uids = {
      authelia = 5003;
      grafana = config.ids.uids.grafana;
      prometheus = config.ids.uids.prometheus;
      radicale = 5001;
      root = config.ids.uids.root;
      samba = 5002;
    };
    gids = uids // {
      grafana = config.ids.gids.grafana;
      prometheus = config.ids.gids.prometheus;
      root = config.ids.gids.root;
    };
    userGroups = {
      authelia = "authelia";
      grafana = "grafana";
      prometheus = "prometheus";
      radicale = "radicale";
      root = "root";
      samba = "samba";
    };
  };
}
