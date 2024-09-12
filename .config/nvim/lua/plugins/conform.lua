return {
	"stevearc/conform.nvim",
	version = "7.0.0", -- higher version requires nvim >= .10
	-- event = { "BufReadPre", "BufNewFile" },
	config = function()
		local conform = require("conform")

		conform.setup({
			formatters = {
				stylua = {
					command = "/home/wolfen/stylua/bin/stylua", --NIXOS
				},
				clang_format = {
					command = "/home/wolfen/clang-tools/bin/clang-format", --NIXOS
				},
				biome = {
					command = "/home/wolfen/biome/bin/biome", --NIXOS
				},
			},
			formatters_by_ft = {
				lua = { "stylua" },
				-- Conform will run multiple formatters sequentially
				python = { "isort", "black" },
				-- Use a sub-list to run only the first available formatter
				javascript = { "prettierd", "prettier", stop_after_first = true },
				typescript = { "prettierd", "prettier", stop_after_first = true },
				json = { "biome" },
				cs = { "csharpier" },
				cpp = { "clang_format" },
			},
			format_on_save = {
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>fm", function()
			conform.format({
				lsp_fallback = true,
				async = false,
				timeout_ms = 500,
			})
		end)
	end,
}
