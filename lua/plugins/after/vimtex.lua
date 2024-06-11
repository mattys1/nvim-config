return {
	"lervag/vimtex",
	lazy = false,     -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	init = function()
		vim.g.vimtex_view_method = "zathura_simple"
		vim.g.maplocalleader = "\\"
		-- vim.g.vimtex_compiler_method = "xelatex"
		vim.g.tex_flavor='pdflatex'
		vim.g.vimtex_complete_envs = 1
		vim.g.vimtex_complete_close_brackets = 1
		vim.g.vimtex_complete_enabled = 1

		vim.g.vimtex_quickfix_ignore_filters = {
		  'Overfull',
		  'Underfull'
		}

		-- sync zathura with cursor position
		vim.api.nvim_create_autocmd("CursorMoved", {
			group = vim.api.nvim_create_augroup("CursorMovedGroup", { clear = true }),
			callback = function()
				if vim.bo.filetype == "tex" then
					vim.cmd(":VimtexView")
				end
			end,
		})
	end

}
