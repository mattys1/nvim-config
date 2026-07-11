local vue_language_server_path = vim.fn.expand '$MASON/packages'
  .. '/vue-language-server'
  .. '/node_modules/@vue/language-server'

local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_language_server_path,
  languages = { 'vue' },
}

-- vue_ls runs in "hybrid mode": it handles CSS/HTML in .vue files,
-- but TypeScript support requires ts_ls (or vtsls) with the Vue plugin.
vim.lsp.config('ts_ls', {
  init_options = {
    plugins = {
      vue_plugin,
    },
  },
  filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
})

-- This file is loaded by mason-lspconfig as `lsp/vue_ls.lua`.
-- Its return value is merged into the vue_ls config, so it must be a table.
-- The base vue_ls config (cmd, filetypes, on_init, ...) comes from nvim-lspconfig.
return {}
