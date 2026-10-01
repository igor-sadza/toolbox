------------------------------------------------------------
-- Copyright (c) 2026 Igor Sadza
-- Released under the GPLv3 license
-- ---------------------------------------------------------
--
-- FILE: ./build/rootfs/opt/toolbox/config/nvim/lua/toolbox/options.lua
-- DESC: Editor options, clipboard and providers
--
------------------------------------------------------------

local opt = vim.opt

-- ============================================================
-- Editing
-- ============================================================

opt.number = true
opt.relativenumber = true
opt.mouse = "a"

opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.softtabstop = 2
opt.smartindent = true

opt.ignorecase = true
opt.smartcase = true

opt.wrap = false
opt.undofile = true

-- ============================================================
-- UI
-- ============================================================

opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 8
opt.sidescrolloff = 8

opt.splitright = true
opt.splitbelow = true

-- Rounded borders for every floating window (LSP hover, diagnostics, ...)
opt.winborder = "rounded"

opt.updatetime = 250
opt.timeoutlen = 400
opt.completeopt = { "menu", "menuone", "noselect" }

-- Command-line completion
opt.wildmenu = true
opt.wildmode = { "longest:full", "full" }

-- netrw is replaced by nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ============================================================
-- Clipboard (OSC 52)
--
-- The container has no X11/Wayland clipboard tool. Copy goes to
-- the terminal via OSC 52 (works through tmux and SSH); paste
-- uses Neovim's own register, because most terminals do not
-- answer OSC 52 paste requests.
-- ============================================================

local osc52 = require("vim.ui.clipboard.osc52")

local function paste()
  return {
    vim.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = osc52.copy("+"),
    ["*"] = osc52.copy("*"),
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}

opt.clipboard = "unnamedplus"

-- ============================================================
-- Providers
-- ============================================================

-- Node provider stays enabled (npm 'neovim' is installed in the image).
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
