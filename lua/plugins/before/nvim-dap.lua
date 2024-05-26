return {
	"mfussenegger/nvim-dap",
	config = function()
		local map = vim.keymap.set
		map("n", "<leader>db", "<CMD> DapToggleBreakpoint <CR>")
		map("n", "<leader>dr", "<CMD> DapContinue <CR>")
	end
}
