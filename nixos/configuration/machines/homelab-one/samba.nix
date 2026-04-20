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
      example = "";
      description = "the group of the samba user";
    };
    allowedUsers = lib.mkOption {
      type = lib.types.str;
      default = "";
      example = "";
      description = "space separated list, only these user names can log in";
    };
    sambaUser = lib.mkOption {
      type = lib.types.str;
      default = "samba-user";
      example = "";
      description = "the samba user";
    };
    sambaUid = lib.mkOption {
      type = lib.types.int;
      default = 1001;
      example = "";
      description = "the uid of the samba user";
    };
    sambaGid = lib.mkOption {
      type = lib.types.int;
      default = 1001;
      example = "";
      description = "the gid of the samba group";
    };
    filePermissionMask = lib.mkOption {
      type = lib.types.str;
      default = "0770";
      example = "";
      description = "umask for all samba share files and directories";
    };
    shareParentDir = lib.mkOption {
      type = lib.types.str;
      example = "";
      description = ''
        the parent directory of the share directory.
              the share directory will be created inside that directory with the correct permissions.'';
    };
    sambaServerName = lib.mkOption {
      type = lib.types.str;
      example = "";
      description = "the name of the samba server (netbios, server string)";
    };
    sambaShareName = lib.mkOption {
      type = lib.types.str;
      default = "public";
      example = "";
      description = "the name of the samba share, visible when logging in";
    };
  };

  config = lib.mkIf cfg.enable (
    let
      # create this dir and hardlink it to `targetMountPoint`
      sambaDir = "${cfg.shareParentDir}/samba-share";
      shareDir = "${sambaDir}/${cfg.sambaShareName}";
    in
    {
      # ensure the directories for samba exist after boot
      systemd.tmpfiles.rules = [
        "d ${sambaDir} ${cfg.filePermissionMask} ${cfg.sambaUser} ${cfg.sambaGroup} -"
        "d ${shareDir} ${cfg.filePermissionMask} ${cfg.sambaUser} ${cfg.sambaGroup} -"
      ];

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
            # for debugging
            # "log level" = "3 auth:5 passdb:5";

            "server string" = "samba-${cfg.sambaServerName}";
            "netbios name" = builtins.substring 0 15 "${cfg.sambaServerName}"; # 15 chat limit
            "passwd program" = "/run/wrappers/bin/passwd %u";
            # use simple password based authentication
            "security" = "user";
            "server role" = "standalone";
            "ntlm auth" = "ntlmv2-only";

            # harden
            "restrict anonymous" = 2;
            "map to guest" = "never";
            "client min protocol" = "SMB3";
            "client max protocol" = "SMB3";
            "server min protocol" = "SMB3";
            "server max protocol" = "SMB3";
            "client signing" = "required";
            "server signing" = "required";
            "client smb encrypt" = "required";
            "server smb encrypt" = "required";
            # disable printer features
            "load printers" = "no";
            "disable spoolss" = "yes";
            "printcap name" = "/dev/null";
            # disable dns features
            "wins support" = "no";
            "dns proxy" = "no";
            "multicast dns register" = "no";
            # network
            # TODO: get the interface name from somewhere else
            "interfaces" = "enp1s0 127.0.0.1";
            "bind interfaces only" = "yes";
            # tls
            "tls enabled" = "no"; # tls only used for ldap
          };
          "${cfg.sambaShareName}" = {
            "printing" = "bsd";

            # harden
            "guest ok" = "no";
            "valid users" = "${cfg.allowedUsers}";
            # whether the share is discoverable on the network
            "browseable" = "no";
            # only allow local network access
            "hosts deny" = "ALL";
            "hosts allow" = "192.168.1. 127.0.0.1";

            path = "${shareDir}";
            writable = "yes";
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
