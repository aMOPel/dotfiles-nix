{
  lib,
  pkgs,
  pkgs_latest,
  ...
}:
let
in
{
  extraConfig =
    "\n\n"
    + builtins.readFile ./lua/options.lua
    + builtins.readFile ./lua/autocmds.lua
    + builtins.readFile ./lua/mappings.lua
    + builtins.readFile ./lua/misc.lua;
}
