local g = require("globals")
local add = require("utils").addTable

local ft = "yaml"

add(g.lsp.fts, {
	ft,
})

add(g.lsp.servers.lsp_installer, {
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

add(g.treesitter.ensure_installed, {
	ft,
})

add(g.formatter.ensure_installed, {
	"prettierd",
})

add(g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].prettierd },
})

add(g.formatter.on_save, {
	"*." .. ft,
})
