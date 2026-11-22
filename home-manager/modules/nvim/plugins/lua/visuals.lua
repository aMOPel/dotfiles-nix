plugins = g.plugins

table.insert(plugins, {
  name = "mini-icons",
  setup = function() end,
  config = function()
    require("mini.icons").setup()
  end,
})

table.insert(plugins, {
  name = "onedark.nvim",
  setup = function() end,
  config = function()
    require("onedark").load()
  end,
})

table.insert(plugins, {
  name = "lualine.nvim",
  setup = function() end,
  config = function()
    local function SessionStatus()
      local local_session = require("mini.sessions").detected["Session.vim"]
      local session_running = local_session ~= nil and local_session.type == "local"
      if session_running then
        return "Session"
      else
        return ""
      end
    end

    require("lualine").setup({
      options = {
        theme = "onedark",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "location" },
        lualine_x = {
          {
            "diagnostics",
            padding = 2,
            sources = { "nvim_diagnostic" },
            sections = { "error", "warn", "info", "hint" },
            symbols = {
              error = " ",
              warn = " ",
              info = " ",
              hint = " ",
            },
            update_in_insert = false,
            always_visible = false,
          },
        },
        lualine_y = {
          {
            "filename",
            file_status = true,
            path = 0,
            shorting_target = 70,
          },
          {
            "filetype",
            colored = true,
            icon_only = true,
          },
        },
        lualine_z = {},
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {
          {
            "filetype",
            colored = false,
            icon_only = true,
          },
          {
            "filename",
            file_status = true,
            path = 0,
            shorting_target = 70,
          },
        },
        lualine_z = {},
      },
      tabline = {
        lualine_a = { "tabs" },
        lualine_b = { "branch", "diff" },
        lualine_c = {},
        lualine_x = {
          SessionStatus,
        },
        lualine_y = {
          { "encoding" },
          { "fileformat" },
          {
            "filetype",
            icon = { align = "right" },
          },
        },
        lualine_z = {},
      },
      winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      inactive_winbar = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = {},
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
      },
      extensions = {
        "quickfix",
        "fugitive",
        "man",
        "nvim-dap-ui",
        "mundo",
        "toggleterm",
        "trouble",
      },
    })
  end,
})

table.insert(plugins, {
  name = "mini-map",
  setup = function() end,
  config = function()
    local map = require("mini.map")
    map.setup({
      symbols = {
        encode = { "█", "█", resolution = { row = 1, col = 1 } },
        scroll_line = "•",
        scroll_view = "┃",
      },
      window = {
        focusable = false,
        side = "right",
        show_integration_count = false,
        width = 2,
        winblend = 0,
      },
      integrations = {
        map.gen_integration.builtin_search({ search = "InvSearch" }),
        map.gen_integration.diff(),
        map.gen_integration.diagnostic(),
      },
    })
    vim.cmd([[
      hi InvSearch ctermfg=0 ctermbg=11 guifg=#ebd09c guibg=#282c34
      hi MiniMapNormal guifg=#31353f
      hi! link MiniMapSymbolLine MiniMapSymbolView
    ]])
    for _, key in ipairs({ "n", "N", "*", "#" }) do
      local rhs = "<Cmd>lua MiniMap.refresh({}, {lines = false, scrollbar = false})<CR>" .. key
      vim.keymap.set("n", key, rhs)
    end

    map.open()
  end,
})
