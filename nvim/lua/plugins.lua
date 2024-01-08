return {
    "folke/which-key.nvim",
    "f-person/git-blame.nvim",
    "numToStr/Comment.nvim",
  -----------------------------------------------------------
      {
          'rebelot/kanagawa.nvim',
          priority = 1000,
          config = function()
              vim.cmd.colorscheme 'kanagawa'
          end,
      },
  
      {
          'echasnovski/mini.starter',
          version = '*',
          config = function()
              require('mini.starter').setup()
          end
      }
  
  }
  
  