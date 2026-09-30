------------------------------------------------------------
-- Copyright (c) 2026 Igor Sadza
-- Released under the GPLv3 license
-- ---------------------------------------------------------
--
-- FILE: ./build/rootfs/opt/toolbox/config/nvim/lua/toolbox/plugins/git.lua
-- DESC: Git signs and hunk actions
--
------------------------------------------------------------

return {

  -- ----------------------------------------------------------
  -- Gitsigns (keymaps are buffer-local, inside git repos only)
  -- ----------------------------------------------------------

  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      current_line_blame = false,
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        map("n", "]h", function()
          gs.nav_hunk("next")
        end, "Next hunk")

        map("n", "[h", function()
          gs.nav_hunk("prev")
        end, "Previous hunk")

        map("n", "<leader>hs", gs.stage_hunk, "Stage hunk")
        map("n", "<leader>hr", gs.reset_hunk, "Reset hunk")
        map("n", "<leader>hp", gs.preview_hunk, "Preview hunk")

        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Blame line")
      end,
    },
  },
}
