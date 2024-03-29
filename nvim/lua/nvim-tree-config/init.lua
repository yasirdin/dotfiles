require'nvim-tree'.setup {
  disable_netrw        = true,
  hijack_netrw         = true,
  -- open_on_setup        = false,
  -- ignore_ft_on_setup   = {},
  auto_reload_on_write = true,
  open_on_tab          = false,
  hijack_cursor        = true,
  update_cwd           = false,
  -- update_to_buf_dir    = {
  --   enable = true,
  --   auto_open = true,
  -- },
  renderer = {
    highlight_opened_files = 'all',
  },
  diagnostics = {
    enable = false,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
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
    -- height = 30,
    -- hide_root_folder = false,
    side = 'left',
    -- auto_resize = false,
    -- mappings = {
    --   custom_only = false,
    --   list = {}
    -- },
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

