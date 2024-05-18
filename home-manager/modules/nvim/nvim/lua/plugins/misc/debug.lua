local plugins = require("globals").plugins

table.insert(plugins, {
	name = "dap",
	setup = function()
		local noremap = require("utils").noremap
		noremap("n", "<leader>db", ":DapToggleBreakpoint<cr>")
		noremap("n", "<leader>dd", ":DapContinue<cr>")
		noremap("n", "<leader>di", ":DapStepInto<cr>")
		noremap("n", "<leader>do", ":DapStepOut<cr>")
		noremap("n", "<leader>dt", ":DapTerminate<cr>")
	end,
	config = function()
		local g = require("globals")
		for filetype, callback in pairs(g.dap.filetype) do
			callback()
		end
	end,
})

table.insert(plugins, {
	name = "dap-ui",
	setup = function() end,
	config = function()
		local dap, dapui = require("dap"), require("dapui")
		dapui.setup()

		local noremap = require("utils").noremap
		noremap("n", "<leader>du", [[:lua require("dapui").toggle()<cr>]])

		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = function()
			dapui.close()
		end
		dap.listeners.before.event_exited["dapui_config"] = function()
			dapui.close()
		end
	end,
})

table.insert(plugins, {
	name = "nvim-dap-go",
	setup = function() end,
	config = function()
		require("dap-go").setup()
	end,
})


local p = require("utils").p

local M = function(use)
	use({
		p("https://github.com/mfussenegger/nvim-dap"),
	})
	use({
		p("https://github.com/rcarriga/nvim-dap-ui"),
		require = {
			p("https://github.com/mfussenegger/nvim-dap"),
		},
	})

	use({
		p("https://github.com/leoluz/nvim-dap-go"),
		requires = { p("https://github.com/mfussenegger/nvim-dap") },
	})

end
return M
