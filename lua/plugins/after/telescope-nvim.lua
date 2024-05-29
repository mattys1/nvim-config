return {
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
		map('n', '<leader>tf', function()
			local root = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "")
			if vim.v.shell_error == 0 then
				require("telescope.builtin").find_files({ cwd = root })
			else
				require("telescope.builtin").find_files()
			end
		end, {})
		map('n', '<leader>tg', function()
			local root = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "")
			if vim.v.shell_error == 0 then
				require("telescope.builtin").live_grep({ cwd = root })
			else
				require("telescope.builtin").live_grep()
			end
		end, {})
		map('n', '<leader>th', function() vim.cmd(":Telescope help_tags") end, {})
		map('n', '<leader>tb', function() vim.cmd(":Telescope buffers") end, {})
		telescope.load_extension('fzf')
	end
}
