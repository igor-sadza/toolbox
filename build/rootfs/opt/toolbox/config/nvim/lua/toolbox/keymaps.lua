------------------------------------------------------------
-- Copyright (c) 2026 Igor Sadza
-- Released under the GPLv3 license
-- ---------------------------------------------------------
--
-- FILE: ./build/rootfs/opt/toolbox/config/nvim/lua/toolbox/keymaps.lua
-- DESC: General keymaps (plugin keymaps live in their plugin spec)
--
------------------------------------------------------------

local map = vim.keymap.set

-- ============================================================
-- Files & buffers
-- ============================================================

map("n", "<leader>w", "<cmd>write<cr>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>quit<cr>", { desc = "Quit" })
map("n", "<leader>Q", "<cmd>qa!<cr>", { desc = "Quit all without saving" })

map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
map("n", "<leader>bd", "<cmd>bdelete<cr>", { desc = "Delete buffer" })

-- ============================================================
-- Windows
-- ============================================================

map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- ============================================================
-- Editing
-- ============================================================

map("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlight" })

map("v", "J", ":move '>+1<cr>gv=gv", { desc = "Move selection down" })
map("v", "K", ":move '<-2<cr>gv=gv", { desc = "Move selection up" })

-- Keep selection after indentation
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Disable macro recording (q is used to close plugin windows)
map("n", "q", "<Nop>", { silent = true })

-- ============================================================
-- Session Restore
-- ============================================================

local function restore_session(opts)
  require("persistence").load(opts)

  vim.schedule(function()
    require("nvim-tree.api").tree.open()
  end)
end

vim.keymap.set("n", "<leader>qs", function()
  restore_session()
end, { desc = "Restore session" })

vim.keymap.set("n", "<leader>ql", function()
  restore_session({ last = true })
end, { desc = "Restore last session" })
