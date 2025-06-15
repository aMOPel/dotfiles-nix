local ft = "typescript"

utils.addTable(g.lsp.fts, {
	ft,
	"ts",
	"tsx",
	"typescriptreact",
	"javascript",
	"jsx",
	"javascriptreact",
})

utils.addTable(g.lsp.servers.lsp_installer, {
	denols = function(on_attach, capabilities)
		local lspconfig = require("lspconfig")
		return {
			capabilities = capabilities,
			on_attach = on_attach,
			root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
		}
	end,
	ts_ls = function(on_attach, capabilities)
		local lspconfig = require("lspconfig")
		return {
			capabilities = capabilities,
			on_attach = on_attach,
			root_dir = function(filename, bufnr)
				local denoRootDir = lspconfig.util.root_pattern(
					"deno.json",
					"deno.jsonc"
				)(filename)
				if denoRootDir then
					-- print('this seems to be a deno project; returning nil so that tsserver does not attach');
					return nil
					-- else
					-- print('this seems to be a ts project; return root dir based on package.json')
				end

				return lspconfig.util.root_pattern("package.json")(filename)
			end,
			single_file_support = false,
		}
	end,
})

utils.addTable(g.linter.filetype, {
	[ft] = { "biomejs" },
	ts = { "biomejs" },
	tsx = { "biomejs" },
	typescriptreact = { "biomejs" },
	javascript = { "biomejs" },
	jsx = { "biomejs" },
	javascriptreact = { "biomejs" },
})

utils.addTable(g.formatter.filetype, {
	[ft] = {
		require("formatter.filetypes")[ft].biome,
	},
	ts = {
		require("formatter.filetypes").typescript.biome,
	},
	tsx = {
		require("formatter.filetypes").typescriptreact.biome,
	},
	typescriptreact = {
		require("formatter.filetypes").typescriptreact.biome,
	},
	javascript = {
		require("formatter.filetypes").javascript.biome,
	},
	jsx = {
		require("formatter.filetypes").javascriptreact.biome,
	},
	javascriptreact = {
		require("formatter.filetypes").javascriptreact.biome,
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

-- local configs = {}

-- vim.api.nvim_create_autocmd({ "Filetype" }, {
-- 	group = "MyFt",
-- 	pattern = { ft },
-- 	callback = configs[ft],
-- })

local configurePackageInfo = function()
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
	vim.keymap.set(
		"n",
		"<leader>jp",
		":lua require('package-info').change_version()<CR>",
		{ desc = "package info change version" }
	)
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	pattern = { "package.json" },
	group = "MyFt",
	callback = configurePackageInfo,
})
