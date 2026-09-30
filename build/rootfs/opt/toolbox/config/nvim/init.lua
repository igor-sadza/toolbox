------------------------------------------------------------
-- Copyright (c) 2026 Igor Sadza
-- Released under the GPLv3 license
-- ---------------------------------------------------------
--
-- FILE: ./build/rootfs/opt/toolbox/config/nvim/init.lua
-- DESC: Neovim entrypoint (plugins pinned in lazy-lock.json)
--
-- LAYOUT:
--   lua/toolbox/options.lua      editor options, clipboard, providers
--   lua/toolbox/keymaps.lua      general keymaps
--   lua/toolbox/filetypes.lua    filetype detection
--   lua/toolbox/diagnostics.lua  diagnostics display + navigation
--   lua/toolbox/plugins/*.lua    lazy.nvim plugin specs (one per area)
--
------------------------------------------------------------

-- ============================================================
-- Leader (must be set before lazy.nvim loads plugins)
-- ============================================================

vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- ============================================================
-- Core
-- ============================================================

require("toolbox.options")
require("toolbox.keymaps")
require("toolbox.filetypes")
require("toolbox.diagnostics")

-- ============================================================
-- Bootstrap lazy.nvim
-- ============================================================

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- lazy.nvim itself is pinned by lazy-lock.json too (restore does
-- not move lazy.nvim, so the bootstrap checks out the locked commit).
local function locked_commit(name)
  local ok, lock = pcall(function()
    local path = vim.fn.stdpath("config") .. "/lazy-lock.json"
    return vim.json.decode(table.concat(vim.fn.readfile(path), "\n"))
  end)

  return ok and lock[name] and lock[name].commit or nil
end

if not vim.uv.fs_stat(lazypath) then
  local commit = locked_commit("lazy.nvim")

  local result = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })

  if vim.v.shell_error == 0 and commit then
    result = vim.fn.system({ "git", "-C", lazypath, "checkout", "--quiet", commit })
  end

  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to install lazy.nvim:\n", "ErrorMsg" },
      { result, "WarningMsg" },
    }, true, {})
    return
  end
end

vim.opt.rtp:prepend(lazypath)

-- ============================================================
-- Plugins
-- ============================================================

require("lazy").setup({
  { import = "toolbox.plugins" },
}, {
  -- Updates come from the monthly nvim-lock PR, not from the editor.
  checker = {
    enabled = false,
  },

  change_detection = {
    notify = false,
  },
})
