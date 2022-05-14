return require('packer').startup(function()
	-- Packer can manage itself
	use 'wbthomason/packer.nvim'

	-- Lazy loading:
	-- Load on an autocommand event
	use {'andymass/vim-matchup', event = 'VimEnter'}

	use { 'kyazdani42/nvim-tree.lua',
	config = function() 
		require'nvim-tree'.setup() 
	end
}

-- Load on a combination of conditions: specific filetypes or commands
-- Also run code after load (see the "config" key)

-- Post-install/update hook with neovim command
use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

use {
	'numToStr/Comment.nvim',
	config = function()
		require('Comment').setup()
	end
}

use {
	'nvim-telescope/telescope.nvim',
	requires = { {'nvim-lua/plenary.nvim'} }
}

use {
	'nvim-lualine/lualine.nvim',
	requires = { 'kyazdani42/nvim-web-devicons', opt = true }
}
use { "projekt0n/github-nvim-theme" }

end)
