return {
	-- "norcalli/nvim-colorizer.lua",
	"catgoose/nvim-colorizer.lua", -- other repo needs to be updated for vim.tbl_flatten
	config = function()
		require("colorizer").setup({
			"*",
			css = { rgb_fn = true },
		})
	end,
}
