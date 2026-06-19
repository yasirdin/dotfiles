return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    -- mini.files (<leader>e) stays the quick jump-and-edit explorer.
    -- neo-tree is the "see the whole project at a glance" overview: a
    -- centered floating tree that closes itself once a file is chosen.
    keys = {
      { '<leader>t', '<cmd>Neotree float toggle<cr>', desc = 'Toggle project tree (float)' },
    },
    opts = {
      close_if_last_window = true,
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        hijack_netrw_behavior = 'disabled', -- mini.files owns the default explorer
        filtered_items = {
          -- No default hiding: show everything, including dotfiles and
          -- gitignored files. Press `H` inside the tree to flip the hidden
          -- state on/off. To fold away a pattern later, add it to
          -- hide_by_pattern (globs), e.g. { '*.py' }, and toggle with `H`.
          visible = true,
          hide_dotfiles = false,
          hide_gitignored = false,
          hide_by_name = {},
          hide_by_pattern = {},
          never_show = { '.DS_Store' },
        },
      },
      window = {
        position = 'float',
        mappings = {
          ['<space>'] = 'toggle_node',
          ['H'] = 'toggle_hidden',    -- live show/hide filtered items
          ['z'] = 'close_all_nodes',  -- collapse everything
          ['Z'] = 'expand_all_nodes', -- expand everything (not bound by default)
          ['/'] = 'fuzzy_finder',
          ['P'] = { 'toggle_preview', config = { use_float = true } },
        },
      },
      default_component_configs = {
        indent = { with_expanders = true },
      },
    },
  },
}
