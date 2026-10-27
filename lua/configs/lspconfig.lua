-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

-- EXAMPLE
local servers = { "html", "cssls", "gopls" }

-- lsps with default config
-- capabilities / on_init / on_attach are already applied globally by defaults()
-- (via vim.lsp.config("*", ...) and the LspAttach autocmd)
vim.lsp.enable(servers)

-- Load local configuration if it exists
local ok, local_config = pcall(require, "local.cpp-config")
if ok then
  -- Setup clangd for C++
  vim.lsp.config("clangd", local_config.clangd_config or {})
  vim.lsp.enable "clangd"

  -- Setup cmake language server
  vim.lsp.enable "cmake"

  -- Apply C++ specific settings
  local_config.cpp_settings()
end

-- configuring single server, example: typescript
-- vim.lsp.config("ts_ls", { ... })
-- vim.lsp.enable "ts_ls"
