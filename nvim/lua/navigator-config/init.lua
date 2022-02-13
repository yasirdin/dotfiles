-- Configuration
require('Navigator').setup()

-- Keybindings
local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

map('n', "<C-h>", ":lua require('Navigator').left()<CR>", opts)
map('n', "<C-k>", ":lua require('Navigator').up()<CR>", opts)
map('n', "<C-l>", ":lua require('Navigator').right()<CR>", opts)
map('n', "<C-j>", ":lua require('Navigator').down()<CR>", opts)
map('n', "<C-p>", ":lua require('Navigator').previous()<CR>", opts)
