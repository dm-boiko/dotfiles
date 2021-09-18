local keymap = vim.api.nvim_set_keymap  		-- set global keymap
local default_opts = {noremap = true, silent = true}

keymap("i", "jk", "<Esc>", default_opts )
keymap("i", "kj", "<Esc>", default_opts )

keymap("n", "<C-h>", "<C-w>h", default_opts)
keymap("n", "<C-j>", "<C-w>j", default_opts)
keymap("n", "<C-k>", "<C-w>k", default_opts)
keymap("n", "<C-l>", "<C-w>l", default_opts)

keymap("n", "<leader>w", ":w<CR>", default_opts)
keymap("n", "<leader>;", ":", default_opts)

keymap("n", "0", "^", default_opts)
keymap("n", "tt", ":tabnew<CR>", default_opts)
keymap("n", "tg", ":tabclose<CR>", default_opts)
keymap("n", "<leader>ec", ":tabe $MYVIMRC<CR>", default_opts)
keymap('n', '<leader>q', ':quitall<CR>', default_opts)
