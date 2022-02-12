local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.g.mapleader = ' '  -- Set leader key as space

map('n', '<leader>e', ':NvimTreeToggle<CR>', opts)
