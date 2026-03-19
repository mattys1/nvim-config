return {
    "nvim-neorg/neorg",
    lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
    version = "*", -- Pin Neorg to the latest stable release
	-- config = true,
	depencencies = {
		"nvim-treesitter/nvim-treesitter",
	},

	config = function ()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {},
				["core.completion"] = {config = {
					engine = "nvim-cmp"
				}},
				["core.latex.renderer"] = {}
			}
		})

		vim.keymap.set('n', '<localleader>ot', '<cmd>Neorg toc<CR>')
	end
}
