{ lib, pkgs, ... }:
let
in
{
  extraConfig =
    "\n\n"
    + builtins.readFile ./init.vim
    + builtins.readFile ./general/mappings.vim
    + builtins.readFile ./general/neovim.vim
    + builtins.readFile ./general/options.vim
    + builtins.readFile ./general/unix.vim
    + builtins.readFile ./vim-sandwich/surround.vim
  ;
}
