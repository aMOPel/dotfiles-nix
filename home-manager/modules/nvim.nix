{ pkgs, ... }: {
  enable = true;
  defaultEditor = true;
  viAlias = true;
  vimAlias = true;
  vimdiffAlias = true;
  plugins = (with pkgs.vimPlugins; [
    # common
    plenary-nvim
    fzfWrapper
    fzf-vim
    telescope-fzf-native-nvim
    fuzzy-nvim
    nui-nvim

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

    # filetypes
    # nim-nvim
    # vim-kitty
    vim-vue
    vim-markdown
    typescript-vim
    vim-godot
    # dockerfile-vim
    # requirements-txt-vim
    gitignore-vim
    # vim-compiler-python
    vim-go
    vim-nix

    # lsp
    nvim-lspconfig
    SchemaStore-nvim
    nvim-lint
    formatter-nvim

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

  ]) ++ (with pkgs.vimPlugins.nvim-treesitter-parsers; [

  ]);
}
