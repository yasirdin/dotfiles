return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewFileHistory', 'DiffviewToggleFiles' },
  keys = {
    { '<leader>vv', '<cmd>DiffviewOpen<CR>', desc = 'Diffview: review working tree' },
    { '<leader>vm', function()
        local head = vim.fn.systemlist('git symbolic-ref --short refs/remotes/origin/HEAD')[1] or ''
        local base = head:match('^origin/%S+') and head or 'origin/main'
        vim.cmd('DiffviewOpen ' .. base .. '...HEAD')
      end, desc = 'Diffview: review branch vs default' },
    { '<leader>vc', '<cmd>DiffviewClose<CR>', desc = 'Diffview: close' },
    { '<leader>vh', '<cmd>DiffviewFileHistory %<CR>', desc = 'Diffview: history of current file' },
    { '<leader>vH', '<cmd>DiffviewFileHistory<CR>', desc = 'Diffview: history of whole repo' },
    { '<leader>vf', '<cmd>DiffviewToggleFiles<CR>', desc = 'Diffview: toggle file panel' },
  },
  opts = {
    enhanced_diff_hl = true,
    file_panel = {
      -- Tree style nests directories, so each row shows just the short
      -- leaf filename instead of a long full path that gets truncated.
      listing_style = 'tree',
      win_config = function()
        -- Scale the panel to ~25% of the editor width, clamped to a
        -- sane range so it grows on wide screens but never dominates.
        local width = math.floor(vim.o.columns * 0.25)
        return {
          position = 'left',
          width = math.max(35, math.min(width, 60)),
        }
      end,
    },
  },
}
