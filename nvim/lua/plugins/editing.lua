return {
  'ntpeters/vim-better-whitespace',

  {
    'terrortylor/nvim-comment',
    config = function()
      require('nvim_comment').setup({
        line_mapping = '<leader>cl',
        operator_mapping = '<leader>c',
      })
    end,
  },

  'numToStr/FTerm.nvim',
}
