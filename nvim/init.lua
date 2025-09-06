vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require("options")
require("keymap")

-- vim.cmd([[silent! autocmd BufRead,BufNewFile *.tf set filetype=hcl]])


-- When text is yanked, highlight it for a short while
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

--  LAZY PLUGIN SETUP
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

require("lazy").setup("plugins", {
 change_detection = {
  notify = false,
 },
})

require("lsp-config")
