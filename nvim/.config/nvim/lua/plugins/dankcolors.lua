return {
	{
		"RRethy/base16-nvim",
		priority = 1000,
		config = function()
			require('base16-colorscheme').setup({
				base00 = '#131313',
				base01 = '#131313',
				base02 = '#848a80',
				base03 = '#848a80',
				base04 = '#d8dfd2',
				base05 = '#fbfff8',
				base06 = '#fbfff8',
				base07 = '#fbfff8',
				base08 = '#ffb19f',
				base09 = '#ffb19f',
				base0A = '#baea94',
				base0B = '#abffa5',
				base0C = '#e3ffcd',
				base0D = '#baea94',
				base0E = '#d4ffb1',
				base0F = '#d4ffb1',
			})

			vim.api.nvim_set_hl(0, 'Visual', {
				bg = '#848a80',
				fg = '#fbfff8',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Statusline', {
				bg = '#baea94',
				fg = '#131313',
			})
			vim.api.nvim_set_hl(0, 'LineNr', { fg = '#848a80' })
			vim.api.nvim_set_hl(0, 'CursorLineNr', { fg = '#e3ffcd', bold = true })

			vim.api.nvim_set_hl(0, 'Statement', {
				fg = '#d4ffb1',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Keyword', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Repeat', { link = 'Statement' })
			vim.api.nvim_set_hl(0, 'Conditional', { link = 'Statement' })

			vim.api.nvim_set_hl(0, 'Function', {
				fg = '#baea94',
				bold = true
			})
			vim.api.nvim_set_hl(0, 'Macro', {
				fg = '#baea94',
				italic = true
			})
			vim.api.nvim_set_hl(0, '@function.macro', { link = 'Macro' })

			vim.api.nvim_set_hl(0, 'Type', {
				fg = '#e3ffcd',
				bold = true,
				italic = true
			})
			vim.api.nvim_set_hl(0, 'Structure', { link = 'Type' })

			vim.api.nvim_set_hl(0, 'String', {
				fg = '#abffa5',
				italic = true
			})

			vim.api.nvim_set_hl(0, 'Operator', { fg = '#d8dfd2' })
			vim.api.nvim_set_hl(0, 'Delimiter', { fg = '#d8dfd2' })
			vim.api.nvim_set_hl(0, '@punctuation.bracket', { link = 'Delimiter' })
			vim.api.nvim_set_hl(0, '@punctuation.delimiter', { link = 'Delimiter' })

			vim.api.nvim_set_hl(0, 'Comment', {
				fg = '#848a80',
				italic = true
			})

			local current_file_path = vim.fn.stdpath("config") .. "/lua/plugins/dankcolors.lua"
			if not _G._matugen_theme_watcher then
				local uv = vim.uv or vim.loop
				_G._matugen_theme_watcher = uv.new_fs_event()
				_G._matugen_theme_watcher:start(current_file_path, {}, vim.schedule_wrap(function()
					local new_spec = dofile(current_file_path)
					if new_spec and new_spec[1] and new_spec[1].config then
						new_spec[1].config()
						print("Theme reload")
					end
				end))
			end
		end
	}
}
