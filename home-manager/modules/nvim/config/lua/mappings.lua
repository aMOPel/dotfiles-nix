-- stolen from mini.basics
DiagnosticToggle = {}
DiagnosticToggle.diagnostic_is_enabled = function(buf_id)
	return vim.diagnostic.is_enabled({ bufnr = buf_id })
end
DiagnosticToggle.buffer_diagnostic_state = {}
DiagnosticToggle.toggle_diagnostic = function()
	local buf_id = vim.api.nvim_get_current_buf()
	local is_enabled = DiagnosticToggle.diagnostic_is_enabled(buf_id)

	vim.diagnostic.enable(not is_enabled, { bufnr = buf_id })

	local new_buf_state = not is_enabled
	DiagnosticToggle.buffer_diagnostic_state[buf_id] = new_buf_state

	return new_buf_state and "  diagnostic" or "nodiagnostic"
end

-- akin to unimpaired mappings
vim.keymap.set(
	{ "n" },
	"yoe",
	DiagnosticToggle.toggle_diagnostic,
	{ desc = "toggle diagnostics" }
)

vim.keymap.set(
	{ "x" },
	"g/",
	"<esc>/\\%V",
	{ silent = false, desc = "Search inside visual selection" }
)

vim.keymap.set({ "n" }, "gp", '"`[" . strpart(getregtype(), 0, 1) . "`]"', {
	expr = true,
	replace_keycodes = false,
	desc = "Visually select changed text",
})

vim.keymap.set(
	{ "n" },
	"<C-S>",
	"<Cmd>silent! update | redraw<CR>",
	{ desc = "Save" }
)
vim.keymap.set(
	{ "i", "x" },
	"<C-S>",
	"<Esc><Cmd>silent! update | redraw<CR>",
	{ desc = "Save and go to Normal mode" }
)

vim.keymap.set(
	{ "n" },
	"<space><space>",
	"<cmd>b#<cr>",
	{ desc = "jump to alternative last edited" }
)

vim.keymap.set(
	{ "n" },
	"gf",
	[[<cmd>vertical wincmd f<cr>]],
	{ desc = "Open file under the cursor in a vsplit" }
)

vim.keymap.set({ "n" }, "ZZ", "<cmd>qa<cr>", { desc = "close all" })

vim.keymap.set(
	{ "n" },
	"<<",
	"<<_",
	{ desc = "Indent and jump to first non-blank character linewise" }
)
vim.keymap.set(
	{ "n" },
	">>",
	">>_",
	{ desc = "Indent and jump to first non-blank character linewise" }
)

