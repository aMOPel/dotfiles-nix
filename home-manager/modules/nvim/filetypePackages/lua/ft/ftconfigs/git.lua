local ft = "gitcommit"

vim.tbl_deep_extend("force", g.linter.filetype, {
	[ft] = {
		"gitlint",
	},
})

vim.tbl_deep_extend("force", g.linter.custom_linter, {
	"",
})
