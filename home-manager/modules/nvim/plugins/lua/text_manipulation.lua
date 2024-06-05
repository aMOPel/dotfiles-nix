plugins = g.plugins

table.insert(plugins, {
	name = "vim-yoink",
	setup = function()
		vim.g.yoinkAutoFormatPaste = 0
		vim.g.yoinkSavePersistently = 1
		vim.g.yoinkIncludeDeleteOperations = 1

		vim.keymap.set(
			"n",
			"<c-n>",
			"<plug>(YoinkPostPasteSwapBack)",
			{ desc = "cycle next register" }
		)
		vim.keymap.set(
			"n",
			"<c-p>",
			"<plug>(YoinkPostPasteSwapForward)",
			{ desc = "cycle prev register" }
		)
		vim.keymap.set("n", "p", "<plug>(YoinkPaste_p)", { desc = "paste" })
		vim.keymap.set(
			"n",
			"P",
			"<plug>(YoinkPaste_P)",
			{ desc = "paste before" }
		)
		vim.keymap.set(
			"n",
			"y",
			"<plug>(YoinkYankPreserveCursorPosition)",
			{ desc = "yank" }
		)
		vim.keymap.set(
			"x",
			"y",
			"<plug>(YoinkYankPreserveCursorPosition)",
			{ desc = "yank" }
		)
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "vim-subversive",
	setup = function()
		vim.g.subversivePromptWithCurrent = 0
		vim.g.subversiveCurrentTextRegister = "r"
		vim.g.subversivePromptWithActualCommand = 1
		vim.g.subversivePreserveCursorPosition = 1

		vim.keymap.set(
			{ "n", "x" },
			"S",
			"<plug>(SubversiveSubstitute)",
			{ desc = "substitute with register" }
		)
		vim.keymap.set(
			"n",
			"SS",
			"<plug>(SubversiveSubstituteLine)",
			{ desc = "substitute whole line" }
		)
		vim.keymap.set(
			"x",
			"P",
			"<plug>(SubversiveSubstitute)",
			{ desc = "substitute with register" }
		)
		vim.keymap.set(
			"x",
			"p",
			"<plug>(SubversiveSubstitute)",
			{ desc = "substitute with register" }
		)

		vim.keymap.set(
			{ "n", "x" },
			"R",
			"<plug>(SubversiveSubvertRange)",
			{ desc = "camel case word forward" }
		)
		vim.keymap.set(
			"n",
			"RR",
			"<plug>(SubversiveSubvertWordRange)",
			{ desc = "camel case word forward" }
		)
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "CamelCaseMotion",
	setup = function()
		vim.keymap.set(
			{ "n", "x" },
			"gw",
			"<Plug>CamelCaseMotion_w",
			{ desc = "camel case word forward" }
		)
		vim.keymap.set(
			{ "n", "x" },
			"gb",
			"<Plug>CamelCaseMotion_b",
			{ desc = "camel case word backward" }
		)
		vim.keymap.set(
			{ "n", "x" },
			"ge",
			"<Plug>CamelCaseMotion_e",
			{ desc = "camel case word end" }
		)
		vim.keymap.set(
			{ "x", "o" },
			"igw",
			"<Plug>CamelCaseMotion_iw",
			{ desc = "inside camel case word" }
		)
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "dial.nvim",
	setup = function() end,
	config = function()
		local augend = require("dial.augend")

		require("dial.config").augends:register_group({
			default = {
				augend.integer.alias.decimal,
				augend.integer.alias.hex,
				augend.integer.alias.octal,
				augend.integer.alias.binary,
				augend.constant.alias.alpha,
				augend.constant.alias.Alpha,
				augend.constant.alias.bool,
				augend.semver.alias.semver,
				augend.date.alias["%Y/%m/%d"],
				augend.date.alias["%m/%d/%Y"],
				augend.date.alias["%d/%m/%Y"],
				augend.date.alias["%m/%d/%y"],
				augend.date.alias["%d/%m/%y"],
				augend.date.alias["%m/%d"],
				augend.date.alias["%-m/%-d"],
				augend.date.alias["%Y-%m-%d"],
				augend.date.alias["%H:%M:%S"],
				augend.date.alias["%H:%M"],
				augend.hexcolor.new({
					case = "lower",
				}),
				augend.constant.new({
					elements = { "&&", "||" },
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = { "!=", "==" },
					word = false,
					cyclic = true,
				}),
				augend.constant.new({
					elements = {
						"TODO",
						"DONE",
						"HACK",
						"FIX",
						"WARN",
						"PERF",
						"NOTE",
						"TEST",
					},
					word = true,
					cyclic = true,
				}),
				augend.constant.new({
					elements = {
						"pick",
						"fixup",
						"reword",
						"edit",
						"squash",
						"exec",
						"break",
						"drop",
						"label",
						"reset",
						"merge",
					},
					word = true,
					cyclic = true,
				}),
			},
		})

		vim.keymap.set("n", "<C-a>", function()
			require("dial.map").manipulate("increment", "normal")
		end, { desc = "dial increment" })
		vim.keymap.set("n", "<C-x>", function()
			require("dial.map").manipulate("decrement", "normal")
		end, { desc = "dial decrement" })
		vim.keymap.set("n", "g<C-a>", function()
			require("dial.map").manipulate("increment", "gnormal")
		end, { desc = "dial increment" })
		vim.keymap.set("n", "g<C-x>", function()
			require("dial.map").manipulate("decrement", "gnormal")
		end, { desc = "dial decrement" })
		vim.keymap.set("v", "<C-a>", function()
			require("dial.map").manipulate("increment", "visual")
		end, { desc = "dial increment" })
		vim.keymap.set("v", "<C-x>", function()
			require("dial.map").manipulate("decrement", "visual")
		end, { desc = "dial decrement" })
		vim.keymap.set("v", "g<C-a>", function()
			require("dial.map").manipulate("increment", "gvisual")
		end, { desc = "dial increment" })
		vim.keymap.set("v", "g<C-x>", function()
			require("dial.map").manipulate("decrement", "gvisual")
		end, { desc = "dial decrement" })
	end,
})

