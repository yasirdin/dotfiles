return require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  use 'airblade/vim-gitgutter'

  use 'ishan9299/nvim-solarized-lua'

  use {
    'kyazdani42/nvim-tree.lua',
    requires = {
      'kyazdani42/nvim-web-devicons',
    },
    config = function() require'nvim-tree'.setup {} end
  }

  use {
    'neovim/nvim-lspconfig',
    'williamboman/nvim-lsp-installer',
  }

  use {
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'saadparwaiz1/cmp_luasnip',
    'L3MON4D3/LuaSnip',
  }

  use {
    'numToStr/Navigator.nvim',
    config = function()
        require('Navigator').setup()
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  use 'ntpeters/vim-better-whitespace'

  use {
    'terrortylor/nvim-comment',
    config = function ()
       require('nvim_comment').setup({line_mapping = "<leader>cl", operator_mapping = "<leader>c"})
    end
  }
end)
