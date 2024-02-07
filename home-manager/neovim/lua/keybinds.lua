local opts = {noremap = true, silent = true}
local map = vim.api.nvim_set_keymap

vim.g.mapleader = '\\'
vim.opt.timeoutlen = 3000
vim.opt.ttimeoutlen = 100

-- Select current word
map("n", "<Space>", "viw", opts)

-- Arrow mappings

map("n", "<Left>", "<Nop>", opts)
map("n", "<Right>", "<Nop>", opts)
map("n", "<Up>", "<Nop>", opts)
map("n", "<Down>", "<Nop>", opts)

map("v", "<Left>", "<Nop>", opts)
map("v", "<Right>", "<Nop>", opts)
map("v", "<Up>", "<Nop>", opts)
map("v", "<Down>", "<Nop>", opts)

map("n", "<C-l>", "<C-w>l", opts)
map("n", "<C-h>", "<C-w>h", opts)
map("n", "<C-k>", "<C-w>k", opts)
map("n", "<C-j>", "<C-w>j", opts)

map("n", "<C-Left>", "<C-w><", opts)
map("n", "<C-Right>", "<C-w>>", opts)
map("n", "<C-Up>", "<C-w>+", opts)
map("n", "<C-Down>", "<C-w>-", opts)

map("n", "j", "gj", opts)
map("n", "k", "gk", opts)

map("n", "<C-u>", ":bp<cr>", opts)
map("n", "<C-i>", ":bn<cr>", opts)
map("n", "<C-d>d", ":bn<BAR>bd#<cr>", opts)

-- Telescope
map("n", "<C-p>", ":Telescope find_files<CR>", opts)
map("n", "<A-p>", ":Telescope live_grep<CR>", opts)

-- Swap lines below/above
map("n", "-", ":m +1<cr>==", opts)
map("n", "-", ":m -2<cr>==", opts)
