{ config, lib, pkgs, ... }:
let
  filetypePlugins = with pkgs; {
    angular = [ ];
    sh = [
      vimPlugins.nvim-treesitter-parsers.bash
      nodePackages.bash-language-server
      shellcheck
      shfmt # TODO:
    ];
    cmake = [
      vimPlugins.nvim-treesitter-parsers.cmake
      cmake-language-server
    ];
    cpp = [
      vimPlugins.nvim-treesitter-parsers.c
      vimPlugins.nvim-treesitter-parsers.cpp
      rocmPackages.llvm.clang-tools-extra
    ];
    css = [
      vimPlugins.nvim-treesitter-parsers.css
      vimPlugins.nvim-treesitter-parsers.scss
      tailwindcss-language-server
      vscode-langservers-extracted
      stylelint
      prettierd
    ];
    dockerfile = [
      vimPlugins.nvim-treesitter-parsers.dockerfile
      dockerfile-language-server-nodejs
      hadolint
      dockfmt # TODO:
    ];
    gdscript = [
      vimPlugins.nvim-treesitter-parsers.gdscript
      vimPlugins.nvim-treesitter-parsers.godot_resource
      gdtoolkit
    ];
    git = [
      vimPlugins.nvim-treesitter-parsers.gitignore
      vimPlugins.nvim-treesitter-parsers.gitattributes
      vimPlugins.nvim-treesitter-parsers.gitcommit
      vimPlugins.nvim-treesitter-parsers.git_config
      vimPlugins.nvim-treesitter-parsers.git_rebase
      vimPlugins.nvim-treesitter-parsers.diff
      gitlint
      commitlint
    ];
    go = [
      vimPlugins.nvim-treesitter-parsers.go
      vimPlugins.nvim-treesitter-parsers.gowork
      vimPlugins.nvim-treesitter-parsers.gomod
      vimPlugins.nvim-treesitter-parsers.gosum
      gofumpt
      golangci-lint
      gopls
      delve
    ];
    html = [
      vimPlugins.nvim-treesitter-parsers.html
      vimPlugins.nvim-treesitter-parsers.xml
      vscode-langservers-extracted
      prettierd
    ];
    json = [
      vimPlugins.nvim-treesitter-parsers.json
      vimPlugins.nvim-treesitter-parsers.json5
      vimPlugins.nvim-treesitter-parsers.jsonc
      vscode-langservers-extracted
      jq
      jsonlint
    ];
    lua = [
      vimPlugins.nvim-treesitter-parsers.lua
      vimPlugins.nvim-treesitter-parsers.luadoc
      vimPlugins.nvim-treesitter-parsers.luap
      lua-language-server
      luacheck
    ];
    markdown = [ ];
    nim = [ ];
    nix = [ ];
    python = [ ];
    tex = [ ];
    toml = [ ];
    typescript = [ ];
    vim = [ ];
    vue = [ ];
    yaml = [
      vimPlugins.nvim-treesitter-parsers.yaml
      yaml-language-server
    ];
    misc = [
      docker-compose-language-service
      editorconfig-checker
      dotenv-linter
    ];

  };
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
      bash
      bibtex
      c
      cmake
      comment
      cpp
      css
      csv
      diff
      dockerfile
      gdscript
      git_config
      git_rebase
      gitattributes
      gitcommit
      gitignore
      go
      godot_resource
      gomod
      gosum
      gowork
      gpg
      html
      http
      ini
      javascript
      jsdoc
      json
      json5
      jsonc
      latex
      lua
      luadoc
      luap
      make
      markdown
      markdown_inline
      nim
      nim_format_string
      python
      query
      regex
      requirements
      rst
      sql
      ssh_config
      toml
      typescript
      vim
      vimdoc
      vue
      xml
      yaml
    ]);
  };
}
