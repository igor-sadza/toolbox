------------------------------------------------------------
-- Copyright (c) 2026 Igor Sadza
-- Released under the GPLv3 license
-- ---------------------------------------------------------
--
-- FILE: ./build/rootfs/opt/toolbox/config/nvim/lua/toolbox/plugins/lsp.lua
-- DESC: Mason (pinned registry), language servers, LSP keymaps
--
-- Neovim defaults (no mapping needed):
--   K     hover            grn  rename        gra  code action
--   grr   references       gri  implementation
--   gO    document symbols <C-s> (insert) signature help
--
------------------------------------------------------------

return {

  -- ----------------------------------------------------------
  -- Mason
  --
  -- The registry is pinned so every image build resolves the
  -- same tool versions (no GitHub API lookup for "latest").
  -- Bumped monthly by .github/workflows/nvim-lock.yml.
  -- ----------------------------------------------------------

  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      registries = {
        "github:mason-org/mason-registry@2026-09-30-aboard-mob",
      },
    },
  },

  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      automatic_enable = {
        -- Installed as formatter (conform), not as a language server.
        exclude = { "stylua" },
      },
    },
  },

  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mason-org/mason.nvim",
    },
    opts = {
      ensure_installed = {
        -- Language servers
        "bash-language-server",
        "clangd",
        "css-lsp",
        "dockerfile-language-server",
        "gopls",
        "html-lsp",
        "json-lsp",
        "lua-language-server",
        "marksman",
        "sqls",
        "terraform-ls",
        "typescript-language-server",
        "yaml-language-server",

        -- Formatters
        "gofumpt",
        "goimports",
        "prettier",
        "prettierd",
        "shfmt",
        "stylua",
      },
      run_on_start = true,
      start_delay = 3000,
    },
  },

  -- ----------------------------------------------------------
  -- Lua: Neovim runtime + plugin types for lua_ls (on demand)
  -- ----------------------------------------------------------

  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- ----------------------------------------------------------
  -- LSP configurations
  -- ----------------------------------------------------------

  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            workspace = { checkThirdParty = false },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("sqls", {
        settings = {
          sqls = {},
        },
      })

      vim.lsp.config("terraformls", {
        init_options = {
          ignoreSingleFileWarning = true,
        },
      })

      -- Keymaps only when an LSP attaches (buffer-local).
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(event)
          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
          end

          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
          map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")

          map("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, "Add workspace folder")
          map("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, "Remove workspace folder")
          map("n", "<leader>lwl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, "List workspace folders")
        end,
      })
    end,
  },
}
