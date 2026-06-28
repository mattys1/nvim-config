return {
	settings = {
		["rust-analyzer"] = {
			check = {
				command = "clippy",
				extraArgs = { "--", "-W", "clippy::pedantic", "-A", "clippy::single_match_else", "-A", "clippy::missing_errors_doc", "-A", "clippy::too_many_lines", "-A", "clippy::must_use_candidate"},
			},
		},
	},
}

