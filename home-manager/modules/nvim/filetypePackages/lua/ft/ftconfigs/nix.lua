local ft = "nix"

vim.tbl_deep_extend("force", g.lsp.fts, {
	ft,
})

vim.tbl_deep_extend("force", g.lsp.servers.lsp_installer, {
	nixd = "default",
})

vim.tbl_deep_extend("force", g.treesitter.indent.disable, {
	ft,
})

vim.tbl_deep_extend("force", g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].nixpkgs_fmt },
})

vim.tbl_deep_extend("force", g.formatter.on_save, {
	"*." .. ft,
})

vim.tbl_deep_extend("force", g.linter.filetype, {
	[ft] = { "nix", "deadnix" },
})
