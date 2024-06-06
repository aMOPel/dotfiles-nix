local ft = "go"

utils.addTable(g.lsp.fts, {
	ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
	gopls = "default",
})

utils.addTable(g.linter.filetype, {
	[ft] = { "golangcilint" },
})

utils.addTable(g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].gofumpt },
})

utils.addTable(g.formatter.on_save, {
	"*." .. ft,
})

local configs = {}

configs[ft] = function()
	local optl = vim.opt_local
	require("dap-go").setup()
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})
