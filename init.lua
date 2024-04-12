-- GIT TEST

-- GLOBALS:

vim.g.mapleader = ' '
vim.g.netrw_keepdir = true

LANGUAGE_SERVERS = {"lua_ls", "pyright", "clangd", "bashls", "marksman"} -- this is a shitty patchwork fix for automatically configuring all language servers, this probably shoul have its own file


-- PLUGINS:

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup({

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				term_colors = true
			})

			vim.cmd.colorscheme("catppuccin")
		end

	},

	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			vim.opt.tabstop = 4
			vim.opt.shiftwidth = 4
			require("nvim-treesitter.configs").setup({
				ensure_installed = {"c", "cpp", "lua", "vim", "vimdoc", "query", "python", "markdown", "asm", "latex", "bash"},
				auto_install = true,

				highlight = {
					enable = true,
				},

				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<Leader>vi", -- set to `false` to disable one of the mappings
						node_incremental = "<Leader>vm",
						scope_incremental = "<Leader>vM",
						node_decremental = "<Leader>vl",
					},

					textobjects = {
						select = {
							enable = true, -- BROKEN RIGHT NOW FOR SELECTING IN FUNCTIONS

							-- Automatically jump forward to textobj, similar to targets.vim
							lookahead = true,

							keymaps = {
								-- You can use the capture groups defined in textobjects.scm
								["af"] = "@function.outer",
								["if"] = "@function.inner",
								["ac"] = "@class.outer",
								-- You can optionally set descriptions to the mappings (used in the desc parameter of
								-- nvim_buf_set_keymap) which plugins like which-key display
								["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
								-- You can also use captures from other query groups like `locals.scm`
								["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
							},
							-- You can choose the select mode (default is charwise 'v')
							--
							-- Can also be a function which gets passed a table with the keys
							-- * query_string: eg '@function.inner'
							-- * method: eg 'v' or 'o'
							-- and should return the mode ('v', 'V', or '<c-v>') or a table
							-- mapping query_strings to modes.
							selection_modes = {
								['@parameter.outer'] = 'v', -- charwise
								['@function.outer'] = 'V', -- linewise
								['@class.outer'] = '<c-v>', -- blockwise
							},
							-- If you set this to `true` (default is `false`) then any textobject is
							-- extended to include preceding or succeeding whitespace. Succeeding
							-- whitespace has priority in order to act similarly to eg the built-in
							-- `ap`.
							--
							-- Can also be a function which gets passed a table with the keys
							-- * query_string: eg '@function.inner'
							-- * selection_mode: eg 'v'
							-- and should return true or false
							include_surrounding_whitespace = true,
						},
					},
				},

				indent = { -- use treesitter indentation
					enable = true
				}
			})
		end

	},

	{
		"nvim-treesitter/nvim-treesitter-textobjects",
	},

	"KarimElghamry/vim-auto-comment",
	"tpope/vim-surround",
	'tpope/vim-repeat',
	'HiPhish/rainbow-delimiters.nvim',
	'junegunn/fzf.vim',
	'nvim-tree/nvim-web-devicons',


	{
		'nvim-telescope/telescope-fzf-native.nvim',
		build = 'make'
	},

	{
		'nvim-telescope/telescope.nvim',
		dependencies = {"nvim-lua/plenary.nvim"},
		tag = "0.1.6",
		config = function()
			local telescope = require("telescope")

			telescope.setup({
				defaults = {
					layout_strategy = "flex",
				},
				extensions = {
					fzf = {
						fuzzy = true,                    -- false will only do exact matching
						override_generic_sorter = true,  -- override the generic sorter
						override_file_sorter = true,     -- override the file sorter
						case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					}
				},
			})

			local map = vim.keymap.set

			map('n', '<leader>tf', function() vim.cmd(":Telescope find_files") end, {})
			map('n', '<leader>tg', function() vim.cmd(":Telescope live_grep") end, {})
			map('n', '<leader>th', function() vim.cmd(":Telescope help_tags") end, {})
			map('n', '<leader>tb', function() vim.cmd(":Telescope buffers") end, {})

			telescope.load_extension('fzf')
		end
	},

	{
		"ggandor/leap.nvim",
		config = function()
			local leap = require("leap")
			local map = vim.keymap.set

			map('n',        's', '<Plug>(leap)')
			map('n',        'gs', '<Plug>(leap-from-window)')

			leap.opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }

		end

	},

	'LunarWatcher/auto-pairs',

	{
		"williamboman/mason.nvim",
		config = function()
			local mason = require("mason")
			mason.setup()
		end
	},

	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			local masonlsp = require("mason-lspconfig")
			masonlsp.setup({
				ensure_installed = LANGUAGE_SERVERS,
			})
		end
	},

	{
		'neovim/nvim-lspconfig',
		config = function()
			-- lsp:
			local lspconfig = require("lspconfig")

			-- setup default lsp configs

			for _, server in ipairs(LANGUAGE_SERVERS) do
				lspconfig[server].setup({})
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
					vim.keymap.set('n', '<leader>lgc', vim.lsp.buf.declaration, opts)
					vim.keymap.set('n', '<leader>lgf', vim.lsp.buf.definition, opts)
					vim.keymap.set('n', '<leader>li', vim.lsp.buf.hover, opts)
					vim.keymap.set('n', '<leader>lgt', vim.lsp.buf.type_definition, opts)
					vim.keymap.set('n', '<leader>lR', vim.lsp.buf.references, opts)
					vim.keymap.set('n', '<leader>lr', vim.lsp.buf.rename, opts)
					vim.keymap.set('n', '<leader>lF', function()
						vim.lsp.buf.format { async = true }
					end, opts)
				end
			}))
		end
	},

	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp"
	},

	'hrsh7th/cmp-nvim-lsp',
	'hrsh7th/cmp-buffer',
	'hrsh7th/cmp-path',
	'hrsh7th/cmp-cmdline',
	'saadparwaiz1/cmp_luasnip',

	{
		'hrsh7th/nvim-cmp',
		config = function()
			-- Set up nvim-cmp.
			local cmp = require'cmp'

			cmp.setup({
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
					['<C-b>'] = cmp.mapping.scroll_docs(-4),
					['<C-f>'] = cmp.mapping.scroll_docs(4),
					['<C-Space>'] = cmp.mapping.complete(),
					['<C-e>'] = cmp.mapping.abort(),
					['<TAB>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
				}),
				sources = cmp.config.sources({
					{ name = 'nvim_lsp' },
					-- { name = 'vsnip' }, -- For vsnip users.
					{ name = 'luasnip' }, -- For luasnip users.
					-- { name = 'ultisnips' }, -- For ultisnips users.
					-- { name = 'snippy' }, -- For snippy users.
					}, {
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
	},

	{ -- This plugin
		"Zeioth/compiler.nvim",
		cmd = {"CompilerOpen", "CompilerToggleResults", "CompilerRedo"},
		opts = {},
		dependencies = { "stevearc/overseer.nvim" },
		config = function()

			local map = vim.keymap.set
			-- Open compiler
			map('n', '<F6>', "<cmd>CompilerOpen<cr>", { noremap = true, silent = true })

			-- Redo last selected option
			map('n', '<S-F6>',
				"<cmd>CompilerStop<cr>" -- (Optional, to dispose all tasks before redo)
				.. "<cmd>CompilerRedo<cr>",
				{ noremap = true, silent = true })

			-- Toggle compiler results
			map('n', '<S-F7>', "<cmd>CompilerToggleResults<cr>", { noremap = true, silent = true })
		end
	},

	{
		"stevearc/overseer.nvim",
		commit = "68a2d344cea4a2e11acfb5690dc8ecd1a1ec0ce0",
		cmd = { "CompilerOpen", "CompilerToggleResults", "CompilerRedo" },
		opts = {
			task_list = {
				direction = "bottom",
				min_height = 25,
				max_height = 25,
				default_detail = 1
			},
		},
	},

	{
		"ggandor/flit.nvim",
		config = function()
			require('flit').setup()
		end
	},

	{ 
		"lukas-reineke/indent-blankline.nvim",
		main = "ibl",
		opts = {},
		config = function()
			local highlight = {
				"RainbowRed",
				"RainbowYellow",
				"RainbowBlue",
				"RainbowOrange",
				"RainbowGreen",
				"RainbowViolet",
				"RainbowCyan",
			}
			local hooks = require "ibl.hooks"
			-- create the highlight groups in the highlight setup hook, so they are reset
			-- every time the colorscheme changes
			hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
				vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
				vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
				vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
				vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
				vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
				vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
				vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
			end)

			vim.g.rainbow_delimiters = { highlight = highlight }
			require("ibl").setup { scope = { highlight = highlight } }

			hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
		end
	},

	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = { "markdown" },
		build = function() vim.fn["mkdp#util#install"]() end,
	},

	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		init = function()
			vim.o.timeout = true
			vim.o.timeoutlen = 300
		end,
		opts = {

		}
	}

	-- {
	-- 	"f3fora/cmp-spell",
	-- 	config = function()

	-- 		local cmp = require("cmp")

	-- 		cmp.setup({
	-- 			sources = {
	-- 				{
	-- 					name = 'spell',
	-- 					option = {
	-- 						keep_all_entries = false,
	-- 						enable_in_context = function()
	-- 							if(vim.bo.filetype == "md") then
	-- 								return true
	-- 							else
	-- 								return false
	-- 							end
	-- 						end,
	-- 					},
	-- 				},
	-- 			},
	-- 		})
	-- 	end
	-- }

})

