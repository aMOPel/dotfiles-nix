{
  config,
  pkgs,
  lib,
  ...
}:
let
  name = "udev-rule-for-via";
  cfg = config.myModules.${name};

  udev-rule = pkgs.stdenv.mkDerivation {
    pname = "udev-rule-for-via";
    version = "2025-10-02";
    src = ./udev-rule;
    installPhase = ''
      cp -r . $out
    '';
  };
in
{
  options.myModules.${name} = {
    enable = lib.mkEnableOption "neovim";
  };

  config = lib.mkIf cfg.enable {
    services.udev.packages = [
      udev-rule
    ];
  };
}
