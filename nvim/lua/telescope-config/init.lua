local map = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }
local theme = 'ivy'

map('n', "<leader>f", string.format(":Telescope find_files theme=%s<CR>", theme), opts)
map('n', "<leader>b", string.format(":Telescope buffers theme=%s<CR>", theme), opts)
map('n', "<leader>g", string.format(":Telescope live_grep theme=%s<CR>", theme), opts)
