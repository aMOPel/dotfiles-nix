local ft = "nix"

utils.addTable(g.lsp.fts, {
	ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
	nixd = "default",
})

utils.addTable(g.linter.filetype, {
	[ft] = { "nix", "deadnix" },
})

utils.addTable(g.treesitter.context.disable, {
  ft,
})
