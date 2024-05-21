table.insert(g.plugins, {
	name = "emmet-vim",
	setup = function()
		-- vim.g.user_emmet_leader_key = '<C-v>'
		-- vim.g.user_emmet_mode = 'in'
	end,
	config = function() end,
})

table.insert(g.plugins, {
	name = "package-info.nvim",
	setup = function() end,
	config = function()
		require("package-info").setup()

		local noremap = utils.noremap_buffer
		noremap("n", "<leader>js", ":lua require('package-info').show()<CR>")
		noremap("n", "<leader>jh", ":lua require('package-info').hide()<CR>")
		noremap("n", "<leader>ju", ":lua require('package-info').update()<CR>")
		noremap("n", "<leader>jd", ":lua require('package-info').delete()<CR>")
		noremap("n", "<leader>ji", ":lua require('package-info').install()<CR>")
		noremap(
			"n",
			"<leader>jr",
			":lua require('package-info').reinstall()<CR>"
		)
		noremap(
			"n",
			"<leader>jp",
			":lua require('package-info').change_version()<CR>"
		)
	end,
})

table.insert(g.plugins, {
	name = "nvim-colorizer.lua",
	setup = function() end,
	config = function()
		require("colorizer").setup({
			filetypes = {
				"css",
				"javascript",
				"yaml",
				"kitty",
				html = {
					mode = "foreground",
				},
			},
		})
	end,
})
