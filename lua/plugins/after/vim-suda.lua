return {
	"lambdalisue/vim-suda",
	config = function()
		vim.cmd([[
		let g:suda_smart_edit = 1
		let g:suda#noninteractive = 1
		]])
	end
}
