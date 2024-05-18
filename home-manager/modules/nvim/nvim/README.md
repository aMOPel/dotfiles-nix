# Strucuture

```text
nvim/
|-after  # execute all callbacks in "globals.lua".plugins.config, AFTER plugins were loaded
|-plugin # execute all callbacks in "globals.lua".plugins.setup, BEFORE plugins were loaded
|-lua
  |-ft
    |-ftconfigs   # configs for filetypes, including lsp, treesitter, formatters and ft depedent settings and mappings
      |-...
    |-_ft_config_template.lua 
  |-plugins
    |-core        # the core plugins
      |-basics.lua      # stuff I always need
      |-cmp.lua         # completion and snippets
      |-filetypes.lua   # support for filetypes, some are already supported, like md, but the plugin improves it further
      |-lsp.lua         # lsp settings using lsp_config and lsp_installer, the actual configuration is done in lua/ft/ftconfigs/*
      |-treesitter.lua  # treesitter settings
      |-visuals.lua     # colorscheme, lualine, ...
    |-misc        # miscellaneous plugins, this is WIP
      |-debug.lua               # debugger related plugins
      |-giveitashot.lua         # things I'm trying currently
      |-filetype_specific.lua   # plugins that are only usable in one or a few filetypes
      |-situational.lua         # plugins that have a very situational use case
      |-standards.lua           # support for standards, like dotenv or editorconfig
      |-text_manipulation.lua   # plugins that enhance text manipulation
    |-_plugin_config_template.lua
  |-globals.lua # this global table is used to "transport" configuration data from lua/ft/ftconfigs/* to various other places
  |-main.lua    # require plugins.lua and anything in ft/ftconfigs/
  |-plugins.lua # setup packer.nvim and require plugins/core in order and everything in plugins/misc/
  |-utils.lua   # utility functions
|-vimscript
  |-general # general/global settings writtin in vimscript
|-init.vim # from here vimscript/general/* is sourced, as well as lua/main.lua
```

# Notable features

1. the directory crawling in ft/ftplugins and plugins/misc, allowing you to just add new files, without explicitly sourcing them
2. specifying all plugin names as full GitHub links, allowing me to immediately open them in the browser with a terminal shortcut
(packer does not like this, thats why the `utils.p` function reduces the links to `username/reponame` for packer)
3. the `ft_` and `plugin_config_template` files, providing guidelines
