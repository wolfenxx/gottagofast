return {
	"OmniSharp/omnisharp-vim",
	config = function()
		vim.api.nvim_create_augroup("omnisharp", { clear = true })
		vim.api.nvim_create_autocmd("FileType", {
			group = "omnisharp",
			command = "nmap <silent> <buffer> <Leader>gd <Plug>(omnisharp_go_to_definition)",
			pattern = "cs",
		})
		vim.api.nvim_create_autocmd("FileType", {
			group = "omnisharp",
			command = "nmap <silent> <buffer> <Leader>fu <Plug>(omnisharp_find_usages)",
			pattern = "cs",
		})
		vim.api.nvim_create_autocmd("FileType", {
			group = "omnisharp",
			command = "nmap <silent> <buffer> <Leader>fi <Plug>(omnisharp_find_implementations)",
			pattern = "cs",
		})
		vim.api.nvim_create_autocmd("FileType", {
			group = "omnisharp",
			command = "nmap <silent> <buffer> <Leader>pd <Plug>(omnisharp_preview_definition)",
			pattern = "cs",
		})
		vim.api.nvim_create_autocmd("FileType", {
			group = "omnisharp",
			command = "nmap <silent> <buffer> <Leader>pi <Plug>(omnisharp_preview_implementations)",
			pattern = "cs",
		})
		vim.api.nvim_create_autocmd("FileType", {
			group = "omnisharp",
			command = "nmap <silent> <buffer> <Leader>tl <Plug>(omnisharp_type_lookup)",
			pattern = "cs",
		})
		vim.api.nvim_create_autocmd("FileType", {
			group = "omnisharp",
			command = "nmap <silent> <buffer> <Leader>doc <Plug>(omnisharp_documentation)",
			pattern = "cs",
		})
		vim.api.nvim_create_autocmd("FileType", {
			group = "omnisharp",
			command = "nmap <silent> <buffer> <Leader>fsy <Plug>(omnisharp_find_symbol)",
			pattern = "cs",
		})
		vim.api.nvim_create_autocmd("FileType", {
			group = "omnisharp",
			command = "nmap <silent> <buffer> <Leader>fx <Plug>(omnisharp_fix_usings)",
			pattern = "cs",
		})

		-- Find all code errors/warnings for the current solution and populate the quickfix window
		vim.api.nvim_create_autocmd("FileType", {
			group = "omnisharp",
			command = "nmap <silent> <buffer> <Leader>gcc <Plug>(omnisharp_global_code_check)",
			pattern = "cs",
		})

		-- Contextual code actions (uses fzf, vim-clap, CtrlP or unite.vim selector when available)
		vim.api.nvim_create_autocmd("FileType", {
			group = "omnisharp",
			command = "nmap <silent> <buffer> <Leader>ca <Plug>(omnisharp_code_actions)",
			pattern = "cs",
		})

		vim.api.nvim_create_autocmd("FileType", {
			group = "omnisharp",
			command = "nmap <silent> <buffer> <Leader>os= <Plug>(omnisharp_code_format)",
			pattern = "cs",
		})
		vim.api.nvim_create_autocmd("FileType", {
			group = "omnisharp",
			command = "nmap <silent> <buffer> <Leader>rn <Plug>(omnisharp_rename)",
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
}