table.insert(plugins, {
	name = "sideways.vim",
	setup = function()
		vim.keymap.set(
			"n",
			"<left>",
			"<cmd>SidewaysLeft<cr>",
			{ desc = "move list element left" }
		)
		vim.keymap.set(
			"n",
			"<right>",
			"<cmd>SidewaysRight<cr>",
			{ desc = "move list element right" }
		)
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "mini.ai",
	setup = function() end,
	config = function()
		local gen_ai_spec = require("mini.extra").gen_ai_spec

		local spec_treesitter = require("mini.ai").gen_spec.treesitter
		require("mini.ai").setup({
			custom_textobjects = {
				e = gen_ai_spec.buffer(),
				d = gen_ai_spec.diagnostic(),
				i = gen_ai_spec.indent(),
			},
			mappings = {
				around = "a",
				inside = "i",
				around_next = "",
				inside_next = "",
				around_last = "",
				inside_last = "",
				goto_left = "",
				goto_right = "",
			},
			n_lines = 50,
			search_method = "cover_or_nearest",
			a = spec_treesitter({
				a = "@parameter.outer",
				i = "@parameter.inner",
			}),
			c = spec_treesitter({ a = "@comment.outer", i = "@comment.inner" }),
			f = spec_treesitter({
				a = "@function.outer",
				i = "@function.inner",
			}),
			-- "@assignment.inner",
			-- "@assignment.outer",
			-- @loop.inner
			-- @loop.outer
			-- @block.inner
			-- @block.outer
			-- @call.inner
			-- @call.outer
			-- @assignment.inner
			-- @assignment.outer
			-- "@assignment.rhs",
			-- "@assignment.lhs",
			-- "@return.inner",
			-- "@return.outer",
			-- "@statement.outer",
			-- "@number.inner",
		})
	end,
})

table.insert(plugins, {
	name = "mini.move",
	setup = function() end,
	config = function()
		require("mini.move").setup({
			mappings = {
				left = "<left>",
				right = "<right>",
				down = "<down>",
				up = "<up>",
				line_left = "",
				line_right = "",
				line_down = "<down>",
				line_up = "<up>",
			},
			options = {
				reindent_linewise = true,
			},
		})
	end,
})

table.insert(plugins, {
	name = "mini.operators",
	setup = function() end,
	config = function()
		require("mini.operators").setup({
			evaluate = { prefix = "" },
			exchange = {
				prefix = "gx",
				reindent_linewise = true,
			},
			multiply = { prefix = "" },
			replace = { prefix = "" },
			sort = {
				prefix = "go",
				func = nil,
			},
		})
	end,
})

table.insert(plugins, {
	name = "mini.align",
	setup = function() end,
	config = function()
		require("mini.align").setup({
			mappings = {
				start = "",
				start_with_preview = "ga",
			},
		})
	end,
})

table.insert(plugins, {
	name = "mini.splitjoin",
	setup = function() end,
	config = function()
		local mini_splitjoin = require("mini.splitjoin")
		mini_splitjoin.setup({
			mappings = {
				toggle = "gj",
			},
			split = {
				hooks_post = {
					mini_splitjoin.gen_hook.add_trailing_separator({
						brackets = { "%b[]" },
					}),
				},
			},
			join = {
				hooks_post = {
					mini_splitjoin.gen_hook.del_trailing_separator(),
				},
			},
		})
	end,
})

table.insert(plugins, {
	name = "mini.surround",
	setup = function() end,
	config = function()
		require("mini.surround").setup({
			mappings = {
				add = "gs",
				delete = "ds",
				find = "",
				find_left = "",
				highlight = "",
				replace = "cs",
				update_n_lines = "",

				suffix_last = "",
				suffix_next = "",
			},
			search_method = "cover_or_next",
		})

		vim.keymap.set(
			"n",
			"yss",
			"gs_",
			{ remap = true, desc = "surround whole line" }
		)
	end,
})
