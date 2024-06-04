plugins = g.plugins

table.insert(plugins, {
	name = "nvim-cmp",
	setup = function()
		vim.opt.completeopt = { "menu", "menuone", "noselect" }
		vim.opt.complete = {}
	end,
	config = function()
		local cmp = require("cmp")

		local compare = require("cmp.config.compare")

		cmp.setup({
			snippet = {
				expand = function(args)
					vim.fn["vsnip#anonymous"](args.body)
				end,
			},
			window = {
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
					option = { fd_timeout_msec = 1500 },
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
		vim.g.vsnip_snippet_dir =
			vim.fn.expand("$XDG_CONFIG_HOME/nvim/snippets")
		vim.cmd([[
imap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
smap <expr> <Tab>   vsnip#jumpable(1)   ? '<Plug>(vsnip-jump-next)'      : '<Tab>'
imap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
smap <expr> <S-Tab> vsnip#jumpable(-1)  ? '<Plug>(vsnip-jump-prev)'      : '<S-Tab>'
xmap        <Tab>   <Plug>(vsnip-cut-text)]])
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
	setup = function()
		vim.opt.wildmenu = false
	end,
	config = function() end,
})
