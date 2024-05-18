local plugins = require("globals").plugins

-- table.insert(plugins, {
-- 	name = "delaytrain.nvim",
-- 	setup = function()
-- 	end,
-- 	config = function()
--     require('delaytrain').setup {
--         delay_ms = 1000,  -- How long repeated usage of a key should be prevented
--         grace_period = 2, -- How many repeated keypresses are allowed
--         keys = {          -- Which keys (in which modes) should be delayed
--             ['nv'] = {'w', 'W', 'b', 'B', 'e', 'E', 'h', 'j', 'k', 'l'},
--             ['i'] = {'<Left>', '<Down>', '<Up>', '<Right>'},
--             -- ['n'] = {'<c-d>', '<c-u>'},
--         },
--     }
--   end,
-- })

table.insert(plugins, {
	name = "neogen",
	setup = function() end,
	config = function()
		require("neogen").setup({ snippet_engine = "vsnip" })
	end,
})

table.insert(plugins, {
	name = "rest.nvim",
	setup = function()
		local map = require("utils").map
		vim.api.nvim_create_autocmd({ "FileType" }, {
			pattern = "http",
			group = "MyAutoCmd",
			callback = function()
				map("n", "<leader>rr", "<Plug>RestNvim", { buffer = true })
			end,
		})
		-- map("n", "<leader>rr", "<Plug>RestNvimLast")
		-- map('n', '<leader>rp', '<Plug>RestNvimPreview')
	end,
	config = function()
		require("rest-nvim").setup({
			-- Open request results in a horizontal split
			result_split_horizontal = false,
			-- Keep the http file buffer above|left when split horizontal|vertical
			result_split_in_place = false,
			-- Skip SSL verification, useful for unknown certificates
			skip_ssl_verification = false,
			-- Encode URL before making request
			encode_url = true,
			-- Highlight request on run
			highlight = {
				enabled = true,
				timeout = 150,
			},
			result = {
				-- toggle showing URL, HTTP info, headers at top the of result window
				show_url = true,
				show_http_info = true,
				show_headers = true,
				-- executables or functions for formatting response body [optional]
				-- set them to false if you want to disable them
				formatters = {
					json = "jq",
					html = function(body)
						return vim.fn.system({ "tidy", "-i", "-q", "-" }, body)
					end,
				},
			},
			-- Jump to request line on run
			jump_to_request = false,
			env_file = ".envrc",
			custom_dynamic_variables = {},
			yank_dry_run = true,
		})
	end,
})

table.insert(plugins, {
	name = "numb.nvim",
	setup = function() end,
	config = function()
		require("numb").setup({
			show_numbers = true, -- Enable 'number' for the window while peeking
			show_cursorline = true, -- Enable 'cursorline' for the window while peeking
			hide_relativenumbers = true, -- Enable turning off 'relativenumber' for the window while peeking
			number_only = false, -- Peek only when the command is only a number instead of when it starts with a number
			centered_peeking = true, -- Peeked line will be centered relative to window
		})
	end,
})

table.insert(plugins, {
	name = "neotest",
	setup = function()
		local noremap = require("utils").noremap
		noremap(
			"n",
			"<leader>tt",
			"<cmd>lua require('neotest').run.run()<cr>",
			{}
		)
		noremap(
			"n",
			"<leader>tc",
			"<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>",
			{}
		)
		noremap(
			"n",
			"<leader>to",
			'<cmd>lua require("neotest").output_panel.toggle()<cr>',
			{}
		)
	end,
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-jest")({
					jestCommand = "npx jest",
					jestConfigFile = "package.json",
					-- env = { CI = true },
					cwd = function(path)
						return vim.fn.getcwd()
					end,
				}),
				-- require("neotest-vim-test")({ allow_file_types = { "javascript", "typescript" } }),
			},
		})
	end,
})

table.insert(plugins, {
	name = "which-key.nvim",
	setup = function() end,
	config = function()
		vim.o.timeout = true
		vim.o.timeoutlen = 300
		require("which-key").setup({
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		})
	end,
})

