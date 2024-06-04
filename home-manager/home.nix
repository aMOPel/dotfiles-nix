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
    ./modules/git
    ./modules/shelltools
    ./modules/ranger
    ./modules/lazygit
  ];

  # uninstall = true;
  # targets.genericLinux.enable = true;

  myModules.neovim = {
    enable = true;
    filetypes = [ "go" ];
  };

  programs.home-manager.enable = true;

  home.username = "momo";
  home.homeDirectory = "/home/momo";
  home.language.base = "en_US";
  home.keyboard.layout = "us";
  home.preferXdgDirectories = true;

  home.sessionVariables = {
    EDITOR = lib.mkDefault "vim";
    VISUAL = lib.mkDefault "vim";
    MANPAGER = lib.mkDefault "less";
    PAGER = lib.mkDefault "less";
  };

  home.packages = with pkgs; [
    niv
    vim
  ];

  home.stateVersion = "23.11";
}
