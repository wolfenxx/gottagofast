vim.g.mapleader = " "
vim.cmd("set relativenumber")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set clipboard=unnamedplus")
vim.keymap.set("n", "<Leader>qt", ":q!<CR>", {})
vim.keymap.set("n", "<Leader>sq", ":wq<CR>", {})
vim.g.OmniSharp_server_path = "/home/wolfen/omnisharp/bin/OmniSharp" --NIXOS
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
