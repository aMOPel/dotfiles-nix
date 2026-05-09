{
  config,
  lib,
  pkgs,
  ...
}:
let
  moduleName = "samba";
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
    filePermissionMask = lib.mkOption {
      type = lib.types.str;
      default = "0770";
      example = "";
      description = "umask for all grafana and prometheus files and directories";
    };
    shareParentDir = lib.mkOption {
      type = lib.types.str;
      example = "";
      description = ''
        the parent directory of the share directory.
              the share directory will be created inside that directory with the correct permissions.'';
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
      myModules.auth = {
        enable = true;
      };

      # ensure the directories for samba exist after boot
      systemd.tmpfiles.settings = extraLib.createDirs {
        userGroup = userGroups.samba;
        mode = cfg.filePermissionMask;
        dirs = [
          sambaDir
          shareDir
        ];
      };

      users = extraLib.createSystemUserGroup {
        userGroup = userGroups.samba;
      };

      sops.secrets."ldap/users.ldif" = {
        restartUnits = lib.mkAfter [
          "samba-user-provisioning.service"
        ];
      };

      # we cheat here, not using actual ldap as auth backend, since that is too complicated
      # instead we inject the ldap users into the smb user db on startup
      systemd.services.samba-user-provisioning = {
        wantedBy = [ "multi-user.target" ];
        after = [ "openldap.service" ];
        before = [ "samba.service" ];

        serviceConfig.Type = "oneshot";

        path = with pkgs; [
          shadow
          gawk
          samba
        ];
        script = ''
          # delete all entries
          # WARNING: if usernames have collision with other users on system like service users,
          # deleting could cause issues
          pdbedit -L | awk -F: '{print $1}' |
          while read -r user; do
            smbpasswd -x "$user" && (userdel "$user" || true);
          done

          # create entries from ldap users
          awk '
          BEGIN { RS="" }
          match($0, /uid: ([^\n]+)/, u) &&
          match($0, /uidNumber: ([^\n]+)/, i) &&
          match($0, /userPassword: ([^\n]+)/, p) {
            print u[1], p[1], i[1]
          }
          ' "${config.sops.secrets."ldap/users.ldif".path}" |
          while read -r user pass uid; do
            useradd --no-create-home --no-user-group --uid "$uid" "$user" || true;
            printf '%s\n%s\n' "$pass" "$pass" | smbpasswd -a -s "$user";
          done
        '';
      };

      services.samba = {
        enable = true;
        openFirewall = true;
        settings = {
          # https://www.samba.org/samba/docs/current/man-html/smb.conf.5.html
          global = {
            # for debugging
            # "log level" = "3 auth:5 passdb:5";

            "server string" = "samba-${defaultDomain}";
            "netbios name" = builtins.substring 0 15 "${defaultDomain}"; # 15 char limit
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
            "interfaces" = "enp1s0 ${extraLib.localAddress}";
            "bind interfaces only" = "yes";
            # tls
            "tls enabled" = "no"; # tls only used for ldap
          };
          "${cfg.sambaShareName}" = {
            "printing" = "bsd";

            # harden
            "guest ok" = "no";
            # whether the share is discoverable on the network
            "browseable" = "no";
            # only allow local network access
            "hosts deny" = "ALL";
            "hosts allow" = "192.168.1. ${extraLib.localAddress}";

            path = "${shareDir}";
            writable = "yes";
            "directory mask" = "${cfg.filePermissionMask}";
            "create mask" = "${cfg.filePermissionMask}";
            # after smb login, regardless of who logged in, all file actions are performed as this user
            "force user" = "${userGroups.samba}";
            # after smb login, regardless of who logged in, all file actions are performed as this group
            "force group" = "${userGroups.samba}";
          };
        };
      };
    }
  );
}
