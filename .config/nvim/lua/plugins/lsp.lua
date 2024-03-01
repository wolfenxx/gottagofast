return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup()
		end,
	},
	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"tsserver",
					"pyright",
				},
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
			local lspconfig = require("lspconfig")
			lspconfig.lua_ls.setup({})
			lspconfig.tsserver.setup({})
			lspconfig.pyright.setup({})

			vim.keymap.set("n", "gD", vim.lsp.buf.declaration, {})
			vim.keymap.set("n", "gd", vim.lsp.buf.definition, {})
			vim.keymap.set("n", "K", vim.lsp.buf.hover, {})
			vim.keymap.set("n", "gi", vim.lsp.buf.implementation, {})
			vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, {})
			vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, {})
			vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, {})
			vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, {})
			vim.keymap.set("n", "gr", vim.lsp.buf.references, {})
			vim.keymap.set("n", "<space>f", function()
				vim.lsp.buf.format({ async = true })
			end, {})
		end,
	},
	{
		"OmniSharp/omnisharp-vim",
		config = function()
			vim.api.nvim_create_augroup("omnisharp", { clear = true })
			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>osgd <Plug>(omnisharp_go_to_definition)",
				pattern = "cs",
			})
			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>osfu <Plug>(omnisharp_find_usages)",
				pattern = "cs",
			})
			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>osfi <Plug>(omnisharp_find_implementations)",
				pattern = "cs",
			})
			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>ospd <Plug>(omnisharp_preview_definition)",
				pattern = "cs",
			})
			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>ospi <Plug>(omnisharp_preview_implementations)",
				pattern = "cs",
			})
			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>ostl <Plug>(omnisharp_type_lookup)",
				pattern = "cs",
			})
			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>osdc <Plug>(omnisharp_documentation)",
				pattern = "cs",
			})
			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>osfs <Plug>(omnisharp_find_symbol)",
				pattern = "cs",
			})
			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>osfx <Plug>(omnisharp_fix_usings)",
				pattern = "cs",
			})

			-- Find all code errors/warnings for the current solution and populate the quickfix window
			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>osgcc <Plug>(omnisharp_global_code_check)",
				pattern = "cs",
			})

			-- Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>osca <Plug>(omnisharp_code_actions)",
				pattern = "cs",
			})

			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>os= <Plug>(omnisharp_code_format)",
				pattern = "cs",
			})
			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>osnm <Plug>(omnisharp_rename)",
				pattern = "cs",
			})
			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>osre <Plug>(omnisharp_restart_server)",
				pattern = "cs",
			})
			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>osst <Plug>(omnisharp_start_server)",
				pattern = "cs",
			})
			vim.api.nvim_create_autocmd("FileType", {
				group = "omnisharp",
				command = "nmap <silent> <buffer> <Leader>ossp <Plug>(omnisharp_stop_server)",
				pattern = "cs",
			})
		end,
	},
}