-- OPTIONS:

-- Splitting:

vim.opt.splitbelow = true             -- when a new window splits vertically, split below
vim.opt.splitright = true             --when a new window splits horizontally, split to the right

-- Tabs:

vim.opt.tabstop = 4 -- make tab have 4 spaces and not 8 wtf vim
vim.opt.shiftwidth = 4

-- line numbers config

vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#ffb3b3', bold=true })
vim.api.nvim_set_hl(0, 'LineNr', { fg='white', bold=true })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#99ccff', bold=true })

vim.opt.clipboard = "unnamedplus"	-- use system clipboard

vim.opt.virtualedit = "block" -- enable virtual editing in block mode for more consistency

vim.opt.inccommand = "split" -- split the screen for preview after search and replace

vim.opt.ignorecase = true -- lowercase commands wooho

vim.opt.termguicolors = true -- better colors in modern terminals

vim.opt.smartindent = false -- disable this and use treesitter indentation instead 
vim.opt.autochdir = true

vim.opt.linebreak = true -- dont cut words in half when wrapping

vim.cmd('autocmd BufEnter * set formatoptions-=cro')  -- disable autocomments 
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')

-- markdown and latex tweaks
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
	pattern = {"*.md", "*.tex"},
	callback = function()
		vim.opt.spell = true
		vim.opt.spelllang = {"en_us", "pl"}
		vim.opt.wrap = true
 		vim.opt.textwidth = 80
	end
})
-- REMAPS: 

