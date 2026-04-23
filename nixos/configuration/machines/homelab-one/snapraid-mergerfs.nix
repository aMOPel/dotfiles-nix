{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "snapraid-mergerfs";
  cfg = config.myModules."${moduleName}";
  inherit (config.globals)
    ports
    subdomains
    uids
    gids
    userGroups
    defaultDomain
    ;
  inherit (config) extraLib;
in
{
  options.myModules."${moduleName}" = {
    enable = lib.mkEnableOption "${moduleName}";
    parityDisks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      example = ''[ "/snapraid/parity-disk1" ]'';
      description = "drives to use purely for parity";
    };
    dataDisks = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      example = ''[ "/snapraid/disk1" ]'';
      description = "drives to use for data";
    };
    filePermissionMask = lib.mkOption {
      type = lib.types.str;
      default = "0775";
      example = "";
      description = "umask for the mergerfs mountpoint";
    };
    mergerfsMountpoint = lib.mkOption {
      type = lib.types.str;
      example = "";
      description = "where the mergerfs is mounted to";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      parityFiles = builtins.map (d: "${d}/snapraid.parity") cfg.parityDisks;
      contentFiles = builtins.map (d: "${d}/snapraid.content") cfg.dataDisks;
      last = l: builtins.elemAt l ((builtins.length l) - 1);
      dataDisks = builtins.listToAttrs (
        builtins.map (d: {
          name = last (builtins.split "/" d);
          value = d;
        }) cfg.dataDisks
      );
      mergerfsSourceDirs = builtins.concatStringsSep ":" (builtins.map (d: "${d}/data") cfg.dataDisks);
    in
    {
      # https://github.com/amadvance/snapraid/blob/master/doc/snapraid.txt
      services.snapraid = {
        enable = true;
        inherit parityFiles contentFiles dataDisks;
        touchBeforeSync = true;
        # TODO: setup monitoring with prometheus or similar for the output of `snapraid status`
        sync = {
          interval = "01:00"; # recalc parity every night
        };
        scrub = {
          interval = "Mon *-*-* 02:00:00"; # check for errors every week
          plan = 8; # check 8% of the array
          olderThan = 10; # check block older than 10 days
        };
      };

      # https://trapexit.github.io/mergerfs/latest/quickstart/#usage
      environment.systemPackages = with pkgs; [
        mergerfs
      ];

      systemd.tmpfiles.settings = config.extraLib.createDirs {
        userGroup = userGroups.root;
        priority = 0;
        dirs = (builtins.map (v: "${v}/data") cfg.dataDisks) ++ [
          cfg.mergerfsMountpoint
        ];
        mode = cfg.filePermissionMask;
      };

      # WARNING: mergerfs does not support "remount", which `nixos-rebuild switch` uses to restart the service.
      # to restart with new options, comment out, `nixos-rebuild switch`, comment back in, `nixos-rebuild switch`
      fileSystems = {
        "${cfg.mergerfsMountpoint}" = {
          device = mergerfsSourceDirs;
          fsType = "mergerfs";
          options = [
            "cache.files=off"
            "category.create=lfs" # least free space, completely fill up one disk first
            "func.getattr=newest"
            "dropcacheonclose=false"
          ];
          depends = cfg.dataDisks;
        };
      };

    }
  );
}
