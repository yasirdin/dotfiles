return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local map = vim.api.nvim_set_keymap
      local opts = { noremap = true, silent = true }
      local theme = 'ivy'

      map('n', "<leader>f", string.format(":Telescope find_files theme=%s<CR>", theme), opts)
      map('n', "<leader>b", string.format(":Telescope buffers theme=%s<CR>", theme), opts)
      map('n', "<leader>g", string.format(":Telescope live_grep theme=%s<CR>", theme), opts)

      require('telescope').setup {
        extensions = {
          fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = "smart_case",
          }
        }
      }

      require('telescope').load_extension('fzf')
    end,
  },

  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
  },
}
