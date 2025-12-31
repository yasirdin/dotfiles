local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- File tree
map('n', '<leader>e', ':NvimTreeToggle<CR>', opts)

-- Diagnostics
map('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
map('n', '[d', '<cmd>lua vim.diagnostic.jump({ count = -1 })<CR>', opts)
map('n', ']d', '<cmd>lua vim.diagnostic.jump({ count = 1 })<CR>', opts)
map('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- LSP with Telescope
map('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
map('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
map('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)
