return {
	{
		"nvim-tree/nvim-tree.lua",
		version = "*",
		lazy = false,
		dependencies = {
			"nvim-tree/nvim-web-devicons",
		},
		cmd = { "NvimTreeToggle", "NvimTreeFindFile" },
		init = function()
			vim.keymap.set("n", ",", ":NvimTreeToggle<CR>", { silent = true })
		end,

		my_mappings = function(bufnr)
			local api = require "nvim-tree.api"

			local function opts(desc)
				return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
			end

			-- default mappings
			api.config.mappings.default_on_attach(bufnr)

			-- custom mappings
			vim.keymap.set('n', '<CR>', api.node.open.no_window_picke,        opts('Open in last buffer'))
			vim.keymap.set('n', '?',     api.tree.toggle_help,                  opts('Help'))
		end,
		config = function()
			-- disable netrw at the very start of your init.lua
			vim.g.loaded_netrw = 1
			vim.g.loaded_netrwPlugin = 1

			-- OR setup with some options
			require("nvim-tree").setup({
				on_attach = my_mappings,
				sort = {
					sorter = "case_sensitive",
				},
				view = {
					width = 40,
					side = "right",
				},
				renderer = {
					group_empty = true,
				},
				filters = {
					dotfiles = true,
				},
			})
		end,
	},
}
