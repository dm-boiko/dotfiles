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
-- cmd('colorscheme github_dimmed')
vim.opt.number = true             -- show line number
vim.opt.relativenumber = true             -- show relative line number
vim.opt.showmatch = true          -- highlight matching parenthesis
vim.opt.foldmethod = "marker"     -- enable folding (default "foldmarker")
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
-- keymap("n", ",", ":NvimTreeToggle<CR>", default_opts)
keymap("n", "tt", ":tabnew<CR>", default_opts)
keymap("n", "tg", ":tabclose<CR>", default_opts)
keymap("n", "<leader>ec", ":tabe $MYVIMRC<CR>", default_opts)
keymap('n', '<leader>q', ':quitall<CR>', default_opts)


-- Always use very magic mode for searching
-- keymap.set("n", "/", [[/\v]])

-- Use Esc to quit builtin terminal
-- keymap.set("t", "<Esc>", [[<c-\><c-n>]])

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
	{ 'numToStr/Comment.nvim', opts = {} },
	{ 'nvim-telescope/telescope.nvim', version = '*', dependencies = { 'nvim-lua/plenary.nvim' } },
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


})

vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
