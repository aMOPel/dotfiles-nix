local plugins = require("globals").plugins

table.insert(plugins, {
	name = "nvim-cmp",
	setup = function() end,
	config = function()
		vim.opt.completeopt = { "menu", "menuone", "noselect" }
		vim.opt.complete = {}

		local cmp = require("cmp")

		local compare = require("cmp.config.compare")

		cmp.setup({
			snippet = {
				expand = function(args)
					vim.fn["vsnip#anonymous"](args.body)
				end,
			},
			window = {
				-- completion = cmp.config.window.bordered{col_offset=-1},
				documentation = cmp.config.disable,
			},
			mapping = cmp.mapping.preset.insert({
				["<CR>"] = cmp.mapping.confirm({ select = false }),
			}),
			sources = cmp.config.sources({
				{ name = "vsnip", max_item_count = 5 },
				{ name = "nvim_lsp", max_item_count = 20 },
			}, {
				{
					name = "rg",
					keyword_length = 3,
					max_item_count = 5,
				},
				{
					name = "buffer",
					keyword_length = 3,
					max_item_count = 5,
				},
				{
					name = "fuzzy_path",
					keyword_length = 3,
					max_item_count = 10,
				},
			}, {
				{ name = "nvim_lua", max_item_count = 20 },
				{ name = "calc" },
				{ name = "emoji" },
			}),
			formatting = {
				format = require("lspkind").cmp_format({
					mode = "symbol_text",
					maxwidth = 50,
					ellipsis_char = "...",
					preset = "default",
					menu = {
						vsnip = "[SNIP]",
						fuzzy_path = "[FZYPATH]",
						nvim_lsp = "[LSP]",
						nvim_lua = "[LUA]",
						buffer = "[BUF]",
						rg = "[RG]",
						cmdline = "[CMD]",
						calc = "[CLC]",
						git = "[GIT]",
						emoji = "[EMJ]",
					},
				}),
			},
			experimental = {
				native_menu = false,
				ghost_text = true,
			},
			sorting = {
				priority_weight = 2,
				comparators = {
					require("cmp_fuzzy_path.compare"),
					compare.offset,
					compare.exact,
					compare.score,
					compare.recently_used,
					compare.kind,
					compare.sort_text,
					compare.length,
					compare.order,
				},
			},
		})

		cmp.setup.filetype("gitcommit", {
			sources = cmp.config.sources({
				{ name = "git" },
			}, {
				{ name = "buffer" },
			}),
		})

		-- go delve does support completion requests
		-- :lua= require("dap").session().capabilities.supportsCompletionsRequest
		cmp.setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
			sources = {
				{ name = "dap" },
			},
		})

		cmp.setup.cmdline({ "/", "?" }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = "buffer", max_item_count = 30 },
			},
		})
		cmp.setup.cmdline(":", {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{
					name = "fuzzy_path",
					max_item_count = 20,
					option = { fd_timeout_msec = 1500 },
				},
			}, {
				{ name = "cmdline", max_item_count = 30 },
			}),
		})
	end,
})

table.insert(plugins, {
	name = "vim-vsnip",
	setup = function()
		-- local map = require 'utils'.map
		vim.g.vsnip_snippet_dir =
			vim.fn.expand("$XDG_CONFIG_HOME/nvim/snippets")

		vim.cmd([[
imap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<tab>'
smap <expr> <Tab>   vsnip#available(1)  ? '<Plug>(vsnip-expand-or-jump)' : '<tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
]])
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "cmp-git",
	setup = function() end,
	config = function()
		require("cmp_git").setup({})
	end,
})

table.insert(plugins, {
	name = "cmp-cmdline",
	setup = function() end,
	config = function()
		local map = require("utils").map
		map("c", "<tab>", "<nop>")
		map("c", "<s-tab>", "<nop>")
		vim.opt.wildmenu = false
	end,
})

local p = require("utils").p

local M = function(use)
	use({
		p("https://github.com/hrsh7th/vim-vsnip"),
		requires = {
			{ p("https://github.com/hrsh7th/vim-vsnip-integ") },
			{
				p("https://github.com/rafamadriz/friendly-snippets"),
			},
		},
	})

	use({
		p("https://github.com/hrsh7th/nvim-cmp"),
		requires = {
			{ p("https://github.com/onsails/lspkind.nvim") },
		},
	})

	-----------------------------------------------------------------------------
	-- Sources
	use({
		p("https://github.com/hrsh7th/cmp-vsnip"),
		requires = {
			{ p("https://github.com/hrsh7th/nvim-cmp") },
			{ p("https://github.com/hrsh7th/vim-vsnip") },
		},
	})
	use({
		p("https://github.com/hrsh7th/cmp-calc"),
		requires = {
			{ p("https://github.com/hrsh7th/nvim-cmp") },
		},
	})
	use({
		p("https://github.com/hrsh7th/cmp-emoji"),
		requires = {
			{ p("https://github.com/hrsh7th/nvim-cmp") },
		},
	})
	use({
		p("https://github.com/hrsh7th/cmp-buffer"),
		requires = {
			{ p("https://github.com/hrsh7th/nvim-cmp") },
		},
	})
	use({
		p("https://github.com/hrsh7th/cmp-nvim-lua"),
		requires = {
			{ p("https://github.com/hrsh7th/nvim-cmp") },
		},
	})
	use({
		p("https://github.com/lukas-reineke/cmp-rg"),
		requires = {
			{ p("https://github.com/hrsh7th/nvim-cmp") },
		},
	})
	use({
		p("https://github.com/hrsh7th/cmp-cmdline"),
		requires = {
			{ p("https://github.com/hrsh7th/nvim-cmp") },
		},
	})
	use({
		p("https://github.com/petertriho/cmp-git"),
		requires = {
			{ p("https://github.com/hrsh7th/nvim-cmp") },
			{ p("https://github.com/nvim-lua/plenary.nvim") },
		},
	})

	use({
		p("https://github.com/rcarriga/cmp-dap"),
		requires = {
			{ p("https://github.com/hrsh7th/nvim-cmp") },
		},
	})

	-- NOTE: can't be part of `requires`
	use({
		p("https://github.com/nvim-telescope/telescope-fzf-native.nvim"),
		run = "make",
	})
	use({
		p("https://github.com/tzachar/cmp-fuzzy-path"),
		requires = {
			{ p("https://github.com/hrsh7th/nvim-cmp") },
			{ p("https://github.com/tzachar/fuzzy.nvim") },
		},
	})

	-- https://github.com/davidsierradz/cmp-conventionalcommits
	-- https://github.com/kristijanhusak/vim-dadbod-completion
end
return M
