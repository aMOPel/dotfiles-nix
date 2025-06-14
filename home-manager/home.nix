{
  config-values-path ? ../config_values.nix,
  config,
  pkgs_latest,
  pkgs_for_nvim,
  pkgs,
  lib,
  hmlib,
  ...
}:
let
  # check that every leaf is different from emtpy string
  config-values = lib.attrsets.mapAttrsRecursive
    (name: value:
    assert
    lib.asserts.assertMsg (value != "")
      "you have to provide a value for the key '${lib.strings.concatStringsSep "." name}'";
    value)
    (import config-values-path);
in
{
  imports = [
    (import ./modules/nvim              {inherit config pkgs_latest lib; pkgs = pkgs_for_nvim;})
    (import ./modules/kitty             {inherit config pkgs_latest pkgs lib;})
    (import ./modules/bash              {inherit config pkgs_latest pkgs lib;})
    (import ./modules/git               {inherit config pkgs_latest pkgs lib;})
    (import ./modules/shelltools        {inherit config pkgs_latest pkgs lib;})
    (import ./modules/yazi              {inherit config pkgs_latest pkgs lib;})
    (import ./modules/task              {inherit config pkgs_latest pkgs lib;})
    (import ./modules/gnome             {inherit config pkgs_latest pkgs lib hmlib;})
    (import ./modules/gpg               {inherit config pkgs_latest pkgs lib;})
    (import ./modules/pass              {inherit config pkgs_latest pkgs lib;})
    (import ./modules/mime-applications {inherit config pkgs_latest pkgs lib;})
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
    locales = [ "en_US.UTF-8/UTF-8" "de_DE.UTF-8/UTF-8" ];
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
