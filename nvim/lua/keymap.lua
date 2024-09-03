local default_opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('', '<Space>', '<Nop>', { noremap = true, silent = true })

vim.keymap.set("i", "jk", "<Esc>", default_opts )
vim.keymap.set("i", "kj", "<Esc>", default_opts )
-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", default_opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", default_opts)
--vim.keymap.set("n", "<C-k>", "g;zz")
--vim.keymap.set("n", "<C-j>", "g,zz")

 vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", default_opts)
-- paste over currently selected text without yanking it
vim.keymap.set("v", "p", '"_dp', default_opts)
vim.keymap.set("v", "P", '"_dP', default_opts)

-- Map enter to ciw in normal mode
vim.keymap.set("n", "<CR>", "ciw", default_opts)


vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- does not work for some reason. TODO
vim.keymap.set('n', '<M-h>', '<C-w>5<', { desc = 'Resize split to the lef' })
vim.keymap.set('n', '<M-l>', '<C-w>5>', { desc = 'Resize split to the right' })
vim.keymap.set('n', '<M-j>', '<C-w>-', { desc = 'Resize split up' })
vim.keymap.set('n', '<M-k>', '<C-w>+', { desc = 'Resise split down' })

-- Diagnostic vim.keymap.sets
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Go to previous [D]iagnostic message' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Go to next [D]iagnostic message' })
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror messages' })
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

vim.keymap.set('i', '<C-j>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<C-m>', '<Plug>(copilot-next)')
vim.keymap.set('i', '<C-.>', '<Plug>(copilot-accept-word)')

vim.keymap.set("n", "<C-BS>", ":q!<cr>", default_opts)

vim.keymap.set("n", "<leader>w", ":w<CR>", default_opts)
vim.keymap.set("n", "<leader>;", ":", default_opts)
vim.keymap.set("n", "<leader>v", ":vsp<CR>", default_opts)



vim.keymap.set("n", "0", "^", default_opts)

vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", default_opts)
vim.keymap.set("n", "<leader>tq", ":tabclose<CR>", default_opts)

-- Move over every line, even continuous one
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
