-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local nvlsp = require "nvchad.configs.lspconfig"

-- 1. Standard web/compiled servers can stay in the default loop
local general_servers = { "html", "cssls", "clangd" }

for _, lsp in ipairs(general_servers) do
  vim.lsp.config(lsp, {
    on_attach = nvlsp.on_attach,
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  })
  vim.lsp.enable(lsp)
end

-- 2. Configure Basedpyright (Handles Autocomplete, Definitions, Type Checking)
vim.lsp.config("basedpyright", {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  settings = {
    basedpyright = {
      analysis = {
        -- Prevents basedpyright from duplicating Ruff's lint warnings
        ignore = { "*" }, 
      },
    },
  },
})
vim.lsp.enable("basedpyright")

-- 3. Configure Ruff (Handles lightning-fast Linting, Organizing Imports, and Code Actions)
vim.lsp.config("ruff", {
  on_attach = function(client, bufnr)
    -- Run NvChad's default mappings and setups
    nvlsp.on_attach(client, bufnr)
    
    -- Disable Ruff's hover capability so it doesn't conflict with Basedpyright
    if client.name == "ruff" then
      client.server_capabilities.hoverProvider = false
    end
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
})
vim.lsp.enable("ruff")
