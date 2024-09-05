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
					"lua_ls", -- language server
					"tsserver", -- language server
					"pyright", -- language server
					"clangd", -- language server
					"csharp_ls", --language server
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
					"prettier", -- formatter
					"prettierd", -- formatter
					"js-debug-adapter", -- debug adapter
					"stylua", -- formatter
					"eslint_d", -- linter
					"csharpier", -- formatter
					"mypy", -- static typing analysis
					"ruff", -- linter
					"isort", -- formatter
					"black", -- formatter
					"debugpy", -- debug adapter for python
					"clang-format", -- formatter
					"codelldb", -- debug adapter for cpp
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
		end,
	},
}
