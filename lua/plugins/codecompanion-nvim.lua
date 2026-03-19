return {
	"olimorris/codecompanion.nvim",
	version = "^19.0.0",
	opts = {},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-treesitter/nvim-treesitter",
		"ravitemer/codecompanion-history.nvim",
	},

	config = function()
		local map = vim.keymap.set
		map({"n", "v"}, "<leader>ccc", "<cmd>CodeCompanionChat Toggle<cr>")
		require("codecompanion").setup({
			extensions = {
				history = {
					enabled = true, -- defaults to true
					opts = {
						dir_to_save = vim.fn.stdpath("data") .. "/codecompanion_chats.json",
					}
				}
			}
		})

	end,
}
