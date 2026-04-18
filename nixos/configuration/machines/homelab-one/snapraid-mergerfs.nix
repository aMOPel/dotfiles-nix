{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "snapraid-mergerfs";
  cfg = config.myModules."${moduleName}";
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
      example = '''';
      description = "umask for the mergerfs mountpoint";
    };
    group = lib.mkOption {
      type = lib.types.str;
      default = "root";
      example = '''';
      description = "the group that owns the mergerfs mountpoint";
    };
    user = lib.mkOption {
      type = lib.types.str;
      default = "root";
      example = '''';
      description = "the user that owns the mergerfs mountpoint";
    };
    mergerfsMountpoint = lib.mkOption {
      type = lib.types.str;
      example = '''';
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
      mergerfsSourceDirPermissions = builtins.concatStringsSep "\n" (
        builtins.map (d: ''
          chown -R ${cfg.user}:${cfg.group} ${d}/data;
          chmod -R ${cfg.filePermissionMask} ${d}/data;
        '') cfg.dataDisks
      );
      mergerfsMountpointPermissions = ''
        chown -R ${cfg.user}:${cfg.group} ${cfg.mergerfsMountpoint};
        chmod -R ${cfg.filePermissionMask} ${cfg.mergerfsMountpoint};
      '';
      mergerfsSourceDirs = builtins.concatStringsSep ":" (builtins.map (d: "${d}/data") cfg.dataDisks);
    in
    {
      # https://github.com/amadvance/snapraid/blob/master/doc/snapraid.txt
      services.snapraid = {
        enable = true;
        inherit parityFiles contentFiles dataDisks;
        touchBeforeSync = true;
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

      # set permissions
      system.activationScripts.setDataPermissions.text =
        mergerfsSourceDirPermissions + mergerfsMountpointPermissions;

      fileSystems = {
        "${cfg.mergerfsMountpoint}" = {
          device = mergerfsSourceDirs;
          fsType = "mergerfs";
          options = [
            "cache.files=off"
            "category.create=pfrd"
            "func.getattr=newest"
            "dropcacheonclose=false"
          ];
          depends = cfg.dataDisks;
        };
      };
    }
  );
}
