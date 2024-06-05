local ft = "json"

vim.tbl_deep_extend("force", g.lsp.fts, {
	ft,
})

vim.tbl_deep_extend("force", g.lsp.servers.lsp_installer, {
	jsonls = function(on_attach, capabilities)
		return {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				json = {
					schemas = require("schemastore").json.schemas(),
				},
			},
		}
	end,
})

vim.tbl_deep_extend("force", g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].jq },
})

vim.tbl_deep_extend("force", g.formatter.on_save, {
	"*." .. ft,
})
