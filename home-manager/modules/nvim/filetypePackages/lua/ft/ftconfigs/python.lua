local ft = "python"

vim.tbl_deep_extend("force", g.lsp.fts, {
	ft,
})

vim.tbl_deep_extend("force", g.lsp.servers.lsp_installer, {
	pylsp = "default",
})

vim.tbl_deep_extend("force", g.treesitter.indent.disable, {
	ft,
})

vim.tbl_deep_extend("force", g.formatter.filetype, {
	[ft] = {
		require("formatter.filetypes")[ft].black,
		require("formatter.filetypes")[ft].isort,
	},
})

vim.tbl_deep_extend("force", g.formatter.on_save, {
	"*." .. ft,
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
