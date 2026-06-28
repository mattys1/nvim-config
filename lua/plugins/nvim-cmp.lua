return {
	'hrsh7th/nvim-cmp',
	event = { "InsertEnter", "CmdlineEnter" },
	config = function()
		-- Set up nvim-cmp.
		local cmp = require'cmp'
		cmp.setup({
			formatting = {
				format = require('lspkind').cmp_format({
					mode = "symbol",
					max_width = 50,
					symbol_map = { Copilot = "" }
				})
			},
			snippet = {
				-- REQUIRED - you must specify a snippet engine
				expand = function(args)
					-- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
					require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
					-- require('snippy').expand_snippet(args.body) -- For `snippy` users.
					-- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
					-- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
				end,
			},
			window = {
				-- completion = cmp.config.window.bordered(),
				-- documentation = cmp.config.window.bordered(),
			},
			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.config.disable,
				["<C-n>"] = cmp.config.disable,
				['<C-j>'] = cmp.mapping(cmp.mapping.select_next_item()),
				['<C-k>'] = cmp.mapping(cmp.mapping.select_prev_item()),
				['<C-b>'] = cmp.mapping.scroll_docs(-4),
				['<C-f>'] = cmp.mapping.scroll_docs(4),
				['<C-Space>'] = cmp.mapping.complete(),
				['<C-e>'] = cmp.mapping.abort(),
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<TAB>"] = cmp.mapping.confirm({ select = true }),
				-- ['<TAB>'] = cmp.mapping(function(fallback)
				-- 	if not cmp.visible() then
				-- 		fallback()
				-- 		return
				-- 	end
				--
				-- 	local entries = cmp.get_entries()
				-- 	if not entries or #entries == 0 then
				-- 		fallback()
				-- 		return
				-- 	end
				--
				-- 	local target_index = nil
				-- 	for i, entry in ipairs(entries) do
				-- 		if entry.source.name ~= "copilot" then
				-- 			target_index = i
				-- 			break
				-- 		end
				-- 	end
				--
				-- 	if not target_index then
				-- 		return;
				-- 	end
				--
				-- 	cmp.select_next_item({ count = target_index - 1 })
				-- 	cmp.confirm({ select = true })
				-- end, { "i", "s" }),
				['<S-TAB>'] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.confirm({ select = false })
					else
						fallback()
					end
				end, { "i", "s" }),
			}),
			sources = cmp.config.sources({
				per_filetype = {
					codecompanion = { "codecompanion" },
				},
				{ name = 'nvim_lsp' },
				{ name = "copilot", group_index = 2 },
				{ name = 'easy-dotnet' },
				-- { name = 'vsnip' }, -- For vsnip users.
				{ name = 'luasnip' }, -- For luasnip users.
				-- { name = 'ultisnips' }, -- For ultisnips users.
				-- { name = 'snippy' }, -- For snippy users.

				{ name = 'buffer' },
			})
		})
		-- Set configuration for specific filetype.
		cmp.setup.filetype('gitcommit', {
			sources = cmp.config.sources({
				{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
			}, {
					{ name = 'buffer' },
				})
		})
		-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline({ '/', '?' }, {
			mapping = cmp.mapping.preset.cmdline(),
			sources = {
				{ name = 'buffer' }
			}
		})
		-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
		cmp.setup.cmdline(':', {
			mapping = cmp.mapping.preset.cmdline(),
			sources = cmp.config.sources({
				{ name = 'path' }
			}, {
					{ name = 'cmdline' }
				}),
			matching = { disallow_symbol_nonprefix_matching = false }
		})
		-- Set up lspconfig.
		-- local lspconfig = require("lspconfig")
		-- local capabilities = require('cmp_nvim_lsp').default_capabilities()
		--			for _, i in ipairs(LANGUAGE_SERVERS) do
		--				lspconfig[i].setup({
		--					capabilities = capabilities
		--				})
		--			end
		local map = vim.keymap.set
	end
}
