local ft = "make"

utils.addTable(g.linter.filetype, {
	[ft] = { "checkmake" },
})

local configs = {}

configs[ft] = function()
	local optl = vim.opt_local
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})
