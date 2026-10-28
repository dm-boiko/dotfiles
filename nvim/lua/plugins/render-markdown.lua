return {
	{
		'MeanderingProgrammer/render-markdown.nvim',
		dependencies = {
			'nvim-treesitter/nvim-treesitter',
		},
		ft = { 'markdown' },
		cmd = { 'RenderMarkdown' },
		keys = {
			{ '<leader>mr', '<cmd>RenderMarkdown toggle<cr>', desc = 'Toggle [M]arkdown [R]endering' },
		},
		---@module 'render-markdown'
		---@type render.md.UserConfig
		opts = {},
	},
}
