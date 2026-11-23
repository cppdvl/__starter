-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

-- Quiet diagnostics: no inline messages, just a small sign next to the line number.
-- Show the full message on demand with <C-w>d (float) or <leader>ds (list); jump with ]d / [d.
local sev = vim.diagnostic.severity
vim.diagnostic.config {
  virtual_text = false,
  virtual_lines = false,
  underline = false,
  update_in_insert = false,
  severity_sort = true,
  signs = {
    text = {
      [sev.ERROR] = "✗",
      [sev.WARN] = "•",
      [sev.INFO] = "·",
      [sev.HINT] = "·",
    },
  },
  float = { border = "rounded", source = true },
}

-- EXAMPLE
local servers = { "html", "cssls", "gopls", "pyright", "ts_ls" }

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
else
  -- No local C++ config: still run clangd with defaults (needed for t+ / go-to-definition)
  vim.lsp.enable "clangd"
end

-- configuring single server, example: typescript
-- vim.lsp.config("ts_ls", { ... })
-- vim.lsp.enable "ts_ls"
