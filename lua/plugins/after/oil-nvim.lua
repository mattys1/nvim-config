return {
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
}
