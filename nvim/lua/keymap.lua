local default_opts = { noremap = true, silent = true }

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { noremap = true, silent = true })

vim.keymap.set("i", "jk", "<Esc>", default_opts )
vim.keymap.set("i", "kj", "<Esc>", default_opts )

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", default_opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", default_opts)

vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", default_opts)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", default_opts)

-- paste over currently selected text without yanking it
vim.keymap.set("v", "p", '"_dp', default_opts)
vim.keymap.set("v", "P", '"_dP', default_opts)

-- Map enter to ciw in normal mode
vim.keymap.set("n", "<CR>", "ciw", default_opts)


vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Diagnostic vim.keymap.sets
vim.keymap.set('n', '[d', function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set("n", "<C-BS>", ":q!<cr>", default_opts)

vim.keymap.set("n", "<leader>w", ":w<CR>", default_opts)
vim.keymap.set("n", "<leader>;", ":", default_opts)
vim.keymap.set("n", "<leader>v", ":vsp<CR>", default_opts)
vim.keymap.set("n", "0", "^", default_opts)
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", default_opts)
vim.keymap.set("n", "<leader>tq", ":tabclose<CR>", default_opts)

-- Move over wrapped lines
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })






