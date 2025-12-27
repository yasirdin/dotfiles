local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- File tree
map('n', '<leader>e', ':NvimTreeToggle<CR>', opts)

-- Diagnostics
map('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
map('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
