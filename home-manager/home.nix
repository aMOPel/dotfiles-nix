{ config, pkgs, lib, ... }:
let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  lib = pkgs.lib;
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
    filetypes = [
      "go"
      "nix"
      "typescript"
      "css"
      "dockerfile"
      "git"
      "html"
      "json"
      "lua"
      "vim"
      "markdown"
      "python"
      "sh"
      "toml"
      "yaml"
      "misc"
    ];
  };

  programs.home-manager.enable = true;

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.language.base = "en_US.UTF-8";
  home.keyboard.layout = "us";
  home.preferXdgDirectories = true;

  home.sessionVariables = {
    EDITOR = lib.mkDefault "vim";
    VISUAL = lib.mkDefault "vim";
    MANPAGER = lib.mkDefault "less";
    PAGER = lib.mkDefault "less";
  };

  home.packages = with pkgs; [
    brave
    niv
    vim
  ];

  home.stateVersion = "23.11";
}
