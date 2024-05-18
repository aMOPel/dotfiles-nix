local g = require("globals")
local add = require("utils").addTable

local ft = "gdscript"

add(g.lsp.fts, {
	ft,
})

add(g.lsp.servers.other, {
	gdscript = "default",
})

add(g.treesitter.ensure_installed, {
	ft,
	"godot_resource",
})

add(g.treesitter.indent.disable, {
	ft,
})

add(g.formatter.ensure_installed, {
	"gdtoolkit",
})

add(g.formatter.filetype, {
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

add(g.formatter.on_save, {
	"*.gd",
})

add(g.linter.ensure_installed, {
	"gdtoolkit",
})

add(g.linter.filetype, {
	[ft] = { "gdlint" },
})

add(g.dap.filetype, {
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
	local noremap = require("utils").noremap_buffer

	-- gdscript styleguide
	optl.fileformat = "unix"
	optl.fixendofline = true
	optl.fileencoding = "utf-8"
	optl.expandtab = false

	optl.tabstop = 2
	optl.shiftwidth = 2

	optl.makeprg = "godot --headless --script %"
	-- noremap('n', '<leader>lf', ':exec "!gdformat -l 80 "  .  resolve(expand("%:p"))<cr>')
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})
