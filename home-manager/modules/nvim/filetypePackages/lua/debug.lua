local setup_dap = function()
	utils.noremap("n", "<leader>db", ":DapToggleBreakpoint<cr>")
	utils.noremap("n", "<leader>dd", ":DapContinue<cr>")
	utils.noremap("n", "<leader>di", ":DapStepInto<cr>")
	utils.noremap("n", "<leader>do", ":DapStepOut<cr>")
	utils.noremap("n", "<leader>dt", ":DapTerminate<cr>")
	for filetype, callback in pairs(g.dap.filetype) do
		callback()
	end
end

local setup_dap_ui = function()
	local dap, dapui = require("dap"), require("dapui")
	dapui.setup()

	utils.noremap("n", "<leader>du", [[:lua require("dapui").toggle()<cr>]])

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

local setup_dap_go = function()
	require("dap-go").setup()
end

setup_dap()
setup_dap_ui()
setup_dap_go()
