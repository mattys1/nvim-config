return {
	"CopilotC-Nvim/CopilotChat.nvim",
	dependencies = {
		{ "zbirenbaum/copilot.lua" },
		{ "nvim-lua/plenary.nvim", branch = "master" },
		{ "nvim-telescope/telescope.nvim" }
	},
	build = "make tiktoken",
	opts = {
		model = "claude-3.7-sonnet-thought",
		prompts = {
			BufferInfo = {
				system_prompt = '> #buffer\n> #diagnostics',
			}
		}
	},

	config = function()
		vim.keymap.set({"n", "v"}, "<leader>cpc", "<cmd>CopilotChat<cr>", { noremap = true, silent = true })
	end,
}
