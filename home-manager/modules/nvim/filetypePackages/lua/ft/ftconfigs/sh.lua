local ft = "sh"

utils.addTable(g.lsp.fts, {
	ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
	bashls = "default",
})

utils.addTable(g.linter.filetype, {
	[ft] = { "shellcheck" },
})

utils.addTable(g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].shfmt },
})
