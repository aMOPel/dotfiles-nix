plugins = g.plugins

table.insert(plugins, {
  name = "snacks",
  setup = function() end,
  config = function()
    require("snacks").setup({

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
    })
  end,
})
