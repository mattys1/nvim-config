return {
	'neovim/nvim-lspconfig',
	dependencies = {"artemave/workspace-diagnostics.nvim"},
	config = function ()
		local map = vim.keymap.set
		map('n', '<leader>ldf', vim.diagnostic.open_float)
		-- Use LspAttach autocommand to only map the following keys
		-- after the language server attaches to the current buffer
		vim.api.nvim_create_autocmd('LspAttach', ({
			group = vim.api.nvim_create_augroup('UserLspConfig', {}),
			callback = function(ev)
				-- Buffer local mappings.
				-- See `:help vim.lsp.*` for documentation on any of the below function
				local opts = {buffer = ev.buf}
				map({ 'n', 'v' }, '<leader>lgc', vim.lsp.buf.declaration, opts)
				map({ 'n', 'v' }, '<leader>lgf', vim.lsp.buf.definition, opts)
				map({ 'n', 'v' }, '<leader>lh', vim.lsp.buf.hover, opts)
				map({ 'n', 'v' }, '<leader>lgt', vim.lsp.buf.type_definition, opts)
				map({ 'n', 'v' }, '<leader>lR', vim.lsp.buf.references, opts)
				map({ 'n', 'v' }, '<leader>lr', vim.lsp.buf.rename, opts)
				map({ 'n', 'v' }, '<leader>lca', vim.lsp.buf.code_action, opts)
				map({ 'n', 'v' }, '<leader>lF', function()
					vim.lsp.buf.format { async = true }
				end, opts)
			end}))
	end
}
