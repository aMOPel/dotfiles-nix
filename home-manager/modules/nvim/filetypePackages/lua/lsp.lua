local setup_lsps = function()
	-- Global mappings.
	-- See `:help vim.diagnostic.*` for documentation on any of the below functions
	vim.keymap.set(
		"n",
		"<space>ld",
		vim.diagnostic.open_float,
		{ desc = " lsp diagnostics open float" }
	)
	vim.keymap.set(
		"n",
		"[d",
		vim.diagnostic.goto_prev,
		{ desc = "lsp prev diagnostic" }
	)
	vim.keymap.set(
		"n",
		"]d",
		vim.diagnostic.goto_next,
		{ desc = "lsp next diagnostic" }
	)
	vim.keymap.set(
		"n",
		"<space>lq",
		vim.diagnostic.setloclist,
		{ desc = "lsp diagnostics location list" }
	)

	-- Use LspAttach autocommand to only map the following keys
	-- after the language server attaches to the current buffer
	vim.api.nvim_create_autocmd("LspAttach", {
		group = vim.api.nvim_create_augroup("UserLspConfig", {}),
		callback = function(ev)
			-- Buffer local mappings.
			-- See `:help vim.lsp.*` for documentation on any of the below functions
			vim.keymap.set(
				"n",
				"gD",
				vim.lsp.buf.declaration,
				{ buffer = ev.buf, desc = "lsp declaration" }
			)
			vim.keymap.set(
				"n",
				"gd",
				vim.lsp.buf.definition,
				{ buffer = ev.buf, desc = "lsp definition" }
			)
			vim.keymap.set(
				"n",
				"K",
				vim.lsp.buf.hover,
				{ buffer = ev.buf, desc = "lsp hover" }
			)
			vim.keymap.set(
				"n",
				"gi",
				vim.lsp.buf.implementation,
				{ buffer = ev.buf, desc = "lsp implementation" }
			)
			vim.keymap.set(
				"n",
				"gr",
				vim.lsp.buf.references,
				{ buffer = ev.buf, desc = "lsp references" }
			)
			vim.keymap.set(
				"n",
				"<C-k>",
				vim.lsp.buf.signature_help,
				{ buffer = ev.buf, desc = "lsp signature_help" }
			)
			vim.keymap.set(
				"n",
				"<space>wa",
				vim.lsp.buf.add_workspace_folder,
				{ buffer = ev.buf, desc = "lsp add workspace folder" }
			)
			vim.keymap.set(
				"n",
				"<space>wr",
				vim.lsp.buf.remove_workspace_folder,
				{ buffer = ev.buf, desc = "lsp remove workspace folder" }
			)
			vim.keymap.set("n", "<space>wl", function()
				print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
			end, { buffer = ev.buf, desc = "lsp list workspace folders" })
			vim.keymap.set(
				"n",
				"<space>lr",
				vim.lsp.buf.rename,
				{ buffer = ev.buf, desc = "lsp rename" }
			)
			vim.keymap.set(
				{ "n", "v" },
				"<space>la",
				vim.lsp.buf.code_action,
				{ buffer = ev.buf, desc = "lsp code action" }
			)
			vim.keymap.set("n", "<space>lf", function()
				vim.lsp.buf.format({ async = true })
			end, { buffer = ev.buf, desc = "lsp format buffer" })
		end,
	})

	-------------------------------------------------------------------
	-- setup servers

	-- Servers managed by Mason
	local servers = g.lsp.servers.lsp_installer

	local lspconfig = require("lspconfig")

	local function setup_server(server_name, server_config)
		local config = {
			capabilities = require("cmp_nvim_lsp").default_capabilities(),
			on_attach = function() end,
		}

		if server_config == "default" then
		elseif type(server_config) == "function" then
			config = server_config(config.on_attach, config.capabilities)
		else
			print("error with " .. server_name)
		end

		lspconfig[server_name].setup(config)
	end

	for server_name, server_config in pairs(servers) do
		setup_server(server_name, server_config)
	end
end

local setup_linters = function()
	local lint = require("lint")
	utils.addTable(lint.linters, g.linter.custom_linter)
	lint.linters_by_ft = g.linter.filetype
	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
		group = "MyAutoCmd",
		callback = function()
			lint.try_lint()
		end,
	})
end

local setup_formatters = function()
	require("formatter").setup({
		logging = true,
		log_level = vim.log.levels.WARN,
		filetype = g.formatter.filetype,
	})

	vim.keymap.set(
		"n",
		"gq",
		"<cmd>FormatWrite<cr>",
		{ desc = "format buffer" }
	)
	-- vim.cmd([[autocmd MyAutoCmd BufWritePost * FormatWrite]])
	-- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	-- 	pattern = g.formatter.on_save,
	-- 	group = "MyAutoCmd",
	-- 	callback = function()
	-- 		vim.cmd([[FormatWrite]])
	-- 	end,
	-- })
end

setup_lsps()
setup_linters()
setup_formatters()
