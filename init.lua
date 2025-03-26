-- GLOBALS:

vim.g.mapleader = ' '
vim.g.netrw_keepdir = true
-- vim.g.loaded_netrwPlugin = false

-- hack cause terminal background transparency doesn't work without it
-- vim.cmd(
-- 	[[
-- 	augroup Catpuccin
-- 	autocmd!
-- 	autocmd ColorScheme * highlight Normal guibg=NONE ctermbg=NONE
-- 	autocmd ColorScheme * highlight NonText guibg=NONE ctermbg=NONE
-- 	augroup END
-- 	]]
-- )

-- PLUGINS:
require("plugins")
-- force english
-- vim.cmd("language en_GB.utf-8")

-- Splitting:

vim.opt.splitbelow = true             -- when a new window splits vertically, split below
vim.opt.splitright = true             --when a new window splits horizontally, split to the right

-- Tabs:

vim.opt.tabstop = 4 -- make tab have 4 spaces and not 8 wtf vim
vim.opt.shiftwidth = 4

-- line numbers config

vim.opt.number = true
vim.opt.relativenumber = true
vim.api.nvim_set_hl(0, 'LineNrAbove', { fg='#ffb3b3', bold=true })
vim.api.nvim_set_hl(0, 'LineNr', { fg='white', bold=true })
vim.api.nvim_set_hl(0, 'LineNrBelow', { fg='#99ccff', bold=true })

vim.opt.clipboard = "unnamedplus"	-- use system clipboard

vim.opt.virtualedit = "block" -- enable virtual editing in block mode for more consistency

vim.opt.inccommand = "split" -- split the screen for preview after search and replace

vim.opt.ignorecase = true -- lowercase commands wooho

vim.opt.termguicolors = true -- better colors in modern terminals

vim.opt.smartindent = false -- disable this and use treesitter indentation instead 
vim.opt.autochdir = true

vim.opt.linebreak = true -- dont cut words in half when wrapping
vim.opt.breakindent = true

vim.cmd('autocmd BufEnter * set formatoptions-=cro')  -- disable autocomments 
vim.cmd('autocmd BufEnter * setlocal formatoptions-=cro')

-- markdown and latex tweaks
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
	pattern = {"*.md", "*.tex"},
	callback = function()
		vim.opt.spell = true
		vim.opt.spelllang = {"en_us", "pl"}
		-- vim.opt.wrap = true
		vim.opt.textwidth = 80
		vim.cmd[[
			call pencil#init()
		]]
	end
})
-- REMAPS: 

local map = vim.keymap.set

map('n', '<Space>', '<NOP>')

-- Remap x to use the black hole register
map('n', 'x', '"_x')

-- Remap d to use the black hole register
map('n', 'd', '"_d')
map('x', 'd', '"_d')

-- Remap dd to use the black hole register
map('n', 'dd', '"_dd')

-- Remap D to use the black hole register
map('n', 'D', '"_D')
map('x', 'D', '"_D')

-- same thing with c
map('x', 'c', '"_c')
map('n', 'c', '"_c')

-- Remap d to delete and leader d to cut
map('n', '<leader>d', 'd')
map('n', '<leader>dd', 'dd')
map('n', '<leader>D', 'D')
map('v', '<leader>d', 'd')
map('v', '<leader>D', 'D')

-- Auto screen recentering on scroll
map('n', '<C-u>', '<C-u>zz')
map('n', '<C-d>', '<C-d>zz')

-- Move 1 more lines up or down in normal and visual selection modes
map('n', 'K', ':m .-2<CR>==')
map('n', 'J', ':m .+1<CR>==')
map('v', 'K', ':m \'<-2<CR>gv=gv')
map('v', 'J', ':m \'>+1<CR>gv=gv')

-- quick :w
map('n', '<leader>w', function() vim.cmd.write() end)

--quick :q!
map('n', '<leader>q', function() vim.cmd(":q!") end)

map('n', '<leader>ldq', function()
	vim.diagnostic.setloclist({ open = true })
end)

-- fuck
vim.keymap.set('n', '<leader>pi', ':PastifyAfter<CR>')

-- markdown and latex remaps for better movement in wrapped lines
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
pattern = {"*.md", "*.tex"},
callback = function()
	map("n", "j", "gj")
	map("x", "j", "gj")
	map("n", "k", "gk")
	map("x", "k", "gk")
	map("n", "zn", "]s1z=")
	-- map({"i", 'v'}, "<ESC>", "<ESC>gqap")
end
})

-- VSCode fixes:

if vim.g.vscode == true then
	-- Keep undo/redo lists in sync with VSCode
	map("<silent>", 'u', "<Cmd>call VSCodeNotify('undo')<CR>")
	map("<silent>", "<C-r>", "<Cmd>call VSCodeNotify('redo')<CR>")
end

-- Enter insert mode at the correct indentation, by u/motboken

vim.cmd[[function! IndentWithI()
if len(getline('.')) == 0
return "\"_cc"
else
return "i"
endif
endfunction
nnoremap <expr> i IndentWithI()]]

vim.api.nvim_create_autocmd('TextYankPost', {
	desc = 'Highlight when yanking (copying) text',
	group = vim.api.nvim_create_augroup('highlight-yank', { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- set ctags if there are any

if vim.fn.filereadable("./tags") == 1 then
	vim.opt.tags = "./tags"
end
