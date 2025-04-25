local ft = "markdown"

utils.addTable(g.lsp.fts, {
	ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
	ltex = function(on_attach, capabilities)
		return {
			capabilities = capabilities,
			on_attach = on_attach,
			on_init = function(client)
				client.config.settings =
					utils.addTable(client.config.settings, {
						ltex = {
							enabled = {
								-- "bibtex",
								-- "gitcommit",
								"markdown",
								-- "org",
								-- "tex",
								"restructuredtext",
								-- "rsweave",
								"latex",
								-- "quarto",
								-- "rmd",
								-- "context",
								-- "mail",
								-- "plaintext",
							},
						},
					})

				client.notify(
					"workspace/didChangeConfiguration",
					{ settings = client.config.settings }
				)
				return true
			end,
		}
	end,
})

utils.addTable(g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].prettierd },
})

utils.addTable(g.linter.filetype, {
	[ft] = {
		"proselint",
		"write_good",
		"alex",
		"markdownlint",
	},
})
