local ft = "gdscript"

vim.tbl_deep_extend("force", g.lsp.fts, {
	ft,
})

vim.tbl_deep_extend("force", g.lsp.servers.lsp_installer, {
	gdscript = "default",
})

vim.tbl_deep_extend("force", g.treesitter.indent.disable, {
	ft,
})

vim.tbl_deep_extend("force", g.formatter.filetype, {
	[ft] = {
		function()
			return {
				exe = "gdformat",
				args = {
					"--line-length=80",
				},
			}
		end,
	},
})

vim.tbl_deep_extend("force", g.formatter.on_save, {
	"*.gd",
})

vim.tbl_deep_extend("force", g.linter.filetype, {
	[ft] = { "gdlint" },
})

vim.tbl_deep_extend("force", g.dap.filetype, {
	[ft] = function()
		local dap = require("dap")
		dap.adapters.godot = {
			type = "server",
			host = "127.0.0.1",
			port = 6006,
		}
		dap.configurations.gdscript = {
			{
				type = "godot",
				request = "launch",
				name = "Launch scene",
				project = "${workspaceFolder}",
				launch_scene = true,
			},
		}
	end,
})

local configs = {}

configs[ft] = function()
	local optl = vim.opt_local

	-- gdscript styleguide
	optl.fileformat = "unix"
	optl.fixendofline = true
	optl.fileencoding = "utf-8"
	optl.expandtab = false

	optl.tabstop = 2
	optl.shiftwidth = 2
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})
