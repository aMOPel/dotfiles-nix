local g = require("globals")
local add = require("utils").addTable

local ft = "nim"

add(g.lsp.fts, {
	ft,
	-- 'nims',
})

-- add(g.lsp.servers.lsp_installer, {
-- 	nimls = "default",
-- })

add(g.lsp.servers.other, {
	nim_langserver = "default",
})

add(g.treesitter.ensure_installed, {
	ft,
	"nim_format_string",
})

add(g.treesitter.indent.disable, {
	ft,
})

add(g.formatter.filetype, {
	[ft] = function()
		return {
			exe = "nimpretty",
			args = {
				vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
			},
			stdin = false,
		}
	end,
})

-- add(g.formatter.on_save, {
-- 	"*." .. ft,
-- })

local configs = {}

configs[ft] = function() end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})
