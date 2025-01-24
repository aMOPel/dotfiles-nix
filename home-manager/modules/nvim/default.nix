{ config, lib, pkgs, pkgs_latest, ... }:
let
  cfg = config.myModules.neovim;
in
{
  options.myModules.neovim = {
    enable = lib.mkEnableOption "neovim";
    filetypes = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      example = ''["cpp", "javascript"]'';
      description = "A list of filetypes that neovim should support";
    };
  };

  config = lib.mkIf cfg.enable {

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

    programs.neovim =
      let
        plugins = import ./plugins { inherit lib pkgs; };
        lua = import ./config { inherit lib pkgs; };
        filetypePackages = import ./filetypePackages {
          inherit lib pkgs pkgs_latest;
          filetypes = cfg.filetypes;
        };
      in
      {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;
        vimdiffAlias = true;
        plugins = filetypePackages.plugins ++ plugins.plugins;
        extraPackages = filetypePackages.packages;
        extraLuaConfig = lua.extraConfig + filetypePackages.extraConfig + plugins.extraConfig;
      };
  };
}
