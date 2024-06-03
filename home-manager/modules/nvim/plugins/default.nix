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

    # visuals
    nvim-web-devicons
    lualine-nvim
    onedark-nvim
    nvim-scrollbar
    nvim-hlslens

    # text manipulation
    vim-textobj-user
    # vim-textobj-indent
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
    camelcasemotion
    vim-argwrap

    # situational
    # TODO:
    # toggleterm-nvim
    vim-floaterm
    vim-grepper
    vim-fugitive
    vim-rhubarb
    rnvimr
    todo-comments-nvim
    # vim-maximizer
    # TODO:
    # undotree
    nvim-bqf
    qf-nvim

    # giveitashot
    dressing-nvim
    telescope-nvim
  ];

  extraConfig =
    "\n\n"
    + builtins.readFile ./lua/basics.lua
    + builtins.readFile ./lua/cmp.lua
    + builtins.readFile ./lua/visuals.lua
    + builtins.readFile ./lua/situational.lua
    + builtins.readFile ./lua/text_manipulation.lua
    # + builtins.readFile ./lua/giveitashot.lua
    + builtins.readFile ./lua/after.lua
  ;
}
