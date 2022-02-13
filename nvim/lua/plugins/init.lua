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
    'numToStr/Navigator.nvim',
    config = function()
        require('Navigator').setup()
    end
  }

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} }
  }
end)
