local plugins = require("globals").plugins

table.insert(plugins, {
	name = "nvim-lspconfig",
	setup = function() end,
	config = function()
		-- Global mappings.
		-- See `:help vim.diagnostic.*` for documentation on any of the below functions
		vim.keymap.set("n", "<space>ld", vim.diagnostic.open_float)
		vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
		vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
		vim.keymap.set("n", "<space>lq", vim.diagnostic.setloclist)

		-- Use LspAttach autocommand to only map the following keys
		-- after the language server attaches to the current buffer
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below functions
				local opts = { buffer = ev.buf }
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
				vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
				vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
				vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
				vim.keymap.set(
					"n",
					"<space>wa",
					vim.lsp.buf.add_workspace_folder,
					opts
				)
				vim.keymap.set(
					"n",
					"<space>wr",
					vim.lsp.buf.remove_workspace_folder,
					opts
				)
				vim.keymap.set("n", "<space>wl", function()
					print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
				end, opts)
				-- vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
				vim.keymap.set("n", "<space>lr", vim.lsp.buf.rename, opts)
				vim.keymap.set(
					{ "n", "v" },
					"<space>la",
					vim.lsp.buf.code_action,
					opts
				)
				vim.keymap.set("n", "<space>lf", function()
					vim.lsp.buf.format({ async = true })
				end, opts)
			end,
		})

		-------------------------------------------------------------------
		-- setup servers

		local g = require("globals")
		-- Servers managed by Mason
		local lsp_installer_servers = g.lsp.servers.lsp_installer
		-- Servers not managed by Mason
		local other_servers = g.lsp.servers.other
		-- custom setup wrapper like typescript
		local special_setups = g.lsp.servers.special_setup

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

			if special_setups[server_name] ~= nil then
				special_setups[server_name](config)
			else
				lspconfig[server_name].setup(config)
			end
		end

		for server_name, server_config in pairs(lsp_installer_servers) do
			setup_server(server_name, server_config)
		end

		for server_name, server_config in pairs(other_servers) do
			setup_server(server_name, server_config)
		end
	end,
})

-- table.insert(plugins, {
--  name = "fidget.nvim",
--  setup = function() end,
--  config = function()
--    require("fidget").setup({})
--  end,
-- })

-- table.insert(plugins, {
--  name = "nvim-dd",
--  setup = function() end,
--  config = function()
--    -- require('dd').setup { timeout = 1000, }
--  end,
-- })

table.insert(plugins, {
	name = "nvim-lint",
	setup = function() end,
	config = function()
		local g = require("globals")
		local add = require("utils").addTable
		local lint = require("lint")
		add(lint.linters, g.linter.custom_linter)
		lint.linters_by_ft = g.linter.filetype
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
			group = "MyAutoCmd",
			callback = function()
				lint.try_lint()
			end,
		})
	end,
})

table.insert(plugins, {
	name = "formatter.nvim",
	setup = function() end,
	config = function()
		local g = require("globals")
		local add = require("utils").addTable
		add(g.formatter.filetype, {
			["*"] = {
				require("formatter.filetypes").any.remove_trailing_whitespace,
			},
		})

		require("formatter").setup({
			logging = true,
			log_level = vim.log.levels.WARN,
			filetype = g.formatter.filetype,
		})

		local noremap = require("utils").noremap
		noremap("n", "gq", ":FormatWrite<cr>")
		-- vim.cmd([[autocmd MyAutoCmd BufWritePost * FormatWrite]])
		vim.api.nvim_create_autocmd({ "BufWritePost" }, {
			pattern = g.formatter.on_save,
			group = "MyAutoCmd",
			callback = function()
				vim.cmd([[FormatWrite]])
			end,
		})
	end,
})

-- table.insert(plugins, {
--  name = "nvim-navic",
--  setup = function() end,
--  config = function()
--    require("nvim-navic").setup()
--  end,
-- })

local p = require("utils").p

local M = function(use)
	use({
		p("https://github.com/neovim/nvim-lspconfig"),
		requires = {
			{ "hrsh7th/cmp-nvim-lsp" },
			{ p("https://github.com/williamboman/mason.nvim") },
			{ p("https://github.com/williamboman/mason-lspconfig.nvim") },
			{
				p(
					"https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim"
				),
			},
			-- { p("https://gitlab.com/yorickpeterse/nvim-dd") },
			-- { p("https://github.com/j-hui/fidget.nvim") },
			{ p("https://github.com/b0o/SchemaStore.nvim") },
			-- { p("https://github.com/barreiroleo/ltex_extra.nvim") },
			-- { p("https://github.com/SmiteshP/nvim-navic") },
		},
	})

	use({
		p("https://github.com/mfussenegger/nvim-lint"),
	})
	use({
		p("https://github.com/mhartington/formatter.nvim"),
	})
end
return M
