return {
	"jay-babu/mason-nvim-dap.nvim",
	event = "VeryLazy",
	dependencies = {
		"williamboman/mason.nvim",
		"mfussenegger/nvim-dap",
	},
	opts = {
	},
	config = function()
		local masonNvimDap = require("mason-nvim-dap")
		masonNvimDap.setup({
			handlers = {},
			ensure_installed = {
				"codelldb",
			},
			auto_install = true
		})
	end
}
