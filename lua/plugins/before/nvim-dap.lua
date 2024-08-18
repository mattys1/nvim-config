return {
	"mfussenegger/nvim-dap",
	config = function()
		-- gdb support
		local dap = require('dap')
		dap.adapters.cppdbg = {
			id = 'cppdbg',
			type = 'executable',
			command = '/home/mattys/gdb/extension/debugAdapters/bin/OpenDebugAD7',
		}

		dap.configurations.cpp = {
			{
				name = "Launch file",
				type = "cppdbg",
				request = "launch",
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
				cwd = '${workspaceFolder}',
				stopAtEntry = true,
			},
			{
				name = 'Attach to gdbserver :1234',
				type = 'cppdbg',
				request = 'launch',
				MIMode = 'gdb',
				miDebuggerServerAddress = 'localhost:1234',
				miDebuggerPath = '/usr/bin/gdb',
				cwd = '${workspaceFolder}',
				program = function()
					return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
				end,
			},
		}

		--remaps
		local map = vim.keymap.set
		map("n", "<leader>db", "<CMD> DapToggleBreakpoint <CR>")
		map("n", "<leader>dr", "<CMD> DapContinue <CR>")
	end
}
