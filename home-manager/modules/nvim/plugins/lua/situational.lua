plugins = g.plugins

table.insert(plugins, {
	name = "toggleterm.nvim",
	setup = function() end,
	config = function()
		local function rh(height)
			return math.floor(height * vim.o.lines)
		end
		local function rw(width)
			return math.floor(width * vim.o.columns)
		end

		require("toggleterm").setup({
			open_mapping = [[<leader>ff]],
			insert_mappings = false,
			terminal_mappings = false,
			shell = "$SHELL",
			direction = "float",
			float_opts = {
				width = rw(0.9),
				height = rh(0.9),
			},
			on_open = function(term)
				vim.cmd("startinsert!")
			end,
		})

		vim.keymap.set("n", "<leader>fs", "<cmd>TermSelect<cr>", {
			desc = "select terminal",
		})

		-- TERMIAL WINDOW KEYMAPS
		function set_terminal_keymaps()
			local opts = { buffer = 0 }
			vim.keymap.set("t", "<f11>", [[<C-\><C-n>]], opts)
			vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
		end

		vim.api.nvim_create_autocmd({ "TermOpen" }, {
			group = "MyAutoCmd",
			pattern = { "term://*toggleterm#*" },
			callback = function(ev)
				set_terminal_keymaps()
			end,
			desc = "set window keymaps in toggle term",
		})

		function setup_tui(cmd, lhs)
			local Terminal = require("toggleterm.terminal").Terminal
			local tui = Terminal:new({
				cmd = cmd,
				hidden = true,
				direction = "float",
				float_opts = {
					width = rw(1.0),
					height = rh(1.0),
				},
			})
			vim.keymap.set("n", lhs, function()
				tui:toggle()
			end, {
				noremap = true,
				silent = true,
				desc = "toggle " .. cmd .. " floating terminal",
			})
		end

		-- TUIs
		setup_tui("lazygit", "<leader>fg")
		setup_tui("taskwarrior-tui", "<leader>ft")
	end,
})

table.insert(plugins, {
	name = "vim-grepper",
	setup = function()
		vim.keymap.set(
			"n",
			"<c-f>",
			"<cmd>Grepper -tool rg<CR>",
			{ desc = "ripgrep" }
		)

		vim.cmd([[
aug Grepper
  au!
  au User Grepper ++nested call setqflist([], 'r', {'context': {'bqf': {'pattern_hl': '\%#' . getreg('/')}}})
aug END
]])

		vim.g.grepper = {
			open = 1,
			prompt_quote = 1,
			simple_prompt = 1,
			switch = 1,
			quickfix = 1,
			searchreg = 1,
			highlight = 1,
			dir = "cwd",
			tools = { "rg" },
			rg = {
				grepprg = "rg -H --no-heading --vimgrep --smart-case --follow --",
			},
		}
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "vim-fugitive",
	setup = function()
		vim.keymap.set(
			"n",
			"<leader>gg",
			"<cmd>-tabnew<cr><cmd>Git ++curwin<CR>",
			{ desc = "open fugitive status" }
		)
		vim.keymap.set(
			"n",
			"<leader>gl",
			"<cmd>-tabnew<cr><cmd>Gclog <CR>",
			{ desc = "open fugitive log" }
		)
		vim.keymap.set(
			"n",
			"<leader>gd",
			"<cmd>-tabnew %<cr><cmd>Gdiffsplit! <cr>",
			{ desc = "open fugitive diff split" }
		)
		vim.keymap.set(
			"n",
			"<leader>go",
			"<cmd>Gedit :(top)%",
			{ desc = "open current file (which is somewhere in git history) in worktree" }
		)

		vim.api.nvim_create_autocmd({ "FileType" }, {
			group = "MyAutoCmd",
			pattern = { "fugitive" },
			callback = function(ev)
				vim.keymap.set(
					"n",
					"dt",
					[["zyiw:<c-u>Git difftool -y <c-r>z^...<c-r>z<cr>]],
					{
						desc = "open tab for every file that changed in the commit under the cursor",
						buffer = true,
						silent = true,
						noremap = true,
					}
				)
			end,
			desc = "set keymaps in fugitive window",
		})
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "yazi.nvivm",
	setup = function()
		vim.keymap.set(
			{ "n", "v" },
			"-",
			"<cmd>Yazi<cr>",
			{ desc = "Open yazi at the current file" }
		)
		vim.keymap.set(
			{ "n", "v" },
			"+",
			"<cmd>Yazi toggle<cr>",
			{ desc = "Resume the last yazi session" }
		)
	end,
	config = function()
		require("yazi").setup({
			open_for_directories = true,
			keymaps = {
				open_file_in_vertical_split = "<c-y><c-v>",
				open_file_in_horizontal_split = false,
				open_file_in_tab = "<c-y><c-t>",
        send_to_quickfix_list = "<c-y><c-q>",
        show_help = false,
				grep_in_directory = false,
				replace_in_directory = false,
				cycle_open_buffers = false,
				copy_relative_path_to_selected_files = false,
				change_working_directory = "<c-y><c-g>",
			},
		})
	end,
})

table.insert(plugins, {
	name = "todo-comments.nvim",
	setup = function() end,
	config = function()
		require("todo-comments").setup({
			keywords = {
				DONE = { icon = " ", color = "done" },
				TODO = { icon = " ", color = "info" },
			},
			colors = {
				done = { "#84da94" },
			},
		})
	end,
})

table.insert(plugins, {
	name = "qf.nvim",
	setup = function()
		vim.keymap.set("n", "Q", function()
			require("qf").toggle("c", false)
		end, { desc = "toggle quickfix list" })
	end,
	config = function()
		require("qf").setup({
			l = {},
			c = {
				wide = true,
			},
			close_other = true,
			pretty = true,
		})
	end,
})

table.insert(plugins, {
	name = "dressing.nvim",
	setup = function() end,
	config = function()
		require("dressing").setup()
	end,
})
