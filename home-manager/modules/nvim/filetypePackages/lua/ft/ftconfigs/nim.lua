local ft = "nim"

utils.addTable(g.lsp.fts, {
  ft,
  -- 'nims',
})

utils.addTable(g.lsp.servers.lsp_installer, {
  nim_langserver = "default",
})
