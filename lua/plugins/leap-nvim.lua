return {
	"ggandor/leap.nvim",
	config = function()
		local leap = require("leap")
		local map = vim.keymap.set
		map('n',        's', '<Plug>(leap)')
		map('n',        'gs', '<Plug>(leap-from-window)')
		map('v',        's', '<Plug>(leap)')
		map('v',        'gs', '<Plug>(leap-from-window)')
		leap.opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }
	end
}
