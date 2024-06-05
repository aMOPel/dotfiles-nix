{ lib, pkgs, ... }:
let
in
{
  extraConfig =
    "\n\n"
    + builtins.readFile ./vim-sandwich/surround.vim
  ;
}
