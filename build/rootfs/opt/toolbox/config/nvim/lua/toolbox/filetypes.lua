------------------------------------------------------------
-- Copyright (c) 2026 Igor Sadza
-- Released under the GPLv3 license
-- ---------------------------------------------------------
--
-- FILE: ./build/rootfs/opt/toolbox/config/nvim/lua/toolbox/filetypes.lua
-- DESC: Filetype detection (so the right LSP attaches)
--
------------------------------------------------------------

vim.filetype.add({
  pattern = {
    -- GitHub Actions: plain yaml (gh_actions_ls attaches by path)
    [".*/%.github/workflows/.*%.ya?ml"] = "yaml",
    [".*/%.github/actions/.*/action%.ya?ml"] = "yaml",
  },
})
