return {
	{
		"mfussenegger/nvim-dap-python",
		dependencies = {
			"mfussenegger/nvim-dap",
		},
		ft = "python",
		config = function()
			local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
			require("dap-python").setup(path)

			vim.keymap.set("n", "<Leader>dpr", require("dap-python").test_method, {})
		end,
	},
	{
		"jay-babu/mason-nvim-dap.nvim",
		dependencies = {
			"williamboman/mason.nvim",
			"mfussenegger/nvim-dap",
		},
		config = function()
			require("mason-nvim-dap").setup()
		end,
	},
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"rcarriga/nvim-dap-ui",
			"nvim-neotest/nvim-nio",
		},
		config = function()
			local dap = require("dap")
			local dapui = require("dapui")
			local widgets = require("dap.ui.widgets")

			dapui.setup()

			-- JS/TS
			dap.adapters["pwa-node"] = {
				type = "server",
				host = "127.0.0.1",
				port = 8123,
				executable = {
					command = "js-debug-adapter",
				},
			}

			dap.configurations.javascript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					runtimeExecutable = "node",
				},
			}

			dap.configurations.typescript = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					runtimeExecutable = "node",
				},
			}

			-- C#
			dap.adapters.coreclr = {
				type = "executable",
				command = "netcoredbg",
				args = { "--interpreter=vscode" },
			}

			dap.configurations.cs = {
				{
					type = "coreclr",
					name = "launch - netcoredbg",
					request = "launch",
					program = function()
						return vim.fn.input("Path to dll", vim.fn.getcwd() .. "/bin/Debug/", "file")
					end,
				},
			}

			-- C++
			dap.adapters.codelldb = {
				type = "server",
				host = "127.0.0.1",
				port = 8123,
				executable = {
					command = "codelldb",
					args = {
						"--port",
						"8123",
					},
				},
			}

			dap.configurations.cpp = {
				{
					type = "codelldb",
					request = "launch",
					program = function()
						return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
					end,
					cwd = "${workspaceFolder}",
					terminal = "console",
				},
			}

			dap.listeners.before.attach.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.launch.dapui_config = function()
				dapui.open()
			end
			dap.listeners.before.event_terminated.dapui_config = function()
				dapui.close()
			end
			dap.listeners.before.event_exited.dapui_config = function()
				dapui.close()
			end

			vim.keymap.set("n", "<Leader>dc", dap.continue, {})
			vim.keymap.set("n", "<Leader>do", dap.step_over, {})
			vim.keymap.set("n", "<Leader>di", dap.step_into, {})
			vim.keymap.set("n", "<Leader>dt", dap.step_out, {})
			vim.keymap.set("n", "<Leader>bp", dap.toggle_breakpoint, {})
			vim.keymap.set("n", "<Leader>B", dap.set_breakpoint, {})
			vim.keymap.set("n", "<Leader>dr", dap.repl.open, {})
			vim.keymap.set("n", "<Leader>dl", dap.run_last, {})
			vim.keymap.set({ "n", "v" }, "<Leader>dh", widgets.hover, {})
			vim.keymap.set({ "n", "v" }, "<Leader>dp", widgets.preview, {})
		end,
	},
}
