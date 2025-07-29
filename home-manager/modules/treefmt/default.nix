{
  config,
  pkgs,
  lib,
  ...
}:
let
  treefmt-nix = import pkgs.treefmt-nix;

  cfg = config.myModules.treefmt;

  myTreefmt = treefmt-nix.mkWrapper pkgs {
    package = pkgs.treefmt;
    projectRootFile = ".git/config";
    programs.deno.enable = true;
    # settings.formatter.deno.options = [
    #   "--indent-width=3"
    # ];
  };
in
{
  options.myModules.treefmt = {
    enable = lib.mkEnableOption "treefmt";
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      myTreefmt
    ];
  };
}
