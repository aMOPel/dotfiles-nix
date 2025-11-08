local ft = "tex"

utils.addTable(g.lsp.fts, {
	ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
	-- server_name = function(on_attach, capabilities) end,
	ltex = "default",
})

-- disable treesitter highlight in favor of vimtex
utils.addTable(g.treesitter.highlight.disable, {
	"latex",
})

