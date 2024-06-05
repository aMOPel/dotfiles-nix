plugins = g.plugins

table.insert(plugins, {
	name = "vim-floaterm",
	setup = function()
		vim.g.floaterm_shell = "bash"
		vim.g.floaterm_width = 0.9
		vim.g.floaterm_height = 0.8
		vim.g.floaterm_opener = "tabe"

		local noremap = utils.noremap
		noremap("n", "<leader>ff", ":FloatermToggle --cwd=<buffer> <CR>")
		noremap("t", "<C-W>c", "<C-\\><C-n><C-W>c")
		noremap("t", "<C-W><c-c>", "<C-\\><C-n><C-W>c")
		noremap("t", "<C-W>w", "<C-\\>:FloatermNext<cr>")
		noremap("t", "<C-W><c-w>", "<C-\\>:FloatermNext<cr>")
		noremap("t", "<C-W>n", "<C-\\>:FloatermNew<cr>")
		noremap("t", "<C-W><c-n>", "<C-\\>:FloatermNew<cr>")
		noremap(
			"n",
			"<leader>fm",
			':exec "FloatermNew --cwd=<buffer> --autoclose=0 --disposable " . &makeprg<CR>'
		)
		noremap(
			"n",
			"<leader>fg",
			":FloatermNew --cwd=<buffer> --autoclose=1 --width=1.0 --height=1.0 lazygit<CR>"
		)
		noremap(
			"n",
			"<leader>ft",
			":FloatermNew --cwd=<buffer> --autoclose=2 --disposable taskwarrior-tui<CR>"
		)
		noremap(
			"n",
			"<leader>fw",
			":FloatermNew --cwd=<buffer> --autoclose=0 --disposable --width=0.9 timew week<CR>"
		)
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "vim-grepper",
	setup = function()
		local noremap = utils.noremap
		local map = utils.map
		noremap("n", "<c-f>", ":Grepper -tool rg<CR>")
		-- noremap('n', '<leader>*', ':Grepper -tool rg -cword -noprompt<cr>')

		-- map("n", "gs", "<Plug>(GrepperOperator)")
		-- map("x", "gs", "<Plug>(GrepperOperator)")

		vim.cmd([[
aug Grepper
  au!
  au User Grepper ++nested call setqflist([], 'r', {'context': {'bqf': {'pattern_hl': '\%#' . getreg('/')}}})
aug END
]])

		vim.g.grepper = {
			open = 1,
			prompt_quote = 1,
			simple_prompt = 1,
			switch = 1,
			quickfix = 1,
			searchreg = 1,
			highlight = 1,
			dir = "cwd",
			tools = { "rg" },
			rg = {
				grepprg = "rg -H --no-heading --vimgrep --smart-case --follow --",
			},
			operator = {
				open = 1,
				switch = 1,
				prompt = 0,
				quickfix = 1,
				searchreg = 1,
				highlight = 1,
				dir = "cwd",
				tools = { "rg" },
				rg = {
					grepprg = "rg -H --no-heading --vimgrep --smart-case --",
				},
			},
		}
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "vim-fugitive",
	setup = function()
		local noremap = utils.noremap
		noremap("n", "<leader>gg", ":-tabnew<cr>:Git ++curwin<CR>")
		noremap("n", "<leader>gl", ":-tabnew<cr>:Gclog <CR>")
		noremap("n", "<leader>gd", ":-tabnew %<cr>:Gdiffsplit! <cr>")
		-- vim.cmd [[au MyPlugins Filetype gitcommit nnoremap <buffer> <c-s> :wq<cr>]]
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "rnvimr",
	setup = function()
		local noremap = utils.noremap
		noremap("n", "-", ":RnvimrToggle<CR>")
	end,
	config = function()
		vim.g.rnvimr_enable_ex = 1
		vim.g.rnvimr_enable_picker = 0
		vim.g.rnvimr_enable_bw = 1
		vim.g.rnvimr_draw_border = 0
		vim.g.rnvimr_layout = {
			relative = "editor",
			width = math.floor(0.9 * vim.o.columns),
			height = math.floor(0.8 * vim.o.lines),
			col = math.floor(0.05 * vim.o.columns),
			row = math.floor(0.05 * vim.o.lines),
			style = "minimal",
			border = "rounded",
		}
	end,
})

table.insert(plugins, {
	name = "todo-comments.nvim",
	setup = function() end,
	config = function()
		require("todo-comments").setup({
			keywords = {
				DONE = { icon = " ", color = "done" },
				TODO = { icon = " ", color = "info" },
			},
			colors = {
				done = { "#84da94" },
			},
		})
	end,
})

-- table.insert(plugins, {
--   name = 'vim-dispatch',
--   setup = function()
--     vim.g.dispatch_no_maps = 1
--     local noremap = require 'utils'.noremap
--     noremap('n', '<cr>', ':Make<cr>')
--   end,
--   config = function()
--   end,
-- })

