local g = require("globals")
local add = require("utils").addTable

local ft = "toml"

add(g.lsp.fts, {
	ft,
})

-- add(g.lsp.servers.lsp_installer, {
--   'taplo',
-- })

add(g.treesitter.ensure_installed, {
	ft,
})

-- add(g.formatter.filetype, {
-- 	[ft] = { require("formatter.filetypes")[ft].taplo },
-- })
--
-- add(g.formatter.on_save, {
--  "*." .. ft,
-- })
