vim.api.nvim_create_augroup("MyAutoCmd", {})
vim.api.nvim_create_augroup("MyFt", {})
vim.api.nvim_create_augroup("CustomFileType", {})

vim.filetype.add({
	filename = {
		[".env"] = "sh",
		[".envrc"] = "sh",
	},
})

vim.filetype.add({
	pattern = {
		["*kitty*.conf"] = "kitty",
	},
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "MyAutoCmd",
	pattern = { "qf" },
	callback = function(ev)
		vim.keymap.set(
			{ "n" },
			"s",
			[[:<c-u>cdo s/// | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]],
			{ buffer = true, desc = "quick search and replace in quickfix" }
		)
	end,
	desc = "quick search and replace in quickfix",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
	group = "MyAutoCmd",
	pattern = { "help" },
	callback = function(ev)
		vim.keymap.set(
			{ "n" },
			"go",
			[[<c-]>]],
			{ buffer = true, desc = "follow tags in helpfiles easier" }
		)
	end,
	desc = "follow tags in helpfiles easier",
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
	group = "MyAutoCmd",
	pattern = { "*" },
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
	end,
	desc = "Highlight yanked text",
})
