-----------------------------------------------------------
-- Lazy.nvim plugin manager
-- `:help lazy.nvim.txt` for more info
-----------------------------------------------------------
local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system {
		'git',
		'clone',
		'--filter=blob:none',
		'https://github.com/folke/lazy.nvim.git',
		'--branch=stable', -- latest stable release
		lazypath,
	}
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
	{ 'folke/which-key.nvim', opts = {} },

	{ "f-person/git-blame.nvim"},

	{ 
		"nvim-lualine/lualine.nvim",
	},

	{ 
		'projekt0n/github-nvim-theme', opts = {},
		config = function()
			require('github-theme').setup()
		end
	},

	{ 'numToStr/Comment.nvim', opts = {} },

	{ 
		'nvim-telescope/telescope.nvim', 
		version = '*', 
		dependencies = { 'nvim-lua/plenary.nvim' },
	},

	{
		'nvim-telescope/telescope-fzf-native.nvim',
		-- NOTE: If you are having trouble with this installation,
		--       refer to the README for telescope-fzf-native for more instructions.
		build = 'make',
		cond = function()
			return vim.fn.executable 'make' == 1
		end,
	},

	{

		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		-- config = function()
		-- 	pcall(require('nvim-treesitter.install').update { with_sync = true })
		-- end,
	},

	{
		'rebelot/kanagawa.nvim',
		priority = 1000,
		config = function()
			vim.cmd.colorscheme 'kanagawa'
		end,
	},

	{

		'nvim-lualine/lualine.nvim',
		-- See `:help lualine.txt`
		opts = {
			options = {
				icons_enabled = false,
				-- theme = 'onedark',
				component_separators = '|',
				section_separators = '',
			},
		},
	},

	{
		"nvim-telescope/telescope-file-browser.nvim",
		dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").load_extension "file_browser"
		end,
	},

	{
		'glepnir/dashboard-nvim',
		event = 'VimEnter',
		config = function()
			require('dashboard').setup {
			}
		end,
		dependencies = { {'nvim-tree/nvim-web-devicons'}}
	},

	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			char = "▏",
			context_char = "▏",
			show_end_of_line = false,
			space_char_blankline = " ",
			show_current_context = true,
			show_current_context_start = true,
			filetype_exclude = {
				"help",
				"startify",
				"dashboard",
				"packer",
				"neogitstatus",
				"NvimTree",
				"Trouble",
				"alpha",
				"neo-tree",
			},
			buftype_exclude = {
				"terminal",
				"nofile",
			},
			-- char_highlight_list = {
			--   "IndentBlanklineIndent1",
			--   "IndentBlanklineIndent2",
			--   "IndentBlanklineIndent3",
			--   "IndentBlanklineIndent4",
			--   "IndentBlanklineIndent5",
			--   "IndentBlanklineIndent6",
			-- },
		},
	},

	{
		"echasnovski/mini.indentscope",
		lazy = true,
		enabled = true,
		-- lazy = true,
		version = false, -- wait till new 0.7.0 release to put it back on semver
		-- event = "BufReadPre",
		opts = {
			symbol = "▏",
			-- symbol = "│",
			options = { try_as_border = false },
		},
		config = function(_, opts)
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help",
					"alpha",
					"dashboard",
					"neo-tree",
					"Trouble",
					"lazy",
					"mason",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
			require("mini.indentscope").setup(opts)
		end,
	},

	{
		"akinsho/toggleterm.nvim",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			open_mapping = [[<C-n>]],
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

	{
		"anuvyklack/windows.nvim",
		event = "WinNew",
		dependencies = {
			{ "anuvyklack/middleclass" },
			{ "anuvyklack/animation.nvim", enabled = true },
		},
		opts = {
			animation = { enable = true, duration = 150, fps = 60 },
			autowidth = { enable = true },
		},
		keys = { { "<leader>m", "<cmd>WindowsMaximize<CR>", desc = "Zoom window" } },
		init = function()
			vim.o.winwidth = 30
			vim.o.winminwidth = 30
			vim.o.equalalways = true
		end,
	},

	{
		"folke/noice.nvim",
		event = "VeryLazy",
		opts = {
			cmdline = {
				view = "cmdline",
				format = {
					cmdline = { icon = "  " },
					search_down = { icon = "  󰄼" },
					search_up = { icon = "  " },
					lua = { icon = " " },
				},
			},
			lsp = {
				progress = { enabled = true },
				hover = { enabled = false },
				signature = { enabled = false },
				-- override markdown rendering so that **cmp** and other plugins use **Treesitter**
				override = {
					["vim.lsp.util.convert_input_to_markdown_lines"] = true,
					["vim.lsp.util.stylize_markdown"] = true,
					["cmp.entry.get_documentation"] = true,
				},
			},
			routes = {
				{
					filter = {
						event = "msg_show",
						find = "%d+L, %d+B",
					},
				},
			},
		},
		dependencies = {
			-- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
			"MunifTanjim/nui.nvim",
			-- OPTIONAL:
			--   `nvim-notify` is only needed, if you want to use the notification view.
			--   If not available, we use `mini` as the fallback
			-- "rcarriga/nvim-notify",
		}
	},

	{
		"echasnovski/mini.pairs",
		event = "VeryLazy",
		config = function(_, opts)
			require("mini.pairs").setup(opts)
		end,
	},

	-- {
	-- 	"ray-x/lsp_signature.nvim",
	-- 	event = { "InsertEnter" },
	-- 	opts = {
	-- 	  floating_window = false, -- show hint in a floating window, set to false for virtual text only mode
	-- 	  floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
	-- 	  hint_scheme = "Comment", -- highlight group for the virtual text
	-- 	},
	-- },
	{
		"nvim-neo-tree/neo-tree.nvim",
		cmd = "Neotree",
		dependencies = { "mrbjarksen/neo-tree-diagnostics.nvim" },
		keys = {
			{
				",",
				function()
					require("neo-tree.command").execute({ toggle = true, position = "right" })
				end,
				desc = "Explorer (root dir)",
				remap = true,
			},
			{
				"<leader>e",
				function()
					require("neo-tree.command").execute({
						toggle = true,
						position = "float",
					})
				end,
				desc = "Explorer Float (root dir)",
			},
		},
		-- opts = require("tvl.config.neo-tree"),
		init = function()
			vim.g.neo_tree_remove_legacy_commands = 1
			if vim.fn.argc() == 1 then
				local stat = vim.loop.fs_stat(vim.fn.argv(0))
				if stat and stat.type == "directory" then
					require("neo-tree")
					vim.cmd([[set showtabline=0]])
				end
			end
		end,
	},

	{
		"RRethy/vim-illuminate",
		event = { "BufReadPost", "BufNewFile" },
		opts = {
			filetypes_denylist = {
				"dirvish",
				"fugitive",
				"neo-tree",
				"alpha",
				"NvimTree",
				"neo-tree",
				"dashboard",
				"TelescopePrompt",
				"TelescopeResult",
				"DressingInput",
				"neo-tree-popup",
				"",
			},
			delay = 200,
		},
		config = function(_, opts)
			require("illuminate").configure(opts)

			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			-- also set it after loading ftplugins, since a lot overwrite [[ and ]]
			vim.api.nvim_create_autocmd("FileType", {
				callback = function()
					local buffer = vim.api.nvim_get_current_buf()
					map("]]", "next", buffer)
					map("[[", "prev", buffer)
				end,
			})
		end,
		keys = {
			{ "]]", desc = "Next Reference" },
			{ "[[", desc = "Prev Reference" },
		},
	},

	{	
		"kevinhwang91/nvim-ufo",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "kevinhwang91/promise-async", event = "BufReadPost" },
		opts = {
			open_fold_hl_timeout = 400,
		},
		keys = {
			--   { "fd", "zd", desc = "Delete fold under cursor" },
			--   { "fo", "zo", desc = "Open fold under cursor" },
			--   { "fO", "zO", desc = "Open all folds under cursor" },
			--   { "fc", "zC", desc = "Close all folds under cursor" },
			--   { "fa", "za", desc = "Toggle fold under cursor" },
			--   { "fA", "zA", desc = "Toggle all folds under cursor" },
			--   { "fv", "zv", desc = "Show cursor line" },
			{
				"zM",
				function()
					require("ufo").closeAllFolds()
				end,
				desc = "Close all folds",
			},
			--   {
			-- 	"fR",
			-- 	function()
			-- 	  require("ufo").openAllFolds()
			-- 	end,
			-- 	desc = "Open all folds",
			--   },
			--   { "fm", "zm", desc = "Fold more" },
			--   { "fr", "zr", desc = "Fold less" },
			--   { "fx", "zx", desc = "Update folds" },
			--   { "fz", "zz", desc = "Center this line" },
			--   { "ft", "zt", desc = "Top this line" },
			--   { "fb", "zb", desc = "Bottom this line" },
			--   { "fg", "zg", desc = "Add word to spell list" },
			--   { "fw", "zw", desc = "Mark word as bad/misspelling" },
			--   { "fe", "ze", desc = "Right this line" },
			--   { "fE", "zE", desc = "Delete all folds in current buffer" },
			--   { "fs", "zs", desc = "Left this line" },
			--   { "fH", "zH", desc = "Half screen to the left" },
			--   { "fL", "zL", desc = "Half screen to the right" },
		},
	},

	{
		"luukvbaal/statuscol.nvim",
		event = { "BufReadPost", "BufNewFile" },
		config = function()
			local builtin = require("statuscol.builtin")
			require("statuscol").setup({
				relculright = false,
				ft_ignore = { "neo-tree" },
				segments = {
					{
						-- line number
						text = { "", builtin.lnumfunc },
						condition = { true, builtin.not_empty },
						click = "v:lua.ScLa",
					},
					{ text = { "%s" }, click = "v:lua.ScSa" }, -- Sign
					{ text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" }, -- Fold
				},
			})
			vim.api.nvim_create_autocmd({ "BufEnter" }, {
				callback = function()
					if vim.bo.filetype == "neo-tree" then
						vim.opt_local.statuscolumn = ""
					end
				end,
			})
		end,
	},

})
