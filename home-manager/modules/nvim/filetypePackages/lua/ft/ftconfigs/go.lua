local ft = "go"

utils.addTable(g.lsp.fts, {
  ft,
})

utils.addTable(g.lsp.servers.lsp_installer, {
  gopls = "default",
})

utils.addTable(g.linter.filetype, {
  [ft] = { "golangcilint" },
})
