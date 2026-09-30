------------------------------------------------------------
-- Copyright (c) 2026 Igor Sadza
-- Released under the GPLv3 license
-- ---------------------------------------------------------
--
-- FILE: ./build/rootfs/opt/toolbox/config/nvim/lua/toolbox/plugins/ui.lua
-- DESC: Theme, icons, status line, which-key
--
------------------------------------------------------------

return {

  -- ----------------------------------------------------------
  -- Theme
  -- ----------------------------------------------------------

  {
    "folke/tokyonight.nvim",
    priority = 1000,
    config = function()
      require("tokyonight").setup({
        style = "night",
        transparent = false,
      })

      vim.cmd.colorscheme("tokyonight")
    end,
  },

  -- ----------------------------------------------------------
  -- Icons
  -- ----------------------------------------------------------

  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
  },

  -- ----------------------------------------------------------
  -- Status line
  -- ----------------------------------------------------------

  {
    "nvim-lualine/lualine.nvim",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      options = {
        theme = "auto",
        globalstatus = true,
      },
    },
  },

  -- ----------------------------------------------------------
  -- Which-key (press <leader> and wait to see all mappings)
  -- ----------------------------------------------------------

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>a", group = "AI" },
        { "<leader>ap", group = "AI git" },
        { "<leader>b", group = "Buffer" },
        { "<leader>c", group = "Code" },
        { "<leader>f", group = "Find" },
        { "<leader>h", group = "Git hunks" },
        { "<leader>l", group = "LSP" },
        { "<leader>lw", group = "Workspace" },
        { "<leader>x", group = "Diagnostics" },
      },
    },
  },
}