table.insert(plugins, {
	name = "qf.nvim",
	setup = function()
		local noremap = utils.noremap
		noremap("n", "Q", function()
			require("qf").toggle("c", false)
		end)
	end,
	config = function()
		require("qf").setup({
			l = {
				auto_close = true, -- Automatically close location/quickfix list if empty
				auto_follow = false, -- Follow current entry, possible values: prev,next,nearest, or false to disable
				auto_follow_limit = 8, -- Do not follow if entry is further away than x lines
				follow_slow = true, -- Only follow on CursorHold
				auto_open = true, -- Automatically open list on QuickFixCmdPost
				auto_resize = true, -- Auto resize and shrink location list if less than `max_height`
				max_height = 8, -- Maximum height of location/quickfix list
				min_height = 5, -- Minimum height of location/quickfix list
				wide = true, -- Open list at the very bottom of the screen, stretching the whole width.
				number = false, -- Show line numbers in list
				relativenumber = true, -- Show relative line numbers in list
				unfocus_close = false, -- Close list when window loses focus
				focus_open = false, -- Auto open list on window focus if it contains items
			},
			-- Quickfix list configuration
			c = {
				auto_close = true, -- Automatically close location/quickfix list if empty
				auto_follow = false, -- Follow current entry, possible values: prev,next,nearest, or false to disable
				auto_follow_limit = 8, -- Do not follow if entry is further away than x lines
				follow_slow = true, -- Only follow on CursorHold
				auto_open = true, -- Automatically open list on QuickFixCmdPost
				auto_resize = true, -- Auto resize and shrink location list if less than `max_height`
				max_height = 8, -- Maximum height of location/quickfix list
				min_height = 5, -- Minimum height of location/quickfix list
				wide = true, -- Open list at the very bottom of the screen, stretching the whole width.
				number = false, -- Show line numbers in list
				relativenumber = true, -- Show relative line numbers in list
				unfocus_close = false, -- Close list when window loses focus
				focus_open = false, -- Auto open list on window focus if it contains items
			},
			close_other = true, -- Close location list when quickfix list opens
			pretty = false, -- "Pretty print quickfix lists"
		})
	end,
})

table.insert(plugins, {
	name = "dressing.nvim",
	setup = function() end,
	config = function()
		require("dressing").setup({
			input = {
				-- Set to false to disable the vim.ui.input implementation
				enabled = true,

				-- Default prompt string
				default_prompt = "Input",

				-- Trim trailing `:` from prompt
				trim_prompt = true,

				-- Can be 'left', 'right', or 'center'
				title_pos = "left",

				-- When true, <Esc> will close the modal
				insert_only = true,

				-- When true, input will start in insert mode.
				start_in_insert = true,

				-- These are passed to nvim_open_win
				border = "rounded",
				-- 'editor' and 'win' will default to being centered
				relative = "cursor",

				-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
				prefer_width = 40,
				width = nil,
				-- min_width and max_width can be a list of mixed types.
				-- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
				max_width = { 140, 0.9 },
				min_width = { 20, 0.2 },

				buf_options = {},
				win_options = {
					-- Disable line wrapping
					wrap = false,
					-- Indicator for when text exceeds window
					list = true,
					listchars = "precedes:…,extends:…",
					-- Increase this for more context when text scrolls off the window
					sidescrolloff = 0,
				},

				-- Set to `false` to disable
				mappings = {
					n = {
						["<Esc>"] = "Close",
						["<CR>"] = "Confirm",
					},
					i = {
						["<C-c>"] = "Close",
						["<CR>"] = "Confirm",
						["<Up>"] = "HistoryPrev",
						["<Down>"] = "HistoryNext",
					},
				},

				override = function(conf)
					-- This is the config that will be passed to nvim_open_win.
					-- Change values here to customize the layout
					return conf
				end,

				-- see :help dressing_get_config
				get_config = nil,
			},
			select = {
				-- Set to false to disable the vim.ui.select implementation
				enabled = true,

				-- Priority list of preferred vim.select implementations
				backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

				-- Trim trailing `:` from prompt
				trim_prompt = true,

				-- Options for telescope selector
				-- These are passed into the telescope picker directly. Can be used like:
				-- telescope = require('telescope.themes').get_ivy({...})
				telescope = nil,

				-- Options for fzf selector
				fzf = {
					window = {
						width = 0.5,
						height = 0.4,
					},
				},

				-- Options for fzf-lua
				fzf_lua = {
					-- winopts = {
					--   height = 0.5,
					--   width = 0.5,
					-- },
				},

				-- Options for nui Menu
				nui = {
					position = "50%",
					size = nil,
					relative = "editor",
					border = {
						style = "rounded",
					},
					buf_options = {
						swapfile = false,
						filetype = "DressingSelect",
					},
					win_options = {
						winblend = 0,
					},
					max_width = 80,
					max_height = 40,
					min_width = 40,
					min_height = 10,
				},

				-- Options for built-in selector
				builtin = {
					-- Display numbers for options and set up keymaps
					show_numbers = true,
					-- These are passed to nvim_open_win
					border = "rounded",
					-- 'editor' and 'win' will default to being centered
					relative = "editor",

					buf_options = {},
					win_options = {
						cursorline = true,
						cursorlineopt = "both",
					},

					-- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
					-- the min_ and max_ options can be a list of mixed types.
					-- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
					width = nil,
					max_width = { 140, 0.8 },
					min_width = { 40, 0.2 },
					height = nil,
					max_height = 0.9,
					min_height = { 10, 0.2 },

					-- Set to `false` to disable
					mappings = {
						["<Esc>"] = "Close",
						["<C-c>"] = "Close",
						["<CR>"] = "Confirm",
					},

					override = function(conf)
						-- This is the config that will be passed to nvim_open_win.
						-- Change values here to customize the layout
						return conf
					end,
				},

				-- Used to override format_item. See :help dressing-format
				format_item_override = {},

				-- see :help dressing_get_config
				get_config = nil,
			},
		})
	end,
})
