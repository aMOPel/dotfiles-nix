local ft = "nim"

vim.tbl_deep_extend("force", g.lsp.fts, {
	ft,
	-- 'nims',
})

vim.tbl_deep_extend("force", g.lsp.servers.lsp_installer, {
	nim_langserver = "default",
})

vim.tbl_deep_extend("force", g.treesitter.indent.disable, {
	ft,
})

vim.tbl_deep_extend("force", g.formatter.filetype, {
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
