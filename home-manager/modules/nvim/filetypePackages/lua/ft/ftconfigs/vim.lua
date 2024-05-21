ft = "vim"

-- utils.addTable(g.lsp.fts, {
-- 	ft,
-- })

-- utils.addTable(g.lsp.servers.lsp_installer, {
-- 	server_name = function(on_attach, capabilities) end,
-- })

-- utils.addTable(g.treesitter.highlight.disable, {
-- 	-- ft,
--   'help'
-- })

-- utils.addTable(g.formatter.filetype, {
-- 	[ft] = { require("formatter.filetypes")[ft].prettierd },
-- })

-- utils.addTable(g.formatter.on_save, {
-- 	"*." .. ft,
-- })

-- local configs = {}

-- configs[ft] = function()
-- 	local optl = vim.opt_local
-- end

-- vim.api.nvim_create_autocmd({ "Filetype" }, {
-- 	group = "MyFt",
-- 	pattern = { ft },
-- 	callback = configs[ft],
-- })
