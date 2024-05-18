local g = require("globals")
local add = require("utils").addTable

local ft = "python"

add(g.lsp.fts, {
	ft,
})

add(g.lsp.servers.lsp_installer, {
	pylsp = "default",
})

add(g.treesitter.ensure_installed, {
	ft,
	"requirements",
})

add(g.treesitter.indent.disable, {
	ft,
})

add(g.formatter.ensure_installed, {
	"black",
	"isort",
})

add(g.formatter.filetype, {
	[ft] = {
		require("formatter.filetypes")[ft].black,
		require("formatter.filetypes")[ft].isort,
	},
})

add(g.formatter.on_save, {
	"*." .. ft,
})

local configs = {}

configs[ft] = function()
	local optl = vim.opt_local
	local noremap = require("utils").noremap_buffer
	optl.foldmethod = "indent"
	-- " setl foldexpr=nvim#treesitter#foldexpr()
	noremap(
		"n",
		"<leader>n",
		':exec "FloatermNew --autoclose=0 --disposable python3 " . resolve(expand("%:p")) <CR>'
	)
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})
