ft = "nix"

utils.addTable(g.lsp.fts, {
	ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
	-- server_name = function(on_attach, capabilities) end,
	nixd = "default",
})

utils.addTable(g.treesitter.indent.disable, {
	ft,
})

utils.addTable(g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].nixpkgs_fmt },
})

utils.addTable(g.formatter.on_save, {
	"*." .. ft,
})

utils.addTable(g.linter.filetype, {
	[ft] = { "nix", "deadnix" },
})

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
