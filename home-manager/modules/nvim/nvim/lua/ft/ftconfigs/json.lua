local g = require("globals")
local add = require("utils").addTable

local ft = "json"

add(g.lsp.fts, {
	ft,
})

add(g.lsp.servers.lsp_installer, {
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

add(g.treesitter.ensure_installed, {
	ft,
	"json5",
	"jsonc",
})

add(g.formatter.ensure_installed, {
	"jq",
})

add(g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].jq },
})

add(g.formatter.on_save, {
	"*." .. ft,
})
