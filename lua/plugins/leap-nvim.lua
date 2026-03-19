return {
	"https://codeberg.org/andyg/leap.nvim",
	config = function()
		local leap = require("leap")
		local map = vim.keymap.set
		map('n',        's', '<Plug>(leap)')
		map('n',        'gs', '<Plug>(leap-from-window)')
		map('v',        's', '<Plug>(leap)')
		map('v',        'gs', '<Plug>(leap-from-window)')
		leap.opts.equivalence_classes = { ' \t\r\n', '([{', ')]}', '\'"`' }

		-- do
		-- 	-- Return an argument table for `leap()`, tailored for f/t-motions.
		-- 	local function as_ft (key_specific_args)
		-- 		local common_args = {
		-- 			inputlen = 1,
		-- 			inclusive = true,
		-- 			-- To limit search scope to the current line:
		-- 			-- pattern = function (pat) return '\\%.l'..pat end,
		-- 			opts = {
		-- 				labels = '',  -- force autojump
		-- 				safe_labels = vim.fn.mode(1):match'[no]' and '' or nil,  -- [1]
		-- 			},
		-- 		}
		-- 		return vim.tbl_deep_extend('keep', common_args, key_specific_args)
		-- 	end
		--
		-- 	local clever = require('leap.user').with_traversal_keys        -- [2]
		-- 	local clever_f = clever('f', 'F')
		-- 	local clever_t = clever('t', 'T')
		--
		-- 	for key, key_specific_args in pairs {
		-- 		f = { opts = clever_f, },
		-- 		F = { backward = true, opts = clever_f },
		-- 		t = { offset = -1, opts = clever_t },
		-- 		T = { backward = true, offset = 1, opts = clever_t },
		-- 	} do
		-- 		vim.keymap.set({'n', 'x', 'o'}, key, function ()
		-- 			require('leap').leap(as_ft(key_specific_args))
		-- 		end)
		-- 	end
		-- end
	end
}
