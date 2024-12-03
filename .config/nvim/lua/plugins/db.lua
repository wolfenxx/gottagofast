return {
	{
		"tpope/vim-dadbod",
	},
	{
		"kristijanhusak/vim-dadbod-ui",
		config = function()
			vim.keymap.set("n", "<Leader>db", "<cmd>DBUIToggle<CR>", {})
		end,
	},
	{
		"kristijanhusak/vim-dadbod-completion",
	},
}
