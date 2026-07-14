return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local map = vim.keymap.set
      local theme = 'ivy'

      map('n', "<leader>f", string.format(":Telescope find_files theme=%s<CR>", theme), { silent = true, desc = 'Find files' })
      map('n', "<leader>b", string.format(":Telescope buffers theme=%s<CR>", theme), { silent = true, desc = 'Find buffers' })
      map('n', "<leader>g", string.format(":Telescope live_grep theme=%s<CR>", theme), { silent = true, desc = 'Live grep' })

      require('telescope').setup {
        defaults = {
          devicons_enabled = false,
        },
        pickers = {
          find_files = {
            devicons_enabled = false,
          },
          buffers = {
            devicons_enabled = false,
          },
          live_grep = {
            devicons_enabled = false,
          },
        },
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
