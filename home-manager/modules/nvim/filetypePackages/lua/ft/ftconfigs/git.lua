local ft = "gitcommit"

utils.addTable(g.linter.filetype, {
	[ft] = {
		"gitlint",
	},
})

utils.addTable(g.linter.custom_linter, {
	"",
})
