vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Disable netrw early for nvim-tree (must be before any plugin loads)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
-- Pre-create FileExplorer augroup to avoid E216 from nvim-tree's manage_netrw (silent! still logs in -V)
pcall(vim.api.nvim_create_augroup, 'FileExplorer', { clear = true })
-- Suppress vim-tmux-navigator netrw conflict warning
vim.g.tmux_navigator_disable_netrw_workaround = 1

require("options")
require("keymap")

vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = '*.tf',
  callback = function() vim.bo.filetype = 'hcl' end,
})

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--  LAZY PLUGIN SETUP
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
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

require("lazy").setup("plugins", {
	change_detection = {
		notify = false,
	},
})
