# https://github.com/NixOS/nixpkgs/blob/nixos-25.11/nixos/modules/misc/ids.nix
{
  config,
  lib,
  ...
}:
{
  options = {
    myIds.uids = lib.mkOption {
      internal = true;
      description = ''
        The user IDs used in NixOS.
      '';
      type = lib.types.attrsOf lib.types.ints.u32;
    };

    myIds.gids = lib.mkOption {
      internal = true;
      description = ''
        The group IDs used in NixOS.
      '';
      type = lib.types.attrsOf lib.types.ints.u32;
    };
  };

  config = {
    myIds = rec {
      uids = {
        radicale = 5001;
        samba = 5002;
        grafana = config.ids.uids.grafana;
        prometheus = config.ids.uids.prometheus;
      };
      gids = uids;
    };
  };
}
