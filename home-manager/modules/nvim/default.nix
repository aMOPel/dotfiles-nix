{ config, lib, pkgs, ... }:
let
  filetypePackages = import ./filetypePackages.nix { inherit lib pkgs; };
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
    plugins = (with pkgs.vimPlugins; [
      # common
      {
        type = "lua";
        plugin = plenary-nvim;
        optional = true;
      }
      {
        type = "lua";
        plugin = fzfWrapper;
        optional = true;
      }
      {
        type = "lua";
        plugin = fzf-vim;
        optional = true;
      }
      {
        type = "lua";
        plugin = telescope-fzf-native-nvim;
        optional = true;
      }
      {
        type = "lua";
        plugin = fuzzy-nvim;
        optional = true;
      }
      {
        type = "lua";
        plugin = nui-nvim;
        optional = true;
      }

      # basics
      indent-blankline-nvim
      vim-matchup
      # vim-cutlass
      vim-unimpaired
      # vim-shot-f
      vim-highlightedyank
      # vim-ipmotion
      vim-repeat
      vim-dotenv

      # snippets
      vim-vsnip
      vim-vsnip-integ
      friendly-snippets
      # vscode-angular-snippets

      # cmp
      nvim-cmp
      lspkind-nvim
      cmp-vsnip
      cmp-calc
      cmp-emoji
      cmp-buffer
      cmp-nvim-lua
      cmp-rg
      cmp-cmdline
      cmp-git
      cmp-dap
      cmp-fuzzy-path
      cmp-nvim-lsp

      # treesitter
      nvim-treesitter
      nvim-treesitter-context
      nvim-treesitter-textobjects
      nvim-ts-context-commentstring

      # visuals
      nvim-web-devicons
      lualine-nvim
      onedark-nvim
      nvim-scrollbar
      nvim-hlslens

      # debug
      nvim-dap
      nvim-dap-ui
      nvim-dap-go

      # text manipulation
      vim-textobj-user
      # vim-textobj-indent
      vim-textobj-comment
      vim-textobj-entire
      # textobj-word-column-vim
      mini-nvim
      dial-nvim
      sideways-vim
      # vim-schlepp REPLACE with mini.move
      vim-subversive
      # vim-yoink
      vim-abolish

      vim-sandwich
      vim-exchange
      comment-nvim
      # vim-surround-funk
      camelcasemotion
      vim-argwrap

      # filetype specific
      typescript-nvim
      emmet-vim
      package-info-nvim
      nvim-colorizer-lua
      # vim-textobj-xmlattr

      # situational
      # NEW
      toggleterm-nvim
      vim-grepper
      vim-fugitive
      vim-rhubarb
      rnvimr
      todo-comments-nvim

      # NEW
      undotree
      nvim-bqf
      # qf-nvim

    ] ++ filetypePackages);
  };
}
