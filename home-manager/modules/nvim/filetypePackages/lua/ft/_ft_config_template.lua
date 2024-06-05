local ft = "filetype_name"

vim.tbl_deep_extend("force", g.lsp.fts, {
	ft,
})

vim.tbl_deep_extend("force", g.lsp.servers.lsp_installer, {
	-- server_name = function(on_attach, capabilities) end,
	server_name = "default",
})

vim.tbl_deep_extend("force", g.treesitter.indent.disable, {
	ft,
})

vim.tbl_deep_extend("force", g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].prettierd },
})

vim.tbl_deep_extend("force", g.formatter.on_save, {
	"*." .. ft,
})

vim.tbl_deep_extend("force", g.linter.filetype, {
	"",
})

vim.tbl_deep_extend("force", g.linter.custom_linter, {
	"",
})

vim.tbl_deep_extend("force", g.dap.filetype, {
	"",
})

local configs = {}

configs[ft] = function()
	local optl = vim.opt_local
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})
