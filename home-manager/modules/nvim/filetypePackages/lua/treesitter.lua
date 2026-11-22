local treesitter = function()
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function(ev)
      local ft = ev.match
      if vim.tbl_contains(g.treesitter.highlight.disable, ft) then
        return
      end
      local lang = vim.treesitter.language.get_lang(ft)

      if lang and vim.treesitter.language.add(lang) then
        vim.treesitter.start(ev.buf, lang)
      end
    end,
  })
end

local treesitter_textobjects = function()
  require("nvim-treesitter-textobjects").setup({
    select = {
      lookahead = true,
      include_surrounding_whitespace = false,
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
    on_attach = function(buf)
      vim.cmd([[hi TreesitterContextBottom gui=underline guisp=Grey]])

      if vim.list_contains(g.treesitter.context.disable, vim.bo.filetype) then
        return false
      end
    end,
  })
end

treesitter()
treesitter_textobjects()
treesitter_context()
