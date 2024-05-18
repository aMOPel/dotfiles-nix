local g = require("globals")
local add = require("utils").addTable

local ft = "nix"

add(g.lsp.fts, {
	ft,
})

add(g.lsp.servers.other, {
	-- server_name = function(on_attach, capabilities) end,
	nixd = "default",
})

add(g.treesitter.indent.disable, {
	ft,
})

add(g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].nixpkgs_fmt },
})

add(g.formatter.on_save, {
	"*." .. ft,
})

add(g.linter.filetype, {
	[ft] = { "nix", "deadnix" },
})

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
