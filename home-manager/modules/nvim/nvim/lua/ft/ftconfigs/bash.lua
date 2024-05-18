local g = require("globals")
local add = require("utils").addTable

local ft = "sh"

add(g.lsp.fts, {
	ft,
})

add(g.lsp.servers.lsp_installer, {
	bashls = "default",
})

add(g.treesitter.ensure_installed, {
	"bash",
})

local configs = {}

configs[ft] = function()
	local optl = vim.opt_local
	local noremap = require("utils").noremap_buffer
	noremap(
		"n",
		"<leader>n",
		':exec "FloatermNew --disposable --width=0.95 --height=0.95 " . resolve(expand("%:p")) <CR>'
	)
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})
