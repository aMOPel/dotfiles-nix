{
  config,
  lib,
  ...
}:
let
  moduleName = "samba";
  cfg = config.myModules."${moduleName}";
in
{
  options.myModules."${moduleName}" = {
    enable = lib.mkEnableOption "${moduleName}";
    sambaGroup = lib.mkOption {
      type = lib.types.str;
      default = "samba-group";
      example = '''';
      description = "the group of the samba user";
    };
    sambaUser = lib.mkOption {
      type = lib.types.str;
      default = "samba-user";
      example = '''';
      description = "the samba user";
    };
    sambaUid = lib.mkOption {
      type = lib.types.int;
      default = 1001;
      example = '''';
      description = "the uid of the samba user";
    };
    sambaGid = lib.mkOption {
      type = lib.types.int;
      default = 1001;
      example = '''';
      description = "the gid of the samba group";
    };
    filePermissionMask = lib.mkOption {
      type = lib.types.string;
      default = "0775";
      example = '''';
      description = "umask for all samba share files and directories";
    };
    shareParentDir = lib.mkOption {
      type = lib.types.string;
      example = '''';
      description = ''
        the parent directory of the share directory.
              the share directory will be created inside that directory with the correct permissions.'';
    };
    publicShareName = lib.mkOption {
      type = lib.types.string;
      example = '''';
      description = "the name under which the share can be found";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      # create this dir and hardlink it to `targetMountPoint`
      sourceMountPoint = "${cfg.shareParentDir}/samba-share";
      targetMountPoint = "/srv/samba/public";
    in
    {
      # ensure the directories for samba exist after boot
      systemd.tmpfiles.rules = [
        "d ${sourceMountPoint} ${cfg.filePermissionMask} ${cfg.sambaUser} ${cfg.sambaGroup} -"
        "d ${targetMountPoint} ${cfg.filePermissionMask} ${cfg.sambaUser} ${cfg.sambaGroup} -"
      ];

      # hardlink from `targetMountPoint` to `sourceMountPoint`
      fileSystems."${targetMountPoint}" = {
        device = "${sourceMountPoint}";
        options = [ "bind" ];
      };

      users = {
        groups = {
          "${cfg.sambaGroup}" = {
            gid = cfg.sambaGid;
          };
        };
        extraUsers = {
          "${cfg.sambaUser}" = {
            isSystemUser = true;
            uid = cfg.sambaUid;
            group = "${cfg.sambaGroup}";
          };
        };
      };

      services.samba = {
        enable = true;
        openFirewall = true;
        settings = {
          # https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html
          global = {
            "server string" = "${cfg.publicShareName}";
            "netbios name" = "${cfg.publicShareName}";
            "invalid users" = [
              "root"
            ];
            "passwd program" = "/run/wrappers/bin/passwd %u";
            # use simple password based authentication
            security = "user";
            # only allow local network access
            "hosts allow" = "192.168.1. 127.0.0.1";
            "hosts deny" = "ALL";
          };
          public = {
            path = "${targetMountPoint}";
            writable = "yes";
            "guest ok" = "no";
            # whether the share is discoverable on the network
            "browseable" = "yes";
            "directory mask" = "${cfg.filePermissionMask}";
            "create mask" = "${cfg.filePermissionMask}";
            # after smb login, regardless of who logged in, all file actions are performed as this user
            "force user" = "${cfg.sambaUser}";
            # after smb login, regardless of who logged in, all file actions are performed as this group
            "force group" = "${cfg.sambaGroup}";
          };
        };
      };
    }
  );
}
