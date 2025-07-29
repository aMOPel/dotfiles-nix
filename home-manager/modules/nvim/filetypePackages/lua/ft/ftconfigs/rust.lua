local ft = "rust"

utils.addTable(g.lsp.fts, {
	ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
	rust_analyzer = "default",
})

-- utils.addTable(g.dap.filetype, {
-- 	"",
-- })

-- local configs = {}
--
-- configs[ft] = function()
-- 	local optl = vim.opt_local
-- end
--
-- vim.api.nvim_create_autocmd({ "Filetype" }, {
-- 	group = "MyFt",
-- 	pattern = { ft },
-- 	callback = configs[ft],
-- })
