return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls", -- lua language server
					"tsserver", -- js/ts language server
					"pyright", -- python language server
					"clangd", -- C++ language server
					"csharp_ls", -- C# language server
					"dockerls", -- Dockerfile language server
					--"sqls", -- SQL language server
					--"nil_ls", -- NIX language server
					--"hyprls", -- Hyprlang language server
					"lemminx", -- XML language server
					"yamlls", -- YAML language server
				},
			})
		end,
	},
	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		config = function()
			local installer = require("mason-tool-installer")

			installer.setup({
				ensure_installed = {
					"prettier", -- js/ts formatter
					"prettierd", -- js/ts formatter
					"biome", -- js/ts/json formatter, json language server
					"js-debug-adapter", -- js/ts debug adapter
					"stylua", -- lua formatter
					"eslint_d", -- js/ts linter
					"csharpier", -- C# formatter
					"mypy", -- python static typing analysis
					"ruff", -- python linter
					"isort", -- python formatter
					"black", -- python formatter
					"debugpy", -- python debug adapter
					"clang-format", -- C++ formatter
					"codelldb", -- C++ debug adapter
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "antosha417/nvim-lsp-file-operations", config = true },
		},
		config = function()
			local lspconfig = require("lspconfig")
			local cmp_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_lsp.default_capabilities()

			local opts = { noremap = true, silent = true }
			local on_attach = function(client, bufnr)
				opts.buffer = bufnr

				vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
				vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
				vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
				vim.keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)
				vim.keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)
				vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
				vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
				vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
			end

			lspconfig.lua_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "lua" },
				settings = {
					Lua = {
						misc = {
							executablePath = "/home/wolfen/lua-language-server/bin/lua-language-server", --NIXOS
						},
						diagnostics = {
							globals = { "vim" },
						},
						workspace = {
							library = {
								[vim.fn.expand("$VIMRUNTIME/lua")] = true,
								[vim.fn.stdpath("config") .. "/lua"] = true,
							},
						},
					},
				},
			})

			lspconfig.tsserver.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "javascript", "typescript" },
			})

			lspconfig.pyright.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "python" },
			})

			lspconfig.csharp_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "cs" },
				settings = {
					misc = {
						executablePath = "/home/wolfen/csharp-ls/bin/csharp-ls", --NIXOS
					},
				},
			})

			lspconfig.clangd.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "cpp" },
			})

			lspconfig.biome.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "json" },
				settings = {
					misc = {
						executablePath = "/home/wolfen/biome/bin/biome", --NIXOS
					},
				},
			})

			lspconfig.dockerls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "Dockerfile" },
				settings = {
					misc = {
						executablePath = "/home/wolfen/docker-ls/bin/docker-ls", --NIXOS
					},
				},
			})

			lspconfig.lemminx.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "xml" },
				settings = {
					misc = {
						executablePath = "/home/wolfen/lemminx/bin/lemminx", --NIXOS
					},
				},
			})

			lspconfig.yamlls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "yaml" },
				settings = {
					misc = {
						executablePath = "/home/wolfen/yaml-language-server/bin/yaml-language-server", --NIXOS
					},
				},
			})

			lspconfig.sqls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "sql" },
				settings = {
					misc = {
						executablePath = "/home/wolfen/sqls/bin/sqls", --NIXOS
					},
				},
			})

			lspconfig.nil_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "nix" },
				settings = {
					misc = {
						executablePath = "/home/wolfen/nil/bin/nil", --NIXOS
					},
				},
			})
		end,
	},
}
