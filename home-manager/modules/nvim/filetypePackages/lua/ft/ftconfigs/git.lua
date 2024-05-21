ft = "gitcommit"

-- utils.addTable(g.lsp.fts, {
-- 	ft,
-- })

-- utils.addTable(g.lsp.servers.lsp_installer, {
-- 	-- server_name = function(on_attach, capabilities) end,
-- 	server_name = "default",
-- })

-- utils.addTable(g.treesitter.indent.disable, {
-- 	ft,
-- })

-- utils.addTable(g.formatter.filetype, {
-- 	[ft] = { require("formatter.filetypes")[ft].prettierd },
-- })

-- utils.addTable(g.formatter.on_save, {
-- 	"*." .. ft,
-- })

utils.addTable(g.linter.filetype, {
	[ft] = {
		"gitlint",
	},
})

utils.addTable(g.linter.custom_linter, {
	"",
})

-- utils.addTable(g.dap.filetype, {
-- 	"",
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
