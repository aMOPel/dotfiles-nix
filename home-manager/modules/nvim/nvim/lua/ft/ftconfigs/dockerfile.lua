local g = require("globals")
local add = require("utils").addTable

local ft = "dockerfile"

add(g.lsp.fts, {
	ft,
})

add(g.lsp.servers.lsp_installer, {
	dockerls = "default",
})

add(g.treesitter.ensure_installed, {
	ft,
})
