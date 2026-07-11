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
    -- basedpyright has richer code actions / hover / references
    client.server_capabilities.codeActionProvider = false
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.inlayHintProvider = false
    client.server_capabilities.referencesProvider = false
    client.server_capabilities.signatureHelpProvider = false
    client.server_capabilities.workspaceSymbolProvider = false
    client.server_capabilities.implementationProvider = false
    client.server_capabilities.callHierarchyProvider = false
  end,
  single_file_support = false,
}
