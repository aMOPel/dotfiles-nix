local ft = "go"

vim.tbl_deep_extend("force", g.lsp.fts, {
	ft,
})

vim.tbl_deep_extend("force", g.lsp.servers.lsp_installer, {
	gopls = "default",
})

vim.tbl_deep_extend("force", g.linter.filetype, {
	[ft] = { "golangcilint" },
})

vim.tbl_deep_extend("force", g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].gofumpt },
})

vim.tbl_deep_extend("force", g.formatter.on_save, {
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
