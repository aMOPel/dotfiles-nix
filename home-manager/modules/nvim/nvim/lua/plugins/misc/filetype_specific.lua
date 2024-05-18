local plugins = require("globals").plugins

table.insert(plugins, {
	name = "emmet-vim",
	setup = function()
		-- vim.g.user_emmet_leader_key = '<C-v>'
		-- vim.g.user_emmet_mode = 'in'
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "package-info.nvim",
	setup = function() end,
	config = function()
		require("package-info").setup()

		local noremap = require("utils").noremap_buffer
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

table.insert(plugins, {
	name = "nvim-colorizer.lua",
	setup = function() end,
	config = function()
		require("colorizer").setup({
			"css",
			"javascript",
			"yaml",
			"kitty",
			html = {
				mode = "foreground",
			},
		})
	end,
})

local p = require("utils").p

local M = function(use)
	-- is setup with lsp
	-- TODO: archived
	use({ p("https://github.com/jose-elias-alvarez/typescript.nvim") })
	use({ p("https://github.com/mattn/emmet-vim") })
	use({
		p("https://github.com/vuki656/package-info.nvim"),
		requires = { p("https://github.com/MunifTanjim/nui.nvim") },
	})
	use({ p("https://github.com/norcalli/nvim-colorizer.lua") })
	-- provides ax and ix
	use({
		p("https://github.com/whatyouhide/vim-textobj-xmlattr"),
		requires = { p("https://github.com/kana/vim-textobj-user") },
	})

	use({ p("https://github.com/johnpapa/vscode-angular-snippets") })
end
return M

-- for sql:
-- https://github.com/tpope/vim-dadbod
