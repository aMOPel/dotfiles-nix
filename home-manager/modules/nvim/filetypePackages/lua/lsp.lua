local setup_lsps = function()
  local Snacks = require("snacks")
  -- Global mappings.
  -- See `:help vim.diagnostic.*` for documentation on any of the below functions
  vim.keymap.set("n", "<leader>ls", Snacks.picker.lsp_symbols, { desc = "lsp symbols" })
  vim.keymap.set("n", "<leader>lS", Snacks.picker.lsp_workspace_symbols, { desc = "lsp symbols workspace" })
  vim.keymap.set("n", "<leader>ld", Snacks.picker.diagnostics, { desc = "lsp diagnostics project" })
  vim.keymap.set("n", "[d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, { desc = "lsp prev diagnostic" })
  vim.keymap.set("n", "]d", function()
    vim.diagnostic.jump({ count = -1, float = true })
  end, { desc = "lsp next diagnostic" })
  vim.keymap.set("n", "<leader>lq", Snacks.picker.diagnostics_buffer, { desc = "lsp diagnostics buffer" })
  vim.keymap.set("n", "<leader>li", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
  end, { desc = "lsp diagnostics buffer" })

  -- Use LspAttach autocommand to only map the following keys
  -- after the language server attaches to the current buffer
  vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(ev)
      -- Buffer local mappings.
      -- See `:help vim.lsp.*` for documentation on any of the below functions
      vim.keymap.set("n", "gD", Snacks.picker.lsp_declarations, { buffer = ev.buf, desc = "lsp declaration" })
      vim.keymap.set("n", "gy", Snacks.picker.lsp_type_definitions, { buffer = ev.buf, desc = "lsp type definition" })
      vim.keymap.set("n", "gI", Snacks.picker.lsp_incoming_calls, { buffer = ev.buf, desc = "lsp incoming calls" })
      vim.keymap.set("n", "gO", Snacks.picker.lsp_outgoing_calls, { buffer = ev.buf, desc = "lsp outgoing calls" })
      vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions, { buffer = ev.buf, desc = "lsp definition" })
      vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "lsp hover" })
      vim.keymap.set("n", "gi", Snacks.picker.lsp_implementations, { buffer = ev.buf, desc = "lsp implementation" })
      vim.keymap.set("n", "gr", Snacks.picker.lsp_references, { buffer = ev.buf, desc = "lsp references" })
      vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, { buffer = ev.buf, desc = "lsp signature_help" })
      vim.keymap.set("n", "gl", vim.lsp.codelens.run, { buffer = ev.buf, desc = "lsp code lens" })

      vim.keymap.set(
        "n",
        "<leader>wa",
        vim.lsp.buf.add_workspace_folder,
        { buffer = ev.buf, desc = "lsp add workspace folder" }
      )
      vim.keymap.set(
        "n",
        "<leader>wr",
        vim.lsp.buf.remove_workspace_folder,
        { buffer = ev.buf, desc = "lsp remove workspace folder" }
      )
      vim.keymap.set("n", "<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, { buffer = ev.buf, desc = "lsp list workspace folders" })
      vim.keymap.set("n", "<leader>lr", vim.lsp.buf.rename, { buffer = ev.buf, desc = "lsp rename" })
      vim.keymap.set({ "n", "v" }, "<leader>la", vim.lsp.buf.code_action, { buffer = ev.buf, desc = "lsp code action" })
      vim.keymap.set("n", "<leader>lf", function()
        vim.lsp.buf.format({ async = true })
      end, { buffer = ev.buf, desc = "lsp format buffer" })
    end,
  })

  -------------------------------------------------------------------
  -- setup servers

  local servers = g.lsp.servers.lsp_installer

  local function setup_server(server_name, server_config)
    local config = {
      capabilities = require("blink.cmp").get_lsp_capabilities(),
      on_attach = function() end,
    }

    if server_config == "default" then
    elseif type(server_config) == "function" then
      config = server_config(config.on_attach, config.capabilities)
    else
      print("error with " .. server_name)
    end

    vim.lsp.config(server_name, config)
    vim.lsp.enable(server_name)
  end

  for server_name, server_config in pairs(servers) do
    setup_server(server_name, server_config)
  end
end

local setup_linters = function()
  local lint = require("lint")
  utils.addTable(lint.linters, g.linter.custom_linter)
  lint.linters_by_ft = g.linter.filetype
  vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
    group = "MyAutoCmd",
    callback = function()
      lint.try_lint()
    end,
  })
end

local setup_formatters = function()
  require("formatter").setup({
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = g.formatter.filetype,
  })

  vim.keymap.set("n", "gq", "<cmd>FormatWrite<cr>", { desc = "format buffer" })
  -- vim.cmd([[autocmd MyAutoCmd BufWritePost * FormatWrite]])
  -- vim.api.nvim_create_autocmd({ "BufWritePost" }, {
  -- 	pattern = g.formatter.on_save,
  -- 	group = "MyAutoCmd",
  -- 	callback = function()
  -- 		vim.cmd([[FormatWrite]])
  -- 	end,
  -- })
end

setup_lsps()
setup_linters()
setup_formatters()
