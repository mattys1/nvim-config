return {
	"nvim-java/nvim-java",
	dependencies = {
		"williamboman/mason.nvim",
	},
	config = function()
		require('java').setup({
		})
	end
}
