return {
	{
		'VonHeikemen/lsp-zero.nvim',
		branch = 'v3.x',
		lazy = true,
		config = false,
	},
	{
		'neovim/nvim-lspconfig',
		dependencies = {
			{'hrsh7th/cmp-nvim-lsp'},
		}
	},

	-- Autocompletion
	{
		'hrsh7th/nvim-cmp',
		dependencies = {
			{'L3MON4D3/LuaSnip'}
		},
	},

	{
		'williamboman/mason.nvim',
		-- will be setup later in lsp.lua

	},

	{
		'williamboman/mason-lspconfig.nvim',
		-- will be setup later in lsp.lua
	}



}
