local plugins = require("globals").plugins

table.insert(plugins, {
	name = "nvim-web-devicons",
	setup = function() end,
	config = function()
		require("nvim-web-devicons").setup({
			override = {
				nim = {
					icon = "👑",
					name = "nim",
				},
			},
		})
	end,
})

table.insert(plugins, {
	name = "onedark.nvim",
	setup = function() end,
	config = function()
		require("onedark").load()
	end,
})

-- table.insert(plugins, {
-- 	name = "nvim-gps",
-- 	setup = function() end,
-- 	config = function()
-- 		require("nvim-gps").setup()
-- 	end,
-- })

table.insert(plugins, {
	name = "lualine.nvim",
	setup = function() end,
	config = function()
		-- local gps = require("nvim-gps")

		local function ObsessionStatusMod()
			return vim.fn.ObsessionStatus("Session", "")
		end

		require("lualine").setup({
			options = {
				theme = "onedark",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				globalstatus = false,
				refresh = {
					statusline = 1000,
					tabline = 1000,
					winbar = 1000,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = { "location" },
				lualine_x = {
					{
						"diagnostics",
						padding = 2,
						sources = { "nvim_diagnostic" },
						sections = { "error", "warn", "info", "hint" },
						symbols = {
							error = " ",
							warn = " ",
							info = " ",
							hint = " ",
						},
						update_in_insert = false,
						always_visible = false,
					},
				},
				lualine_y = {
					{
						"filename",
						file_status = true,
						path = 0,
						shorting_target = 70,
					},
					{
						"filetype",
						colored = true,
						icon_only = true,
					},
				},
				lualine_z = {},
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {
					{
						"filetype",
						colored = false,
						icon_only = true,
					},
					{
						"filename",
						file_status = true,
						path = 0,
						shorting_target = 70,
					},
				},
				lualine_z = {},
			},
			tabline = {
				lualine_a = { "tabs" },
				lualine_b = { "branch", "diff" },
				lualine_c = {
					-- { gps.get_location, cond = gps.is_available },
				},
				lualine_x = { ObsessionStatusMod },
				lualine_y = {
					{ "encoding" },
					{ "fileformat" },
					{
						"filetype",
						icon = { align = "right" },
					},
				},
				lualine_z = {},
			},
			winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			inactive_winbar = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {},
			},
			extensions = {
				"quickfix",
				"fugitive",
				"man",
				"nvim-dap-ui",
				"mundo",
				"mason",
			},
		})
	end,
})

table.insert(plugins, {
	name = "nvim-hlslens",
	setup = function() end,
	config = function()
		local kopts = { noremap = true, silent = true }
		vim.api.nvim_set_keymap(
			"n",
			"n",
			[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
			kopts
		)
		vim.api.nvim_set_keymap(
			"n",
			"N",
			[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
			kopts
		)
		vim.api.nvim_set_keymap(
			"n",
			"*",
			[[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]],
			{}
		)
		vim.api.nvim_set_keymap(
			"x",
			"*",
			[[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]],
			{}
		)

		-- vim.api.nvim_set_keymap('n', '<Leader>l', ':noh<CR>', kopts)
	end,
})

table.insert(plugins, {
	name = "nvim-scrollbar",
	setup = function() end,
	config = function()
		require("scrollbar").setup({
			show = true,
			show_in_active_only = false,
			set_highlights = true,
			folds = 1000, -- handle folds, set to number to disable folds if no. of lines in buffer exceeds this
			max_lines = false, -- disables if no. of lines in buffer exceeds this
			handle = {
				text = " ",
				color = nil,
				cterm = nil,
				highlight = "Visual",
				hide_if_all_visible = true, -- Hides handle if all lines are visible
			},
			marks = {
				Search = {
					-- text = { "ﰯ" },
					text = { "" },
					priority = 0,
					color = nil,
					cterm = nil,
					highlight = "WarningMsg",
				},
				Error = {
					text = { "" },
					priority = 1,
					color = nil,
					cterm = nil,
					highlight = "DiagnosticError",
				},
				Warn = {
					text = { "" },
					priority = 2,
					color = nil,
					cterm = nil,
					highlight = "DiagnosticWarn",
				},
				Info = {
					text = { "" },
					priority = 3,
					color = nil,
					cterm = nil,
					highlight = "DiagnosticInfo",
				},
				Hint = {
					text = { "" },
					priority = 4,
					color = nil,
					cterm = nil,
					highlight = "DiagnosticHint",
				},
				Misc = {
					text = { "" },
					priority = 5,
					color = nil,
					cterm = nil,
					highlight = "Normal",
				},
			},
			excluded_buftypes = {
				"terminal",
			},
			excluded_filetypes = {
				"prompt",
				"TelescopePrompt",
			},
			autocmd = {
				render = {
					"BufWinEnter",
					"TabEnter",
					"TermEnter",
					"WinEnter",
					"CmdwinLeave",
					"TextChanged",
					"VimResized",
					"WinScrolled",
				},
				clear = {
					"BufWinLeave",
					"TabLeave",
					"TermLeave",
					"WinLeave",
				},
			},
			handlers = {
				diagnostic = true,
				search = false, -- Requires hlslens to be loaded, will run require("scrollbar.handlers.search").setup() for you
			},
		})
		require("scrollbar.handlers.search").setup({
			auto_enable = true,
			enable_incsearch = true,
			calm_down = true,
			nearest_only = true,
			nearest_float_when = "always",
			float_shadow_blend = 50,
			virt_priority = 100,
			build_position_cb = nil,
			override_lens = nil,
		})
	end,
})

local p = require("utils").p

local M = function(use)
	use({ p("https://github.com/kyazdani42/nvim-web-devicons") })

	use({
		p("https://github.com/nvim-lualine/lualine.nvim"),
		after = "nvim-treesitter",
		requires = {
			{ p("https://github.com/navarasu/onedark.nvim") },
			-- { p("https://github.com/SmiteshP/nvim-gps"), after = 'nvim-treesitter', },
		},
	})
	use({
		p("https://github.com/petertriho/nvim-scrollbar"),
		requires = { p("https://github.com/kevinhwang91/nvim-hlslens") },
	})
end
return M
