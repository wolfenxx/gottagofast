return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")
		auto_session.setup({
			auto_restore_enabled = false,
			auto_session_suppress_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
		})

		vim.keymap.set("n", "<Leader>wr", "<cmd>SessionRestore<CR>", {})
		vim.keymap.set("n", "<Leader>ws", "<cmd>SessionSave<CR>", {})
	end
}
