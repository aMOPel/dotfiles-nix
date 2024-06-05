plugins = g.plugins

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
				line_left = "<left>",
				line_right = "<right>",
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
			evaluate = {},
			exchange = {
				prefix = "gx",
				reindent_linewise = true,
			},
			multiply = {},
			replace = {
				prefix = "S",
				reindent_linewise = true,
			},
			sort = {
				prefix = "gs",
				func = nil,
			},
		})
	end,
})

table.insert(plugins, {
	name = "vim-yoink",
	setup = function()
		vim.g.yoinkAutoFormatPaste = 0
		vim.g.yoinkSavePersistently = 1
		vim.g.yoinkIncludeDeleteOperations = 1

		local map = utils.map
		map("n", "<c-n>", "<plug>(YoinkPostPasteSwapBack)")
		map("n", "<c-p>", "<plug>(YoinkPostPasteSwapForward)")
		map("n", "p", "<plug>(YoinkPaste_p)")
		map("n", "P", "<plug>(YoinkPaste_P)")
		map("n", "[y", "<plug>(YoinkRotateBack)")
		map("n", "]y", "<plug>(YoinkRotateForward)")
		map("n", "y", "<plug>(YoinkYankPreserveCursorPosition)")
		map("x", "y", "<plug>(YoinkYankPreserveCursorPosition)")
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

		local map = utils.map

		map("x", "P", "<plug>(SubversiveSubstitute)")
		map("x", "p", "<plug>(SubversiveSubstitute)")

		local noremap = utils.noremap
		noremap("n", "R", "<plug>(SubversiveSubvertRange)")
		noremap("x", "R", "<plug>(SubversiveSubvertRange)")
		noremap("n", "RR", "<plug>(SubversiveSubvertWordRange)")
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
	name = "CamelCaseMotion",
	setup = function()
		-- vim.g.camelcasemotion_key = ','
		local map = utils.map
		map("", "gw", "<Plug>CamelCaseMotion_w")
		map("", "gb", "<Plug>CamelCaseMotion_b")
		map("", "ge", "<Plug>CamelCaseMotion_e")
		map({ "x", "o" }, "igw", "<Plug>CamelCaseMotion_iw")
		map({ "x", "o" }, "igb", "<Plug>CamelCaseMotion_ib")
		map({ "x", "o" }, "ige", "<Plug>CamelCaseMotion_ie")
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "vim-log-print",
	setup = function()
		vim.g["log_print#default_mappings"] = 0

		vim.g["log_print#languages"] = {
			gdscript = { pre = "print(", post = ")" },
			typescript = { pre = "console.log(", post = ")" },
			sh = { pre = "echo " },
			nim = { pre = "print " },
		}

		local map = utils.map
		map("n", "gl", "<Plug>LogPrintToggle")
		map("n", "[g", "<Plug>LogPrintAbove")
		map("n", "]g", "<Plug>LogPrintBelow")
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "textobj-word-column.vim",
	setup = function()
		vim.g.textobj_wordcolumn_no_default_key_mappings = 1

		vim.fn["textobj#user#map"]("wordcolumn", {
			word = {
				["select-i"] = "io",
				["select-a"] = "ao",
			},
			WORD = {
				["select-i"] = "iO",
				["select-a"] = "aO",
			},
		})
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "dial.nvim",
	setup = function() end,
	config = function()
		local augend = require("dial.augend")
		local augend_leftright = augend.constant.new({
			elements = { "left", "right" },
			word = false,
			cyclic = true,
			preserve_case = true,
		})
		local augend_onoff = augend.constant.new({
			elements = { "on", "off" },
			word = false,
			cyclic = true,
			preserve_case = true,
		})

		require("dial.config").augends:register_group({
			default = {
				-- this disables the jumping for leftright and onoff
				augend.user.new({
					find = function(line, cursor)
						local range = augend_leftright:find(line, cursor)
						if range ~= nil then
							if range.from <= cursor and cursor <= range.to then
								return range
							end
						end
						return nil
					end,
					add = function(text, addend, cursor)
						return augend_leftright:add(text, addend, cursor)
					end,
				}),
				augend.user.new({
					find = function(line, cursor)
						local range = augend_onoff:find(line, cursor)
						if range ~= nil then
							if range.from <= cursor and cursor <= range.to then
								return range
							end
						end
						return nil
					end,
					add = function(text, addend, cursor)
						return augend_onoff:add(text, addend, cursor)
					end,
				}),

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
				-- augend.constant.new { elements = { 'and', 'or' }, word = true, cyclic = true, },
				augend.constant.new({
					elements = { "&&", "||" },
					word = false,
					cyclic = true,
				}),
				-- augend.constant.new { elements = { 'on', 'off' }, word = false, cyclic = true, },
				-- augend.constant.new { elements = { 'right', 'left' }, word = true, cyclic = true, },
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

		local noremap = utils.noremap
		noremap("n", "<C-a>", require("dial.map").inc_normal())
		noremap("n", "<C-x>", require("dial.map").dec_normal())
		noremap("v", "<C-a>", require("dial.map").inc_visual())
		noremap("v", "<C-x>", require("dial.map").dec_visual())
		noremap("v", "g<C-a>", require("dial.map").inc_gvisual())
		noremap("v", "g<C-x>", require("dial.map").dec_gvisual())
	end,
})

table.insert(plugins, {
	name = "sideways.vim",
	setup = function()
		local noremap = utils.noremap
		noremap("n", "<left>", ":SidewaysLeft<cr>")
		noremap("n", "<right>", ":SidewaysRight<cr>")
	end,
	config = function() end,
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
			-- Module mappings. Use `''` (empty string) to disable one.
			mappings = {
				add = "ys", -- Add surrounding in Normal and Visual modes
				delete = "ds", -- Delete surrounding
				find = "", -- Find surrounding (to the right)
				find_left = "", -- Find surrounding (to the left)
				highlight = "", -- Highlight surrounding
				replace = "cs", -- Replace surrounding
				update_n_lines = "", -- Update `n_lines`

				suffix_last = "", -- Suffix to search with "prev" method
				suffix_next = "", -- Suffix to search with "next" method
			},
			search_method = "cover_or_next",
		})

		-- Remap adding surrounding to Visual mode selection
		vim.keymap.del("x", "ys")
		vim.keymap.set(
			"x",
			"S",
			[[:<C-u>lua MiniSurround.add('visual')<CR>]],
			{ silent = true, desc = "surround in visual mode" }
		)
		vim.keymap.set(
			"n",
			"yss",
			"ys_",
			{ remap = true, desc = "surround whole line" }
		)
	end,
})
