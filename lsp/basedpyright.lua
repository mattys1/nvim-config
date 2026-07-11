local root_dir_python = function(bufnr, cb)
  local bufname = vim.api.nvim_buf_get_name(bufnr)
  if string.match(bufname, 'site%-packages') or string.match(bufname, '[\\/][Ll]ib[\\/]') then
    return
  end
  local root = vim.fs.root(bufnr, {
    'pyproject.toml',
    'pyrightconfig.json',
    'ruff.toml',
    '.ruff.toml',
    'pyrefly.toml',
    '.git',
  }) or vim.fn.expand('%:p:h')
  cb(root)
end

return {
  filetypes = { 'python' },
  root_dir = root_dir_python,
  on_attach = function(client, _)
    -- delegate fast-response capabilities to pyrefly, keep type checking here
    client.server_capabilities.completionProvider = false
    client.server_capabilities.documentHighlightProvider = false
    client.server_capabilities.documentSymbolProvider = false
    client.server_capabilities.semanticTokensProvider = false
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.definitionProvider = false
    client.server_capabilities.declarationProvider = false
    client.server_capabilities.typeDefinitionProvider = false
    client.server_capabilities.renameProvider = false
  end,
  settings = {
    basedpyright = {
      disableOrganizeImports = true, -- ruff handles imports
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = 'openFilesOnly',
        useLibraryCodeForTypes = true,
        diagnosticSeverityOverrides = {
          reportUnknownMemberType = 'none',
          reportUnusedCallResult = 'none',
        },
        exclude = {
          '**/.venv',
          '**/venv',
          '**/__pycache__',
          '**/dist',
          '**/build',
        },
      },
    },
  },
  single_file_support = false,
}
