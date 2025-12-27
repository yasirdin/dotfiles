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
        signs = true,
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

      -- Diagnostic signs
      local signs = { Error = "✘", Warn = "▲", Hint = "⚑", Info = "»" }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- Mason setup (must be called before lsp config)
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = {
          'pyright',
          'lua_ls',
          'bashls',
        },
        automatic_installation = true,
      })

      -- LSP server configurations (Neovim 0.11+ API)

      -- Python
      vim.lsp.config('pyright', {})

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
      vim.lsp.enable('lua_ls')
      vim.lsp.enable('bashls')
    end,
  },
}
