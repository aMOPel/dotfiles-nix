{
  config,
  lib,
  ...
}:
let
  moduleName = "globals";
  cfg = config."${moduleName}";
  config-values = import ./config_values.nix;
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
    userGroups = lib.mkOption {
      internal = true;
      description = ''
        the names that serve as both username and groupname for services
      '';
      type = lib.types.attrsOf lib.types.str;
    };
    defaultDomain = lib.mkOption {
      internal = true;
      description = ''
        root domain under which all services are served
      '';
      type = lib.types.str;
    };
  };

  config."${moduleName}" = rec {
    defaultDomain = "${config-values.nixos.hostname}.lan";
    ports = {
      authelia = 9091;
      grafana = 3000;
      node-exporter = 9100;
      prometheus = 9090;
      radicale = 5232;
      step-ca = 8443;
    };
    subdomains = {
      # WARNING: the keys need to match actual service names in `config.services.`
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
