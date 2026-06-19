return {
  {
    'nvim-mini/mini.files',
    version = false,
    config = function()
      require('mini.files').setup {
        -- Show all files, including dotfiles (matches the old nvim-tree
        -- behaviour where `filters.dotfiles = false`).
        content = {
          filter = nil,
          sort = nil,
        },
        mappings = {
          close       = 'q',
          go_in       = 'l',
          go_in_plus  = 'L',
          go_out      = 'h',
          go_out_plus = 'H',
          reset       = '<BS>',
          reveal_cwd  = '@',
          show_help   = 'g?',
          synchronize = '=',
          trim_left   = '<',
          trim_right  = '>',
        },
        -- Move deletions to a module-managed trash dir instead of erasing
        -- them, so a mistaken `d` is recoverable.
        options = {
          permanent_delete = false,
          use_as_default_explorer = true,
        },
        windows = {
          preview     = true,
          width_focus = 50,
          width_nofocus = 25,
          width_preview = 60,
        },
      }

      -- mini.files only allows one key bound to `close` (`q` above). Add
      -- <Esc> as a second way to quit, set buffer-locally each time an
      -- explorer buffer is created.
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
          vim.keymap.set('n', '<Esc>', function()
            MiniFiles.close()
          end, { buffer = args.data.buf_id, desc = 'Close mini.files' })
        end,
      })
    end,
  },
}
