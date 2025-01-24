local ft = "nim"

utils.addTable(g.lsp.fts, {
	ft,
	-- 'nims',
})

utils.addTable(g.lsp.servers.lsp_installer, {
	nim_langserver = "default",
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
