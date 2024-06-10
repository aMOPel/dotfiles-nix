plugins = g.plugins

table.insert(plugins, {
	name = "nvim-web-devicons",
	setup = function() end,
	config = function()
		require("nvim-web-devicons").setup({
			override = {
				nim = {
					icon = "",
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

table.insert(plugins, {
	name = "lualine.nvim",
	setup = function() end,
	config = function()
		local function SessionStatus()
			local local_session =
				require("mini.sessions").detected["Session.vim"]
			local session_running = local_session ~= nil
				and local_session.type == "local"
			if session_running then
				return "Session"
			else
				return ""
			end
		end

		require("lualine").setup({
			options = {
				theme = "onedark",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
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
				lualine_c = {},
				lualine_x = {
					SessionStatus,
				},
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
				"toggleterm",
				"trouble",
			},
		})
	end,
})

table.insert(plugins, {
	name = "nvim-hlslens",
	setup = function()
		vim.keymap.set(
			"n",
			"n",
			[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]]
		)
		vim.keymap.set(
			"n",
			"N",
			[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]]
		)
		vim.keymap.set(
			{ "n", "x" },
			"*",
			[[<Plug>(asterisk-z*)<Cmd>lua require('hlslens').start()<CR>]]
		)
		vim.keymap.set(
			{ "n", "x" },
			"#",
			[[<Plug>(asterisk-z#)<Cmd>lua require('hlslens').start()<CR>]]
		)
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "nvim-scrollbar",
	setup = function() end,
	config = function()
		require("scrollbar").setup({
			handle = {
				highlight = "Visual",
			},
			marks = {
				Cursor = {
					text = "•",
					priority = 0,
					gui = nil,
					color = nil,
					cterm = nil,
					color_nr = nil, -- cterm
					highlight = "Normal",
				},
				Search = {
					text = { "" },
					priority = 1,
					gui = nil,
					color = nil,
					cterm = nil,
					color_nr = nil, -- cterm
					highlight = "WarningMsg",
				},
				Error = {
					text = { "" },
					priority = 2,
					gui = nil,
					color = nil,
					cterm = nil,
					color_nr = nil, -- cterm
					highlight = "DiagnosticError",
				},
				Warn = {
					text = { "" },
					priority = 3,
					gui = nil,
					color = nil,
					cterm = nil,
					color_nr = nil, -- cterm
					highlight = "DiagnosticWarn",
				},
				Info = {
					text = { "" },
					priority = 4,
					gui = nil,
					color = nil,
					cterm = nil,
					color_nr = nil, -- cterm
					highlight = "DiagnosticInfo",
				},
				Hint = {
					text = { "" },
					priority = 5,
					gui = nil,
					color = nil,
					cterm = nil,
					color_nr = nil, -- cterm
					highlight = "DiagnosticHint",
				},
				Misc = {
					text = { "" },
					priority = 6,
					gui = nil,
					color = nil,
					cterm = nil,
					color_nr = nil, -- cterm
					highlight = "Normal",
				},
			},
			excluded_buftypes = {},
			excluded_filetypes = {},
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
