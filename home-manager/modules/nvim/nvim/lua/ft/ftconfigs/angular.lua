local g = require("globals")
local add = require("utils").addTable

-- local ft = "filetype_name"

-- add(g.lsp.fts, {
-- 	ft,
-- })

add(g.lsp.servers.lsp_installer, {
	angularls = "default",
})

-- add(g.treesitter.ensure_installed, {
-- 	ft,
-- })
--
-- add(g.formatter.ensure_installed, {
-- 	"prettierd",
-- })
--
-- add(g.formatter.filetype, {
-- 	[ft] = { require("formatter.filetypes")[ft].prettierd },
-- })
--
-- add(g.formatter.on_save, {
-- 	"*." .. ft,
-- })
--
-- local configs = {}
--
-- configs[ft] = function()
-- 	local optl = vim.opt_local
-- 	local noremap = require("utils").noremap_buffer
-- end
--
-- vim.api.nvim_create_autocmd({ "Filetype" }, {
-- 	group = "MyFt",
-- 	pattern = { ft },
-- 	callback = configs[ft],
-- })
