
" " 1 Plugin list
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
call plug#begin('~/.vim/plugged')
  " Snippet support (C-j)
  " Plug 'SirVer/ultisnips'

  " Asynchronous maker and linter (needs linters to work)
  " Plug 'benekastah/neomake', { 'on': ['Neomake'] }

  " Autocomplete
  " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

  " Automatically closing pair stuff
  Plug 'cohama/lexima.vim'

  " Commenting support (gc)
  Plug 'tpope/vim-commentary'

  " Heuristically set indent settings
  Plug 'tpope/vim-sleuth'

  "  Ruby support (plays nicely with tpope/rbenv-ctags)
  Plug 'vim-ruby/vim-ruby'

  " Rails support (:A, :R, :Rmigration, :Rextract)
  Plug 'tpope/vim-rails', { 'for': ['ruby', 'eruby', 'haml', 'slim'] }

  " " Bundler support (plays nicely with tpope/gem-ctags)
  " Plug 'tpope/vim-bundler', { 'for': ['ruby', 'eruby', 'haml', 'slim'] }

  " Custom text objects creation (dependency for the latter)
  Plug 'kana/vim-textobj-user'

  " Mutli color cheme and switcher
  Plug 'flazz/vim-colorschemes'
  Plug 'xolox/vim-colorscheme-switcher'
  Plug 'xolox/vim-misc'

  " material color scheme
  Plug 'hzchirs/vim-material'

  Plug 'nelstrom/vim-textobj-rubyblock'
  Plug 'tpope/vim-endwise'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-sensible'
  Plug 'scrooloose/nerdtree'
  Plug 'ctrlpvim/ctrlp.vim'
  Plug 'itchyny/lightline.vim'
call plug#end()
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


" ======================================================================================================================
" " 2 Basic settings (Neovim defaults: https://neovim.io/doc/user/vim_diff.html#nvim-option-defaults)
"
" ======================================================================================================================

set encoding=utf-8                          " The encoding displayed.
scriptencoding utf-8                        " Set utf-8 as default script encoding
set shell=/bin/zsh                          " Setting shell to zsh
set showcmd                                 " Show commands as you type them
set textwidth=120                           " Text width is 120 characters
set cmdheight=1                             " Command line height
set pumheight=10                            " Completion window max size
set noswapfile                              " New buffers will be loaded without creating a swapfile
set hidden                                  " Enables to switch between unsaved buffers and keep undo history
set clipboard+=unnamed                      " Allow to use system clipboard
set lazyredraw                              " Don't redraw while executing macros (better performance)
set showmatch                               " Show matching brackets when text indicator is over them
set matchtime=2                             " How many tenths of a second to blink when matching brackets
set nostartofline                           " Prevent cursor from moving to beginning of line when switching buffers
set virtualedit=block                       " To be able to select past EOL in visual block mode
set nojoinspaces                            " No extra space when joining a line which ends with . ? !
set scrolloff=5                             " Scroll when closing to top or bottom of the screen
set updatetime=1000                         " Update time used to create swap file or other things
set suffixesadd+=.rb                        " Add ruby files to suffixes
set guicursor=                  				    " Linux Mint compatibility
colo lodestone
" ----------------------------------------------------------------------------------------------------------------------
" 2.1 Split settings (more natural)
"
" ----------------------------------------------------------------------------------------------------------------------
set splitbelow                              " Splitting a window will put the new window below the current
set splitright                              " Splitting a window will put the new window right of the current


" ----------------------------------------------------------------------------------------------------------------------
" 2.2 Navigation between windows (more natural)
"
" ----------------------------------------------------------------------------------------------------------------------
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" ---------------------------------------------------------------------------------------------------------------------
" 2.3 Search settings
"
" ---------------------------------------------------------------------------------------------------------------------
set ignorecase                              " Ignore case by default
set smartcase                               " Make search case sensitive only if it contains uppercase letters
set wrapscan                                " Search again from top when reached the bottom
set nohlsearch                              " Don't highlight after search

" ----------------------------------------------------------------------------------------------------------------------
" 2.4 Persistent undo settings
"
" ----------------------------------------------------------------------------------------------------------------------
 if has('persistent_undo')
   set undofile
     set undodir=~/.config/nvim/tmp/undo//
 endif

" ----------------------------------------------------------------------------------------------------------------------
" 2.5 Avoid using arrows
"
" ----------------------------------------------------------------------------------------------------------------------
nnoremap <Left> :echo "Use h"<CR>
nnoremap <Right> :echo "Use l"<CR>
nnoremap <Up> :echo "Use k"<CR>
nnoremap <Down> :echo "Use j"<CR>

 " ======================================================================================================================
 " 3.0 Mapping settings
 "
 " ======================================================================================================================

let mapleader = "\<Space>"                  " Set space as leader key
set nocompatible                            " nobody need compatibility :D
set nohlsearch                              " Don't highlight after search
set noshowmode                              " Dont show mode, because lightline is showing it already

" Use autocompletion plugin at startup
let g:deoplete#enable_at_startup = 1
let g:python3_host_prog = '/usr/local/bin/python3'
" Make CtrlP use ag for listing the files. Way faster and no useless files.l
let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
let g:ctrlp_use_caching = 0

" statusline settings
 let g:lightline = {
       \ 'colorscheme': 'one',
             \ }


set tabstop=2 " set tab size to 2, ruby-way
set expandtab " insert spaces instead of TAB
set shiftwidth=2 "number of space characters inserted for indentation
set cursorline " underline active line
set autoread  " Reload files changed outside vim
" set list listchars=tab:\ \ ,trail:•" Display tabs and trailing spaces visually
syntax on
filetype plugin indent on " Ruby syntax highlighting

" normal mode mappings
nmap 0 ^
nmap <leader>vr :tabe $MYVIMRC<cr>
nmap <leader>so :source $MYVIMRC<cr>
nmap <leader>; :
nmap <leader>w :w<CR>
map <C-n> :NERDTreeToggle<CR>
let g:NERDTreeWinPos = "right"

" insert mode mappings
imap jk <esc>
imap kj <esc>

map + <c-w>+
map _ <c-w>-
map = <c-w>>
map - <c-w><
" tweaked line numbers
set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END
