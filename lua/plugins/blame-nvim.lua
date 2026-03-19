return {
  {
    "FabijanZulj/blame.nvim",
    lazy = false,
    config = function()
		local map = vim.keymap.set
		map("n", "<leader>gbl", "<cmd>BlameToggle<cr>")
		require('blame').setup {}
    end,
  },
}
