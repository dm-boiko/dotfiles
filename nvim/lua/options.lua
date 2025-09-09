local options = {
	clipboard = "unnamedplus", -- allows neovim to access the system clipboard
	--cmdheight = 0, -- more space in the neovim command line for displaying messages
	confirm = true, -- Confirm to save changes before exiting modified buffer
	conceallevel = 0, -- so that `` is visible in markdown files
	completeopt = 'menuone,noselect', -- use popup menu for completion in insert mode
	incsearch = true, -- incremental search, show matches as you type
	hlsearch = false, -- highlight all matches on previous search pattern
	inccommand = "nosplit",
	ignorecase = true, -- ignore case in search patterns
	grepformat = "%f:%l:%c:%m",
	-- grepprg = "rg --vimgrep",
	mouse = "a", -- allow the mouse to be used in neovim
	-- pumheight = 10, -- pop up menu height
	showmode = false, -- we don't need to see things like -- INSERT -- anymore
	smartindent = true,
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	swapfile = false, -- creates a swapfile
	termguicolors = true, -- set term gui colors (most terminals support this)
	--timeoutlen = 100, -- time to wait for a mapped sequence to complete (in milliseconds)
	undofile = true,         -- enable persistent undo
	updatetime = 500, -- faster completion (4000ms default)
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	cursorline = true, -- highlight the current line
	number = true, -- set numbered lines
	relativenumber = true,  -- set relative numbered lines
	signcolumn = "no", -- always show the sign column, otherwise it would shift the text each time
	wrap = true, -- display lines as one long line
	laststatus = 3,
	-- guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20",
	background = "dark",
	selection = "exclusive",
	virtualedit = "onemore",
	title = true,
	titlestring = "%<%F%=%l/%L - nvim",
	--linespace = 8,
	mousemoveevent = true,
	syntax = "off",
	spelllang = { "en" },
	-- use fold
	foldlevelstart = 99,
	foldlevel = 99,
	foldenable = true,
	foldcolumn = "0",
	fillchars = {
		foldopen = "",
		foldclose = "",
		fold = " ",
		foldsep = " ",
		diff = "╱",
		eob = " ",
	},
	-- session
	-- sessionoptions = { "buffers", "curdir", "tabpages", "winsize" },
	tabstop = 4,
	shiftwidth = 4,
	expandtab = true,
	softtabstop = 4,

}

for k, v in pairs(options) do
	vim.opt[k] = v
end
