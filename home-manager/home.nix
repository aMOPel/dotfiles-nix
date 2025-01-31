{ config, pkgs, pkgs_latest, pkgs_for_nvim, lib, ... }:
let
  sources = import ../nix/sources.nix;
  pkgs = import sources.nixpkgs { };
  pkgs_latest = import sources."nixpkgs_latest" { };
  pkgs_for_nvim = import sources."nixpkgs_for_nvim" { };
  lib = pkgs.lib;
  personalInfo = import ./personal_info.nix { inherit lib; };
in
{
  imports = [
    (import ./modules/nvim       {inherit config pkgs_latest lib; pkgs = pkgs_for_nvim;})
    (import ./modules/kitty      {inherit config pkgs pkgs_latest lib;})
    (import ./modules/bash       {inherit config pkgs pkgs_latest lib;})
    (import ./modules/git        {inherit config pkgs pkgs_latest lib;})
    (import ./modules/shelltools {inherit config pkgs pkgs_latest lib;})
    (import ./modules/ranger     {inherit config pkgs pkgs_latest lib;})
    (import ./modules/task       {inherit config pkgs pkgs_latest lib;})
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

      "cpp"
      "rust"
      "go"
      "python"
      "gdscript"

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
