local ft = "*"

utils.addTable(g.formatter.filetype, {
	[ft] = {
		require("formatter.filetypes").any.remove_trailing_whitespace,
	},
})

utils.addTable(g.linter.filetype, {
	[ft] = { "editorconfig-checker" },
})

local util = require("formatter.util")
utils.addTable(g.formatter.filetype, {
	[ft] = {
		function()
			return {
				exe = "treefmt",
				args = {
					"--stdin",
					util.escape_path(util.get_current_buffer_file_name()),
				},
        no_append = true,
				stdin = true,
			}
		end,
	},
})
