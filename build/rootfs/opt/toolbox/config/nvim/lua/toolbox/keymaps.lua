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
-- Cheatsheet (same file as the shell 'cheat' command)
-- ============================================================

map("n", "<leader>?", function()
  local path = (vim.env.TOOLBOX_ROOT or "/opt/toolbox") .. "/doc/cheatsheet.md"

  if vim.fn.filereadable(path) == 0 then
    vim.notify("Cheatsheet not found: " .. path, vim.log.levels.WARN)
    return
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.fn.readfile(path))
  vim.bo[buf].filetype = "markdown"
  vim.bo[buf].modifiable = false
  vim.bo[buf].bufhidden = "wipe"

  local width = math.min(110, math.floor(vim.o.columns * 0.9))
  local height = math.floor(vim.o.lines * 0.85)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = math.floor((vim.o.lines - height) / 2),
    col = math.floor((vim.o.columns - width) / 2),
    title = " Toolbox cheatsheet (q to close, / to search) ",
    title_pos = "center",
  })

  vim.wo[win].wrap = false
  vim.wo[win].conceallevel = 2

  vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = buf, nowait = true, silent = true })
  vim.keymap.set("n", "<Esc>", "<cmd>close<cr>", { buffer = buf, nowait = true, silent = true })
end, { desc = "Cheatsheet" })
