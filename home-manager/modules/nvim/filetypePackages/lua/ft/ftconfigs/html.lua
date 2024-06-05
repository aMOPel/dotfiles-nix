local ft = "html"

vim.tbl_deep_extend("force", g.lsp.fts, {
	ft,
})

vim.tbl_deep_extend("force", g.lsp.servers.lsp_installer, {
	html = function(on_attach, capabilities)
		local add_on_attach = function(client, bufnr)
			client.server_capabilities.document_formatting = false
			client.server_capabilities.document_range_formatting = false
			on_attach(client, bufnr)
		end

		return {
			filetypes = { "html" },
			capabilities = capabilities,
			on_attach = add_on_attach,
		}
	end,
})

vim.tbl_deep_extend("force", g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].prettierd },
})

vim.tbl_deep_extend("force", g.formatter.on_save, {
	"*." .. ft,
})
