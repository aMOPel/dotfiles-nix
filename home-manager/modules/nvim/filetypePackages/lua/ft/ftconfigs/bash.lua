ft = "sh"

utils.addTable(g.lsp.fts, {
	ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
	bashls = "default",
})

local configs = {}

configs[ft] = function()
	local optl = vim.opt_local
	utils.noremap(
		"n",
		"<leader>n",
		':exec "FloatermNew --disposable --width=0.95 --height=0.95 " . resolve(expand("%:p")) <CR>'
	)
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})
