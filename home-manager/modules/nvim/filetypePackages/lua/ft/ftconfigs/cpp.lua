local ft = "cpp"

utils.addTable(g.lsp.fts, {
	"c",
	"cpp",
})

utils.addTable(g.lsp.servers.lsp_installer, {
	clangd = "default",
})

utils.addTable(g.linter.filetype, {
	[ft] = { "cppcheck", "cpplint" },
})

utils.addTable(g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].clangformat },
})
