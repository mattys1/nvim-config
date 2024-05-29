return {
	"lervag/vimtex",
	lazy = false,     -- we don't want to lazy load VimTeX
	-- tag = "v2.15", -- uncomment to pin to a specific release
	init = function()
		vim.g.vimtex_view_method = "zathura"
		vim.g.maplocalleader = "\\"
		vim.g.vimtex_compiler_method = "xelatex"
		vim.g.tex_flavor='xelatex'
		vim.g.vimtex_complete_envs = 1
		vim.g.vimtex_complete_close_brackets = 1
		vim.g.vimtex_complete_enabled = 1
	end
}
