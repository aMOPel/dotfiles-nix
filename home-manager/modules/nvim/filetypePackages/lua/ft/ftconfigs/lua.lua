local ft = "lua"

vim.tbl_deep_extend("force", g.lsp.fts, {
	ft,
})

vim.tbl_deep_extend("force", g.lsp.servers.lsp_installer, {
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

vim.tbl_deep_extend("force", g.formatter.filetype, {
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

vim.tbl_deep_extend("force", g.formatter.on_save, {
	"*." .. ft,
})
