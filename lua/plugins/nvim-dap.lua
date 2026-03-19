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
		dap.adapters.codelldb = {
			type = 'server',
			port = "${port}",
			executable = {
				command = '/usr/bin/codelldb',
				args = {"--port", "${port}"},
			}
		}

		dap.configurations.rust = {
			{
				name = "Rust debug",
				showDisassembly = "never",
				type = "codelldb",
				request = "launch",
				program = function()
					vim.fn.jobstart('cargo test --no-run')
					return vim.fn.input('Path to executable: ', string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", "") .. '/target/debug/raptordb', 'file')
				end,
				cwd = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", ""),
				stopOnEntry = true,
			},

			{
				name = "Rust debug tests",
				showDisassembly = "never",
				type = "codelldb",
				request = "launch",
				program = function()
					local output = vim.fn.systemlist('cargo test --no-run')
					local last_line = output[#output]
					local parts = vim.split(last_line, " ")
					vim.print(parts)

					local path = parts[6]
					if path:sub(1, 1) == "(" then
						path = path:sub(2)
					end
					if path:sub(-1) == ")" then
						path = path:sub(1, -2)
					end

					return path
				end,
				cwd = string.gsub(vim.fn.system("git rev-parse --show-toplevel"), "\n", ""),
				stopOnEntry = true,
			},
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
