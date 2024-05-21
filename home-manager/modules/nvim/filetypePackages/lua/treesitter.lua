local treesitter = function()
	require("nvim-treesitter.configs").setup({
		ensure_installed = g.treesitter.ensure_installed,
		highlight = {
			enable = true,
			disable = g.treesitter.highlight.disable,
			additional_vim_regex_highlighting = false,
		},
		indent = {
			enable = false,
			disable = g.treesitter.indent.disable,
		},
		incremental_selection = {
			enable = false,
			disable = g.treesitter.incremental_selection.disable,
		},
		matchup = {
			enable = true,
			disable_virtual_text = { "nim" },
		},
		textobjects = {
			select = {
				enable = { "nim" },
				lookahead = true,
				keymaps = {
					-- You can use the capture groups defined in textobjects.scm
					["iz"] = "@assignment.inner",
					["az"] = "@assignment.outer",
					["if"] = "@function.inner",
					["af"] = "@function.outer",
					-- @loop.inner
					-- @loop.outer
					-- @block.inner
					-- @block.outer
					-- @call.inner
					-- @call.outer
					["ia"] = "@parameter.inner",
					["aa"] = "@parameter.outer",
					["ic"] = "@comment.inner",
					["ac"] = "@comment.outer",
					-- @assignment.inner
					-- @assignment.outer
					["im"] = "@assignment.rhs",
					["am"] = "@assignment.lhs",
					["ir"] = "@return.inner",
					["ar"] = "@return.outer",
					["as"] = "@statement.outer",
					["in"] = "@number.inner",
				},
				-- selection_modes = {
				--   ['@function.outer'] = 'v', -- linewise
				-- },
				include_surrounding_whitespace = false,
			},
		},
	})
end

local treesitter_context = function()
	vim.keymap.set("n", "[c", function()
		require("treesitter-context").go_to_context()
	end, { silent = true })

	require("treesitter-context").setup({
		enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
		max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
		min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
		line_numbers = true,
		multiline_threshold = 20, -- Maximum number of lines to show for a single context
		trim_scope = "outer", -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
		mode = "cursor", -- Line used to calculate context. Choices: 'cursor', 'topline'
		-- Separator between context and content. Should be a single character string, like '-'.
		-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
		separator = nil,
		zindex = 10000, -- The Z-index of the context window
		on_attach = function()
			vim.cmd([[hi TreesitterContextBottom gui=underline guisp=Grey]])
		end,
	})
end

local treesitter_context_comment_string = function()
	require("ts_context_commentstring").setup({
		enable_autocmd = false,
	})
end

treesitter()
treesitter_context()
treesitter_context_comment_string()
