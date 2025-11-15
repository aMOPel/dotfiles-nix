local ft = "sh.dotenv"

utils.addTable(g.linter.filetype, {
  [ft] = { "dotenv_linter" },
})

vim.filetype.add({
  filename = {
    [".envrc"] = "sh",
    [".env"] = ft,
  },
  pattern = {
    ["%.env%..*"] = ft,
  },
})
