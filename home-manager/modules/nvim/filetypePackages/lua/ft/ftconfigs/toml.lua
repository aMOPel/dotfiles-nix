local ft = "toml"

utils.addTable(g.lsp.fts, {
	ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
	taplo = "default",
})

utils.addTable(g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].taplo },
})
