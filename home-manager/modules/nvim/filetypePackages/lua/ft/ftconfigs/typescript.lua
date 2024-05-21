ft = "typescript"

utils.addTable(g.lsp.fts, {
	ft,
	"javascript",
})

utils.addTable(g.lsp.servers.lsp_installer, {
	tsserver = "default",
})

utils.addTable(g.linter.filetype, {
	[ft] = { "eslint_d" },
	javascript = { "eslint_d" },
})

utils.addTable(g.formatter.filetype, {
	[ft] = {
		-- function() pcall(
		--   function(arg) vim.cmd(arg) end,
		--   'TypescriptOrganizeImports'
		-- ) end,
		require("formatter.filetypes")[ft].prettierd,
	},
})

utils.addTable(g.dap.filetype, {
	[ft] = function()
		local dap = require("dap")
		require("dap").adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = vim.fn.stdpath("data")
					.. "/mason/bin/js-debug-adapter",
			},
		}
		require("dap").configurations.typescript = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
		}
	end,
})

local configs = {}

configs[ft] = function()
	local optl = vim.opt_local
	utils.noremap(
		"n",
		"gq",
		[[
:TypescriptAddMissingImports<cr>
:sleep 300m<cr>
:TypescriptOrganizeImports<cr>
:sleep 300m<cr>
:update<cr>
:FormatWrite<cr>]]
	)
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})

-- utils.addTable(g.formatter.on_save, {
-- 	"*." .. ft,
-- })
