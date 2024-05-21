plugins = g.plugins

table.insert(plugins, {
	name = "indent_blankline.nvim",
	setup = function()
		vim.g.indent_blankline_filetype_exclude = {
			"terminal",
			"help",
			"floaterm",
			"lsp-installer",
			"qf",
		}
	end,
	config = function()
		-- vim.g.indent_blankline_use_treesitter = true
		-- vim.g.indent_blankline_show_current_context = true
		require("ibl").setup({
			enabled = true,
			indent = {
				char = "|",
				tab_char = "╏",
			},
			scope = {
				enabled = true,
			},
			exclude = {
				buftypes = {
					"terminal",
					"nofile",
					"quickfix",
					"prompt",
				},
				filetypes = {
					"lspinfo",
					"packer",
					"checkhealth",
					"help",
					"man",
					"gitcommit",
					"TelescopePrompt",
					"TelescopeResults",
					"floaterm",
					"mason",
				},
			},
		})
	end,
})

table.insert(plugins, {
	name = "vim-matchup",
	setup = function()
		-- vim.g.matchup_transmute_enabled = 1
		vim.g.matchup_mappings_enabled = 0
		vim.g.matchup_text_obj_enabled = 0
		vim.g.matchup_surround_enabled = 0
		vim.g.matchup_matchparen_offscreen = {
			method = "popup",
			scrolloff = 1,
			fullwidth = 1,
		}

		local map = utils.map
		map({ "n", "x" }, "%", "<plug>(matchup-%)")
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "vim-cutlass",
	setup = function() end,
	config = function()
		local noremap = utils.noremap
		noremap("n", "m", "d")
		noremap("x", "m", "d")
		noremap("n", "mm", "dd")
		noremap("n", "M", "D")
	end,
})

table.insert(plugins, {
	name = "vim-asterisk",
	setup = function()
		-- local map = require 'utils'.map
		-- map('', '*', '<Plug>(asterisk-gz*)')
		vim.g["asterisk#keeppos"] = 1
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "vim-highlightedyank",
	setup = function()
		vim.g.highlightedyank_highlight_duration = 500
	end,
	config = function() end,
})
