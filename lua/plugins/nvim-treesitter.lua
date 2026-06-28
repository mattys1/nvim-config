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

		local ts = require("nvim-treesitter")

		ts.install({ "lua", "rust" })

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "*.*",
			callback = function(event)
				vim.wo[event.buf].foldexpr = "v:lua.vim.treesitter.foldexpr()"
				vim.wo[event.buf].foldmethod = "expr"
				vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

				local ft = event.match
				local lang = vim.treesitter.language.get_lang(ft)

				if lang ~= nil then
					ts.install({ lang })
				end
			end,
		})

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
			pattern = "*.*",
			callback = function(args)
				local buf = args.buf
				local ft = vim.bo[buf].filetype
				if ft == nil or ft == "" then
					return
				end

				local lang = vim.treesitter.language.get_lang(ft)
				if lang == nil then
					return
				end

				pcall(vim.treesitter.start, buf, lang)
			end,
		})
	end
}
