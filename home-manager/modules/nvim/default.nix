{ config, lib, pkgs, ... }:
let
  filetypePackages = import ./filetypePackages { inherit lib pkgs; };
  plugins = import ./plugins { inherit lib pkgs; };
  vimscript = import ./vimscript { inherit lib pkgs; };
in
{
  home.packages = with pkgs; [
    # nvimpager
    neovim-remote
  ];

  home.sessionVariables =
    {
      EDITOR = lib.mkForce "nvim";
      VISUAL = lib.mkForce "nvim";
      MANPAGER = lib.mkForce "nvim +Man!";
      # PAGER = lib.mkForce "nvimpager";
    };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    plugins = filetypePackages.plugins ++ plugins.plugins;
    extraPackages = filetypePackages.packages;
    extraConfig = vimscript.extraConfig;
    extraLuaConfig = filetypePackages.extraConfig + plugins.extraConfig;
  };
}
