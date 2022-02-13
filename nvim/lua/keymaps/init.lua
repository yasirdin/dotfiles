local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = ' '  -- Set leader key as space

map('n', '<leader>e', ':NvimTreeToggle<CR>', opts)

map('n', "<C-h>", ":lua require('Navigator').left()<CR>", opts)
map('n', "<A-k>", ":lua require('Navigator').up()<CR>", opts)
map('n', "<A-l>", ":lua require('Navigator').right()<CR>", opts)
map('n', "<A-j>", ":lua require('Navigator').down()<CR>", opts)
map('n', "<A-p>", ":lua require('Navigator').previous()<CR>", opts)
