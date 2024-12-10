return {
	"folke/noice.nvim",
	event = "VeryLazy",
	dependencies = {
		"MunifTanjim/nui.nvim",
		"rcarriga/nvim-notify",
	},
	config = function()
		require("telescope").load_extension("noice")
		require("noice").setup({
			presets = { inc_rename = true },
			vim.keymap.set("n", "<Leader>dm", "<cmd>NoiceDismiss<CR>", {}),
		})
	end,
}
