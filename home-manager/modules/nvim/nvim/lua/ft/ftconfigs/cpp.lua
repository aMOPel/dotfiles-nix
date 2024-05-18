local g = require("globals")
local add = require("utils").addTable

add(g.lsp.fts, {
	"c",
	"cpp",
	"objc",
	"objcpp",
})

add(g.lsp.servers.lsp_installer, {
	clangd = "default",
})

add(g.treesitter.ensure_installed, {
	"c",
	"cpp",
})

local configs = {}

configs["cpp"] = function()
	vim.cmd([[
if !exists("current_compiler")
  let current_compiler = "cpp"

  let s:cpo_save = &cpo
  set cpo-=C

  " CompilerSet makeprg=make

  let &cpo = s:cpo_save
  unlet s:cpo_save
endif

if !exists("current_compiler")
  compiler cpp
endif
]])
	-- vim.g.LanguageClient_serverCommands = {
	--   cpp = {'clangd'},
	-- }

	-- local optl = vim.opt_local
	-- optl.cindent = true
	-- optl.foldmethod = 'syntax'

	local optl = vim.opt_local
	local noremap = require("utils").noremap_buffer
	noremap(
		"n",
		"<leader>n",
		":FloatermNew --autoclose=0 --disposable ./release/binary<CR>"
	)
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { "cpp" },
	callback = configs["cpp"],
})
