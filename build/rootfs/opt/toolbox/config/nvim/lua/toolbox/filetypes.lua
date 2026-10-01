------------------------------------------------------------
-- Copyright (c) 2026 Igor Sadza
-- Released under the GPLv3 license
-- ---------------------------------------------------------
--
-- FILE: ./build/rootfs/opt/toolbox/config/nvim/lua/toolbox/filetypes.lua
-- DESC: Filetype detection (so the right LSP attaches)
--
--   compose*.y(a)ml / docker-compose*.y(a)ml  -> yaml.docker-compose
--   <chart>/templates/*.{yaml,yml,tpl}        -> helm
--   <chart>/values*.y(a)ml                    -> yaml.helm-values
--   *.tmpl / *.gotmpl                         -> gotmpl (gomplate)
--   .github/workflows|actions/*.y(a)ml        -> yaml (+ gh_actions_ls)
--
------------------------------------------------------------

-- Inside a Helm chart (a parent directory has Chart.yaml)?
local function in_chart(path)
  return vim.fs.root(path, "Chart.yaml") ~= nil
end

local function helm(ft)
  return function(path)
    if in_chart(path) then
      return ft
    end
  end
end

vim.filetype.add({
  extension = {
    gotmpl = "gotmpl",
    tmpl = "gotmpl",
    tf = "terraform",
  },

  pattern = {
    -- Docker Compose
    [".*/compose%.ya?ml"] = "yaml.docker-compose",
    [".*/compose%..*%.ya?ml"] = "yaml.docker-compose",
    [".*/docker%-compose%.ya?ml"] = "yaml.docker-compose",
    [".*/docker%-compose%..*%.ya?ml"] = "yaml.docker-compose",

    -- Helm
    [".*/templates/.*%.ya?ml"] = { helm("helm"), { priority = 10 } },
    [".*/templates/.*%.tpl"] = { helm("helm"), { priority = 10 } },
    [".*/values.*%.ya?ml"] = { helm("yaml.helm-values"), { priority = 10 } },

    -- GitHub Actions: plain yaml (gh_actions_ls attaches by path)
    [".*/%.github/workflows/.*%.ya?ml"] = "yaml",
    [".*/%.github/actions/.*/action%.ya?ml"] = "yaml",
  },
})

