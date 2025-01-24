{ filetypes ? [ ], lib, pkgs, ... }:
let

  vim-grip = pkgs.vimUtils.buildVimPlugin {
    pname = "vim-grip";
    version = "2024-06-07";
    src = pkgs.fetchFromGitHub {
      owner = "PratikBhusal";
      repo = "vim-grip";
      rev = "b89bc5fe850da96d2ea5bb8764c71b2020d0f10b";
      sha256 = "sha256-if2ibS96vIXdeAVE9I+oTkxvHdYbgMyWyO6LKUD/QY8=";
    };
    meta.homepage = "https://github.com/PratikBhusal/vim-grip";
  };

  cypher-vim-syntax = pkgs.vimUtils.buildVimPlugin {
    pname = "cypher-vim-syntax";
    version = "2024-06-17";
    src = pkgs.fetchFromGitHub {
      owner = "neo4j-contrib";
      repo = "cypher-vim-syntax";
      rev = "386abb72a5113dfd3aa88ab59bb1e99d3ff33c8e";
      sha256 = "sha256-iJLl5BPM5KV+WcnmYV0HSfYyBePXkPYy2nWeqy2VU+o=";
    };
    meta.homepage = "https://github.com/neo4j-contrib/cypher-vim-syntax";
  };

  pluginKeys = [
    "tsParsers"
    "ftplugins"
  ];
  packageKeys = [
    "lsps"
    "linters"
    "formatters"
    "debuggers"
    "extraTools"
  ];
  filetypePackages = with pkgs; {
    angular = { };

    cmake = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ cmake ];
      lsps = [ cmake-language-server ];
    };

    make = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ make ];
      linters = [ checkmake ];
    };


    cpp = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ c cpp ];
      lsps = [ clang-tools ];
      linters = [ cppcheck cpplint ];
      # TODO: clangd extensions
    };

    css = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ css scss ];
      lsps = [
        tailwindcss-language-server
        vscode-langservers-extracted
      ];
      # TODO:
      # linters = [ stylelint ];
      # formatters = [ prettierd ];
      ftplugins = with vimPlugins; [
        {
          type = "lua";
          plugin = emmet-vim;
          config = ''
            -- vim.g.user_emmet_leader_key = '<C-v>'
            -- vim.g.user_emmet_mode = 'in'
          '';
        }
      ];
    };

    cypher = {
      # TODO:
      # lsps = [ cypher-language-server ];
      ftplugins = with vimPlugins; [ cypher-vim-syntax ];
    };

    dockerfile = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ dockerfile ];
      lsps = [ dockerfile-language-server-nodejs ];
      # TODO:
      # linters = [ hadolint ];
      # formatters = [ dockfmt ];
      # ftplugins = with vimPlugins; [ Dockerfile.vim ];
    };

    gdscript = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        gdscript
        godot_resource
        # gdshader
      ];
      formatter = [ gdtoolkit ];
      linters = [ gdtoolkit ];
      ftplugins = with vimPlugins; [
        {
          type = "lua";
          plugin = vim-godot;
          config = ''
            vim.filetype.add({
            	pattern = {
            		["*.tscn"] = "dosini",
            		["*.tres"] = "dosini",
            		["*.import"] = "dosini",
            		["*.godot"] = "dosini",
            	},
            })
          '';
        }
      ];
    };

    git = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        gitignore
        gitattributes
        gitcommit
        git_config
        git_rebase
        diff
      ];
      linters = [
        gitlint
        # TODO:
        # commitlint
      ];
    };

    go = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        go
        gowork
        gomod
        gosum
        gotemplate
      ];
      lsps = [ gopls ];
      linters = [ golangci-lint ];
      formatters = [ gofumpt ];
      debuggers = [ delve ];
      ftplugins = with vimPlugins; [
        {
          type = "lua";
          plugin = vim-go;
          config = ''
            vim.g.go_echo_go_info = 0
            vim.g.go_template_autocreate = 0
            vim.g.go_gopls_enabled = 0
            vim.g.go_metalinter_autosave = 0
            vim.g.go_textobj_include_variable = 0
            vim.g.go_textobj_include_function_doc = 0
            vim.g.go_textobj_enabled = 0
            vim.g.go_def_mapping_enabled = 0
            vim.g.go_doc_keywordprg_enabled = 0
            vim.g.go_mod_fmt_autosave = 0
            vim.g.go_imports_autosave = 0
            vim.g.go_fmt_autosave = 0
            vim.g.go_code_completion_enabled = 0
          '';
        }
        nvim-dap-go
      ];
    };

    html = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ html xml ];
      lsps = [ vscode-langservers-extracted ];
      formatters = [ prettierd ];
      ftplugins = with vimPlugins; [
        {
          type = "lua";
          plugin = emmet-vim;
          config = ''
            -- vim.g.user_emmet_leader_key = '<C-v>'
            -- vim.g.user_emmet_mode = 'in'
          '';
        }
      ];
    };

    json = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        json
        json5
        jsonc
      ];
      lsps = [ vscode-langservers-extracted ];
      formatters = [ jq ];
      # TODO:
      # linters = [ nodePackages.jsonlint ];
    };

    lua = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        lua
        luadoc
        luap
      ];
      lsps = [ lua-language-server ];
      # TODO:
      # linters = [luajitPackages];
      formatters = [ stylua ];
    };

    markdown = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        markdown
        markdown_inline
      ];
      lsps = [ ltex-ls ];
      linters = [
        proselint
        write-good
        nodePackages.alex
        markdownlint-cli
      ];
      formatters = [ prettierd ];
      extraTools = [ python312Packages.grip ];
      ftplugins = with vimPlugins; [
        vim-grip
      ];
    };

    nim = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        nim
        nim_format_string
      ];
      lsps = [ nimlangserver ];
      # TODO:
      # ftplugins = with vimPlugins; [ nim.nvim];
    };

    nix = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ nix ];
      lsps = [ nixd ];
      linters = [
        deadnix
      ];
      formatters = [ nixfmt-rfc-style ];
    };

    python = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        python
        requirements
      ];
      lsps = [ python312Packages.python-lsp-server ];
      # TODO:
      # linters = [
      #   pylint
      #   python312Packages.pydocstyle
      #   python312Packages.pycodestyle
      # ];
      formatters = [
        black
        isort
      ];
      # TODO:
      # ftplugins = with vimPlugins; [
      #   vim-compiler-python
      #   requirements-txt-vim
      # ];
    };

    rust = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        rust
      ];
      lsps = [ rust-analyzer ];
      formatters = [ rustfmt ];
      # TODO: 
      # ftplugins = with vimPlugins; [
      #   rustaceanvim
      # ];
    };

    sh = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ bash ];
      lsps = [ nodePackages.bash-language-server ];
      linters = [ shellcheck ];
      formatters = [ shfmt ];
    };

    dotenv = {
      linters = [ dotenv-linter ];
    };

    tex = { };

    toml = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ toml ];
      lsps = [ taplo ];
    };

    typescript = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        typescript
        javascript
        tsx
        jsdoc
      ];
      lsps = [ nodePackages.typescript-language-server ];
      linters = [ eslint_d ];
      formatters = [ prettierd ];
      # TODO:
      # debuggers = [ ];
      ftplugins = with vimPlugins; [
        typescript-vim

        package-info-nvim
        # TODO:
        # typescript-tools-vim
      ];
    };

    vim = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ vim vimdoc ];
    };

    vue = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ vue ];
      # TODO:
      # lsps = [];
      ftplugins = with vimPlugins; [ vim-vue ];
    };

    yaml = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ yaml ];
      lsps = [ yaml-language-server ];
      formatters = [ prettierd ];
    };

    misc = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        hurl
        http
        gpg
        passwd
        ini
        rst
        csv
        tsv
        ssh_config
        vimdoc
        sql
        regex
        comment
        # editorconfig
      ];
      lsps = [
        docker-compose-language-service
      ];
      linters = [
        editorconfig-checker
      ];
      # TODO:
      # ftplugins = with vimPlugins; [
      #   vim-kitty
      #   fzf-gitignore
      #   cypher-vim-syntax
      # ];
      ftplugins = with vimPlugins; [
        {
          type = "lua";
          plugin = nvim-colorizer-lua;
          config = ''
            require("colorizer").setup({
              filetypes = {
                "css",
                "javascript",
                "yaml",
                "kitty",
                html = {
                  mode = "foreground",
                },
              },
            })
          '';
        }
      ];
    };

  };

  extraPlugins = with pkgs.vimPlugins; [
    # lsp
    nvim-lspconfig
    SchemaStore-nvim
    nvim-lint
    formatter-nvim

    # treesitter
    nvim-treesitter
    nvim-treesitter-context
    nvim-treesitter-textobjects

    # debug
    nvim-dap
    nvim-dap-ui
  ];

  # if list is empty, use all filetypes
  allFiletypes = if builtins.length filetypes == 0 then builtins.attrNames filetypePackages else filetypes;
  # pick only chosen filetypePackages
  enabledFiletypePackages = lib.attrsets.filterAttrs (name: value: builtins.elem name allFiletypes) filetypePackages;
  # pick only chosen lua files from ftconfigs/
  enabledFtconfigPaths = builtins.filter
    (e: builtins.elem
      (lib.strings.removeSuffix ".lua" (builtins.baseNameOf e))
      allFiletypes)
    (lib.filesystem.listFilesRecursive ./lua/ft/ftconfigs);

in
{
  plugins =
    extraPlugins ++
    lib.lists.flatten
      (builtins.map
        (name: builtins.catAttrs name (builtins.attrValues enabledFiletypePackages))
        pluginKeys);
  packages =
    lib.lists.flatten
      (builtins.map
        (name: builtins.catAttrs name (builtins.attrValues enabledFiletypePackages))
        packageKeys);
  extraConfig =
    "\n\n"
    + builtins.readFile ./lua/globals.lua
    + builtins.readFile ./lua/utils.lua
    + builtins.concatStringsSep "\n\n" (lib.lists.forEach enabledFtconfigPaths builtins.readFile)
    + builtins.readFile ./lua/lsp.lua
    + builtins.readFile ./lua/debug.lua
    + builtins.readFile ./lua/treesitter.lua
  ;
}
