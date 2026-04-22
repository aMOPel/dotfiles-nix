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
  domainAsUrl = domain: "https://${domain}";

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
              user = builtins.toString config.myIds.uids."${userGroup}";
              group = builtins.toString config.myIds.gids."${userGroup}";
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
          gid = lib.mkForce config.myIds.gids."${userGroup}";
        };
      };
      extraUsers = {
        "${userGroup}" = {
          isSystemUser = lib.mkForce true;
          uid = lib.mkForce config.myIds.uids."${userGroup}";
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
        domainAsUrl
        createDirs
        createSystemUserGroup
        createSystemUserGroups
        ;
    };
  };
}
