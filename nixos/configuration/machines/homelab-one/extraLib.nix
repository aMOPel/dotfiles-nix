{
  config,
  lib,
  ...
}:
let
  localHostname = "localhost";
  localAddress = "127.0.0.1";
  localUrl = "http://${localAddress}";
  localAddressWithPort = port: "${localAddress}:${builtins.toString port}";
  localHostnameWithPort = port: "${localHostname}:${builtins.toString port}";
  localUrlWithPort = port: "${localUrl}:${builtins.toString port}";
  localAddressWithPortFor = service: localAddressWithPort config.globals.port."${service}";
  localHostnameWithPortFor = service: localHostnameWithPort config.globals.port."${service}";
  localUrlWithPortFor = service: localUrlWithPort config.globals.port."${service}";
  domainAsUrl = domain: "https://${domain}";
  domainFor = service: "${config.globals.subdomains."${service}"}.${config.globals.defaultDomain}";

  createDirs =
    {
      userGroup,
      dirs,
      mode ? "0770",
      priority ? 5,
    }:
    {
      "${builtins.toString priority}-${userGroup}" = builtins.foldl' (x: y: x // y) { } (
        builtins.map (v: {
          "${v}" = {
            "d" = {
              inherit mode;
              user = builtins.toString config.globals.uids."${userGroup}";
              group = builtins.toString config.globals.gids."${userGroup}";
            };
          };
        }) dirs
      );
    };

  createSystemUserGroup =
    {
      userGroup,
    }:
    {
      groups = {
        "${userGroup}" = {
          gid = lib.mkForce config.globals.gids."${userGroup}";
        };
      };
      extraUsers = {
        "${userGroup}" = {
          isSystemUser = lib.mkForce true;
          uid = lib.mkForce config.globals.uids."${userGroup}";
          group = lib.mkForce "${userGroup}";
        };
      };
    };

  createSystemUserGroups =
    userGroups:
    builtins.foldl'
      (x: y: {
        groups = x.groups // y.groups;
        extraUsers = x.extraUsers // y.extraUsers;
      })
      {
        groups = { };
        extraUsers = { };
      }
      (builtins.map (userGroup: createSystemUserGroup { inherit userGroup; }) userGroups);

in
{
  options = {
    extraLib = lib.mkOption {
      internal = true;
      description = ''
        extra library functions
      '';
      type = lib.types.attrs;
    };
  };
  config = {
    extraLib = {
      inherit
        localHostname
        localAddress
        localUrl
        localAddressWithPort
        localHostnameWithPort
        localUrlWithPort
        localAddressWithPortFor
        localHostnameWithPortFor
        localUrlWithPortFor
        domainAsUrl
        createDirs
        createSystemUserGroup
        createSystemUserGroups
        domainFor
        ;
    };
  };
}
