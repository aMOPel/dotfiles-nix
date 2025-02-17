{
  config,
  lib,
  pkgs,
  pkgs_latest,
  ...
}:
let
  cfg = config.myModules.pass;
in
{
  options.myModules.pass = {
    enable = lib.mkEnableOption "pass";
  };

  config = lib.mkIf cfg.enable {

    programs.password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [
        # exts.pass-import
      ]);
      settings = {
      };
    };

    # TODO: maybe switch to chromium to get home manager to download browser pass extension too
    programs.browserpass = {
      enable = true;
      browsers = [
        "brave"
      ];
    };

  };
}
