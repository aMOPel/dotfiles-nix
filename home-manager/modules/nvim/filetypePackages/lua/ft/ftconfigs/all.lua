local ft = "*"

utils.addTable(g.formatter.filetype, {
	[ft] = {
		require("formatter.filetypes").any.remove_trailing_whitespace,
	},
})

utils.addTable(g.linter.filetype, {
	[ft] = { "editorconfig-checker" },
})
