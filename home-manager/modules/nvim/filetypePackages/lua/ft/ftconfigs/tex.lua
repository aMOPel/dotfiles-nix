local ft = "tex"

utils.addTable(g.lsp.fts, {
	ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
	-- server_name = function(on_attach, capabilities) end,
	ltex = "default",
})
