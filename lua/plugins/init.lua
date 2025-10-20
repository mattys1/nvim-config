local plugDir = vim.tbl_filter(function(path)
	return not path:match("init%.lua$")
end, vim.api.nvim_get_runtime_file("lua/plugins/*.lua", true));

local plugins = {}

for _, plug in ipairs(plugDir) do
	-- vim.print(plug)
	table.insert(plugins, require(plug:match("lua/(.-)%.lua$"):gsub("/", ".")
))
end

-- vim.print(earlyPlugsContents)

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
		plugins,
	}, {
		rocks = {
			hererocks = true,  -- recommended if you do not have global installation of Lua 5.1.
		}
	}
)

