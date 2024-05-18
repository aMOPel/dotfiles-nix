local plugins = require("globals").plugins

table.insert(plugins, {
	name = "vim-schlepp",
	setup = function()
		vim.g["Schlepp#useShiftWidthLines"] = 1
		vim.g["Schlepp#dupLinesDir"] = "down"
		vim.g["Schlepp#dupBlockDir"] = "right"

		local map = require("utils").map
		map("x", "gd", "<Plug>SchleppDupSmart")
		map("x", "<up>", "<Plug>SchleppUp")
		map("x", "<down>", "<Plug>SchleppDown")
		map("x", "<left>", "<Plug>SchleppLeft")
		map("x", "<right>", "<Plug>SchleppRight")
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "vim-yoink",
	setup = function()
		vim.g.yoinkAutoFormatPaste = 0
		vim.g.yoinkSavePersistently = 1
		vim.g.yoinkIncludeDeleteOperations = 1

		local map = require("utils").map
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

		local map = require("utils").map
		map("n", "S", "<plug>(SubversiveSubstitute)")
		map("n", "SS", "<plug>(SubversiveSubstituteLine)")
		-- map("n", "SL", "<plug>(SubversiveSubstituteEndOfLine)")

		map("x", "P", "<plug>(SubversiveSubstitute)")
		map("x", "p", "<plug>(SubversiveSubstitute)")

		local noremap = require("utils").noremap
		noremap("n", "R", "<plug>(SubversiveSubvertRange)")
		noremap("x", "R", "<plug>(SubversiveSubvertRange)")
		noremap("n", "RR", "<plug>(SubversiveSubvertWordRange)")
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "vim-exchange",
	setup = function()
		vim.g.exchange_no_mappings = 1
		vim.g.exchange_indent = "=="

		local map = require("utils").map
		map("n", "gx", "<Plug>(Exchange)")
		map("x", "gx", "<Plug>(Exchange)")
		map("n", "gxc", "<Plug>(ExchangeClear)")
		map("n", "gxx", "<Plug>(ExchangeLine)")
		map("n", "gX", "<Plug>(ExchangeLine):norm! $<cr>")
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "mini.ai",
	setup = function() end,
	config = function()
		local miniAiDiagnostics = function()
			local diagnostics = vim.diagnostic.get(0)
			diagnostics = vim.tbl_map(function(diagnostic)
				local from_line = diagnostic.lnum + 1
				local from_col = diagnostic.col + 1
				local to_line = diagnostic.end_lnum + 1
				local to_col = diagnostic.end_col + 1
				return {
					from = { line = from_line, col = from_col },
					to = { line = to_line, col = to_col },
				}
			end, diagnostics)
			return diagnostics
		end
		require("mini.ai").setup({
			custom_textobjects = {
				d = miniAiDiagnostics,
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
		})
	end,
})

table.insert(plugins, {
	name = "vim-sandwich",
	setup = function()
		vim.cmd([[runtime vimscript/vim-sandwich/surround.vim]])
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "Comment.nvim",
	setup = function() end,
	config = function()
		require("Comment").setup({
			padding = true,
			sticky = true,
			mappings = {
				basic = true,
				extra = true,
				extended = false,
			},
			toggler = {
				line = "gcc",
				block = "|||",
			},
			opleader = {
				line = "gc",
				block = "||",
			},
			pre_hook = require(
				"ts_context_commentstring.integrations.comment_nvim"
			).create_pre_hook(),
		})
	end,
})

table.insert(plugins, {
	name = "vim-surround-funk",
	setup = function()
		vim.g.surround_funk_create_mappings = 0
		local map = require("utils").map
		map("n", "dsf", "<Plug>(DeleteSurroundingFunction)")
		map("n", "dsF", "<Plug>(DeleteSurroundingFUNCTION)")
		map("n", "csf", "<Plug>(ChangeSurroundingFunction)")
		map("n", "csF", "<Plug>(ChangeSurroundingFUNCTION)")
		map("n", "ysf", "<Plug>(YankSurroundingFunction)")
		map("n", "ysF", "<Plug>(YankSurroundingFUNCTION)")
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "CamelCaseMotion",
	setup = function()
		-- vim.g.camelcasemotion_key = ','
		local map = require("utils").map
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

		local map = require("utils").map
		map("n", "gl", "<Plug>LogPrintToggle")
		map("n", "[g", "<Plug>LogPrintAbove")
		map("n", "]g", "<Plug>LogPrintBelow")
	end,
	config = function() end,
})

table.insert(plugins, {
	name = "vim-argwrap",
	setup = function()
		local noremap = require("utils").noremap
		noremap("n", "gj", ":ArgWrap<CR>")
		vim.g.argwrap_tail_comma_braces = "[{"
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

		local noremap = require("utils").noremap
		noremap("n", "<C-a>", require("dial.map").inc_normal())
		noremap("n", "<C-x>", require("dial.map").dec_normal())
		noremap("v", "<C-a>", require("dial.map").inc_visual())
		noremap("v", "<C-x>", require("dial.map").dec_visual())
		noremap("v", "g<C-a>", require("dial.map").inc_gvisual())
		noremap("v", "g<C-x>", require("dial.map").dec_gvisual())
	end,
})

-- table.insert(plugins, {
-- 	name = "targets.vim",
-- 	setup = function() end,
-- 	config = function()
-- 		vim.g.targets_aiAI = { "a", "i", " ", " " }
-- 		vim.g.targets_nl = { " ", " " }
-- 		vim.g.targets_seekRanges =
-- 			"cc cr cb cB lc ac Ac lr rr ll lb ar ab lB Ar aB Ab AB rb rB al Al"
-- 		vim.cmd([[
-- autocmd MyPlugins User targets#mappings#user call targets#mappings#extend({
--     \ 'a': {'argument': [{'o': '[{([]', 'c': '[])}]', 's': ','}]},
--     \ })
-- ]])

-- vim.api.nvim_create_autocmd(
--   { 'User' },
--   {
--   pattern = 'targets#mappings#user',
--   group = 'MyAutoCmd',
--   callback = function()
--     vim.fn['targets#mappings#extend']({
--       a = {},
--     })
--   end,
--   once = true,
-- })
-- 	end,
-- })

