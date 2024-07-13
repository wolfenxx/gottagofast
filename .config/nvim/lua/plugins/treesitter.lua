return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		config = function()
			local treesitter = require("nvim-treesitter.configs")
			treesitter.setup({
				ensure_installed = {
					"lua",
					"javascript",
					"typescript",
					"html",
					"json",
					"yaml",
					"bash",
					"vim",
					"dockerfile",
					"python",
					"c_sharp",
					"cpp",
				},
				incremental_selection = {
					enable = true,
					keymaps = {
						init_selection = "<C-space>",
						node_incremental = "<C-space>",
						scope_incremental = false,
						node_decremental = "<bs>",
					},
				},
				sync_install = false,
				highlight = { enable = true },
				indent = { enable = true },
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		config = function()
			require("nvim-treesitter.configs").setup({
				textobjects = {
					select = {
						enable = true,
						lookahead = true,
						keymaps = {
							["a="] = { query = "@assignment.outer" },
							["i="] = { query = "@assignment.inner" },
							["l="] = { query = "@assignment.lhs" },
							["r="] = { query = "@assignment.rhs" },

							["aa"] = { query = "@parameter.outer" },
							["ia"] = { query = "@parameter.inner" },

							["ai"] = { query = "@conditional.outer" },
							["ii"] = { query = "@conditional.inner" },

							["al"] = { query = "@loop.outer" },
							["il"] = { query = "@loop.inner" },

							["af"] = { query = "@call.outer" },
							["if"] = { query = "@call.inner" },

							["am"] = { query = "@function.outer" },
							["im"] = { query = "@function.inner" },

							["ac"] = { query = "@class.outer" },
							["ic"] = { query = "@class.inner" },
							-- to add
							-- @block
							-- @comment
							-- @return
						},
					},
					swap = {
						enable = true,
						swap_next = {
							["<leader>na"] = "@parameter.inner",
							["<leader>nm"] = "@function.outer",
						},
						swap_previous = {
							["<leader>pa"] = "@parameter.inner",
							["<leader>pm"] = "@function.outer",
						},
					},
					move = {
						enable = true,
						set_jumps = true,
						goto_next_start = {
							["]f"] = { query = "@call.outer" },
							["]m"] = { query = "@function.outer" },
							["]c"] = { query = "@class.outer" },
							["]i"] = { query = "@conditional.outer" },
							["]l"] = { query = "@loop.outer" },

							["]s"] = { query = "@scope", query_group = "locals" },
							["]z"] = { query = "@fold", query_group = "folds" },
						},
						goto_next_end = {
							["]F"] = { query = "@call.outer" },
							["]M"] = { query = "@function.outer" },
							["]C"] = { query = "@class.outer" },
							["]I"] = { query = "@conditional.outer" },
							["]L"] = { query = "@loop.outer" },
						},
						goto_previous_start = {
							["[f"] = { query = "@call.outer" },
							["[m"] = { query = "@function.outer" },
							["[c"] = { query = "@class.outer" },
							["[i"] = { query = "@conditional.outer" },
							["[l"] = { query = "@loop.outer" },
						},
						goto_previous_end = {
							["[F"] = { query = "@call.outer" },
							["[M"] = { query = "@function.outer" },
							["[C"] = { query = "@class.outer" },
							["[I"] = { query = "@conditional.outer" },
							["[L"] = { query = "@loop.outer" },
						},
					},
				},
			})

			local repeat_move = require("nvim-treesitter.textobjects.repeatable_move")

			vim.keymap.set({ "n", "x", "o" }, ";", repeat_move.repeat_last_move)
			vim.keymap.set({ "n", "x", "o" }, ",", repeat_move.repeat_last_move_opposite)

			vim.keymap.set({ "n", "x", "o" }, "f", repeat_move.builtin_f)
			vim.keymap.set({ "n", "x", "o" }, "F", repeat_move.builtin_F)
			vim.keymap.set({ "n", "x", "o" }, "t", repeat_move.builtin_t)
			vim.keymap.set({ "n", "x", "o" }, "T", repeat_move.builtin_T)
		end,
	},
}
