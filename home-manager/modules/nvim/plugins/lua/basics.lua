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
	name = "buildin highlight yank",
	setup = function()
		vim.cmd(
			[[autocmd TextYankPost * silent! lua vim.highlight.on_yank {higroup='IncSearch', timeout=500}]]
		)
	end,
	config = function() end,
})
