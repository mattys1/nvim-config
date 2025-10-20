return {
	"folke/trouble.nvim",
	opts = {
		modes = {
			test = {
				mode = "diagnostics",
				preview = {
					type = "split",
					relative = "win",
					position = "right",
					size = 0.3,
				},
			},
		},
	},
	cmd = "Trouble",
	keys = {
		{
			"<leader>ldt",
			"<cmd>Trouble test toggle<cr>",
			desc = "Diagnostics (Trouble)",
		},
	},
}
