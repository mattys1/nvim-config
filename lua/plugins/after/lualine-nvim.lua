return {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
	config = function()
		local catppuccin_background = require('lualine.themes.catppuccin-mocha')
		catppuccin_background.normal.c.bg = '#181825'
		require('lualine').setup({
			options = { theme = catppuccin_background },
		})
	end
}
