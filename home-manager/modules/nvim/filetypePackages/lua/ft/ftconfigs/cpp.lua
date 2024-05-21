utils.addTable(g.lsp.fts, {
	"c",
	"cpp",
	"objc",
	"objcpp",
})

utils.addTable(g.lsp.servers.lsp_installer, {
	clangd = "default",
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
	utils.noremap(
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
