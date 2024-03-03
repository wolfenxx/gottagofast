return {
	"Wansmer/treesj",
	keys = { "<space>m", "<space>j", "<space>s" },
	dependencies = { "nvim-treesitter/nvim-treesitter" },
	config = function()
		require("treesj").setup({
			-- Use default keymaps (<space>m - toggle, <space>j - join, <space>s - split)
			use_default_keymaps = true,
			check_syntax_error = true,
			max_join_length = 120,
			cursor_behavior = "hold",
			notify = true,
			dot_repeat = true,
			on_error = nil,
		})
	end,
}
