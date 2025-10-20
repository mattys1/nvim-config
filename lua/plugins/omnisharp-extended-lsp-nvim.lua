return {
	"Hoffs/omnisharp-extended-lsp.nvim",
	config = function()
		local map = vim.keymap.set
		map('n', 'gd', '<cmd>lua require("omnisharp_extended").lsp_definition()<CR>', { noremap = true, silent = true })

		map('n', '<leader>D', '<cmd>lua require("omnisharp_extended").lsp_type_definition()<CR>', { noremap = true, silent = true })

		map('n', 'gr', '<cmd>lua require("omnisharp_extended").lsp_references()<CR>', { noremap = true, silent = true })

		map('n', 'gi', '<cmd>lua require("omnisharp_extended").lsp_implementation()<CR>', { noremap = true, silent = true })
	end
}
