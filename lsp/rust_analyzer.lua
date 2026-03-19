return {
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
				extraArgs = { "--", "-W", "clippy::pedantic", "-A", "clippy::single_match_else" },
			},
		},
	},
}

