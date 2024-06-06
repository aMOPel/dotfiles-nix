local ft = "cpp"

utils.addTable(g.lsp.fts, {
	"c",
	"cpp",
	"objc",
	"objcpp",
})

utils.addTable(g.lsp.servers.lsp_installer, {
	clangd = "default",
})
