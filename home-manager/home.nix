{ config, pkgs, lib, ... }:
let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  lib = pkgs.lib;
  personalInfo = import ./personal_info.nix { inherit lib; };
in
{
  imports = [
    ./modules/nvim
    ./modules/kitty
    ./modules/bash
    ./modules/git
    ./modules/shelltools
    ./modules/ranger
    ./modules/task
  ];

  # uninstall = true;
  # targets.genericLinux.enable = true;

  myModules.task = {
    enable = true;
    context = personalInfo.task.context;
  };

  myModules.git = {
    enable = true;
    enableLazygit = true;
    userName = personalInfo.git.userName;
    userEmail = personalInfo.git.userEmail;
  };

  myModules.neovim = {
    enable = true;
    filetypes = [
      "sh"
      "dotenv"
      "nix"
      "make"
      "dockerfile"
      "git"
      "markdown"

      "json"
      "toml"
      "yaml"

      "typescript"
      "css"
      "html"

      "lua"
      "vim"

      "go"
      "python"

      "misc"
    ];
  };

  programs.home-manager.enable = true;

  home.username = personalInfo.username;
  home.homeDirectory = personalInfo.homeDirectory;
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
