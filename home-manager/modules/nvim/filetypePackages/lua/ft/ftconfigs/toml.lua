local ft = "toml"

vim.tbl_deep_extend("force", g.lsp.fts, {
	ft,
})

vim.tbl_deep_extend("force", g.lsp.servers.lsp_installer, {
	"taplo",
})

vim.tbl_deep_extend("force", g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].taplo },
})

vim.tbl_deep_extend("force", g.formatter.on_save, {
	"*." .. ft,
})
