return {

	{
		"akinsho/toggleterm.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			open_mapping = [[<C-g>]],
			start_in_insert = true,
			direction = "float",
			autochdir = false,
			float_opts = {
				-- border = Util.generate_borderchars("thick", "tl-t-tr-r-bl-b-br-l"),
				winblend = 0,
			},
			highlights = {
				FloatBorder = { link = "ToggleTermBorder" },
				Normal = { link = "ToggleTerm" },
				NormalFloat = { link = "ToggleTerm" },
			},
			winbar = {
				enabled = true,
				name_formatter = function(term)
					return string.format("%d:%s", term.id, term:_display_name())
				end,
			},
		},
	},
}
