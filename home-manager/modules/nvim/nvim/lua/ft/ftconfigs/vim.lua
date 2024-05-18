local g = require("globals")
local add = require("utils").addTable

local ft = "vim"

-- add(g.lsp.fts, {
-- 	ft,
-- })

-- add(g.lsp.servers.lsp_installer, {
-- 	server_name = function(on_attach, capabilities) end,
-- })

-- add(g.treesitter.highlight.disable, {
-- 	-- ft,
--   'help'
-- })

add(g.treesitter.ensure_installed, {
	ft,
	"vimdoc",
})

-- add(g.formatter.ensure_installed, {
-- 	"prettierd",
-- })

-- add(g.formatter.filetype, {
-- 	[ft] = { require("formatter.filetypes")[ft].prettierd },
-- })

-- add(g.formatter.on_save, {
-- 	"*." .. ft,
-- })

-- local configs = {}

-- configs[ft] = function()
-- 	local optl = vim.opt_local
-- 	local noremap = require("utils").noremap_buffer
-- end

-- vim.api.nvim_create_autocmd({ "Filetype" }, {
-- 	group = "MyFt",
-- 	pattern = { ft },
-- 	callback = configs[ft],
-- })
