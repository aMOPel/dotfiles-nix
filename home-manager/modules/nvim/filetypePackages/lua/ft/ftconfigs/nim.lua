ft = "nim"

utils.addTable(g.lsp.fts, {
	ft,
	-- 'nims',
})

-- utils.addTable(g.lsp.servers.lsp_installer, {
-- 	nimls = "default",
-- })

utils.addTable(g.lsp.servers.lsp_installer, {
	nim_langserver = "default",
})

utils.addTable(g.treesitter.indent.disable, {
	ft,
})

utils.addTable(g.formatter.filetype, {
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

-- utils.addTable(g.formatter.on_save, {
-- 	"*." .. ft,
-- })

local configs = {}

configs[ft] = function() end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})
