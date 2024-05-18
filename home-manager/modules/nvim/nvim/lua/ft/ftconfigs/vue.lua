local g = require("globals")
local add = require("utils").addTable

local ft = "vue"

add(g.lsp.fts, {
	ft,
})

add(g.lsp.servers.lsp_installer, {
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

add(g.treesitter.ensure_installed, {
	ft,
})
