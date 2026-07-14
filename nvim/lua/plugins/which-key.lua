return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = 500,
    spec = {
      { '<leader>v', group = 'Diffview' },
    },
  },
}
