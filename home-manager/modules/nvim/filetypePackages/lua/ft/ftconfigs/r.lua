local ft = "r"

utils.addTable(g.lsp.fts, {
  ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
  -- server_name = function(on_attach, capabilities) end,
  server_name = "default",
})

local configs = {}

configs[ft] = function()
  local optl = vim.opt_local

  require("r").setup({
    -- your options here
    tmpdir = "~/.local/state/nvim",
  })
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
  group = "MyFt",
  pattern = { ft },
  callback = configs[ft],
})
