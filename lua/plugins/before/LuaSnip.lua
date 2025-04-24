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
		local lsextras = require"luasnip.extras"

		local s = ls.snippet
		local t = ls.text_node
		local i = ls.insert_node
		local fmt = require("luasnip.extras.fmt").fmt
		local rep = lsextras.rep
		-- vim.print(vim.g.snippets)
		ls.add_snippets("tex", {
			s("imag", fmt(
				[[
				\begin{{figure}}[H]
					\centering
					\includegraphics[width=1\textwidth]{{images/{}}}
					\caption{{\centering{{{}}}}}
				\end{{figure}}
				]], { i(1, "path/to/image"), i(2, "<CAPTION_TEXT>") }
			))
		})

		ls.add_snippets("tex", {
			s("limag", fmt(
				[[
				\begin{{figure}}[H]
					\centering
					\includegraphics[width=1\textwidth]{{images/{}}}
					\caption{{\centering{{{}}}}}
					\label{{fig:{}}}
				\end{{figure}}
				]], { i(1, "path/to/image"), i(2, "<CAPTION_TEXT>"), i(3, "<FIGURE_NAME>") }
			))
		})

		ls.add_snippets("tex", {
			s("lst", fmt(
				[[
				\begin{{lstlisting}}[language={}, caption={{{}}}] 
				{}
				\end{{lstlisting}}
				]], { i(1, "text"), i(2, "<CAPTION>"), i(3, "<CONTENTS>") }
			))
		})

		ls.add_snippets("tex", {
			s("sss", fmt(
				[[
					\somestuffstyle{{{}}}
				]], { i(1, "<TEXT>") }
			))
		})

		ls.add_snippets("tex", {
			s("ttt", fmt(
				[[
					\texttt{{{}}}
				]], { i(1, "<TEXT>") }
			))
		})

		ls.add_snippets("bib", {
			s("onl", fmt(
				[[
					@online(
						{},
						title = {{{}}},
						url = {{{}}},
					)
				]], { i(1, "<CITE_NAME>"), i(2, "<TITLE>"), i(3, "<URL>") }
			))
		})


		-- ls.add_snippets({"cpp", "c", "h"}, {
		-- 	s("#dfhg", fmt(
		-- 		[[
		-- 			#ifndef {}
		-- 				#define {}
		-- 			#endif
		-- 		]], { i(1, "VAL"), rep(1) }
		-- 	))
		-- })

		vim.keymap.set({"i", "s"}, "<C-n>", function() ls.jump( 1) end, {silent = true})
		vim.keymap.set({"i", "s"}, "<C-m>", function() ls.jump(-1) end, {silent = true})
	end
}
