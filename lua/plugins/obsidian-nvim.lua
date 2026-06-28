return {
	"obsidian-nvim/obsidian.nvim",
	version = "*", -- use latest release, remove to use latest commit
	---@module 'obsidian'
	---@type obsidian.config
	opts = {
		legacy_commands = false, -- this will be removed in 4.0.0
		workspaces = {
			-- {
				--   name = "personal",
				--   path = "~/vaults/personal",
				-- },
				-- {
					--   name = "work",
					--   path = "~/vaults/work",
					-- },

					{
						name = "raptordb",
						path = "~/skrypty-i-syfy/studia/inzynierka/raptorDBPraca/obsidian/RaptorDB"
					},
				},
				picker = {
					-- name = "snacks.picker", -- use snacks picker
					name = "telescope.nvim",   -- or telescope
					-- name = "fzf-lua",     -- or fzf-lua
					-- name = "mini.pick",   -- or mini.pick
				},
			},
		}

