{
  config,
  lib,
  pkgs,
  pkgs_latest,
  ...
}:
let
  cfg = config.myModules.gpg;
  gpgPkg = config.programs.gpg.package;
in
{
  options.myModules.gpg = {
    enable = lib.mkEnableOption "gpg";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gcr
    ];

    home.sessionVariables = {
      SSH_AUTH_SOCK = "$(${gpgPkg}/bin/gpgconf --list-dirs agent-ssh-socket)";
    };

    programs.gpg = {
      enable = true;
      mutableKeys = true;
      mutableTrust = true;
      scdaemonSettings = {
        disable-ccid = true;
      };
      settings = {
        # armor = true;
      };
    };
    services.gpg-agent = {
      enable = true;
      enableBashIntegration = true;
      enableScDaemon = true;
      enableSshSupport = true;
      sshKeys = [
        "D8D21C00002B50535AC339A7DACB46B749B06047"
      ];
      pinentry.package = pkgs.pinentry-gnome3;
      # pinentryPackage = pkgs.pinentry-tty;
      # extraConfig = ''
      #   allow-loopback-pinentry
      # '';
    };
  };
}
