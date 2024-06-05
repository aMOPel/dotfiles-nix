plugins = g.plugins

table.insert(plugins, {
	name = "indent_blankline.nvim",
	setup = function() end,
	config = function()
		require("ibl").setup({
			enabled = true,
			scope = {
				enabled = true,
			},
			exclude = {
				filetypes = {
					"floaterm",
				},
			},
		})
	end,
})

table.insert(plugins, {
	name = "vim-matchup",
	setup = function()
		vim.g.matchup_mappings_enabled = 0
		vim.g.matchup_text_obj_enabled = 0
		vim.g.matchup_surround_enabled = 0
		vim.g.matchup_matchparen_offscreen = {
			method = "popup",
			scrolloff = 1,
			fullwidth = 1,
		}

		vim.keymap.set(
			{ "n", "x" },
			"%",
			"<plug>(matchup-%)",
			{ desc = "vim-matchup" }
		)
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "vim-cutlass",
	setup = function() end,
	config = function()
		vim.keymap.set("n", "m", "d", { desc = "cut" })
		vim.keymap.set("x", "m", "d", { desc = "cut" })
		vim.keymap.set("n", "mm", "dd", { desc = "cut whole line" })
		vim.keymap.set("n", "M", "D", { desc = "cut until eol" })
	end,
})

table.insert(plugins, {
	name = "vim-asterisk",
	setup = function()
		-- see hlslens
		vim.g["asterisk#keeppos"] = 1
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "mini.basics",
	setup = function()
		require("mini.basics").setup({
			options = {
				basic = false,
				extra_ui = false,
				win_borders = "bold",
			},
			mappings = {
				basic = false,
				option_toggle_prefix = [[yo]],
				windows = false,
				move_with_alt = false,
			},
			autocommands = {
				basic = false,
				relnum_in_visual_mode = false,
			},
		})
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "mini.bracketed",
	setup = function() end,
	config = function()
		require("mini.bracketed").setup()
	end,
})

table.insert(plugins, {
	name = "mini.misc",
	setup = function() end,
	config = function()
		vim.keymap.set(
			"n",
			"<C-W>m",
			require("mini.misc").zoom,
			{ desc = "maximize current window" }
		)
		vim.keymap.set(
			"n",
			"<C-W><C-M>",
			require("mini.misc").zoom,
			{ desc = "maximize current window" }
		)
	end,
})
