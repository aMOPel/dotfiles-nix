ft = "vue"

utils.addTable(g.lsp.fts, {
	ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
	volar = function(on_attach, capabilities)
		local add_on_attach = function(client, bufnr)
			client.server_capabilities.document_formatting = false
			client.server_capabilities.document_range_formatting = false
			on_attach(client, bufnr)
		end
		return {
			init_options = {
				languageFeatures = {
					diagnostics = false,
				},
			},
			on_attach = add_on_attach,
			settings = {
				tsPlugin = true,
			},
		}
	end,
})
