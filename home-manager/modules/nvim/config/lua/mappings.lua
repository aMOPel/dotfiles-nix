-- stolen from mini.basics
PutEmptyLine = {}
PutEmptyLine.put_empty_line = function(put_above)
	-- This has a typical workflow for enabling dot-repeat:
	-- - On first call it sets `operatorfunc`, caches data, and calls
	--   `operatorfunc` on current cursor position.
	-- - On second call it performs task: puts `v:count1` empty lines
	--   above/below current line.
	if type(put_above) == "boolean" then
		vim.o.operatorfunc = "v:lua.PutEmptyLine.put_empty_line"
		PutEmptyLine.cache_empty_line = { put_above = put_above }
		return "g@l"
	end

	local target_line = vim.fn.line(".")
		- (PutEmptyLine.cache_empty_line.put_above and 1 or 0)
	vim.fn.append(target_line, vim.fn["repeat"]({ "" }, vim.v.count1))
end
_G.PutEmptyLine = PutEmptyLine

vim.keymap.set(
	{ "n" },
	"[ ",
	"v:lua.PutEmptyLine.put_empty_line(v:true)",
	{ expr = true, desc = "Put empty line above" }
)
vim.keymap.set(
	{ "n" },
	"] ",
	"v:lua.PutEmptyLine.put_empty_line(v:false)",
	{ expr = true, desc = "Put empty line below" }
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
	"<leader>sg",
	[[mz*:%s///g|norm g`z<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]],
	{ desc = "Quick substitute whole file" }
)

vim.keymap.set(
	{ "x" },
	"<leader>sg",
	[[:s//g<Left><Left>]],
	{ desc = "Quick substitute within selected area" }
)

vim.keymap.set({ "n" }, "<c-e>", [[:e ./<c-n>]], { desc = "quick file search" })

vim.keymap.set({ "n" }, "<c-q>", [[:b <c-n>]], { desc = "quick buffer search" })

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

vim.keymap.set({ "n" }, "yoD", function()
	if vim.o.diff then
		vim.cmd([[diffoff]])
		return
	end
	vim.cmd([[diffthis]])
end, { desc = "toggle diff" })
