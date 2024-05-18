local g = require("globals")
local add = require("utils").addTable

local ft = "go"

add(g.lsp.fts, {
	ft,
})

add(g.lsp.servers.lsp_installer, {
	gopls = "default",
})

add(g.treesitter.ensure_installed, {
	ft,
	"gowork",
	"gomod",
	"gosum",
})

add(g.linter.ensure_installed, {
	"golangci-lint",
})

add(g.linter.filetype, {
	[ft] = { "golangcilint" },
})

add(g.formatter.ensure_installed, {
	"gofumpt",
	-- "goimports",
	-- "golines",
})

add(g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].gofumpt },
})

add(g.formatter.on_save, {
	"*." .. ft,
})

add(g.dap.ensure_installed, {
	"delve",
})

local configs = {}

configs[ft] = function()
	local optl = vim.opt_local
	local noremap = require("utils").noremap_buffer
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})
