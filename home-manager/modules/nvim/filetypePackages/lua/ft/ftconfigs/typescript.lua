local ft = "typescript"

vim.tbl_deep_extend("force", g.lsp.fts, {
	ft,
	"javascript",
})

vim.tbl_deep_extend("force", g.lsp.servers.lsp_installer, {
	tsserver = "default",
})

vim.tbl_deep_extend("force", g.linter.filetype, {
	[ft] = { "eslint_d" },
	javascript = { "eslint_d" },
})

vim.tbl_deep_extend("force", g.formatter.filetype, {
	[ft] = {
		require("formatter.filetypes")[ft].prettierd,
	},
})

vim.tbl_deep_extend("force", g.dap.filetype, {
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
	require("package-info").setup()

	vim.keymap.set(
		"n",
		"<leader>js",
		":lua require('package-info').show()<CR>",
		{ desc = "package info show" }
	)
	vim.keymap.set(
		"n",
		"<leader>jh",
		":lua require('package-info').hide()<CR>",
		{ desc = "package info hide" }
	)
	vim.keymap.set(
		"n",
		"<leader>ju",
		":lua require('package-info').update()<CR>",
		{ desc = "package info update" }
	)
	vim.keymap.set(
		"n",
		"<leader>jd",
		":lua require('package-info').delete()<CR>",
		{ desc = "package info delete" }
	)
	vim.keymap.set(
		"n",
		"<leader>ji",
		":lua require('package-info').install()<CR>",
		{ desc = "package info install" }
	)
	vim.keymap.set(
		"n",
		"<leader>jr",
		":lua require('package-info').reinstall()<CR>",
		{ desc = "package info reinstall" }
	)
	noremap(
		"n",
		"<leader>jp",
		":lua require('package-info').change_version()<CR>",
		{ desc = "package info change version" }
	)
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})
