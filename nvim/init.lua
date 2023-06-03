----------------------------------------------------------
-- General
-----------------------------------------------------------
vim.g.mapleader = " "             -- map Space as leader key
vim.opt.mouse = "a"               -- enable mouse support
vim.opt.clipboard = "unnamedplus" -- copy/paste to system clipboard
vim.opt.swapfile = false          -- don"t use swapfile
vim.opt.undofile = true 		  -- save undo history


-----------------------------------------------------------
-- Neovim UI
-----------------------------------------------------------
vim.opt.number = true             -- show line number
vim.opt.relativenumber = true             -- show relative line number
vim.opt.showmatch = true          -- highlight matching parenthesis

local options = {
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	cmdheight = 0, -- more space in the neovim command line for displaying messages
	confirm = true, -- Confirm to save changes before exiting modified buffer
	conceallevel = 0, -- so that `` is visible in markdown files
	incsearch = true,
	hlsearch = true, -- highlight all matches on previous search pattern
	inccommand = "nosplit",
	ignorecase = true, -- ignore case in search patterns
	grepformat = "%f:%l:%c:%m",
	-- grepprg = "rg --vimgrep",
	mouse = "a", -- allow the mouse to be used in neovim
	pumheight = 10, -- pop up menu height
	showmode = false, -- we don't need to see things like -- INSERT -- anymore
	smartindent = true, -- make indenting smarter again
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	swapfile = false, -- creates a swapfile
	termguicolors = true, -- set term gui colors (most terminals support this)
	timeoutlen = 100, -- time to wait for a mapped sequence to complete (in milliseconds)
	undofile = true,                         -- enable persistent undo
	updatetime = 500, -- faster completion (4000ms default)
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	-- expandtab = true, -- convert tabs to spaces
	-- shiftwidth = 2, -- the number of spaces inserted for each indentation
	-- tabstop = 2, -- insert 2 spaces for a tab
	cursorline = true, -- highlight the current line
	number = true, -- set numbered lines
	relativenumber = true,                   -- set relative numbered lines
	numberwidth = 2, -- set number column width to 2 {default 4}
	signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	wrap = false, -- display lines as one long line
	-- scrolloff = 6, -- is one of my fav
	-- sidescrolloff = 8,
	laststatus = 3,
	guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20",
	-- guicursor = "a:xxx",
	background = "dark",
	selection = "exclusive",
	virtualedit = "onemore",
	showcmd = false,
	title = true,
	titlestring = "%<%F%=%l/%L - nvim",
	linespace = 8,
	mousemoveevent = true,
	syntax = "off",
	spelllang = { "en" },
	-- use fold
	foldlevelstart = 99,
	foldlevel = 99,
	foldenable = true,
	foldcolumn = "1",
	fillchars = {
	  foldopen = "",
	  foldclose = "",
	  fold = " ",
	  foldsep = " ",
	  diff = "╱",
	  eob = " ",
	},
	-- session
	sessionoptions = { "buffers", "curdir", "tabpages", "winsize" },
  }

  
  for k, v in pairs(options) do
	vim.opt[k] = v
  end

-- vim.o.foldcolumn = '1' -- '0' is not bad
-- vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
-- vim.o.foldlevelstart = 99
-- vim.o.foldenable = true
-- vim.opt.foldmethod = "expr"
-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"


-- Put anything you want to happen only in Neovide here
if vim.g.neovide then
	vim.o.guifont = "SauceCodePro Nerd Font Mono:h14" 
	vim.g.neovide_refresh_rate = 120
	vim.g.neovide_cursor_animation_length = 0.1
	vim.g.neovide_cursor_trail_size = 0
	vim.g.neovide_cursor_animate_command_line = false
end

vim.opt.splitright = true         -- vertical split to the right
vim.opt.splitbelow = true         -- orizontal split to the bottom
vim.opt.ignorecase = true         -- ignore case letters when search
vim.opt.smartcase = true          -- ignore lowercase for the whole pattern
vim.opt.hlsearch = false          -- don"t highlight after search
vim.g.showcmd = true              -- show commands as it's typed
vim.wo.cursorline = true          -- Highlight current line


