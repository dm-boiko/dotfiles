return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },

		config = function()
			vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text
			local git_blame = require('gitblame')
			vim.g.gitblame_message_template = '<date> •  <summary>  • <author>'

			require("lualine").setup({
				options = {
					icons_enabled = true,
					-- theme = 'codedark',
					component_separators = { left = '', right = ''},
					-- section_separators = { left = 'JJJJ', right = ''},
					section_separators = { left = '', right = ''},
					disabled_filetypes = { 'NvimTree' },
					always_divide_middle = true,
					globalstatus = true,
				},
				sections = {
					lualine_a = {},
					lualine_b = {
						{
							'filename',
							file_status = true,      -- Displays file status (readonly status, modified status)
							newfile_status = false,  -- Display new file status (new file means no write after created)
							path = 1,                -- 0: Just the filename
							-- 1: Relative path
							-- 2: Absolute path
							-- 3: Absolute path, with tilde as the home directory
							-- 4: Filename and parent dir, with tilde as the home directory

							shorting_target = 40,    -- Shortens path to leave 40 spaces in the window
							-- for other components. (terrible name, any suggestions?)
							symbols = {
								modified = '[+]',      -- Text to show when the file is modified.
								readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
								unnamed = '[No Name]', -- Text to show for unnamed buffers.
								newfile = '[New]',     -- Text to show for newly created file before first write
							}
						}
					},
					lualine_c = { { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available } },
					lualine_x = {},
					lualine_y = {},
					lualine_z = {}
				},
				tabline = {},
				extensions = {}
			})
		end,
	},
}
