local ft = "markdown"

utils.addTable(g.lsp.fts, {
	ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
	ltex = "default",
})

utils.addTable(g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].prettierd },
})

utils.addTable(g.formatter.on_save, {
	"*." .. ft,
})

utils.addTable(g.linter.filetype, {
	[ft] = {
		"proselint",
		"write_good",
		"alex",
		"markdownlint",
	},
})
