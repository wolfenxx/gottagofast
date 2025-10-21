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
					--"lua_ls", -- lua language server. Uncomment for non-nixos setup
					"ts_ls", -- js/ts language server
					"pyright", -- python language server
					-- "clangd", -- C++ language server. Uncomment for non-nixos setup
					-- "csharp_ls", -- C# language server. Uncomment for non-nixos setup
					-- "dockerls", -- Dockerfile language server. Uncomment for non-nixos setup
					-- "sqls", -- SQL language server. Uncomment for non-nixos setup
					-- "nil_ls", -- NIX language server. Uncomment for non-nixos setup
					-- "hyprls", -- Hyprlang language server. Uncomment for non-nixos setup
					-- "lemminx", -- XML language server. Uncomment for non-nixos setup
					-- "yamlls", -- YAML language server. Uncomment for non-nixos setup
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
					"prettier",    -- js/ts formatter
					"prettierd",   -- js/ts formatter
					-- "biome", -- js/ts/json formatter, js/ts linter. Uncomment for non-nixos setup
					"js-debug-adapter", -- js/ts debug adapter
					-- "stylua",      -- lua formatter. Uncomment for non-nixos setup
					"eslint_d",    -- js/ts linter
					-- "csharpier",   -- C# formatter. Uncomment for non-nixos setup
					"mypy",        -- python static typing analysis
					-- "ruff",        -- python linter. Uncomment for non-nixos setup
					"isort",       -- python formatter
					"black",       -- python formatter
					"debugpy",     -- python debug adapter
					-- "clang-format", -- C++ formatter. Uncomment for non-nixos setup
					"codelldb",    -- C++ debug adapter
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

			local disable_sqls_formatter = function(client, bufnr)
				on_attach(client, bufnr)

				-- Disable LSP formatting to avoid conflicts with conform.nvim
				client.server_capabilities.documentFormattingProvider = false
				client.server_capabilities.documentRangeFormattingProvider = false
			end

			vim.lsp.enable({ "lua_ls", "ts_ls", "pyright", "csharp_ls", "clangd", "biome", "dockerls", "lemminx", "yamlls",
				"sqls", "nil_ls", "hyprls" })

			vim.lsp.config("lua_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "lua" },
				cmd = { vim.fn.expand("~") .. "/lua-language-server/bin/lua-language-server" }, --NIXOS
				settings = {
					-- misc = {
					-- 	executablePath = "~/lua-language-server/bin/lua-language-server", --NIXOS
					-- },
					Lua = {
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

			vim.lsp.config("ts_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "javascript", "typescript" },
			})

			vim.lsp.config("pyright", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "python" },
			})

			vim.lsp.config("csharp_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "cs" },
				cmd = { vim.fn.expand("~") .. "/csharp-ls/bin/csharp-ls" }, --NIXOS
				-- settings = {
				-- 	misc = {
				-- 		executablePath = "~/csharp-ls/bin/csharp-ls", --NIXOS
				-- 	},
				-- },
			})

			vim.lsp.config("clangd", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "cpp" },
				cmd = { vim.fn.expand("~") .. "/clang-tools/bin/clangd" }, --NIXOS
				-- settings = {
				-- 	misc = {
				-- 		executablePath = "~/clang-tools/bin/clangd", --NIXOS
				-- 	},
				-- },
			})

			vim.lsp.config("biome", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "json" },
				cmd = { vim.fn.expand("~") .. "/biome/bin/biome" }, --NIXOS
				-- settings = {
				-- 	misc = {
				-- 		executablePath = "~/biome/bin/biome", --NIXOS
				-- 	},
				-- },
			})

			vim.lsp.config("dockerls", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "Dockerfile" },
				cmd = { vim.fn.expand("~") .. "/docker-language-server/bin/docker-language-server", "start", "--stdio" },
				-- settings = {
				-- 	misc = {
				-- 		executablePath = "~/docker-language-server/bin/docker-language-server", --NIXOS
				-- 	},
				-- },
			})

			vim.lsp.config("lemminx", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "xml" },
				cmd = { vim.fn.expand("~") .. "/lemminx/bin/lemminx" }, --NIXOS
				-- settings = {
				-- 	misc = {
				-- 		executablePath = "~/lemminx/bin/lemminx", --NIXOS
				-- 	},
				-- },
			})

			vim.lsp.config("yamlls", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "yaml" },
				cmd = { vim.fn.expand("~") .. "/yaml-language-server/bin/yaml-language-server", "--stdio" }, --NIXOS
				-- settings = {
				-- 	misc = {
				-- 		executablePath = "~/yaml-language-server/bin/yaml-language-server", --NIXOS
				-- 	},
				-- },
			})

			vim.lsp.config("sqls", {
				capabilities = capabilities,
				on_attach = disable_sqls_formatter,
				filetypes = { "sql" },
				cmd = { vim.fn.expand("~") .. "/sqls/bin/sqls" }, --NIXOS
				-- settings = {
				-- 	misc = {
				-- 		executablePath = "~/sqls/bin/sqls", --NIXOS
				-- 	},
				-- },
			})

			vim.lsp.config("nil_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "nix" },
				cmd = { vim.fn.expand("~") .. "/nil/bin/nil" }, --NIXOS
				-- settings = {
				-- 	misc = {
				-- 		executablePath = "~/nil/bin/nil", --NIXOS
				-- 	},
				-- },
			})

			vim.lsp.config("hyprls", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "hyprlang" },
				cmd = { vim.fn.expand("~") .. "/hyprls/bin/hyprls" }, --NIXOS
				-- settings = {
				-- 	misc = {
				-- 		executablePath = "~/hyprls/bin/hyprls", --NIXOS
				-- 	},
				-- },
			})
		end,
	},
}
