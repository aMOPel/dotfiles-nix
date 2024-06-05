local ft = "markdown"

vim.tbl_deep_extend("force", g.lsp.fts, {
	ft,
})

vim.tbl_deep_extend("force", g.lsp.servers.lsp_installer, {
	-- ltex = function(on_attach, capabilities)
	-- 	return {
	-- 		capabilities = capabilities,
	-- 		on_attach = on_attach,
	-- 		settings = {
	-- 			ltex = {
	-- 				language = "auto",
	-- 				diagnosticSeverity = "information",
	-- 				sentenceCacheSize = 2000,
	-- 			},
	-- 		},
	-- 	}
	-- end,

	ltex = "default",
})

vim.tbl_deep_extend("force", g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].prettierd },
})

vim.tbl_deep_extend("force", g.formatter.on_save, {
	"*." .. ft,
})

vim.tbl_deep_extend("force", g.linter.filetype, {
	[ft] = {
		"proselint",
		"write_good",
		"alex",
		"markdownlint",
	},
})
