-- Theme plumbing for DankMaterialShell's neovim matugen template.
--
-- DMS regenerates ~/.config/nvim/colors/dms.lua and
-- ~/.config/nvim/lua/lualine/themes/dms.lua on every theme change (both are
-- gitignored). The generated colorscheme needs AvengeMedia/base46 and reads
-- ~/.config/DankMaterialShell/settings.json for base theme / harmony, so no
-- colours live in this repo. colors/dms.lua installs its own file watcher and
-- re-applies itself when DMS rewrites it.
--
-- base16-nvim stays as a fallback for machines where DMS hasn't written the
-- template yet; see config/autocmds.lua for the matugen/SIGUSR1 path.
--
-- The colorscheme is handed to LazyVim's opts (not a VimEnter autocmd):
-- LazyVim applies it before VeryLazy, so lualine can find the "dms" theme,
-- and config/autocmds.lua is itself loaded lazily after VimEnter.
return {
	{ "AvengeMedia/base46", lazy = false, priority = 1000 },
	{ "RRethy/base16-nvim", lazy = false, priority = 999 },
	{
		"LazyVim/LazyVim",
		opts = {
			colorscheme = function()
				local dms_path = vim.fn.stdpath("config") .. "/colors/dms.lua"
				if vim.uv.fs_stat(dms_path) and pcall(vim.cmd.colorscheme, "dms") then
					return
				end
				require("config.matugen_fallback")()
			end,
		},
	},
}
