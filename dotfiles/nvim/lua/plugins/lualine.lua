return {
	'nvim-lualine/lualine.nvim',
	config = function()
		require('lualine').setup({
			options = {
				theme = 'dracula'
			},
			sections = {
				lualine_a = {'mode'},
				lualine_b = {},
				lualine_c = {
					{
						'filename',
						file_status = false,
						path = 1
					}
				},
				lualine_x = {},
				lualine_y = {'progress'},
				lualine_z = {'location'}
			},
		})
	end
}
