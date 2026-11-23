plugins = g.plugins

table.insert(plugins, {
  name = "blink.cmp",
  setup = function() end,
  config = function()
    require("blink.cmp").setup({
      keymap = {
        preset = "default",
        ["<Tab>"] = { "accept", "snippet_forward", "fallback" },
        ["<enter>"] = { "show_documentation", "hide_documentation", "fallback" },
        ["<C-y>"] = { "fallback" },
        ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },
        ["<C-u>"] = { "scroll_signature_up", "scroll_documentation_up", "fallback" },
        ["<C-d>"] = { "scroll_signature_down", "scroll_documentation_down", "fallback" },
      },
      completion = {
        keyword = { range = "full" }, -- use text ahead of cursor for completion
        documentation = { auto_show = false },
        accept = { auto_brackets = { enabled = true } },
        list = { selection = { preselect = false, auto_insert = true } },
        ghost_text = { enabled = true },
        menu = {
          -- nvim-cmp style menu
          draw = {
            columns = {
              { "label", "label_description", gap = 1 },
              { "kind_icon", "kind", gap = 1 },
              { "source_name" },
            },
          },
        },
      },
      signature = {
        enabled = true,
        window = { show_documentation = false },
      },
      cmdline = {
        completion = {
          list = { selection = { preselect = false, auto_insert = true } },
          menu = { auto_show = true },
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer", "ripgrep" },
        providers = {
          lsp = {
            score_offset = 5,
          },
          ripgrep = {
            module = "blink-ripgrep",
            name = "Ripgrep",
            async = true,
            opts = {},
            max_items = 5,
          },
        },
      },
    })
  end,
})
