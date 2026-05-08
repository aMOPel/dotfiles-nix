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
    ldap = lib.mkOption {
      internal = true;
      description = ''
        ldap definitions
      '';
      type = lib.types.attrs;
    };
  };

  config."${moduleName}" = rec {
    defaultDomain = "${config-values.nixos.hostname}.lan";
    ports = {
      authelia = 9091;
      dnsmasq = 53;
      dnsmasq-exporter = 9103;
      forgejo = 9106;
      grafana = 3000;
      nginx-exporter = 9102;
      node-exporter = 9100;
      openldap = 389;
      process-exporter = 9105;
      prometheus = 9090;
      radicale = 5232;
      smartctl-exporter = 9101;
      step-ca = 8443;
      systemd-exporter = 9104;
    };
    subdomains = {
      # WARNING: the keys need to match actual service names in `config.services.`
      authelia = "authelia";
      forgejo = "forgejo";
      grafana = "grafana";
      prometheus = "prometheus";
      radicale = "radicale";
    };
    uids = {
      authelia = 5003;
      forgejo = 5005;
      grafana = config.ids.uids.grafana;
      prometheus = config.ids.uids.prometheus;
      radicale = 5001;
      root = config.ids.uids.root;
      samba = 5002;
      systemd-exporter = 5004;
    };
    gids = uids // {
      prometheus = config.ids.gids.prometheus;
      root = config.ids.gids.root;
    };
    userGroups = {
      authelia = "authelia";
      forgejo = "forgejo";
      grafana = "grafana";
      openldap = "openldap";
      prometheus = "prometheus";
      radicale = "radicale";
      root = "root";
      samba = "samba";
      step-ca = "step-ca";
      systemd-exporter = "systemd-exporter";
    };
    ldap = rec {
      attributes = {
        groups = "ou=groups";
        people = "ou=people";
        services = "ou=services";
      };
      DNs = rec {
        defaultDomain = "dc=homelab-one,dc=lan";
        rootAdmin = "cn=admin,${defaultDomain}";
        groups = rec {
          root = "${attributes.groups},${defaultDomain}";
          admin = "cn=admin,${root}";
        };
        people = rec {
          root = "${attributes.people},${defaultDomain}";
        };
        services = rec {
          root = "${attributes.services},${defaultDomain}";
          authelia = "uid=authelia,${root}";
          grafana = "uid=grafana,${root}";
          radicale = "uid=radicale,${root}";
        };
      };
    };
  };
}
