local disabledFiletypes = { }

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		vim.opt.tabstop = 4
		vim.opt.shiftwidth = 4
		require("nvim-treesitter.configs").setup({
			ensure_installed = {"c", "cpp", "lua", "vim", "vimdoc", "query", "python", "markdown", "asm", "latex", "bash"},
			ignore_install = { 'org' },
			auto_install = true,
			highlight = {
				enable = true,
				disable = disabledFiletypes
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
				enable = true,
				disabledFiletypes = disabledFiletypes,
			}
		})
	end
}
