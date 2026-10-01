------------------------------------------------------------
-- Copyright (c) 2026 Igor Sadza
-- Released under the GPLv3 license
-- ---------------------------------------------------------
--
-- FILE: ./build/rootfs/opt/toolbox/config/nvim/prompts/review.lua
-- DESC: Helpers for review.md (${review.diff})
--
------------------------------------------------------------

return {
  diff = function()
    return vim.system({ "git", "diff", "--no-ext-diff", "HEAD" }, { text = true }):wait().stdout
  end,
}
