local ft = "ts"

utils.addTable(g.lsp.fts, {
  ft,
  "html",
})

-- BUG: if npx is not in path this crashes the config loading
utils.addTable(g.lsp.servers.lsp_installer, {
  angularls = function(on_attach, capabilities)
    local lsputil = require("lspconfig.util")
    local root_pattern = lsputil.root_pattern("angular.json", ".angular/")

    -- copied from https://github.com/neovim/nvim-lspconfig/blob/d95655822dc5d6a60d06a72fce26435ef5224b0b/lua/lspconfig/configs/angularls.lua
    local function get_probe_dir(root_dir)
      local project_root = vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])

      return project_root and project_root .. "/node_modules" or ""
    end
    local function get_angular_core_version(root_dir)
      local project_root = vim.fs.dirname(vim.fs.find("node_modules", { path = root_dir, upward = true })[1])

      if not project_root then
        return ""
      end

      local package_json = project_root .. "/package.json"
      if not vim.loop.fs_stat(package_json) then
        return ""
      end

      local contents = io.open(package_json):read("*a")
      local json = vim.json.decode(contents)
      if not json.dependencies then
        return ""
      end

      local angular_core_version = json.dependencies["@angular/core"]

      angular_core_version = angular_core_version and angular_core_version:match("%d+%.%d+%.%d+")

      return angular_core_version
    end

    local function checkCmdAvailable()
      return vim.fn.executable("npx") == 1 or vim.fn.executable("ngserver") == 1
    end

    local function buildCmd(rootDir)
      local cmd = {}

      if vim.fn.executable("npx") == 1 then
        cmd = { "npx", "ngserver" }
      elseif vim.fn.executable("ngserver") == 1 then
        cmd = { "ngserver" }
      else
        return nil
      end
      local probe_dir = get_probe_dir(rootDir)
      local angular_core_version = get_angular_core_version(rootDir)
      utils.addTable(cmd, {
        "--stdio",
        "--tsProbeLocations",
        probe_dir,
        "--ngProbeLocations",
        probe_dir,
        "--angularCoreVersion",
        angular_core_version,
      })
      return cmd
    end

    local result = {
      capabilities = capabilities,
      on_attach = on_attach,
      root_dir = root_pattern,
    }
    if checkCmdAvailable() then
      utils.addTable(result, {
        cmd = buildCmd(vim.fn.getcwd()),
        on_new_config = function(new_config, new_root_dir)
          new_config.cmd = buildCmd(new_root_dir)
        end,
      })
    end
    return result
  end,
})
