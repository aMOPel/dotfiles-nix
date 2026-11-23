plugins = g.plugins

table.insert(plugins, {
  name = "snacks",
  setup = function() end,
  config = function()
    local Snacks = require("snacks")
    Snacks.setup({
      indent = {
        enabled = true,
        indent = {
          enabled = true,
        },
        animate = {
          enabled = false,
        },
        scope = {
          enabled = false,
        },
        chunk = {
          enabled = false,
        },
        -- filter = function(buf, win)
        --   return vim.g.snacks_indent ~= false and vim.b[buf].snacks_indent ~= false and vim.bo[buf].buftype == ""
        -- end,
      },
      lazygit = {
        enabled = true,
        configure = true,
      },

      input = {
        enabled = true,
        icon = "",
        win = {
          relative = "cursor",
          width = 0.3,
          min_width = 20,

          wo = {
            winhighlight = "NormalFloat:Normal,FloatBorder:BufferVisible",
          },
        },
        expand = false,
      },

      terminal = {
        enabled = true,
        shell = vim.env.SHELL,
        win = {
          relative = "editor",
          position = "float",
          width = 0.9,
          height = 0.9,
          border = "single",
        },
      },

      picker = {
        enabled = true,
        win = {
          input = {
            keys = {
              ["yof"] = { "toggle_follow", mode = { "n" } },
              ["yoh"] = { "toggle_hidden", mode = { "n" } },
              ["yoi"] = { "toggle_ignored", mode = { "n" } },
              ["yor"] = { "toggle_regex", mode = { "n" } },
              ["<c-w>m"] = { "toggle_maximize", mode = { "n" } },
              ["<c-w><c-m>"] = { "toggle_maximize", mode = { "n" } },
              ["<c-w>p"] = { "toggle_preview", mode = { "n" } },
              ["<c-w><c-p>"] = { "toggle_preview", mode = { "n" } },
              ["<c-w>c"] = { "cycle_win", mode = { "n" } },
              ["<c-w><c-w>"] = { "cycle_win", mode = { "n" } },
            },
          },
          list = {
            keys = {
              ["yof"] = "toggle_follow",
              ["yoh"] = "toggle_hidden",
              ["yoi"] = "toggle_ignored",
              ["yor"] = "toggle_regex",
              ["<c-w>m"] = "toggle_maximize",
              ["<c-w><c-m>"] = "toggle_maximize",
              ["<c-w>p"] = "toggle_preview",
              ["<c-w><c-p>"] = "toggle_preview",
              ["<c-w>c"] = "cycle_win",
              ["<c-w><c-w>"] = "cycle_win",
            },
          },
          preview = {
            keys = {
              ["a"] = "focus_input",
              ["A"] = "focus_input",
              ["I"] = "focus_input",
              ["<c-w>c"] = "cycle_win",
              ["<c-w><c-w>"] = "cycle_win",
            },
          },
        },
      },
    })

    vim.keymap.set({ "n" }, "<leader>fg", function()
      Snacks.lazygit.open()
    end, { desc = "snacks.lazygit" })

    vim.keymap.set({ "n" }, "<c-e>", function()
      Snacks.picker.smart()
    end, { desc = "snacks.picker smart find files" })
    vim.keymap.set({ "n" }, "<c-f>", function()
      Snacks.picker.grep()
    end, { desc = "snacks.picker grep" })
    vim.keymap.set({ "n" }, "<c-q>", function()
      Snacks.picker.buffers()
    end, { desc = "snacks.picker buffers" })

    vim.api.nvim_create_user_command("PickerAutocmds", function()
      Snacks.picker.autocmds()
    end, { desc = "snacks.picker autocmds" })
    vim.api.nvim_create_user_command("PickerHelp", function()
      Snacks.picker.help()
    end, { desc = "snacks.picker help" })
    vim.api.nvim_create_user_command("PickerHighlights", function()
      Snacks.picker.highlights()
    end, { desc = "snacks.picker highlights" })
    vim.api.nvim_create_user_command("PickerKeymaps", function()
      Snacks.picker.keymaps()
    end, { desc = "snacks.picker keymaps" })
    vim.api.nvim_create_user_command("PickerUndo", function()
      Snacks.picker.undo()
    end, { desc = "snacks.picker undo" })

    vim.keymap.set({ "n" }, "<leader>ff", function()
      Snacks.terminal.toggle()
    end, { desc = "snacks.terminal toggle" })
    vim.keymap.set({ "n" }, "<leader>ft", function()
      Snacks.terminal.toggle("taskwarrior-tui")
    end, { desc = "snacks.terminal toggle taskwarrior-tui" })

    function set_terminal_keymaps()
      local opts = { buffer = 0 }
      vim.keymap.set("t", "<C-w>c", function()
        Snacks.terminal.toggle()
      end, opts)
    end

    vim.api.nvim_create_autocmd({ "FileType" }, {
      group = "MyAutoCmd",
      pattern = { "snacks_terminal" },
      callback = function()
        set_terminal_keymaps()
      end,
      desc = "set window keymaps in toggle term",
    })

    local function terminal_picker()
      local terminals = Snacks.terminal.list()

      if #terminals == 0 then
        vim.notify("No open terminals", vim.log.levels.WARN)
        return
      end

      local items = {}

      for _, term in ipairs(terminals) do
        local buf = term.buf

        local title = vim.api.nvim_buf_is_valid(buf) and vim.b[buf].term_title or nil

        table.insert(items, {
          text = string.format("%s", title or "Terminal"),
          terminal = term,
          buf = buf,
        })
      end

      Snacks.picker.pick({
        title = "Terminals",
        items = items,
        format = function(item)
          return { { item.text } }
        end,
        preview = function(ctx)
          local buf = ctx.item.buf
          if not vim.api.nvim_buf_is_valid(buf) then
            return
          end

          ctx.preview:set_buf(buf)
        end,
        confirm = function(picker, item)
          picker:close()
          if item and item.terminal then
            item.terminal:show():focus()
            vim.schedule(function()
              vim.cmd.startinsert()
            end)
          end
        end,
      })
    end

    vim.keymap.set("n", "<leader>fs", terminal_picker, {
      desc = "Find terminals",
    })
  end,
})
