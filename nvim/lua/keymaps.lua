local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- File explorer (mini.files): toggle, opening at the current file's directory
vim.keymap.set('n', '<leader>e', function()
  if not MiniFiles.close() then
    MiniFiles.open(vim.api.nvim_buf_get_name(0))
  end
end, { noremap = true, silent = true, desc = 'Toggle file explorer' })

-- Diagnostics
map('n', '<leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
map('n', '[d', '<cmd>lua vim.diagnostic.jump({ count = -1 })<CR>', opts)
map('n', ']d', '<cmd>lua vim.diagnostic.jump({ count = 1 })<CR>', opts)
map('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- LSP with Telescope
map('n', 'gr', '<cmd>Telescope lsp_references<CR>', opts)
map('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', opts)
map('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', opts)
