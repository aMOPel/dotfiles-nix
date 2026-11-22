{
  config-values,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./modules/nvim
    ./modules/kitty
    ./modules/bash
    ./modules/git
    ./modules/shelltools
    ./modules/yazi
    ./modules/task
    ./modules/gnome
    ./modules/gpg
    ./modules/pass
    ./modules/mime-applications
    ./modules/treefmt
    ./modules/lazyjournal
    ./modules/zathura
  ];

  # uninstall = true;
  # targets.genericLinux.enable = true;

  myModules = config-values.homeManagerModules;

  programs.home-manager.enable = false;

  home.username = config-values.username;
  home.homeDirectory = config-values.homeDirectory;
  home.language.base = "en_US.UTF-8";
  home.keyboard.layout = "us";
  home.preferXdgDirectories = true;

  i18n.glibcLocales = pkgs.glibcLocales.override {
    allLocales = false;
    locales = [
      "en_US.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];
  };

  home.sessionVariables = {
    EDITOR = lib.mkDefault "vim";
    VISUAL = lib.mkDefault "vim";
    MANPAGER = lib.mkDefault "less";
    PAGER = lib.mkDefault "less";
  };

  home.packages = with pkgs; [
    pkgs.brave
    niv
    vim
  ];

  home.stateVersion = "23.11";
}
