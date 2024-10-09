local LANGUAGE_SERVERS = {
	"lua_ls",
	"pyright",
	"clangd",
	"bashls",
	"marksman",
	"texlab",
	"yamlls",
	"cmake",
	"html",
	"cssls",
	"cssmodules_ls",
	"css_variables",
	"kotlin_language_server",
} -- this is a shitty patchwork fix for automatically configuring all language servers

return {
	'neovim/nvim-lspconfig',
	config = function()
		-- lsp:
		local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
		capabilities.textDocument.completion.completionItem.snippetSupport = true

		local lspconfig = require("lspconfig")
		-- setup default lsp configs
		for _, server in ipairs(LANGUAGE_SERVERS) do
			lspconfig[server].setup({
				capabilities = capabilities
			})
		end

		-- Lua lsp:
		lspconfig.lua_ls.setup({
			settings = {
				Lua = {
					diagnostics = {
						globals = {"vim"}, -- recognize `vim` global
					},
					workspace = {
						-- Make the server aware of Neovim runtime files and plugins (stole this from reddit not sure what it does)
						checkThirdParty = false,
						library = {
							vim.env.VIMRUNTIME,
						},
					},
					telemetry = {
						enable = false, -- thanks mr. luaberg
					},
				},
			},
		})

		-- clangd
		require('lspconfig')['clangd'].setup {
			cmd = { "clangd", "--header-insertion=never"}, -- have to specify headerInsertion here cause config.yaml doesn't want to goddamn cooperate
			capabilities = capabilities
		}

		-- qmlls
		require('lspconfig')['qmlls'].setup {
			cmd = {"qmlls6"},
			capabilities = capabilities,
			root_dir = function()
				local fileDir = vim.fn.expand('%:p:h')
				local error, gitDir = os.execute("git -C " .. fileDir .. " rev-parse --show-toplevel 2> /dev/null")

				if error then
					return fileDir
				end

				return gitDir
			end
		}

		-- vscode-html-language-server

		require'lspconfig'.html.setup {
			capabilities = capabilities,
		}

		-- cssls

		require'lspconfig'.cssls.setup {
			capabilities = capabilities,
		}

		-- kotlin
		require'lspconfig'.kotlin_language_server.setup {}

		-- lsp_remaps:
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
				map('n', '<leader>lgc', vim.lsp.buf.declaration, opts)
				map('n', '<leader>lgf', vim.lsp.buf.definition, opts)
				map('n', '<leader>lh', vim.lsp.buf.hover, opts)
				map('n', '<leader>lgt', vim.lsp.buf.type_definition, opts)
				map('n', '<leader>lR', vim.lsp.buf.references, opts)
				map('n', '<leader>lr', vim.lsp.buf.rename, opts)
				map('n', '<leader>lca', vim.lsp.buf.code_action, opts)
				map('n', '<leader>lF', function()
					vim.lsp.buf.format { async = true }
				end, opts)
			end
		}))

		-- logging
		-- vim.lsp.set_log_level("trace")
	end
}