local map = vim.keymap.set

map('n', '<Space>', '<NOP>')

-- Remap x to use the black hole register
map('n', 'x', '"_x')

-- Remap d to use the black hole register
map('n', 'd', '"_d')
map('x', 'd', '"_d')

-- Remap dd to use the black hole register
map('n', 'dd', '"_dd')

-- Remap D to use the black hole register
map('n', 'D', '"_D')
map('x', 'D', '"_D')

-- Remap d to delete and leader d to cut
map('n', '<leader>d', 'd')
map('n', '<leader>dd', 'dd')
map('n', '<leader>D', 'D')
map('v', '<leader>d', 'd')
map('v', '<leader>D', 'D')

-- Remap leader p to delete and paste in visual mode
map('x', '<leader>p', '_dP')

-- Auto screen recentering on scroll
map('n', '<C-u>', '<C-u>zz')
map('n', '<C-d>', '<C-d>zz')

-- Move 1 more lines up or down in normal and visual selection modes
map('n', 'K', ':m .-2<CR>==')
map('n', 'J', ':m .+1<CR>==')
map('v', 'K', ':m \'<-2<CR>gv=gv')
map('v', 'J', ':m \'>+1<CR>gv=gv')

-- quick nohlsearch command
map('n', '<leader>nh', function() vim.cmd.nohlsearch() end)

-- quick :w
map('n', '<leader>w', function() vim.cmd.write() end)

-- markdown and latex remaps for better movement in wrapped lines
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
	pattern = {"*.md", "*.tex"},
	callback = function()
		map("n", "j", "gj")
		map("x", "j", "gj")
		map("n", "k", "gk")
		map("x", "k", "gk")
	end
})

-- VSCode fixes:

if vim.g.vscode == true then
	-- Keep undo/redo lists in sync with VSCode
	map("<silent>", 'u', "<Cmd>call VSCodeNotify('undo')<CR>")
	map("<silent>", "<C-r>", "<Cmd>call VSCodeNotify('redo')<CR>")
end

-- Enter insert mode at the correct indentation, by u/motboken

vim.cmd[[function! IndentWithI()
    if len(getline('.')) == 0
        return "\"_cc"
    else
        return "i"
    endif
endfunction
nnoremap <expr> i IndentWithI()]]

