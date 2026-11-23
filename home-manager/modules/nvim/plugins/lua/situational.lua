plugins = g.plugins

table.insert(plugins, {
  name = "yazi.nvim",
  setup = function()
    vim.keymap.set({ "n", "v" }, "-", "<cmd>Yazi<cr>", { desc = "Open yazi at the current file" })
    vim.keymap.set({ "n", "v" }, "+", "<cmd>Yazi toggle<cr>", { desc = "Resume the last yazi session" })
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
