------------------------------------------------------------
-- Copyright (c) 2026 Igor Sadza
-- Released under the GPLv3 license
-- ---------------------------------------------------------
--
-- FILE: ./build/rootfs/opt/toolbox/config/nvim/lua/toolbox/plugins/editor.lua
-- DESC: File tree, finder, editing helpers, diagnostics list
--
------------------------------------------------------------

return {

  -- ----------------------------------------------------------
  -- NvimTree
  --
  -- Opens automatically only for `nvim` / `nvim <dir>`
  -- (not for `nvim <file>` or `git commit`).
  -- ----------------------------------------------------------

  {
    "nvim-tree/nvim-tree.lua",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    lazy = false,
    init = function()
      vim.api.nvim_create_autocmd("VimEnter", {
        callback = function(data)
          local is_dir = vim.fn.isdirectory(data.file) == 1
          local is_empty = data.file == "" and vim.bo[data.buf].buftype == ""

          if not (is_dir or is_empty) then
            return
          end

          if is_dir then
            vim.cmd.cd(data.file)
          end

          require("nvim-tree.api").tree.open()
        end,
      })
    end,
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file explorer" },
    },
    opts = {
      view = {
        width = 35,
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = false,
      },
    },
  },

  -- ----------------------------------------------------------
  -- Telescope
  -- ----------------------------------------------------------

  {
    "nvim-telescope/telescope.nvim",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        cond = vim.fn.executable("make") == 1,
      },
    },
    config = function()
      local telescope = require("telescope")
      local actions = require("telescope.actions")
      local builtin = require("telescope.builtin")
      local map = vim.keymap.set

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
            },
          },
        },
      })

      pcall(telescope.load_extension, "fzf")

      map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
      map("n", "<leader>fg", builtin.live_grep, { desc = "Search project" })
      map("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
      map("n", "<leader>fh", builtin.help_tags, { desc = "Search help" })
      map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
      map("n", "<leader>fd", builtin.diagnostics, { desc = "Search diagnostics" })
      map("n", "<leader>fk", builtin.keymaps, { desc = "Search keymaps" })
    end,
  },

  -- ----------------------------------------------------------
  -- Comments (gc / gcc)
  -- ----------------------------------------------------------

  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = {},
  },

  -- ----------------------------------------------------------
  -- Surround (ys / ds / cs)
  -- ----------------------------------------------------------

  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    opts = {},
  },

  -- ----------------------------------------------------------
  -- Autopairs
  -- ----------------------------------------------------------

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {},
  },

  -- ----------------------------------------------------------
  -- Diagnostics list
  -- ----------------------------------------------------------

  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Project diagnostics" },
      { "<leader>xb", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
      { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Document symbols" },
    },
    opts = {},
  },
}
