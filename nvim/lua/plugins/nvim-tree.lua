return {
  {
    'nvim-tree/nvim-tree.lua',
    config = function()
      require'nvim-tree'.setup {
        disable_netrw        = true,
        hijack_netrw         = true,
        auto_reload_on_write = true,
        open_on_tab          = false,
        hijack_cursor        = true,
        update_cwd           = false,
        renderer = {
          highlight_opened_files = 'all',
          -- Git status is shown via emoji glyphs (see icons.glyphs.git below)
          -- rather than color, so the orange highlight stays dedicated to the
          -- currently-open file and the two signals don't clash.
          icons = {
            git_placement = 'after',
            show = {
              file = false,
              folder = false,
              folder_arrow = true,
              git = true,
            },
            glyphs = {
              git = {
                unstaged  = "📝",
                staged    = "✅",
                unmerged  = "🔀",
                renamed   = "🔄",
                untracked = "🆕",
                deleted   = "❌",
                ignored   = "🙈",
              },
            },
          },
        },
        diagnostics = {
          enable = false,
          icons = {
            hint = "",
            info = "",
            warning = "",
            error = "",
          }
        },
        update_focused_file = {
          enable      = true,
          update_cwd  = true,
          ignore_list = {}
        },
        system_open = {
          cmd  = nil,
          args = {}
        },
        filters = {
          dotfiles = false,
          custom = {}
        },
        git = {
          enable = true,
          ignore = true,
          timeout = 500,
        },
        view = {
          width = 50,
          side = 'left',
          number = false,
          relativenumber = false,
          signcolumn = "yes"
        },
        trash = {
          cmd = "trash",
          require_confirm = true
        },
        actions = {
          change_dir = {
            global = false,
          },
          open_file = {
            quit_on_open = false,
          }
        }
      }
    end,
  },
}
