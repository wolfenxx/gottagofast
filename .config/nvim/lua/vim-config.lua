vim.g.mapleader = " "
vim.cmd("set relativenumber")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set clipboard=unnamedplus")
vim.keymap.set("n", "<Leader>qt", ":q!<CR>", {})
vim.keymap.set("n", "<Leader>sq", ":wq<CR>", {})
vim.g.OmniSharp_server_path = "/home/wolfen/omnisharp/bin/OmniSharp" --NIXOS
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldcolumn = "1"
vim.opt.foldlevel = 99
vim.opt.foldlevelstart = 1
vim.opt.foldnestmax = 20
