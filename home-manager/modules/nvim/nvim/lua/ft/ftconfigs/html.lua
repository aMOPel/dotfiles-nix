local g = require("globals")
local add = require("utils").addTable

local ft = "html"

add(g.lsp.fts, {
	ft,
})

add(g.lsp.servers.lsp_installer, {
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

add(g.treesitter.ensure_installed, {
	ft,
	"xml",
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

local configs = {}

configs[ft] = function()
	local optl = vim.opt_local
	local noremap = require("utils").noremap_buffer
	noremap(
		"n",
		"<leader>m",
		':exec "!brave-browser --new-window -- "  .  resolve(expand("%:p"))<cr>'
	)
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})
