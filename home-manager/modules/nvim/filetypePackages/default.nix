{ filetypes ? [ ], lib, pkgs, ... }:
let
  pluginKeys = [
    "tsParsers"
    "ftplugins"
  ];
  packageKeys = [
    "lsps"
    "linters"
    "formatters"
    "debuggers"
  ];
  filetypePackages = with pkgs; {
    angular = { };

    cmake = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ cmake ];
      lsps = [ cmake-language-server ];
    };

    cpp = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ c cpp ];
      lsps = [ rocmPackages.llvm.clang-tools-extra ];
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
    };

    cypher = {
      # TODO:
      # lsps = [ cypher-language-server ];
      # ftplugins = with vimPlugins; [ cypher-vim-syntax ];
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
      ];
      formatter = [ gdtoolkit ];
      linters = [ gdtoolkit ];
      ftplugins = with vimPlugins; [ vim-godot ];
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
      ftplugins = with vimPlugins; [
        {
          type = "lua";
          plugin = vim-markdown;
          config = ''
            vim.g.vim_markdown_folding_disabled = 1
          '';
        }
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
      formatters = [ nixpkgs-fmt ];
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

    sh = {
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ bash ];
      lsps = [ nodePackages.bash-language-server ];
      # TODO:
      # linters = [shellcheck];
      # formatters = [ shfmt ];
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
        jsdoc
      ];
      lsps = [ nodePackages.typescript-language-server ];
      linters = [ eslint_d ];
      formatters = [ prettierd ];
      # TODO:
      # debuggers = [ ];
      ftplugins = with vimPlugins; [
        typescript-vim

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
        http
        gpg
        ini
        make
        rst
        csv
        ssh_config
        vimdoc
        sql
        regex
        comment
      ];
      lsps = [
        docker-compose-language-service
      ];
      # TODO:
      # linters = [
      #   editorconfig-checker
      #   dotenv-linter
      # ];
      # TODO:
      # ftplugins = with vimPlugins; [
      #   vim-kitty
      #   fzf-gitignore
      #   cypher-vim-syntax
      # ];
      ftplugins = with vimPlugins; [
        {
          type = "lua";
          plugin = emmet-vim;
          config = ''
            -- vim.g.user_emmet_leader_key = '<C-v>'
            -- vim.g.user_emmet_mode = 'in'
          '';
        }
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
        {
          type = "lua";
          plugin = package-info-nvim;
          config = ''
            require("package-info").setup()

            local noremap = utils.noremap_buffer
            noremap("n", "<leader>js", ":lua require('package-info').show()<CR>")
            noremap("n", "<leader>jh", ":lua require('package-info').hide()<CR>")
            noremap("n", "<leader>ju", ":lua require('package-info').update()<CR>")
            noremap("n", "<leader>jd", ":lua require('package-info').delete()<CR>")
            noremap("n", "<leader>ji", ":lua require('package-info').install()<CR>")
            noremap(
              "n",
              "<leader>jr",
              ":lua require('package-info').reinstall()<CR>"
            )
            noremap(
              "n",
              "<leader>jp",
              ":lua require('package-info').change_version()<CR>"
            )
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