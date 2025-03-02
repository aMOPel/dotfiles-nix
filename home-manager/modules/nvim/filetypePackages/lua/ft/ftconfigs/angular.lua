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
			local project_root = vim.fs.dirname(
				vim.fs.find("node_modules", { path = root_dir, upward = true })[1]
			)

			return project_root and project_root .. "/node_modules" or ""
		end
		local function get_angular_core_version(root_dir)
			local project_root = vim.fs.dirname(
				vim.fs.find("node_modules", { path = root_dir, upward = true })[1]
			)

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

			angular_core_version = angular_core_version
				and angular_core_version:match("%d+%.%d+%.%d+")

			return angular_core_version
		end
		local default_probe_dir = get_probe_dir(vim.fn.getcwd())
		local default_angular_core_version =
			get_angular_core_version(vim.fn.getcwd())
		local cmd = {
			vim.fn.exepath("npx"),
			"ngserver",
			"--stdio",
			"--tsProbeLocations",
			default_probe_dir,
			"--ngProbeLocations",
			default_probe_dir,
			"--angularCoreVersion",
			default_angular_core_version,
		}

		return {
			capabilities = capabilities,
			on_attach = on_attach,
			cmd = cmd,
			on_new_config = function(new_config, new_root_dir)
				local new_probe_dir = get_probe_dir(new_root_dir)
				local angular_core_version =
					get_angular_core_version(new_root_dir)

				-- We need to check our probe directories because they may have changed.
				new_config.cmd = {
					vim.fn.exepath("npx"),
					"ngserver",
					"--stdio",
					"--tsProbeLocations",
					new_probe_dir,
					"--ngProbeLocations",
					new_probe_dir,
					"--angularCoreVersion",
					angular_core_version,
				}
			end,
			root_dir = root_pattern,
		}
	end,
})

