local setup_dap = function()
	vim.keymap.set(
		"n",
		"<leader>db",
		"<cmd>DapToggleBreakpoint<cr>",
		{ desc = "dap toggle breakpoint" }
	)
	vim.keymap.set(
		"n",
		"<leader>dd",
		"<cmd>DapContinue<cr>",
		{ desc = "dap continue" }
	)
	vim.keymap.set(
		"n",
		"<leader>di",
		"<cmd>DapStepInto<cr>",
		{ desc = "dap step into" }
	)
	vim.keymap.set(
		"n",
		"<leader>do",
		"<cmd>DapStepOut<cr>",
		{ desc = "dap step out" }
	)
	vim.keymap.set(
		"n",
		"<leader>dt",
		"<cmd>DapTerminate<cr>",
		{ desc = "dap terminate" }
	)
	for filetype, callback in pairs(g.dap.filetype) do
		callback()
	end
end

local setup_dap_ui = function()
	local dap, dapui = require("dap"), require("dapui")
	dapui.setup()

	vim.keymap.set(
		"n",
		"<leader>du",
		[[<cmd>lua require("dapui").toggle()<cr>]],
		{ desc = "dap ui toggle" }
	)

	dap.listeners.after.event_initialized["dapui_config"] = function()
		dapui.open()
	end
	dap.listeners.before.event_terminated["dapui_config"] = function()
		dapui.close()
	end
	dap.listeners.before.event_exited["dapui_config"] = function()
		dapui.close()
	end
end

setup_dap()
setup_dap_ui()
