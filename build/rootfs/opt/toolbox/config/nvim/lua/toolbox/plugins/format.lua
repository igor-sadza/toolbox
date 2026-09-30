------------------------------------------------------------
-- Copyright (c) 2026 Igor Sadza
-- Released under the GPLv3 license
-- ---------------------------------------------------------
--
-- FILE: ./build/rootfs/opt/toolbox/config/nvim/lua/toolbox/plugins/format.lua
-- DESC: Formatting (conform.nvim), falls back to the LSP
--
------------------------------------------------------------

local prettier = { "prettierd", "prettier", stop_after_first = true }

return {

  {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    keys = {
      {
        "<leader>cf",
        function()
          require("conform").format({
            async = true,
            lsp_format = "fallback",
          })
        end,
        mode = { "n", "v" },
        desc = "Format buffer",
      },
    },
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        javascript = prettier,
        javascriptreact = prettier,
        typescript = prettier,
        typescriptreact = prettier,
        json = prettier,
        jsonc = prettier,
        css = prettier,
        html = prettier,
        markdown = prettier,
        yaml = prettier,
        go = { "goimports", "gofmt" },
        sh = { "shfmt" },
      },

      default_format_opts = {
        lsp_format = "fallback",
      },
    },
  },
}