-----------------------------------------------------------
-- Key mappings UI
-----------------------------------------------------------
local keymap = vim.api.nvim_set_keymap          -- set global keymap
local default_opts = {noremap = true, silent = true}

keymap("i", "jk", "<Esc>", default_opts )
keymap("i", "kj", "<Esc>", default_opts )

keymap("n", "<C-h>", "<C-w>h", default_opts)
keymap("n", "<C-j>", "<C-w>j", default_opts)
keymap("n", "<C-k>", "<C-w>k", default_opts)
keymap("n", "<C-l>", "<C-w>l", default_opts)

keymap("n", "<leader>w", ":w<CR>", default_opts)
keymap("n", "<leader>;", ":", default_opts)
keymap("n", "<leader>v", ":vsp<CR>", default_opts)
keymap("n", "<leader><leader>", ":Telescope find_files<CR>", default_opts)

keymap("n", "0", "^", default_opts)
keymap("n", "<leader>fb", ":Telescope file_browser<CR>", default_opts)
keymap("n", "tt", ":tabnew<CR>", default_opts)
keymap("n", "tg", ":tabclose<CR>", default_opts)
-- keymap("n", "<leader>ec", ":tabe $MYVIMRC<CR>", default_opts)
keymap('n', '<leader>q', ':quitall<CR>', default_opts)
keymap('n', '<',':quitall<CR>', default_opts)

-------------------- Fuzzy Search --------------------------------
vim.keymap.set("n", "<C-f>", function()
	-- You can pass additional configuration to telescope to change theme, layout, etc.
	require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes"))
  end, { desc = "[/] Fuzzily search in current buffer]" })

-- Change text without putting it into the vim register,
-- see https://stackoverflow.com/q/54255/6064933
-- keymap.set("n", "c", '"_c')
-- keymap.set("n", "C", '"_C')
-- keymap.set("n", "cc", '"_cc')
-- keymap.set("x", "c", '"_c')

-- Copy entire buffer.
-- keymap.set("n", "<leader>y", "<cmd>%yank<cr>", { desc = "yank entire buffer" })

-- Keep cursor position after yanking
-- keymap.set("n", "y", "myy")

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
		dependencies = { 'nvim-lua/plenary.nvim' } 
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

	{ -- Highlight, edit, and navigate code
		'nvim-treesitter/nvim-treesitter',
		dependencies = {
			'nvim-treesitter/nvim-treesitter-textobjects',
		},
		config = function()
			pcall(require('nvim-treesitter.install').update { with_sync = true })
		end,
	},

	{
		'rebelot/kanagawa.nvim',
		priority = 1000,
		config = function()
			vim.cmd.colorscheme 'kanagawa'
		end,
	},

	{ -- Set lualine as statusline
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
	-- Silly addon to make it rain
	-- {
	-- 	'eandrju/cellular-automaton.nvim',
	-- 	dependencies = { {'nvim-treesitter/nvim-treesitter'}}
	-- }
	
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
			"rcarriga/nvim-notify",
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


vim.g.gitblame_display_virtual_text = 0 -- Disable virtual text
local git_blame = require('gitblame')

vim.g.gitblame_message_template = '<date> •  <summary>  • <author>'
require('lualine').setup {
 options = {
  icons_enabled = true,
  -- theme = 'codedark',
  component_separators = { left = '', right = ''},
  -- section_separators = { left = 'JJJJ', right = ''},
  section_separators = { left = '', right = ''},
  disabled_filetypes = { 'neo-tree' },
  always_divide_middle = true,
  globalstatus = true,
 },
 sections = {
	lualine_a = {'mode'},
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


--   lualine_b = {'filename'},
  lualine_c = { { git_blame.get_current_blame_text, cond = git_blame.is_blame_text_available } },
  lualine_x = {'filetype'},
  lualine_y = {},
  lualine_z = {'tabs'}
 },
 inactive_sections = {
  lualine_a = {},
  lualine_b = {},
  lualine_c = {'filename'},
  lualine_x = {'location'},
  lualine_y = {},
  lualine_z = {}
 },
 tabline = {},
 extensions = {}
}

vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.api.nvim_set_keymap("n", "<space>ff", ":Telescope file_browser", { noremap = true })
vim.api.nvim_set_keymap("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true", { noremap = true })

