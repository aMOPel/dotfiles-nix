local ft = "nix"

utils.addTable(g.lsp.fts, {
	ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
	nixd = "default",
})

utils.addTable(g.treesitter.indent.disable, {
	ft,
})

utils.addTable(g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].nixpkgs_fmt },
})

utils.addTable(g.linter.filetype, {
	[ft] = { "nix", "deadnix" },
})
