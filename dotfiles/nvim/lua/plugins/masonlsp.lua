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
					"stylua",      -- lua formatter
					"eslint_d",    -- js/ts linter
					"csharpier",   -- C# formatter
					"mypy",        -- python static typing analysis
					"ruff",        -- python linter
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
					misc = {
						executablePath = "~/lua-language-server/bin/lua-language-server", --NIXOS
					},
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

			lspconfig.ts_ls.setup({
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
						executablePath = "~/csharp-ls/bin/csharp-ls", --NIXOS
					},
				},
			})

			lspconfig.clangd.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "cpp" },
				settings = {
					misc = {
						executablePath = "~/clang-tools/bin/clangd", --NIXOS
					},
				},
			})

			lspconfig.biome.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "json" },
				settings = {
					misc = {
						executablePath = "~/biome/bin/biome", --NIXOS
					},
				},
			})

			lspconfig.dockerls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "Dockerfile" },
				settings = {
					misc = {
						executablePath = "~/docker-ls/bin/docker-ls", --NIXOS
					},
				},
			})

			lspconfig.lemminx.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "xml" },
				settings = {
					misc = {
						executablePath = "~/lemminx/bin/lemminx", --NIXOS
					},
				},
			})

			lspconfig.yamlls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "yaml" },
				settings = {
					misc = {
						executablePath = "~/yaml-language-server/bin/yaml-language-server", --NIXOS
					},
				},
			})

			lspconfig.sqls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "sql" },
				settings = {
					misc = {
						executablePath = "~/sqls/bin/sqls", --NIXOS
					},
				},
			})

			lspconfig.nil_ls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "nix" },
				settings = {
					misc = {
						executablePath = "~/nil/bin/nil", --NIXOS
					},
				},
			})

			lspconfig.hyprls.setup({
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "hyprlang" },
				settings = {
					misc = {
						executablePath = "~/hyprls/bin/hyprls", --NIXOS
					},
				},
			})
		end,
	},
}