table.insert(plugins, {
	name = "legendary.nvim",
	setup = function() end,
	config = function()
		require("legendary").setup({
			-- Initial keymaps to bind, can also be a function that returns the list
			keymaps = {
				{
					"<leader>gg",
					{ n = ":-tabnew<cr>:Git ++curwin<CR>" },
					description = "open fugitive",
				},
			},
			-- Initial commands to bind, can also be a function that returns the list
			commands = {},
			-- Initial augroups/autocmds to bind, can also be a function that returns the list
			autocmds = {},
			-- Initial functions to bind, can also be a function that returns the list
			funcs = {},
			-- Initial item groups to bind,
			-- note that item groups can also
			-- be under keymaps, commands, autocmds, or funcs;
			-- can also be a function that returns the list
			itemgroups = {},
			-- default opts to merge with the `opts` table
			-- of each individual item
			default_opts = {
				-- for example, { silent = true, remap = false }
				keymaps = {},
				-- for example, { args = '?', bang = true }
				commands = {},
				-- for example, { buf = 0, once = true }
				autocmds = {},
			},
			-- Customize the prompt that appears on your vim.ui.select() handler
			-- Can be a string or a function that returns a string.
			select_prompt = " legendary.nvim ",
			-- Character to use to separate columns in the UI
			col_separator_char = "│",
			-- Optionally pass a custom formatter function. This function
			-- receives the item as a parameter and the mode that legendary
			-- was triggered from (e.g. `function(item, mode): string[]`)
			-- and must return a table of non-nil string values for display.
			-- It must return the same number of values for each item to work correctly.
			-- The values will be used as column values when formatted.
			-- See function `default_format(item)` in
			-- `lua/legendary/ui/format.lua` to see default implementation.
			default_item_formatter = nil,
			-- Customize icons used by the default item formatter
			icons = {
				-- keymap items list the modes in which the keymap applies
				-- by default, you can show an icon instead by setting this to
				-- a non-nil icon
				keymap = nil,
				command = "",
				fn = "󰡱",
				itemgroup = "",
			},
			-- Include builtins by default, set to false to disable
			include_builtin = true,
			-- Include the commands that legendary.nvim creates itself
			-- in the legend by default, set to false to disable
			include_legendary_cmds = true,
			-- Options for list sorting. Note that fuzzy-finders will still
			-- do their own sorting. For telescope.nvim, you can set it to use
			-- `require('telescope.sorters').fuzzy_with_index_bias({})` when
			-- triggered via `legendary.nvim`. Example config for `dressing.nvim`:
			--
			-- require('dressing').setup({
			--  select = {
			--    get_config = function(opts)
			--      if opts.kind == 'legendary.nvim' then
			--        return {
			--          telescope = {
			--            sorter = require('telescope.sorters').fuzzy_with_index_bias({})
			--          }
			--        }
			--      else
			--        return {}
			--      end
			--    end
			--  }
			-- })
			sort = {
				-- put most recently selected item first, this works
				-- both within global and item group lists
				most_recent_first = true,
				-- sort user-defined items before built-in items
				user_items_first = true,
				-- sort the specified item type before other item types,
				-- value must be one of: 'keymap', 'command', 'autocmd', 'group', nil
				item_type_bias = nil,
				-- settings for frecency sorting.
				-- https://en.wikipedia.org/wiki/Frecency
				-- Set `frecency = false` to disable.
				-- this feature requires sqlite.lua (https://github.com/kkharji/sqlite.lua)
				-- and will be automatically disabled if sqlite is not available.
				-- NOTE: THIS TAKES PRECEDENCE OVER OTHER SORT OPTIONS!
				frecency = {
					-- the directory to store the database in
					db_root = string.format(
						"%s/legendary/",
						vim.fn.stdpath("data")
					),
					-- the maximum number of timestamps for a single item
					-- to store in the database
					max_timestamps = 10,
				},
			},
			-- Which extensions to load; no extensions are loaded by default.
			-- Setting the plugin name to `false` disables loading the extension.
			-- Setting it to any other value will attempt to load the extension,
			-- and pass the value as an argument to the extension, which should
			-- be a single function. Extensions are modules under `legendary.extensions.*`
			-- which return a single function, which is responsible for loading and
			-- initializing the extension.
			extensions = {
				nvim_tree = false,
				smart_splits = false,
				op_nvim = false,
				diffview = false,
				which_key = {
					-- Automatically add which-key tables to legendary
					-- see ./doc/WHICH_KEY.md for more details
					auto_register = true,
					-- you can put which-key.nvim tables here,
					-- or alternatively have them auto-register,
					-- see ./doc/WHICH_KEY.md
					mappings = {},
					opts = {},
					-- controls whether legendary.nvim actually binds they keymaps,
					-- or if you want to let which-key.nvim handle the bindings.
					-- if not passed, true by default
					do_binding = true,
					-- controls whether to use legendary.nvim item groups
					-- matching your which-key.nvim groups; if false, all keymaps
					-- are added at toplevel instead of in a group.
					use_groups = true,
				},
			},
			scratchpad = {
				-- How to open the scratchpad buffer,
				-- 'current' for current window, 'float'
				-- for floating window
				view = "float",
				-- How to show the results of evaluated Lua code.
				-- 'print' for `print(result)`, 'float' for a floating window.
				results_view = "float",
				-- Border style for floating windows related to the scratchpad
				float_border = "rounded",
				-- Whether to restore scratchpad contents from a cache file
				keep_contents = true,
			},
			-- Directory used for caches
			cache_path = string.format(
				"%s/legendary/",
				vim.fn.stdpath("cache")
			),
			-- Log level, one of 'trace', 'debug', 'info', 'warn', 'error', 'fatal'
			log_level = "info",
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

local p = require("utils").p

local M = function(use)
	-- use { p "https://github.com/ja-ford/delaytrain.nvim" }

	use({
		p("https://github.com/nvim-neotest/neotest"),
		requires = {
			p("https://github.com/nvim-lua/plenary.nvim"),
			p("https://github.com/antoinemadec/FixCursorHold.nvim"),
			{
				p("https://github.com/nvim-neotest/neotest-jest"),
				commit = "3853b842b5d4850a2d5495f75802dabb3cda246c",
			},
			-- p 'https://github.com/nvim-neotest/neotest-vim-test',
			-- p 'https://github.com/vim-test/vim-test',
		},
	})
	use({ p("https://github.com/nacro90/numb.nvim") })
	use({ p("https://github.com/nvim-treesitter/playground") })
	use({ p("https://github.com/tpope/vim-dadbod") })
	use({ p("https://github.com/kristijanhusak/vim-dadbod-ui") })
	use({
		p("https://github.com/rest-nvim/rest.nvim"),
		requires = { p("https://github.com/nvim-lua/plenary.nvim") },
	})

	use({ p("https://github.com/danymat/neogen") })

	use({
		p("https://github.com/mikesmithgh/kitty-scrollback.nvim"),
		disable = false,
		opt = true,
		cmd = { "KittyScrollbackGenerateKittens", "KittyScrollbackCheckHealth" },
		event = { "User KittyScrollbackLaunch" },
		-- tag = '*', -- latest stable version, may have breaking changes if major version changed
		-- tag = 'v2.0.0', -- pin specific tag
		config = function()
			require("kitty-scrollback").setup()
		end,
		p("https://github.com/nvim-telescope/telescope.nvim"),
		tag = "0.1.5",
		requires = { p("https://github.com/nvim-lua/plenary.nvim") },
	})

	use({ p("https://github.com/folke/which-key.nvim") })
	use({ p("https://github.com/mrjones2014/legendary.nvim") })
	use({ p("https://github.com/stevearc/dressing.nvim") })

	-- TODO: look into gitsigns:
	-- https://github.com/lewis6991/gitsigns.nvim
	-- https://github.com/airblade/vim-gitgutter
	-- https://github.com/mhinz/vim-signify
	-- https://github.com/rhysd/git-messenger.vim
	-- https://github.com/f-person/git-blame.nvim
	-- https://github.com/APZelos/blamer.nvim
	-- https://github.com/tveskag/nvim-blame-line
	-- TODO: look into fugitive alternatives:
	-- https://github.com/jreybert/vimagit
	-- https://github.com/TimUntersberger/neogit
	-- https://github.com/tanvirtin/vgit.nvim
	-- https://github.com/akinsho/git-conflict.nvim
	-- https://github.com/sindrets/diffview.nvim
	-- TODO: look into gh plugins:
	-- https://github.com/tpope/vim-rhubarb
	-- https://github.com/pwntester/octo.nvim
	-- https://github.com/ldelossa/gh.nvim
	-- TODO: research: put dispatch results not always in qflist
	-- TODO: fix black git text
	-- TODO: incorporate PackerUpdate --preview
	-- TODO: test framework
	-- TODO: notes framework
	-- TODO: which-key
	-- TODO: hydra
	-- TODO: code runner framework
	-- TODO: buffer switcher?
	-- TODO: easy motion?
	-- TODO: work with marks?
	-- TODO: work with registers?
	-- TODO: work with folds?
	-- TODO: some regex plugin?
end
return M
-- # [[plugins]]
-- # repo = 'https://github.com/NTBBloodbath/rest.nvim'
-- # if = 'has("nvim")'
-- # depends = 'plenary'
-- # hook_add = '''
-- #   nmap <silent> <leader>cc <Plug>RestNvim
-- #   nmap <silent> <leader>cp <Plug>RestNvimPreview
-- #   nmap <silent> <leader>cr <Plug>RestNvimLast
-- # '''
-- # hook_post_source = '''
-- # lua <<EOF
-- # require("rest-nvim").setup({
-- #     -- Open request results in a horizontal split
-- #     result_split_horizontal = false,
-- #     -- Skip SSL verification, useful for unknown certificates
-- #     skip_ssl_verification = false,
-- #     -- Highlight request on run
-- #     highlight = {
-- #       enabled = true,
-- #       timeout = 150,
-- #     },
-- #     -- Jump to request line on run
-- #     jump_to_request = false,
-- #   })
-- # EOF
-- # '''
--
-- # [[plugins]]
-- # repo = 'https://github.com/nvim-neorg/neorg'
-- # depends = 'plenary'
-- # hook_post_source = '''
-- # lua << EOF
-- #   require('neorg').setup {
-- #       -- Tell Neorg what modules to load
-- #       load = {
-- #           ["core.defaults"] = {}, -- Load all the default modules
-- #           ["core.norg.concealer"] = {}, -- Allows for use of icons
-- #           ["core.norg.dirman"] = { -- Manage your directories with Neorg
-- #               config = {
-- #                   workspaces = {
-- #                       my_workspace = "~/neorg"
-- #                   }
-- #               }
-- #           },
-- #           ["core.keybinds"] = { -- Configure core.keybinds
-- #               config = {
-- #                   default_keybinds = true, -- Generate the default keybinds
-- #                   neorg_leader = "<Leader>o" -- This is the default if unspecified
-- #               }
-- #           },
-- #           ["core.norg.completion"] = {
-- #             config = {
-- #               engine = "nvim-cmp",
-- #             },
-- #           },
-- #       },
-- #   }
-- # EOF
-- # '''
--
--
-- # for harpoon
-- # [[plugins]]
-- # repo = 'nvim-lua/popup.nvim'
-- # if = 'has("nvim")'
-- # name = 'popup'
--
-- # [[plugins]]
-- # repo = 'ThePrimeagen/harpoon'
-- # if = 'has("nvim")'
-- # on_lua = 'harpoon'
-- # depends = ['popup', 'plenary']
-- # hook_add = '''
-- #   nnoremap <leader>hh :lua require("harpoon.ui").toggle_quick_menu()<cr>
-- #   nnoremap <leader>ha :lua require("harpoon.mark").add_file()<CR>
-- #   nnoremap <C-m> :lua require("harpoon.ui").nav_file(1)<CR>
-- #   nnoremap <C-n> :lua require("harpoon.ui").nav_file(2)<CR>
-- #   nnoremap <C-h> :lua require("harpoon.ui").nav_file(3)<CR>
-- #   nnoremap <C-y> :lua require("harpoon.ui").nav_file(4)<CR>
-- #   autocmd MyAutoCmd FileType harpoon nnoremap <buffer> <esc> :wq<cr>
-- # '''
-- # hook_post_source = '''
-- # lua <<EOF
-- # require("harpoon").setup({
-- #   global_settings = {
-- #       save_on_toggle = false,
-- #       save_on_change = true,
-- #   },
-- # })
-- # EOF
-- # '''
--
-- # -------------------------------------------------------------------
-- # test
--
-- [[plugins]]
-- repo = 'https://github.com/folke/which-key.nvim'
-- hook_post_source = '''
-- lua <<EOF
-- require("which-key").setup{
--   plugins = {
--     marks = false,
--     spelling = {
--       enabled = true,
--       suggestions = 20,
--     },
--   },
-- }
-- EOF
-- '''
--
-- # -------------------------------------------------------------------
-- # bigger frameworks or functions
--
-- [[plugins]]
-- repo = 'https://github.com/tpope/vim-speeddating'
-- on_cmd = 'SpeedDatingFormat'
-- on_map = { n = ['<c-a>', '<c-x>'] }
-- hook_post_source = '''
-- 1SpeedDatingFormat %-d-%-m-%y
-- '''
--
-- [[plugins]]
-- repo = 'https://github.com/MattesGroeger/vim-bookmarks'
-- on_map = '<Plug>Bookmark'
-- hook_add = '''
--   let g:bookmark_sign = '📘'
--   let g:bookmark_annotation_sign = '📗'
--   let g:bookmark_no_default_key_mappings = 1
--   let g:bookmark_auto_save_file = stdpath('data') . '/bookmarks'
--
--   nmap <Leader>bb <Plug>BookmarkToggle
--   nmap <Leader>bi <Plug>BookmarkAnnotate
--   nmap <Leader>ba <Plug>BookmarkShowAll
--   nmap <Leader>bn <Plug>BookmarkNext
--   nmap <Leader>bp <Plug>BookmarkPrev
--   nmap <Leader>bc <Plug>BookmarkClear
--   nmap <Leader>bx <Plug>BookmarkClearAll
--   nmap <Leader>bk <Plug>BookmarkMoveUp
--   nmap <Leader>bj <Plug>BookmarkMoveDown
--   nmap <Leader>bg <Plug>BookmarkMoveToLine
-- '''
--
-- # [[pluglns]]
-- # repo = 'https://github.com/AndrewRadev/splitjoin.vim'
-- # on_map = { n = [' J', ' j'] }
-- # hook_source = '''
-- #   let g:splitjoin_split_mapping = ''
-- #   let g:splitjoin_join_mapping = ''
-- #
-- #   nmap <Leader>J :SplitjoinJoin<cr>
-- #   nmap <Leader>j :SplitjoinSplit<cr>
-- # '''
-- # # only has clever definitions for these fts
-- # on_ft = [
-- #   'c',
-- #   'coffee',
-- #   'css',
-- #   'elixir',
-- #   'elm',
-- #   'eruby',
-- #   'go',
-- #   'haml',
-- #   'handlebars',
-- #   'html',
-- #   'java',
-- #   'javascript',
-- #   'json',
-- #   'jsx',
-- #   'tsx',
-- #   'lua',
-- #   'perl',
-- #   'php',
-- #   'python',
-- #   'r',
-- #   'ruby',
-- #   'rust',
-- #   'scss',
-- #   'less',
-- #   'shell',
-- #   'tex',
-- #   'vimscript',
-- #   'yaml',
-- # ]
--
-- # [[plugins]]
-- # repo = 'tversteeg/registers.nvim'
-- # if = 'has("nvim")'
-- # on_cmd = 'Registers'
-- # on_map = {
-- #   i = '<c-r>',
-- #   n = '"',
-- #   v = '"',
-- # }
--

-- https://github.com/tpope/vim-projectionist
-- use projectionist instead of altr
--
-- # [[plugins]]
-- # repo = 'kana/vim-altr'
-- # on_map = '<Plug>'
-- # hook_add = '''
-- #   nmap <leader>a <Plug>(altr-back)
-- #   nmap <leader>A <Plug>(altr-forward)
-- # '''
-- # hook_source = '''
-- #   " call altr#remove_all()
-- #   call altr#define('%/src/%.cpp', '%/src/%.h*', '%/include/%.h*')
-- #   call altr#define('%.gd', 'test/unit/test_%.gd')
-- #   call altr#define('addons/*/%.gd', 'test/unit/test_%.gd')
-- # '''
--
