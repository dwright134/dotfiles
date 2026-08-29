-- Fallback colorscheme when DMS has not generated colors/dms.lua (see plugins/dms-theme.lua).
local function source_matugen()
  -- Update this with the location of your output file
  local matugen_path = os.getenv("HOME") .. "/.local/share/nvim/lazy/base16-nvim/colors/base16-matugen.vim" -- dofile doesn't expand $HOME or ~

  local file, err = io.open(matugen_path, "r")
  -- If the matugen file does not exist (yet or at all), we must initialize a color scheme ourselves
  if err ~= nil then
    -- Some placeholder theme, this will be overwritten once matugen kicks in
    vim.cmd("colorscheme base16-catppuccin-mocha")

    -- Optionally print something to the user
    vim.print(
      "A matugen style file was not found, but that's okay! The colorscheme will dynamically change if matugen runs!"
    )
  else
    vim.cmd("colorscheme base16-matugen")
    io.close(file)
  end
end

return source_matugen
