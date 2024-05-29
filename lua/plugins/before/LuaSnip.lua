return {
	"L3MON4D3/LuaSnip",
	dependencies = { "rafamadriz/friendly-snippets" },
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp",
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load()
		local ls = require"luasnip"
		local s = ls.snippet
		local t = ls.text_node
		local i = ls.insert_node
		-- vim.print(vim.g.snippets)
		ls.add_snippets("tex", {
			s("imag", require("luasnip.extras.fmt").fmt(
				[[
				\begin{{figure}}[H]
					\centering
					\includegraphics[width=1\textwidth]{{images/{}}}
					\caption{{\centering{{{}}}}}
				\end{{figure}}
				]], { i(1, "path/to/image"), i(2, "Caption text") }
			))
		})


		vim.keymap.set({"i", "s"}, "<C-n>", function() ls.jump( 1) end, {silent = true})
		vim.keymap.set({"i", "s"}, "<C-m>", function() ls.jump(-1) end, {silent = true})
	end
}
