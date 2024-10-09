return {
	"williamboman/mason-lspconfig.nvim",
	config = function()
		local masonlsp = require("mason-lspconfig")
		masonlsp.setup({
			ensure_installed = LANGUAGE_SERVERS,
		})
	end
}
