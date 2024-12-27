local ft = "cpp"

utils.addTable(g.lsp.fts, {
	"c",
	"cpp",
})

utils.addTable(g.lsp.servers.lsp_installer, {
	clangd = "default",
})

utils.addTable(g.linter.filetype, {
	[ft] = { "cppcheck", "cpplint" },
})

utils.addTable(g.formatter.filetype, {
	[ft] = { require("formatter.filetypes")[ft].clangformat },
})

utils.addTable(g.dap.filetype, {
	[ft] = function()
		local dap = require("dap")
		dap.adapters.gdb = {
			type = "executable",
			command = "gdb",
			args = {
				"--interpreter=dap",
				"--eval-command",
				"set print pretty on",
			},
		}

		dap.configurations.cpp = {
			{
				name = "fantom",
				type = "gdb",
				request = "launch",
				program = function()
					return vim.fn.input(
						"Path to executable: ",
						vim.fn.getcwd() .. "/../install/bin/fantom"
					)
				end,
				cwd = "${workspaceFolder}",
				stopAtBeginningOfMainSubprogram = false,
			},
		}
	end,
})