-- table.insert(plugins, {
--   name = 'cool-substitute.nvim',
--   setup = function()
--   end,
--   config = function()
--     require'cool-substitute'.setup({
--       setup_keybindings = true,
--       mappings = {
--         start = '<leader>sw', -- Mark word / region
--         start_word = '<leader>sW', -- Mark word / region. Edit only full word
--         start_and_edit = '', -- Mark word / region and also edit
--         start_and_edit_word = '', -- Mark word / region and also edit.  Edit only full word.
--         apply_substitute_and_next = '?', -- Start substitution / Go to next substitution
--         apply_substitute_and_prev = '!', -- same as M but backwards
--         apply_substitute_all = '<leader>ss', -- Substitute all
--         force_terminate_substitute = '<leader>sc', -- Terminate macro (if some bug happens)
--         redo_last_record = '',
--         terminate_substitute = '<esc>',
--         skip_substitute = '<cr>',
--         goto_next = '<C-j>',
--         goto_previous = '<C-k>',
--       },
--       reg_char = 's', -- letter to save macro (Dont use number or uppercase here)
--       mark_char = 's', -- mark the position at start of macro
--       writing_substitution_color = "#ECBE7B", -- for status line
--       applying_substitution_color = "#98be65", -- for status line
--       edit_word_when_starting_with_substitute_key = true -- (press M to mark and edit when not executing anything anything)
--     })
--   end,
-- })

table.insert(plugins, {
	name = "sideways.vim",
	setup = function()
		local noremap = require("utils").noremap
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

local p = require("utils").p

local M = function(use)
	use({ p("https://github.com/machakann/vim-sandwich") })
	use({ p("https://github.com/tommcdo/vim-exchange") })
	use({
		p("https://github.com/numToStr/Comment.nvim"),
		after = "nvim-ts-context-commentstring",
	})
	use({ p("https://github.com/Matt-A-Bennett/vim-surround-funk") })
	use({ p("https://github.com/bkad/CamelCaseMotion") })
	-- use { p 'https://github.com/AndrewRadev/deleft.vim', }
	use({ p("https://github.com/FooSoft/vim-argwrap") })
	-- use { p "https://github.com/wellle/targets.vim" }
	use({
		p("https://github.com/aMOPel/vim-log-print"),
		requires = { p("https://github.com/Shougo/context_filetype.vim") },
	})
	use({
		p("https://github.com/kana/vim-textobj-user"),
		requires = {
			{ p("https://github.com/kana/vim-textobj-indent") },
			{ p("https://github.com/kana/vim-textobj-entire") },
			-- { p 'https://github.com/Chun-Yang/vim-textobj-chunk', after = 'vim-textobj-user', },
			-- { p 'https://github.com/saaguero/vim-textobj-pastedtext', after = 'vim-textobj-user', },
			{ p("https://github.com/idbrii/textobj-word-column.vim") },
			{ p("https://github.com/glts/vim-textobj-comment") },
			-- { p "https://github.com/kana/vim-textobj-lastpat", },
		},
	})
	-- use { p "https://github.com/otavioschwanck/cool-substitute.nvim", }
	use({ p("https://github.com/echasnovski/mini.ai") })
	use({ p("https://github.com/monaqa/dial.nvim") })
	use({ p("https://github.com/AndrewRadev/sideways.vim") })
	use({ p("https://github.com/echasnovski/mini.align") })

	use({ p("https://github.com/aMOPel/vim-schlepp") })
	use({ p("https://github.com/svermeulen/vim-subversive") })
	use({ p("https://github.com/svermeulen/vim-yoink") })
	use({ p("https://github.com/tpope/vim-abolish") })
end
return M
