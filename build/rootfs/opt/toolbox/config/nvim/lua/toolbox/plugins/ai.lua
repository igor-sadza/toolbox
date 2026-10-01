------------------------------------------------------------
-- Copyright (c) 2026 Igor Sadza
-- Released under the GPLv3 license
-- ---------------------------------------------------------
--
-- FILE: ./build/rootfs/opt/toolbox/config/nvim/lua/toolbox/plugins/ai.lua
-- DESC: GitHub Copilot (inline) + CodeCompanion (chat, via Copilot)
--
-- Custom prompts (/refactor, /review) live in ../../../prompts/*.md
--
------------------------------------------------------------

return {

  -- ----------------------------------------------------------
  -- GitHub Copilot (inline completions, :Copilot setup once)
  -- ----------------------------------------------------------

  {
    "github/copilot.vim",
    event = "InsertEnter",
    config = function()
      vim.g.copilot_no_tab_map = true

      vim.keymap.set("i", "<C-l>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
        silent = true,
        desc = "Accept Copilot suggestion",
      })
    end,
  },

  -- ----------------------------------------------------------
  -- CodeCompanion (uses GitHub Copilot)
  -- ----------------------------------------------------------

  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "github/copilot.vim",
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      interactions = {
        chat = { adapter = "copilot" },
        inline = { adapter = "copilot" },
      },
      prompt_library = {
        markdown = {
          dirs = {
            vim.fn.stdpath("config") .. "/prompts",
          },
        },
      },
      display = {
        chat = {
          window = {
            layout = "vertical",
            width = 0.35,
          },
        },
      },
    },
    keys = {
      -- Chat
      { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI chat" },
      { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI actions" },

      -- Selection workflows
      { "<leader>ae", ":CodeCompanion /explain<cr>", mode = "x", desc = "Explain selection" },
      { "<leader>af", ":CodeCompanion /fix<cr>", mode = "x", desc = "Fix selection" },
      { "<leader>ar", ":CodeCompanion /refactor<cr>", mode = "x", desc = "Refactor selection" },
      { "<leader>at", ":CodeCompanion /tests<cr>", mode = "x", desc = "Generate tests" },

      -- Git workflows
      { "<leader>apr", "<cmd>CodeCompanion /review<cr>", desc = "Review changes" },
      { "<leader>apc", "<cmd>CodeCompanion /commit<cr>", desc = "Generate commit message" },
    },
  },
}
