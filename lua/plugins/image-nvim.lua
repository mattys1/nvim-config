return {
	"3rd/image.nvim",
	branch = "master",
	opts = {},
	config = function()
		require("image").setup({
			-- tmux_show_only_in_active_window = true, -- auto show/hide images in the correct Tmux window (needs visual-activity off)
		})
	end,
}
