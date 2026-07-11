return {
  "nickjvandyke/opencode.nvim",
  version = "*", -- Latest stable release
  dependencies = {
    {
      -- `snacks.nvim` integration is recommended, but optional
      ---@module "snacks" <- Loads `snacks.nvim` types for configuration intellisense
      "folke/snacks.nvim",
      optional = true,
      opts = {
		input = {}, -- Enhances `ask()`
		picker = { -- Enhances `select()`
			actions = {
				opencode_send = function(...) return require("opencode").snacks_picker_send(...) end,
			},
			win = {
				input = {
					keys = {
						["<a-a>"] = { "opencode_send", mode = { "n", "i" } },
					},
				},
			},
		},
	},
},
  },
  config = function()
	  local opencode_cmd = 'opencode --port'

	  ---@type snacks.terminal.Opts
	  local snacks_terminal_opts = {
		  win = {
			  position = 'right',
			  enter = false,
		  },
	  }
	  ---@type opencode.Opts
	  vim.g.opencode_opts = {
		  server = {
			  start = function()
				  require('snacks.terminal').open(opencode_cmd, snacks_terminal_opts)
			  end,
		  },
		  events = {
			  permissions = {
				  edits = {
					  enabled = false,
				  },
			  },
		  },
	  }
	  vim.o.autoread = true -- Required for `opts.events.reload`

	  -- Recommended/example keymaps
	  vim.keymap.set({ "n", "x" }, "<leader>oca", function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…" })
	  vim.keymap.set({ "n", "x" }, "<leader>oce", function() require("opencode").select() end,                          { desc = "Execute opencode action…" })
	  vim.keymap.set({ "n", "t" }, "<leader>oct", function()
		  require('snacks.terminal').toggle(opencode_cmd, snacks_terminal_opts)
	  end, { desc = "Toggle opencode" })

	  vim.keymap.set({ "n", "x" }, "gocr",  function() return require("opencode").operator("@this ") end,        { desc = "Add range to opencode", expr = true })
	  vim.keymap.set("n",          "gocl", function() return require("opencode").operator("@this ") .. "_" end, { desc = "Add line to opencode", expr = true })

	  vim.keymap.set("n", "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" })
	  vim.keymap.set("n", "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" })

	  vim.keymap.set("n", "+", "<C-a>", { desc = "Increment under cursor", noremap = true })
	  vim.keymap.set("n", "-", "<C-x>", { desc = "Decrement under cursor", noremap = true })
  end,
}
