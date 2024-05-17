-- GLOBALS:

vim.g.mapleader = ' '
vim.g.netrw_keepdir = true

LANGUAGE_SERVERS = {"lua_ls", "pyright", "clangd", "bashls", "marksman",} -- this is a shitty patchwork fix for automatically configuring all language servers, this probably shoul have its own file


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
							enable = true, -- broken, i think it doenst recognize what a class and function is maybe fuck me 
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

	{
		"terrortylor/nvim-comment",
		config = function()
			require('nvim_comment').setup({})
		end
	},

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
				pickers = {
					find_files = {
						hidden = true
					},
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
			map('v',        's', '<Plug>(leap)')
			map('v',        'gs', '<Plug>(leap-from-window)')

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
		end
	},

	{
		"L3MON4D3/LuaSnip",
		-- follow latest release.
		version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
		-- install jsregexp (optional!).
		build = "make install_jsregexp",

		config = function()
			vim.keymap.set({"i", "s"}, "<C-j>", function() ls.jump( 1) end, {silent = true})
			vim.keymap.set({"i", "s"}, "<C-k>", function() ls.jump(-1) end, {silent = true})
		end

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
		'stevearc/oil.nvim',
		opts = {},
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				default_file_explorer = true,
				delete_to_trash = true,

				view_options = {
					show_hidden = true,
					natural_order = true,
				},

				float = {
					padding = 3,
				}
			})


			vim.keymap.set("n", "<leader>fm", "<CMD>Oil --float<CR>", { desc = "Open parent directory" })
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
	},

	{
		"mfussenegger/nvim-dap",
		config = function()
			local map = vim.keymap.set

			map("n", "<leader>db", "<CMD> DapToggleBreakpoint <CR>")
			map("n", "<leader>dr", "<CMD> DapContinue <CR>")
		end
	},

	{
		"jay-babu/mason-nvim-dap.nvim",
		event = "VeryLazy",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		opts = {
		},
		config = function()
			local masonNvimDap = require("mason-nvim-dap")
			masonNvimDap.setup({
				handlers = {},

				ensure_installed = {
					"codelldb",
				},

				auto_install = true

			})
		end
	},

	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")

			dapui.setup()
			
			-- config when ui will open and close
			dap.listeners.after.event_initialized.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			local map = vim.keymap.set

			map("n", "<leader>dc", function()
				dap.disconnect()
				dapui.close()
			end)
		end
	},

	{
		"theHamsta/nvim-dap-virtual-text",
		dependencies = {
			"mfussenegger/nvim-dap",
			"nvim-treesitter/nvim-treesitter",
		},

		config = function()
			require("nvim-dap-virtual-text").setup {
				enabled = true,                        -- enable this plugin (the default)
				enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
				highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
				highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
				show_stop_reason = true,               -- show stop reason when stopped for exceptions
				commented = true,                     -- prefix virtual text with comment string
				only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
				all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
				clear_on_continue = false,             -- clear virtual text on "continue" (might cause flickering when stepping)
				--- A callback that determines how a variable is displayed or whether it should be omitted
				--- @param variable Variable https://microsoft.github.io/debug-adapter-protocol/specification#Types_Variable
				--- @param buf number
				--- @param stackframe dap.StackFrame https://microsoft.github.io/debug-adapter-protocol/specification#Types_StackFrame
				--- @param node userdata tree-sitter node identified as variable definition of reference (see `:h tsnode`)
				--- @param options nvim_dap_virtual_text_options Current options for nvim-dap-virtual-text
				--- @return string|nil A text how the virtual text should be displayed or nil, if this variable shouldn't be displayed
				display_callback = function(variable, buf, stackframe, node, options)
					if options.virt_text_pos == 'inline' then
						return ' = ' .. variable.value
					else
						return variable.name .. ' = ' .. variable.value
					end
				end,
				-- position of virtual text, see `:h nvim_buf_set_extmark()`, default tries to inline the virtual text. Use 'eol' to set to end of line
				virt_text_pos = vim.fn.has 'nvim-0.10' == 1 and 'inline' or 'eol',

				-- experimental features:
				all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
				virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
				virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
				-- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
			}
		end
	},

	{
		"ThePrimeagen/harpoon",
		branch = "harpoon2",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-telescope/telescope.nvim",
		},
		
		config = function()
			local harpoon = require("harpoon")

			-- REQUIRED
			harpoon:setup()
			local conf = require("telescope.config").values
			local function toggle_telescope(harpoon_files)
				local file_paths = {}
				for _, item in ipairs(harpoon_files.items) do
					table.insert(file_paths, item.value)
				end

				require("telescope.pickers").new({}, {
					prompt_title = "Harpoon",
					finder = require("telescope.finders").new_table({
						results = file_paths,
					}),
					previewer = conf.file_previewer({}),
					sorter = conf.generic_sorter({}),
				}):find()
			end

			vim.keymap.set("n", "<leader>hm", function() toggle_telescope(harpoon:list()) end,
				{ desc = "Open harpoon window" })

			-- REQUIRED

			vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end)
			-- vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

			vim.keymap.set("n", "<leader>1", function() harpoon:list():select(1) end)
			vim.keymap.set("n", "<leader>2", function() harpoon:list():select(2) end)
			vim.keymap.set("n", "<leader>3", function() harpoon:list():select(3) end)
			vim.keymap.set("n", "<leader>4", function() harpoon:list():select(4) end)

			-- Toggle previous & next buffers stored within Harpoon list
			vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
			vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)
		end
	},

	{
		"lervag/vimtex",
		lazy = false,     -- we don't want to lazy load VimTeX
		-- tag = "v2.15", -- uncomment to pin to a specific release
		init = function()
			vim.g.vimtex_view_method = "zathura"
			vim.g.maplocalleader = " "
		end
	},

})

-- OPTIONS:

-- force english
vim.cmd("language en_GB.utf-8")

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

-- same thing with c
map('x', 'c', '"_c')
map('n', 'c', '"_c')

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

-- quick :w
map('n', '<leader>w', function() vim.cmd.write() end)

--quick :q!
map('n', '<leader>q', function() vim.cmd(":q!") end)

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

vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})
