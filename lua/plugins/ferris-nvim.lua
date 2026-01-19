return {
    'vxpm/ferris.nvim',
    opts = {
		url_handler = "xdg-open",
		create_commands = true
    },

	config = function()
		local map = vim.keymap.set
		map("n", "<leader>frem", require("ferris.methods.expand_macro"), { desc = "Expand Macro" })
		map("n", "<leader>frjl", require("ferris.methods.join_lines"), { desc = "Join Lines" })
		map("n", "<leader>frvh", require("ferris.methods.view_hir"), { desc = "View HIR" })
		map("n", "<leader>frvm", require("ferris.methods.view_mir"), { desc = "View MIR" })
		map("n", "<leader>frvml", require("ferris.methods.view_memory_layout"), { desc = "View Memory Layout" })
		map("n", "<leader>frvit", require("ferris.methods.view_item_tree"), { desc = "View Item Tree" })
		map("n", "<leader>frvst", require("ferris.methods.view_syntax_tree"), { desc = "View Syntax Tree" })
		map("n", "<leader>froct", require("ferris.methods.open_cargo_toml"), { desc = "Open Cargo.toml" })
		map("n", "<leader>fropm", require("ferris.methods.open_parent_module"), { desc = "Open Parent Module" })
		map("n", "<leader>frod", require("ferris.methods.open_documentation"), { desc = "Open Documentation" })
		map("n", "<leader>frrw", require("ferris.methods.reload_workspace"), { desc = "Reload Workspace" })
		map("n", "<leader>frrm", require("ferris.methods.rebuild_macros"), { desc = "Rebuild Macros" })
	end,
}
