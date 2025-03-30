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
	"ts_ls",
	"eslint",
	"dockerls",
	"docker_compose_language_service",
	"gopls",
	"omnisharp",
	"jsonls",
	"sqls",
	-- "matlab_ls"
	-- "jdtls",
} -- this is a shitty patchwork fix for automatically configuring all language servers

return {
	'neovim/nvim-lspconfig',
	dpeendencies = {"artemave/workspace-diagnostics.nvim"},
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
			cmd = { "clangd", "--header-insertion=never",}, -- have to specify headerInsertion here cause config.yaml doesn't want to goddamn cooperate
			capabilities = capabilities
		}

		-- sqls
		require('lspconfig')['sqls'].setup {
			capabilities = capabilities,
			settings = {
				sqls = {
					connections = {
						{
							driver = 'mysql',
							-- proto = 'tcp',
							-- user = 'root',
							-- passwd = "mattys",
							-- host = '127.0.0.1',
							-- port = '3306',
							-- dbName = 'raptorchat_db',
							-- dbName = 'test',
							dataSourceName = 'root:admin123@tcp(127.0.0.1:3307)/raptorchat_db',
							params = {
								tls = "skip-verify"
							}
						},

						{
							driver = 'mysql',
							-- proto = 'tcp',
							-- user = 'root',
							-- passwd = "mattys",
							-- host = '127.0.0.1',
							-- port = '3306',
							-- dbName = 'raptorchat_db',
							-- dbName = 'test',
							dataSourceName = 'mstanek:123@tcp(127.0.0.1:3306)/employees',
						}
					}
				}
			}
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

	-- typescript

		lspconfig.ts_ls.setup({
			capabilities = capabilities,
			settings = {
				completions = {
					completeFunctionCalls = true
				},
			},

			on_attach = function(client, bufnr)
				require("workspace-diagnostics").populate_workspace_diagnostics(client, bufnr)
			end

			-- handlers = {
			-- 	["textDocument/publishDiagnostics"] = function(_, result, ctx, config)
			-- 		-- log the diagnostics in a file
			-- 		local file = io.open("/tmp/lsp.log", "a")
			-- 		for _, diagnostic in ipairs(result.diagnostics) do
			-- 			if file then
			-- 				file:write(string.format("[%s] %s\n", os.date(), vim.inspect(diagnostic)))
			-- 			end
			-- 		end
			--
			-- 		return result
			-- 	end
			-- },
		})

		-- cssls

		require'lspconfig'.cssls.setup {
			capabilities = capabilities,
			filetypes = { 'css', 'scss', 'less', 'javascriptreact', 'typescriptreact', 'javascript', 'typescript', 'html' },
			settings = {
				css = {
					validate = true,
					lint = {
						unknownAtRules = "ignore"
					}
				},
				scss = {
					validate = true
				},
				less = {
					validate = true
				}
			},

			command = {os.getenv("HOME").."/.local/share/mason/bin/vscode-css-language-server", "--stdio" },
		}

		-- jdtls
		require'lspconfig'.jdtls.setup {
			capabilities = capabilities,
		}

		-- omnisharp
		require'lspconfig'.omnisharp.setup {
			cmd = { "dotnet", "/home/mattys/.local/share/nvim/mason/packages/omnisharp/libexec/OmniSharp.dll" },

			settings = {
				FormattingOptions = {
					-- Enables support for reading code style, naming convention and analyzer
					-- settings from .editorconfig.
					EnableEditorConfigSupport = true,
					-- Specifies whether 'using' directives should be grouped and sorted during
					-- document formatting.
					OrganizeImports = nil,
				},
				MsBuild = {
					-- If true, MSBuild project system will only load projects for files that
					-- were opened in the editor. This setting is useful for big C# codebases
					-- and allows for faster initialization of code navigation features only
					-- for projects that are relevant to code that is being edited. With this
					-- setting enabled OmniSharp may load fewer projects and may thus display
					-- incomplete reference lists for symbols.
					LoadProjectsOnDemand = nil,
				},
				RoslynExtensionsOptions = {
					-- Enables support for roslyn analyzers, code fixes and rulesets.
					EnableAnalyzersSupport = nil,
					-- Enables support for showing unimported types and unimported extension
					-- methods in completion lists. When committed, the appropriate using
					-- directive will be added at the top of the current file. This option can
					-- have a negative impact on initial completion responsiveness,
					-- particularly for the first few completion sessions after opening a
					-- solution.
					EnableImportCompletion = nil,
					-- Only run analyzers against open files when 'enableRoslynAnalyzers' is
					-- true
					AnalyzeOpenDocumentsOnly = nil,
				},
				Sdk = {
					-- Specifies whether to include preview versions of the .NET SDK when
					-- determining which version to use for project loading.
					IncludePrereleases = true,
				},
			},
		}

		-- matlab_ls

		require'lspconfig'.matlab_ls.setup {
			capabilities = capabilities,
			cmd = { "matlab-language-server", "--stdio" },
			settings = {
				MATLAB = {
					indexWorkspace = true,
					installPath = "",
					matlabConnectionTiming = "onStart",
					telemetry = true
				  }
			},
			single_file_support = true
		}

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
