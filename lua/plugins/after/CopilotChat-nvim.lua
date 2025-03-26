return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim", branch = "master" },
		{ "nvim-telescope/telescope.nvim" }
	},
	build = "make tiktoken",
	opts = {

	},

	config = function()
		require("CopilotChat").setup({
			model = "claude-3.7-sonnet-thought"
		})
	end,
}
