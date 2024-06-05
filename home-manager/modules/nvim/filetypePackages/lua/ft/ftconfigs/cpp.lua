local ft = "cpp"

vim.tbl_deep_extend("force", g.lsp.fts, {
	"c",
	"cpp",
	"objc",
	"objcpp",
})

vim.tbl_deep_extend("force", g.lsp.servers.lsp_installer, {
	clangd = "default",
})
