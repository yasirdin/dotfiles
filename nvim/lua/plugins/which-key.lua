return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    delay = 500,
    spec = {
      { '<leader>v', group = 'Diffview' },
      { '<leader>o', group = 'opencode' },
      { '<leader>h', group = 'Git hunks' },
      { '<leader>hp', desc = 'Preview hunk' },
      { '<leader>hs', desc = 'Stage hunk' },
      { '<leader>hu', desc = 'Undo hunk' },
      { '<leader>c', desc = 'Comment (operator)' },
      { '<leader>cl', desc = 'Comment line' },
      { '<leader>s', desc = 'Strip whitespace (operator)' },
      { '<leader>s<space>', desc = 'Strip whitespace (lines)' },
    },
  },
}
