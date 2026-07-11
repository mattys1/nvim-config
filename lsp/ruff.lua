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
    -- let basedpyright provide hover/formatting; ruff is for fast lint diagnostics
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
    client.server_capabilities.hoverProvider = false
  end,
  init_options = {
    settings = {
      organizeImports = true,
      showSyntaxErrors = true,
      codeAction = {
        disableRuleComment = { enable = false },
        fixViolation = { enable = false },
      },
      format = { preview = false },
      lint = { enable = true },
    },
  },
  single_file_support = false,
}
