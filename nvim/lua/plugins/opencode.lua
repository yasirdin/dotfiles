return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    {
      "folke/snacks.nvim",
      opts = {
        input = {},
        picker = {},
        terminal = { auto_close = false },
      },
    },
  },
  keys = {
    { "<leader>oa", function() require("opencode").ask() end, mode = { "n", "v" }, desc = "Ask opencode" },
    { "<leader>os", function() require("opencode").select() end, desc = "Select opencode action" },
    { "<leader>ot", function() require("opencode").toggle() end, desc = "Toggle opencode" },
  },
  config = function()
    vim.g.opencode_opts = {}
    vim.o.autoread = true
  end,
}
