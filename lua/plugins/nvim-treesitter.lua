local disabledFiletypes = { }

return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	-- branch = "master",
	-- version = "0.10.0",
	opts = {
		auto_install = true
	},
	config = function()
		vim.opt.tabstop = 4
		vim.opt.shiftwidth = 4

		local ts = require'nvim-treesitter'

		ts.install {'lua', 'rust'}

		vim.api.nvim_create_autocmd('FileType', {
		  pattern = { '<filetype>' },
		  callback = function(event)
				vim.wo[0][0].foldexpr = 'v:lua.vim.treesitter.foldexpr()'
				vim.wo[0][0].foldmethod = 'expr'
				vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

				local ft = event.match
				local lang = vim.treesitter.language.get_lang(ft)

				if lang ~= nil then
					ts.install({ lang })
				end
		  end,
		})
		vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
			pattern = "*.*",
			callback = function()
				vim.treesitter.start()
			end
		})

	end
}
