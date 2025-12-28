-- Load settings first
require('settings')

-- Set leader keys before lazy.nvim
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require('lazy').setup({
  spec = {
    { import = 'plugins' },
  },
  install = { colorscheme = { 'solarized' } },
  checker = { enabled = false },
})

-- Load configs after plugins are available
require('keymaps')

-- Set colorscheme
vim.opt.background = "dark"
vim.cmd([[colorscheme solarized]])

-- Custom highlight overrides (reapplied on colorscheme change)
vim.api.nvim_create_autocmd('ColorScheme', {
  callback = function()
    -- Fix default intro screen highlight (the <Enter> keys)
    vim.api.nvim_set_hl(0, 'SpecialKey', { fg = '#268bd2', bg = 'NONE' })
    -- Telescope selection: yellow text on darker background
    vim.api.nvim_set_hl(0, 'TelescopeSelection', { fg = '#b58900', bg = '#073642', bold = true })
  end,
})

-- Apply highlights for initial colorscheme
vim.api.nvim_set_hl(0, 'SpecialKey', { fg = '#268bd2', bg = 'NONE' })
vim.api.nvim_set_hl(0, 'TelescopeSelection', { fg = '#b58900', bg = '#073642', bold = true })
