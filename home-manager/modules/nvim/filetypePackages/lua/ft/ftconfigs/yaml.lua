local ft = "yaml"

utils.addTable(g.lsp.fts, {
	ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
	yamlls = function(on_attach, capabilities)
		return {
			capabilities = capabilities,
			on_attach = on_attach,
			settings = {
				yaml = {
					schemaStore = {
						enable = false,
						url = "",
					},
					schemas = require("schemastore").yaml.schemas(),
				},
			},
		}
	end,
})

utils.addTable(g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].prettierd },
})

utils.addTable(g.formatter.on_save, {
	"*." .. ft,
})
