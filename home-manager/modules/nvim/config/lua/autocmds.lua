vim.api.nvim_create_augroup("MyAutoCmd", {})
vim.api.nvim_create_augroup("MyFt", {})
vim.api.nvim_create_augroup("CustomFileType", {})
vim.api.nvim_create_augroup("AutoNoHLSearch", { clear = true })

vim.filetype.add({
  pattern = {
    ["*kitty*.conf"] = "kitty",
  },
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  group = "MyAutoCmd",
  pattern = { "qf" },
  callback = function(ev)
    vim.keymap.set(
      { "n" },
      "s",
      [[:<c-u>cdo s/// | update<Left><Left><Left><Left><Left><Left><Left><Left><Left><Left>]],
      { buffer = true, desc = "quick search and replace in quickfix" }
    )
  end,
  desc = "quick search and replace in quickfix",
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  group = "MyAutoCmd",
  pattern = { "*" },
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 500 })
  end,
  desc = "Highlight yanked text",
})

vim.api.nvim_create_autocmd("InsertEnter", {
  group = "AutoNoHLSearch",
  callback = function()
    vim.schedule(function()
      vim.cmd("nohlsearch")
    end)
  end,
  desc = "disable hlsearch on insert",
})

vim.api.nvim_create_autocmd("CursorMoved", {
  group = "AutoNoHLSearch",
  callback = function()
    if vim.v.hlsearch == 1 and vim.fn.searchcount({ recompute = true }).exact_match == 0 then
      vim.schedule(function()
        vim.cmd("nohlsearch")
      end)
    end
  end,
  desc = "disable hlsearch when cursor leaves searched word",
})
