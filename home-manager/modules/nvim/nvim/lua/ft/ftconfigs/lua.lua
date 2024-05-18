local g = require("globals")
local add = require("utils").addTable

local ft = "lua"

add(g.lsp.fts, {
	ft,
})

add(g.lsp.servers.lsp_installer, {
	lua_ls = function(on_attach, capabilities)
		return {
			capabilities = capabilities,
			on_attach = on_attach,
			on_init = function(client)
				local path = client.workspace_folders[1].name
				if
					not vim.loop.fs_stat(path .. "/.luarc.json")
					and not vim.loop.fs_stat(path .. "/.luarc.jsonc")
				then
					client.config.settings =
						vim.tbl_deep_extend("force", client.config.settings, {
							Lua = {
								runtime = {
									-- Tell the language server which version of Lua you're using
									-- (most likely LuaJIT in the case of Neovim)
									version = "LuaJIT",
								},
								-- Make the server aware of Neovim runtime files
								workspace = {
									checkThirdParty = false,
									library = {
										vim.env.VIMRUNTIME,
										-- "${3rd}/luv/library"
										-- "${3rd}/busted/library",
									},
									-- or pull in all of 'runtimepath'. NOTE: this is a lot slower
									-- library = vim.api.nvim_get_runtime_file("", true)
								},
							},
						})

					client.notify(
						"workspace/didChangeConfiguration",
						{ settings = client.config.settings }
					)
				end
				return true
			end,
		}
	end,
})

add(g.treesitter.ensure_installed, {
	ft,
	"luadoc",
	"luap", -- lua patterns
})

add(g.formatter.ensure_installed, {
	"stylua",
})

add(g.formatter.filetype, {
	[ft] = function()
		return {
			exe = "stylua",
			args = {
				"--search-parent-directories",
				"--column-width",
				"80",
				"--stdin-filepath",
				vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)),
				"--",
				"-",
			},
			stdin = true,
		}
	end,
})

add(g.formatter.on_save, {
	"*." .. ft,
})

local configs = {}

configs[ft] = function()
	local optl = vim.opt_local
	optl.expandtab = false
	local noremap = require("utils").noremap_buffer
	noremap(
		"n",
		"<leader>n",
		':exec "FloatermNew --autoclose=0 --disposable luajit " . resolve(expand("%:p")) <CR>'
	)
end

vim.api.nvim_create_autocmd({ "Filetype" }, {
	group = "MyFt",
	pattern = { ft },
	callback = configs[ft],
})
