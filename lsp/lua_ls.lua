return {
	settings = {
		Lua = {
			diagnostics = {
				globals = {"vim"}, -- recognize `vim` global
			},
			workspace = {
				-- Make the server aware of Neovim runtime files and plugins (stole this from reddit not sure what it does)
				checkThirdParty = false,
				library = {
					vim.env.VIMRUNTIME,
				},
			},
			telemetry = {
				enable = false, -- thanks mr. luaberg
			},
		},
	},
}
