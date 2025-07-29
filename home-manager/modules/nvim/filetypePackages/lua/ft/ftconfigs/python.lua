local ft = "python"

utils.addTable(g.lsp.fts, {
	ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
	pylsp = "default",
})

local configs = {}

configs[ft] = function()
	local optl = vim.opt_local
	optl.foldmethod = "indent"
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})
