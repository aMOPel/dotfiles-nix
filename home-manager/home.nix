{ config, lib, pkgs, ... }:
let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs { };
in
{

  imports = [
    ./modules/nvim
    ./modules/kitty
    ./modules/bash
    ./modules/shelltools
    ./modules/ranger
  ];

  home.sessionVariables =
    {
      EDITOR = lib.mkDefault "vim";
      VISUAL = lib.mkDefault "vim";
      MANPAGER = lib.mkDefault "less";
      PAGER = lib.mkDefault "less";
    };

  home.username = "momo";
  home.homeDirectory = "/home/momo";


  home.packages = with pkgs; [
    niv
    vim
  ];

  home.file = {
    "dotfiles-nix".source = ./..;
  };

  programs.home-manager.enable = true;

  home.stateVersion = "23.11";
}
