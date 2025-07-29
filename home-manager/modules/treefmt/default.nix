{
  config,
  pkgs,
  lib,
}:
let
  inherit (pkgs) treefmt-nix;
  cfg = config.myModules.treefmt;

  myTreefmt = treefmt-nix.mkWrapper pkgs {
    projectRootFile = ".git/config";
    programs.deno.enable = true;
    settings.formatter.deno.args = [
      "fmt"
      "--indent-width=3"
    ];
  };
in
{
  options.myModules.git = {
    enable = lib.mkEnableOption "treefmt";
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      myTreefmt
    ];
  };
}
