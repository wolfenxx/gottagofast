return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			javascript = { "eslint_d" },
			typescript = { "eslint_d" },
			python = { "mypy", "ruff" },
		}

		local lintgroup = vim.api.nvim_create_augroup("lint", { clear = true })

		vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
			group = lintgroup,
			callback = function()
				lint.try_lint()
			end,
		})

		vim.keymap.set("n", "<leader>lnt", function()
			lint.try_lint()
		end, {})
	end,
}
