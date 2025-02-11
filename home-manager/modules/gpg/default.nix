{
  config,
  lib,
  pkgs,
  pkgs_latest,
  ...
}:
let
  cfg = config.myModules.gpg;
in
{
  options.myModules.gpg = {
    enable = lib.mkEnableOption "gpg";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gcr
    ];

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
      enableSshSupport = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };
}
