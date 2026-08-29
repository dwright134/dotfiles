-- Highlight overrides layered on top of whatever colorscheme is active.
-- Colorscheme selection lives in plugins/dms-theme.lua (LazyVim opts.colorscheme).
local function auxiliary_function()
  -- Any other options you wish to set upon matugen reloads can also go here!
  vim.api.nvim_set_hl(0, "Comment", { italic = true })
  -- transparent background
  vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "Pmenu", { bg = "none" })
  vim.api.nvim_set_hl(0, "Terminal", { bg = "none" })
  vim.api.nvim_set_hl(0, "EndOfBuffer", { bg = "none" })
  vim.api.nvim_set_hl(0, "FoldColumn", { bg = "none" })
  vim.api.nvim_set_hl(0, "Folded", { bg = "none" })
  vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
  vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
  vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopeBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopeNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopePromptBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "TelescopePromptTitle", { bg = "none" })

  -- transparent background for neotree
  vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none" })
  vim.api.nvim_set_hl(0, "NeoTreeVertSplit", { bg = "none" })
  vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { bg = "none" })
  vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none" })

  -- transparent background for nvim-tree
  vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "none" })
  vim.api.nvim_set_hl(0, "NvimTreeVertSplit", { bg = "none" })
  vim.api.nvim_set_hl(0, "NvimTreeEndOfBuffer", { bg = "none" })

  -- transparent notify background
  vim.api.nvim_set_hl(0, "NotifyINFOBody", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyERRORBody", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyWARNBody", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyTRACEBody", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyDEBUGBody", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyINFOTitle", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyERRORTitle", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyWARNTitle", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyTRACETitle", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyDEBUGTitle", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyINFOBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyERRORBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyWARNBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyTRACEBorder", { bg = "none" })
  vim.api.nvim_set_hl(0, "NotifyDEBUGBorder", { bg = "none" })
end

-- Re-apply overrides whenever a colorscheme loads (initial load, DMS's own
-- file watcher re-applying colors/dms.lua, or the matugen fallback).
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = auxiliary_function,
})
-- This file is loaded lazily (VeryLazy) by LazyVim, after the colorscheme is
-- already applied, so run once now too.
auxiliary_function()

-- Standalone matugen (~/.config/matugen/config.toml) signals SIGUSR1 after
-- rewriting base16-matugen.vim; only matters on the fallback path.
vim.api.nvim_create_autocmd("Signal", {
  pattern = "SIGUSR1",
  callback = function()
    if vim.g.colors_name ~= "dms" then
      require("config.matugen_fallback")()
    end
  end,
})
