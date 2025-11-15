{
  config,
  lib,
  global-treefmt,
  ...
}:
let
  cfg = config.myModules.treefmt;
in
{
  options.myModules.treefmt = {
    enable = lib.mkEnableOption "treefmt";
  };
  config = lib.mkIf cfg.enable {
    home.packages = [
      global-treefmt
    ];
  };
}
