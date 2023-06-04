----------------------------------------------------------
-- General options
-----------------------------------------------------------
vim.g.mapleader = " "             -- map Space as leader key

local options = {
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	cmdheight = 0, -- more space in the neovim command line for displaying messages
	confirm = true, -- Confirm to save changes before exiting modified buffer
	conceallevel = 0, -- so that `` is visible in markdown files
	incsearch = true,
	-- hlsearch = false, -- highlight all matches on previous search pattern
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

-----------------------------------------------------------
-- Only Neovide settings
----------------------------------------------------------
if vim.g.neovide then
	vim.o.guifont = "SauceCodePro Nerd Font Mono:h14" 
	vim.g.neovide_refresh_rate = 120
	vim.g.neovide_cursor_animation_length = 0.1
	vim.g.neovide_cursor_trail_size = 0
	vim.g.neovide_cursor_animate_command_line = false
end

-----------------------------------------------------------
-- Key mappings
----------------------------------------------------------
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
keymap("n", "<leader><leader>", ":Telescope find_files<CR>", default_opts)

keymap("n", "0", "^", default_opts)
keymap("n", "<leader>fb", ":Telescope file_browser<CR>", default_opts)
keymap("n", "tt", ":tabnew<CR>", default_opts)
keymap("n", "tg", ":tabclose<CR>", default_opts)
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
-- Split parts of the init into different files and load 
----------------------------------------------------------
local core_modules = {
	"load_plugins",
	"load_lualine"
}
-- Using pcall we can handle better any loading issues
for _, module in ipairs(core_modules) do
    local ok, err = pcall(require, module)
    if not ok then
        error("Error loading " .. module .. "\n\n" .. err)
    end
end



-- keymap('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
-- keymap('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
-- keymap('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
-- vim.api.nvim_set_keymap("n", "<space>fb", ":Telescope file_browser path=%:p:h select_buffer=true<CR>", { noremap = true })
