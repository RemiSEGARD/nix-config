local api = vim.api

-- Generic
vim.opt.number = true
vim.opt.scrolloff = 5
vim.opt.mouse = "r"
vim.opt.list = true
vim.opt.listchars = { tab = '>─', eol = "¬", trail = '·'}
vim.opt.cc = "80"

-- Tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

-- Files stuff
vim.opt.autoread = true
vim.opt.autowriteall = true
vim.opt.swapfile = false

-- AutoCmd
--- Filetypes
api.nvim_create_autocmd(
  "FileType",
  { pattern = { "lua", "markdown" }, command = [[ 
    set tabstop=2
    set shiftwidth=2
  ]] }
)

api.nvim_create_autocmd(
  "FileType",
  { pattern = { "ada" }, command = [[ 
    set tabstop=3
    set shiftwidth=3
  ]] }
)

api.nvim_create_autocmd(
  "FileType",
  { pattern = { "Makefile" }, command = [[ 
    set noexpandtab
  ]] }
)
