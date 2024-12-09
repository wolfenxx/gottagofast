vim.g.mapleader = " "
vim.cmd("set relativenumber")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set clipboard=unnamedplus")
vim.keymap.set("n", "<Leader>qt", ":q!<CR>", {})          -- quit and don't save
vim.keymap.set("n", "<Leader>sq", ":wq<CR>", {})          -- save and quit
vim.keymap.set("n", "<A-j>", ":m .+1<CR>==")              -- move line up(n)
vim.keymap.set("n", "<A-k>", ":m .-2<CR>==")              -- move line down(n)
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv")          -- move line up(v)
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv")          -- move line down(v)
vim.keymap.set("n", "<Leader>bn", ":bn<CR>", {})          -- next buffer
vim.keymap.set("n", "<Leader>bp", ":bp<CR>", {})          -- previous buffer
vim.keymap.set("n", "<Leader>bd", ":bd<CR>", {})          -- close buffer
vim.g.OmniSharp_server_path = "~/omnisharp/bin/OmniSharp" --NIXOS
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99                                      -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
