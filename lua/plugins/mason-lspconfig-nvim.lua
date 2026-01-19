return {
	"mason-org/mason-lspconfig.nvim",
	dependencies = {
		{ "mason-org/mason.nvim", opts = {
			registries = {
				"github:mason-org/mason-registry",
				"github:Crashdummyy/mason-registry",
			}
		} },
		"neovim/nvim-lspconfig",
	},
	opts = {
		ensure_installed = {
			"lua_ls",
			"pyright",
			"clangd",
			"bashls",
			"marksman",
			"texlab",
			"yamlls",
			"cmake",
			"html",
			"cssls",
			"rust_analyzer",
			"cssmodules_ls",
			"css_variables",
			"tailwindcss",
			"ts_ls",
			-- "eslint",
			"dockerls",
			"docker_compose_language_service",
			"gopls",
			-- "omnisharp",
			"jsonls",
			"sqls",
			"groovyls",
			-- "rzls"
			-- "matlab_ls"
		},
	}
}
