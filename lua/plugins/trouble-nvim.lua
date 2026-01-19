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
				filter = function(items)
					return vim.tbl_filter(function(item)
						return not string.match(item.basename, [[%__virtual.cs$]])
					end, items)
				end,
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
