------------------------------------------------------------
-- Copyright (c) 2026 Igor Sadza
-- Released under the GPLv3 license
-- ---------------------------------------------------------
--
-- FILE: ./build/rootfs/opt/toolbox/config/nvim/lua/toolbox/plugins/misc.lua
-- DESC: Mason (pinned registry),  
--
------------------------------------------------------------

return {

  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    opts = {
      options = {
        "buffers",
        "curdir",
        "folds",
        "help",
        "tabpages",
        "winsize",
        "terminal",
      },
    },
  }
}
