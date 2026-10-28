return {
	{
		'nvim-telescope/telescope.nvim',
		event = 'VimEnter',
		branch = '0.1.x',
		dependencies = {
			'nvim-lua/plenary.nvim',
			{
				'nvim-telescope/telescope-fzf-native.nvim',
				build = 'make',
				cond = function() return vim.fn.executable 'make' == 1 end,
			},
			{ 'nvim-telescope/telescope-ui-select.nvim' },
		},
		config = function()
			require('telescope').setup {
				pickers = {
					find_files = { theme = "ivy" },
					oldfiles = { theme = "ivy", only_cwd = true }
				},
				extensions = {
					['ui-select'] = { require('telescope.themes').get_dropdown() },
				},
			}
			require('telescope').load_extension('fzf')
			require('telescope').load_extension('ui-select')

			local builtin = require 'telescope.builtin'
			vim.keymap.set('n', '<leader><leader>', builtin.find_files, { desc = '[S]earch [F]iles' })
			vim.keymap.set('n', '<leader>p', builtin.git_files, { desc = '[S]earch [F]iles' })
			vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
			vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
			vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
			vim.keymap.set('n', '<leader>o', builtin.oldfiles, { desc = '[S]earch Recent Files' })
		end,
	},
}
