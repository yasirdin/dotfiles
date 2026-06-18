return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      -- Configure diagnostics display
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          spacing = 4,
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = '✘',
            [vim.diagnostic.severity.WARN] = '▲',
            [vim.diagnostic.severity.HINT] = '⚑',
            [vim.diagnostic.severity.INFO] = '»',
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'always',
          header = '',
          prefix = '',
        },
      })

      -- Mason setup (must be called before lsp config)
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'pyright',
          'ruff',
          'lua_ls',
          'bashls',
        },
        automatic_installation = true,
      })

      -- LSP server configurations (Neovim 0.11+ API)

      -- Python type-checking
      vim.lsp.config('pyright', {})

      -- Python linting via ruff's native LSP. ruff reads each project's
      -- [tool.ruff] from pyproject.toml automatically, so per-repo lint rules
      -- surface inline while editing with no rule duplication here. Let pyright
      -- own hover/definitions.
      vim.lsp.config('ruff', {})
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == 'ruff' then
            client.server_capabilities.hoverProvider = false
          end
        end,
      })

      -- Lua (for Neovim config)
      vim.lsp.config('lua_ls', {
        settings = {
          Lua = {
            diagnostics = {
              globals = { 'vim' },
            },
          },
        },
      })

      -- Bash
      vim.lsp.config('bashls', {})

      -- Enable all configured servers
      vim.lsp.enable('pyright')
      vim.lsp.enable('ruff')
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('bashls')
    end,
  },
}
