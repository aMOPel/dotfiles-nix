local g = require("globals")
local add = require("utils").addTable

local ft = "css"

add(g.lsp.fts, {
	ft,
})

add(g.lsp.servers.lsp_installer, {
	tailwindcss = function(on_attach, capabilities)
		local add_on_attach = function(client, bufnr)
			client.server_capabilities.document_formatting = false
			client.server_capabilities.document_range_formatting = false
			on_attach(client, bufnr)
		end

		return {
			init_options = {
				userLanguages = {
					nim = "twig",
				},
			},
			filetypes = { "html", "vue", "css", "nim" },
			capabilities = capabilities,
			on_attach = add_on_attach,
		}
	end,
	cssls = function(on_attach, capabilities)
		local add_on_attach = function(client, bufnr)
			client.server_capabilities.document_formatting = false
			client.server_capabilities.document_range_formatting = false
			on_attach(client, bufnr)
		end

		return {
			filetypes = { "css" },
			capabilities = capabilities,
			on_attach = add_on_attach,
		}
	end,
})

add(g.treesitter.ensure_installed, {
	ft,
})
