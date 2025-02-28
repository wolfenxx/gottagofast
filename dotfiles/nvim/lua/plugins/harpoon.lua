return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon"):setup()

		-- clear harpoon entries
		vim.keymap.set("n", "<leader>hpc", function()
			harpoon:list():clear()
		end)

		-- add new entry
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end)

		-- select entries based on index
		vim.keymap.set("n", "<C-y>", function()
			harpoon:list():select(1)
		end)
		vim.keymap.set("n", "<C-u>", function()
			harpoon:list():select(2)
		end)
		vim.keymap.set("n", "<C-i>", function()
			harpoon:list():select(3)
		end)
		vim.keymap.set("n", "<C-o>", function()
			harpoon:list():select(4)
		end)
		vim.keymap.set("n", "<C-p>", function()
			harpoon:list():select(5)
		end)

		-- remove entries based on index (note: removing at index 1 will remove all others. Possible bug)
		vim.keymap.set("n", "<leader>yy", function()
			harpoon:list():remove_at(1)
		end)
		vim.keymap.set("n", "<leader>uu", function()
			harpoon:list():remove_at(2)
		end)
		vim.keymap.set("n", "<leader>ii", function()
			harpoon:list():remove_at(3)
		end)
		vim.keymap.set("n", "<leader>oo", function()
			harpoon:list():remove_at(4)
		end)
		vim.keymap.set("n", "<leader>pp", function()
			harpoon:list():remove_at(5)
		end)

		-- replace entries based on index
		vim.keymap.set("n", "<leader>ry", function()
			harpoon:list():replace_at(1)
		end)
		vim.keymap.set("n", "<leader>ru", function()
			harpoon:list():replace_at(2)
		end)
		vim.keymap.set("n", "<leader>ri", function()
			harpoon:list():replace_at(3)
		end)
		vim.keymap.set("n", "<leader>ro", function()
			harpoon:list():replace_at(4)
		end)
		vim.keymap.set("n", "<leader>rp", function()
			harpoon:list():replace_at(5)
		end)

		-- Toggle previous & next buffers stored within Harpoon list
		vim.keymap.set("n", "<C-S-P>", function()
			harpoon:list():prev()
		end)
		vim.keymap.set("n", "<C-S-N>", function()
			harpoon:list():next()
		end)

		-- basic telescope configuration
		local conf = require("telescope.config").values
		local function toggle_telescope(harpoon_files)
			local file_paths = {}
			for _, item in ipairs(harpoon_files.items) do
				table.insert(file_paths, item.value)
			end

			require("telescope.pickers")
					.new({}, {
						prompt_title = "Harpoon",
						finder = require("telescope.finders").new_table({
							results = file_paths,
						}),
						previewer = conf.file_previewer({}),
						sorter = conf.generic_sorter({}),
					})
					:find()
		end

		vim.keymap.set("n", "<C-e>", function()
			toggle_telescope(harpoon:list())
		end, { desc = "Open harpoon window" })
	end,
}
