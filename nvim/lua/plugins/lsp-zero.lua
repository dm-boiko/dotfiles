-- this is not yet working
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
		"ray-x/lsp_signature.nvim",
		event = { "InsertEnter" },
		opts = {
		  floating_window = false, -- show hint in a floating window, set to false for virtual text only mode
		  floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
		  hint_scheme = "Comment", -- highlight group for the virtual text
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
