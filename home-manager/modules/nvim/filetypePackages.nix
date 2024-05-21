{ lib, pkgs, ... }:
let
  default = {
    tsParsers = [ ];
    lsps = [ ];
    linters = [ ];
    formatters = [ ];
    debuggers = [ ];
    ftplugins = [ ];
  };
  filetypePackages = with pkgs; [
    rec { filetype = "angular"; }

    rec {
      filetype = "cmake";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ cmake ];
      lsps = [{ package = cmake-language-server; config = ''{ cmake = "default" }''; }];
    }

    rec {
      filetype = "cpp";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        c
        cpp
      ];
      lsps = [{ package = rocmPackages.llvm.clang-tools-extra; config = ''{ clangd = "default" }''; }];
    }

    rec {
      filetype = "css";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        css
        scss
      ];
      lsps = [
        {
          package = tailwindcss-language-server;
          config = ''
            {
              tailwindcss = function(on_attach, capabilities)
                local add_on_attach = function(client, bufnr)
                  client.server_capabilities.document_formatting = false
                  client.server_capabilities.document_range_formatting = false
                  on_attach(client, bufnr)
                end

                return {
                  init_options = {
                    userLanguages = {
                      nim = "twig",
                    },
                  },
                  filetypes = { "html", "vue", "css", "nim" },
                  capabilities = capabilities,
                  on_attach = add_on_attach,
                }
              end
            }
          '';
        }
        {
          package = vscode-langservers-extracted;
          config = ''
            {
            	cssls = function(on_attach, capabilities)
            		local add_on_attach = function(client, bufnr)
            			client.server_capabilities.document_formatting = false
            			client.server_capabilities.document_range_formatting = false
            			on_attach(client, bufnr)
            		end

            		return {
            			filetypes = { "css" },
            			capabilities = capabilities,
            			on_attach = add_on_attach,
            		}
            	end
            }
          '';
        }
      ];
      # TODO:
      # linters = [ stylelint ];
      # formatters = [ prettierd ];
    }

    rec {
      filetype = "cypher";
      # TODO:
      # lsps = [ cypher-language-server ];
      # ftplugins = with vimPlugins; [ cypher-vim-syntax ];
    }

    rec {
      filetype = "dockerfile";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ dockerfile ];
      lsps = [{ package = dockerfile-language-server-nodejs; config = ''{ dockerls = "default" }''; }];
      # TODO:
      # linters = [ hadolint ];
      # formatters = [ dockfmt ];
      # ftplugins = with vimPlugins; [ Dockerfile.vim ];
    }

    rec {
      filetype = "gdscript";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        gdscript
        godot_resource
      ];
      lsps = [{ config = ''{ gdscript = "default" }''; }];
      formatter = [{
        package = gdtoolkit;
        config = ''
          function()
            return { exe = "gdformat", args = { "--line-length=80", }, }
          end
        '';
      }];
      linters = [{
        package = gdtoolkit;
        config = ''"gdlint"'';
      }];
      ftplugins = with vimPlugins; [ vim-godot ];
    }

    rec {
      filetype = "git";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        gitignore
        gitattributes
        gitcommit
        git_config
        git_rebase
        diff
      ];
      linters = [
        { package = gitlint; config = ''"gitlint"''; }
        # TODO:
        # { package = commitlint; config = ''"commitlint"''; }
      ];
    }

    rec {
      filetype = "go";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        go
        gowork
        gomod
        gosum
      ];
      lsps = [{ package = gopls; config = ''{ gopls = "default" }''; }];
      linters = [{ package = golangci-lint; config = ''"golangci-lint"''; }];
      formatters = [{ package = gofumpt; config = ''require("formatter.filetypes")${filetype}.gofumpt''; }];
      debuggers = [ delve ];
      ftplugins = with vimPlugins; [
        {
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
      ];
    }

    rec {
      filetype = "html";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        html
        xml
      ];
      lsps = [{ package = vscode-langservers-extracted; config = ''{ html = "default" }''; }];
      formatters = [{ package = prettierd; config = ''require("formatter.filetypes")${filetype}.prettierd''; }];
    }

    rec {
      filetype = "json";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        json
        json5
        jsonc
      ];
      lsps = [{
        package = vscode-langservers-extracted;
        config = ''
          {
            jsonls = function(on_attach, capabilities)
              return {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = {
                  json = {
                    schemas = require("schemastore").json.schemas(),
                    validate = { enable = true },
                  },
                },
              }
            end
          }
        '';
      }];
      formatters = [{ package = jq; config = ''require("formatter.filetypes")${filetype}.jq''; }];
      # TODO:
      # linters = [ nodePackages.jsonlint ];
    }

    rec {
      filetype = "lua";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        lua
        luadoc
        luap
      ];
      # TODO:
      # lsps = [{ package = lua-language-server; config = ''{ XX = "default" }''; }];
      # linters = [{
      #   package = luajitPackages.luacheck;
      #   config = '' '';
      # }];
      formatters = [{
        package = stylua;
        config = ''
          	function()
          		return {
          			exe = "stylua",
          			args = {
          				"--search-parent-directories",
          				"--column-width",
          				"80",
          				"--stdin-filepath",
          				vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
          				"--",
          				"-",
          			},
          			stdin = true,
          		}
          	end
        '';
      }];
    }

    rec {
      filetype = "markdown";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        markdown
        markdown_inline
      ];
      lsps = [{ package = ltex-ls; config = ''{ ltex = "default" }''; }];
      linters = [
        { package = proselint; config = ''"proselint"''; }
        { package = write-good; config = ''"write_good"''; }
        { package = nodePackages.alex; config = ''"alex"''; }
        { package = markdownlint-cli; config = ''"markdownlint"''; }
      ];
      formatters = [{ package = prettierd; config = ''require("formatter.filetypes")${filetype}.prettierd''; }];
      ftplugins = with vimPlugins; [
        {
          plugin = vim-markdown;
          config = ''
            vim.g.vim_markdown_folding_disabled = 1
          '';
        }
      ];
    }

    rec {
      filetype = "nim";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        nim
        nim_format_string
      ];
      lsps = [{ package = nimlangserver; config = ''{ nim_langserver = "default" }''; }];
      formatters = [{
        config = ''
          	function()
          		return {
          			exe = "nimpretty",
          			args = {
          				vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
          			},
          			stdin = false,
          		}
          	end
        '';
      }];
      # TODO:
      # ftplugins = with vimPlugins; [ nim.nvim];
    }

    rec {
      filetype = "nix";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ nix ];
      lsps = [{ package = nixd; config = ''{ nixd = "default" }''; }];
      linters = [
        { package = deadnix; config = ''deadnix''; }
        { config = ''nix''; }
      ];
      formatters = [{ package = nixpkgs-fmt; config = ''require("formatter.filetypes")${filetype}.nixpkgs_fmt''; }];
    }

    rec {
      filetype = "python";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        python
        requirements
      ];
      lsps = [{ package = python312Packages.python-lsp-server; config = ''{ pylsp = "default" }''; }];
      # TODO:
      # linters = [
      #   pylint
      #   python312Packages.pydocstyle
      #   python312Packages.pycodestyle
      # ];
      formatters = [
        { package = black; config = ''require("formatter.filetypes")${filetype}.black''; }
        { package = isort; config = ''require("formatter.filetypes")${filetype}.isort''; }
      ];
      # TODO:
      # ftplugins = with vimPlugins; [
      #   vim-compiler-python
      #   requirements-txt-vim
      # ];
    }

    rec {
      filetype = "sh";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ bash ];
      lsps = [{ package = nodePackages.bash-language-server; config = ''{ bashls = "default" }''; }];
      # TODO:
      # linters = [{ package = shellcheck; config = ''''; }];
      # formatters = [ shfmt ];
    }

    rec { filetype = "tex"; }

    rec {
      filetype = "toml";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [ toml ];
      lsps = [{ package = taplo; config = ''{ taplo = "default" }''; }];
    }

    rec {
      filetype = "typescript";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        typescript
        javascript
        jsdoc
      ];
      lsps = [{ package = nodePackages.typescript-language-server; config = ''{ tsserver = "default" }''; }];
      linters = [ eslint_d ];
      formatters = [{ package = prettierd; config = ''require("formatter.filetypes")${filetype}.prettierd,''; }];
      # TODO:
      # debuggers = [ ];
      ftplugins = with vimPlugins; [
        typescript-vim
        # TODO:
        # typescript-tools-vim
      ];
    }

    rec {
      filetype = "vim";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        vim
        vimdoc
      ];
    }

    rec {
      filetype = "vue";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        vue
      ];
      # TODO:
      # lsps = [];
      ftplugins = with vimPlugins; [ vim-vue ];
    }

    rec {
      filetype = "yaml";
      tsParsers = with vimPlugins.nvim-treesitter-parsers; [
        yaml
      ];
      lsps = [{
        package = yaml-language-server;
        config = ''
          {
          	yamlls = function(on_attach, capabilities)
          		return {
          			capabilities = capabilities,
          			on_attach = on_attach,
          			settings = {
          				yaml = {
          					schemaStore = {
          						enable = false,
          						url = "",
          					},
          					schemas = require("schemastore").yaml.schemas(),
          				},
          			},
          		}
          	end
          }
        '';
      }];
      formatters = [{ package = prettierd; config = ''require("formatter.filetypes")${filetype}.prettierd,''; }];
    }

    rec {
      filetype = "misc";
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
        {
          package = docker-compose-language-service;
          config = ''{ docker_compose_language_service = "default" }'';
        }
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
    }

  ];


  values = builtins.attrValues filetypePackages;
  names = builtins.attrNames default;

in
lib.lists.flatten (builtins.map (name: builtins.catAttrs name values) names)
