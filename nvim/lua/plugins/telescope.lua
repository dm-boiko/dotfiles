return {
	{ 
		'nvim-telescope/telescope.nvim', 
		version = '*', 
		dependencies = { 'nvim-lua/plenary.nvim' },
		init = function()
			local builtin = require('telescope.builtin')
			vim.keymap.set('n', '<leader><leader>', builtin.find_files, {})
		end
	},
}
