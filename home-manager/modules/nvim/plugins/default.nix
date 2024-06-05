{ lib, pkgs, ... }:
let

  qf-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "qf-nvim";
    version = "2024-05-21";
    src = pkgs.fetchFromGitHub {
      owner = "ten3roberts";
      repo = "qf.nvim";
      rev = "e7db62a4ec814c12585c0c8262d3304000a1af2e";
      sha256 = "sha256-Xk4mg1zKzJ7EEqZOTkYWa5N4QxJ/QH5C+L9sTjO9FsU=";
    };
    meta.homepage = "https://github.com/ten3roberts/qf.nvim";
  };

  vim-cutlass = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-cutlass";
    version = "2024-06-04";
    src = pkgs.fetchFromGitHub {
      owner = "svermeulen";
      repo = "vim-cutlass";
      rev = "7afd649415541634c8ce317fafbc31cd19d57589";
      sha256 = "sha256-j5W9q905ApDf3fvCIS4UwyHYnEZu5Ictn+6JkV/xjig=";
    };
    meta.homepage = "https://github.com/svermeulen/vim-cutlass";
  };

  vim-ipmotion = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-ipmotion";
    version = "2024-06-04";
    src = pkgs.fetchFromGitHub {
      owner = "justinmk";
      repo = "vim-ipmotion";
      rev = "74762a4fae452766e462ca563c169f781971bad9";
      sha256 = "sha256-+giBR41RdCwhCPII1ru2ROX08be540M00KQeOqbS4sc=";
    };
    meta.homepage = "https://github.com/justinmk/vim-ipmotion";
  };

  vim-shot-f = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-shot-f";
    version = "2024-06-04";
    src = pkgs.fetchFromGitHub {
      owner = "deris";
      repo = "vim-shot-f";
      rev = "eea71d2a1038aa87fe175de9150b39dc155e5e7f";
      sha256 = "sha256-iAPvIs/lhW+w5kFTZKaY97D/kfCGtqKrJVFvZ8cHu+c=";
    };
    meta.homepage = "https://github.com/deris/vim-shot-f";
  };

  vim-yoink = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-yoink";
    version = "2024-06-04";
    src = pkgs.fetchFromGitHub {
      owner = "svermeulen";
      repo = "vim-yoink";
      rev = "89ed6934679fdbc3c20f552b50b1f869f624cd22";
      sha256 = "sha256-ekGKOYzmdaMqAun/3fRGlhA7bLKuhzsXsEcFNukgFWU=";
    };
    meta.homepage = "https://github.com/svermeulen/vim-yoink";
  };

  textobj-word-column-vim = pkgs.vimUtils.buildVimPlugin {
    pname = "textobj-word-column-vim";
    version = "2024-06-05";
    src = pkgs.fetchFromGitHub {
      owner = "coderifous";
      repo = "textobj-word-column.vim";
      rev = "cb40e1459817a7fa23741ff6df05e4481bde5a33";
      sha256 = "sha256-6brmwkaxlSDLm2xXHkV6CsOL+bvsWLsZwE94eaRXFb0=";
    };
    meta.homepage = "https://github.com/coderifous/textobj-word-column.vim";
  };

in
{
  plugins = with pkgs.vimPlugins; [
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
    vim-asterisk
    vim-cutlass
    vim-shot-f
    vim-ipmotion
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

    # visuals
    nvim-web-devicons
    lualine-nvim
    onedark-nvim
    nvim-scrollbar
    nvim-hlslens
    dressing-nvim

    # text manipulation
    vim-textobj-user
    textobj-word-column-vim
    mini-nvim
    dial-nvim
    sideways-vim
    vim-subversive
    vim-yoink
    vim-abolish
    camelcasemotion

    # situational
    toggleterm-nvim
    vim-grepper
    vim-fugitive
    vim-rhubarb
    rnvimr
    todo-comments-nvim
    # TODO:
    # undotree
    nvim-bqf
    qf-nvim

    # giveitashot
  ];

  extraConfig =
    "\n\n"
    + builtins.readFile ./lua/basics.lua
    + builtins.readFile ./lua/cmp.lua
    + builtins.readFile ./lua/visuals.lua
    + builtins.readFile ./lua/situational.lua
    + builtins.readFile ./lua/text_manipulation.lua
    + builtins.readFile ./lua/giveitashot.lua
    + builtins.readFile ./lua/after.lua
  ;
}