vim.keymap.set(
	{ "n" },
	"sg",
	[[mz*:%s///g\|norm g`z<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]],
	{ desc = "Indent and jump to first non-blank character linewise" }
)

vim.keymap.set(
	{ "x" },
	"sg",
	[[:s//g<Left><Left>]],
	{ desc = "Indent and jump to first non-blank character linewise" }
)

vim.keymap.set({ "n" }, "<c-e>", [[:e ./<c-n>]], { desc = "quick file search" })

vim.keymap.set({ "n" }, "<c-b>", [[:b <c-n>]], { desc = "quick buffer search" })

vim.keymap.set(
	{ "t" },
	"<f11>",
	[[<c-\><c-n>]],
	{ desc = "<esc> in terminal mode" }
)

-- undopoints in insert mode
vim.keymap.set(
	{ "i" },
	"<space>",
	[[<c-g>u<space>]],
	{ desc = "undopoint in insert" }
)
vim.keymap.set({ "i" }, "{", [[<c-g>u{]], { desc = "undopoint in insert" })
vim.keymap.set({ "i" }, "[", [[<c-g>u[]], { desc = "undopoint in insert" })
vim.keymap.set({ "i" }, "(", [[<c-g>u(]], { desc = "undopoint in insert" })
vim.keymap.set({ "i" }, ",", [[<c-g>u,]], { desc = "undopoint in insert" })
vim.keymap.set({ "i" }, ".", [[<c-g>u.]], { desc = "undopoint in insert" })
vim.keymap.set(
	{ "i" },
	"<C-U>",
	[[<C-G>u<C-U>]],
	{ desc = "undopoint in insert" }
)
vim.keymap.set(
	{ "i" },
	"<C-W>",
	[[<C-G>u<C-W>]],
	{ desc = "undopoint in insert" }
)

-- tab control
vim.keymap.set({ "n" }, "<C-t>n", [[<cmd>tabnew<cr>]], { desc = "new tab" })
vim.keymap.set(
	{ "n" },
	"<C-t>o",
	[[<cmd>tabonly<cr>]],
	{ desc = "close all other tabs" }
)
vim.keymap.set({ "n" }, "<C-t>c", [[<cmd>tabclose<cr>]], { desc = "close tab" })
vim.keymap.set(
	{ "n" },
	"<C-t>l",
	[[<cmd>tabnext<cr>]],
	{ desc = "goto next tab" }
)
vim.keymap.set(
	{ "n" },
	"<C-t>t",
	[[<cmd>tabnext<cr>]],
	{ desc = "goto next tab" }
)
vim.keymap.set(
	{ "n" },
	"<C-t>h",
	[[<cmd>tabprevious<cr>]],
	{ desc = "goto prev tab" }
)
vim.keymap.set({ "n" }, "<C-t>L", [[<cmd>tabmove]], { desc = "move tab right" })
vim.keymap.set({ "n" }, "<C-t>H", [[<cmd>tabmove]], { desc = "move tab left" })
vim.keymap.set({ "n" }, "<C-t><c-n>", [[<cmd>tabnew<cr>]], { desc = "new tab" })
vim.keymap.set(
	{ "n" },
	"<C-t><c-o>",
	[[<cmd>tabonly<cr>]],
	{ desc = "close all other tabs" }
)
vim.keymap.set(
	{ "n" },
	"<C-t><c-c>",
	[[<cmd>tabclose<cr>]],
	{ desc = "close tab" }
)
vim.keymap.set(
	{ "n" },
	"<C-t><c-l>",
	[[<cmd>tabnext<cr>]],
	{ desc = "goto next tab" }
)
vim.keymap.set(
	{ "n" },
	"<C-t><c-t>",
	[[<cmd>tabnext<cr>]],
	{ desc = "goto next tab" }
)
vim.keymap.set(
	{ "n" },
	"<C-t><c-h>",
	[[<cmd>tabprevious<cr>]],
	{ desc = "goto prev tab" }
)

-- buffer control
vim.keymap.set(
	{ "n" },
	"<C-b>b",
	[[<cmd>bnext<CR>]],
	{ desc = "goto next buffer" }
)
vim.keymap.set(
	{ "n" },
	"<C-b>l",
	[[<cmd>bnext<CR>]],
	{ desc = "goto next buffer" }
)
vim.keymap.set(
	{ "n" },
	"<C-b>h",
	[[<cmd>bprevious<CR>]],
	{ desc = "goto prev buffer" }
)
vim.keymap.set(
	{ "n" },
	"<C-b>c",
	[[<cmd>bdelete<CR>]],
	{ desc = "delete buffer" }
)
vim.keymap.set(
	{ "n" },
	"<C-b>d",
	[[<cmd>bdelete<CR>]],
	{ desc = "delete buffer" }
)
vim.keymap.set(
	{ "n" },
	"<C-b><C-b>",
	[[<cmd>bnext<CR>]],
	{ desc = "goto next buffer" }
)
vim.keymap.set(
	{ "n" },
	"<C-b><C-l>",
	[[<cmd>bnext<CR>]],
	{ desc = "goto next buffer" }
)
vim.keymap.set(
	{ "n" },
	"<C-b><C-h>",
	[[<cmd>bprevious<CR>]],
	{ desc = "goto prev buffer" }
)
vim.keymap.set(
	{ "n" },
	"<C-b><C-c>",
	[[<cmd>bdelete<CR>]],
	{ desc = "delete buffer" }
)
vim.keymap.set(
	{ "n" },
	"<C-b><C-d>",
	[[<cmd>bdelete<CR>]],
	{ desc = "delete buffer" }
)
