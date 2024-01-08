vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })
vim.g.mapleader = ' '

local options = {
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	cmdheight = 0, -- more space in the neovim command line for displaying messages
	confirm = true, -- Confirm to save changes before exiting modified buffer
	conceallevel = 0, -- so that `` is visible in markdown files
	completeopt = 'menuone,noselect',
	incsearch = true,
	hlsearch = false, -- highlight all matches on previous search pattern
	inccommand = "nosplit",
	ignorecase = true, -- ignore case in search patterns
	grepformat = "%f:%l:%c:%m",
	-- grepprg = "rg --vimgrep",
	mouse = "a", -- allow the mouse to be used in neovim
	-- pumheight = 10, -- pop up menu height
	showmode = false, -- we don't need to see things like -- INSERT -- anymore
	smartindent = true, -- make indenting smarter again
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	swapfile = false, -- creates a swapfile
	termguicolors = true, -- set term gui colors (most terminals support this)
	timeoutlen = 100, -- time to wait for a mapped sequence to complete (in milliseconds)
	lazyredraw = true,
	undofile = true,         -- enable persistent undo
	updatetime = 500, -- faster completion (4000ms default)
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	cursorline = true, -- highlight the current line
	cursorcolumn = false, -- highlight the current line
	number = true, -- set numbered lines
	relativenumber = true,                   -- set relative numbered lines
	numberwidth = 2, -- set number column width to 2 {default 4}
	-- signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time
	wrap = false, -- display lines as one long line
	laststatus = 3,
	-- guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20",
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

local keymap = vim.api.nvim_set_keymap
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

keymap("n", "0", "^", default_opts)

keymap("n", "<leader>tn", ":tabnew<CR>", default_opts)
keymap("n", "<leader>tq", ":tabclose<CR>", default_opts)

-- Move over every line, even continious one
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })



local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins")
require("lsp")

