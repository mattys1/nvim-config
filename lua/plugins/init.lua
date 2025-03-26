local earlyPlugs = vim.api.nvim_get_runtime_file("lua/plugins/before/*.lua", true)
local earlyPlugsContents = {}

for _, plug in ipairs(earlyPlugs) do
	-- vim.print(plug)
	table.insert(earlyPlugsContents, require(plug:match("lua/(.-)%.lua$"):gsub("/", ".")
))
end

-- vim.print(earlyPlugsContents)

local latePlugs = vim.api.nvim_get_runtime_file("lua/plugins/after/*.lua", true)
local latePlugsContents = {}

for _, plug in ipairs(latePlugs) do
	-- vim.print(plug)
	-- vim.print(require(plug:match("lua/(.-)%.lua$"):gsub("/", ".")))
	-- vim.print(latePlugsContents)
	table.insert(latePlugsContents, require(plug:match("lua/(.-)%.lua$"):gsub("/", ".")
))
end

local superEarlyPlugs = vim.api.nvim_get_runtime_file("lua/plugins/super_before/*.lua", true)
local superEarlyPlugsContents = {}

for _, plug in ipairs(superEarlyPlugs) do
	-- vim.print(plug)
	-- vim.print(require(plug:match("lua/(.-)%.lua$"):gsub("/", ".")))
	-- vim.print(superEarlyPlugsContents)
	table.insert(superEarlyPlugsContents, require(plug:match("lua/(.-)%.lua$"):gsub("/", ".")
))
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)
require("lazy").setup(
	{
		superEarlyPlugsContents,
		earlyPlugsContents,
		latePlugsContents,
	}, {
		rocks = {
			hererocks = true,  -- recommended if you do not have global installation of Lua 5.1.
		}
	}
)

