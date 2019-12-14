" " 1 Plugin list
" ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
call plug#begin('~/.vim/plugged')

  " Automatically closing pair stuff
  Plug 'cohama/lexima.vim'

  " Commenting support (gc)
  Plug 'tpope/vim-commentary'

  " Heuristically set indent settings
  Plug 'tpope/vim-sleuth'

  " Add end automatically (seems unnecessary because there is cohama/lexima)
  " Plug 'tpope/vim-endwise'
 
  " Git support
  Plug 'tpope/vim-fugitive'

  " Adds montions to surrond objects with 'quotes' (brackets) or <h>tags</h>
  Plug 'tpope/vim-surround'

  " Adds repeat motion for vim-surround
  Plug 'tpope/vim-repeat'

  " Ruby support
  Plug 'vim-ruby/vim-ruby'

  " Intelligent autocomplete
  Plug 'neoclide/coc.nvim', {'do': { -> coc#util#install()}}


  " Custom text objects creation (including Ruby text objects)
  Plug 'kana/vim-textobj-user'
  Plug 'nelstrom/vim-textobj-rubyblock'

  " Mutli color cheme and switcher(including dependency)
  Plug 'flazz/vim-colorschemes'
  Plug 'xolox/vim-colorscheme-switcher'
  Plug 'xolox/vim-misc'

   " One more fuzzy finder
  Plug 'cloudhead/neovim-fuzzy'

  " An ack.vim alternative mimics Ctrl-Shift-F on Sublime Text 2
  Plug 'dyng/ctrlsf.vim'

  " Highlight yanked text
  Plug 'markonm/hlyank.vim'

  " Autosaving
  Plug '907th/vim-auto-save'

  " Fancy start page
  Plug 'mhinz/vim-startify'

  " Code navigation. Tags.
  Plug 'majutsushi/tagbar' 

  " TabNine. Deep Learning based code completion
  " Plug 'zxqfl/tabnine-vim'

  " Close buffers but keep splits
  Plug 'moll/vim-bbye'


  " Tree explorer (with git indicator)
  Plug 'scrooloose/nerdtree'
  Plug 'Xuyuanp/nerdtree-git-plugin'

  " Status line
  Plug 'itchyny/lightline.vim'

  " Fuzzy jumper
  Plug 'ripxorip/aerojump.nvim', { 'do': ':UpdateRemotePlugins' }


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
set cmdheight=1                             " command line height
set pumheight=10                            " Completion window max size
set noswapfile                              " New buffers will be loaded without creating a swapfile
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
set guicursor=                              " Linux Mint compatibility
set termguicolors                           " Rich color support
set mouse=a                                 " Allow using mouse
set cursorline                              " Underline active line
colo adventurous                            " Set colorscheme
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
     set undodir=~/.config/nvim/tmp/undo
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

" To fix after this line__________________________________________________________________________________________________
let mapleader = "\<Space>"                  " Set space as leader key
set nocompatible                            " nobody need compatibility :D
set noshowmode                              " Dont show mode, because lightline is showing it already

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             Plugin: Lightline                              "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:lightline = {
  \ 'colorscheme': 'one',
  \ 'active': {
  \   'left': [ [ 'mode', 'paste'  ],
  \             [ 'fugitive', 'readonly', 'filename', 'modified', 'spell', 'syntastic'  ] ],
  \   'right': [ [ 'lineinfo'  ], ['percent'], [ 'fileformat', 'fileencoding', 'filetype'  ]  ]
  \ },
  \ 'component': {
  \   'modified': '%{&filetype=="help"?"":&modified?"+":&modifiable?"":"-"}',
  \ },
  \ 'component_visible_condition': {
  \   'readonly': '(&filetype!="help"&& &readonly)',
  \   'modified': '(&filetype!="help"&&(&modified||!&modifiable))',
  \ },
  \ 'component_function': {
  \   'fugitive': 'LightlineFugitive',
  \ },
  \ 'component_expand': {
  \   'syntastic': 'SyntasticStatuslineFlag',
  \ },
  \ 'component_type': {
  \   'syntastic': 'error',
  \ }
  \ }

function! LightlineFugitive() abort
  if &filetype ==# 'help'
    return ''
  endif
  if has_key(b:, 'lightline_fugitive') && reltimestr(reltime(b:lightline_fugitive_)) =~# '^\s*0\.[0-5]'
    return b:lightline_fugitive
  endif
  try
    if exists('*fugitive#head')
      let head = fugitive#head()
    else
      return ''
    endif
    let b:lightline_fugitive = head
    let b:lightline_fugitive_ = reltime()
    return b:lightline_fugitive
  catch
  endtry
  return ''
endfunction


" autosave settings
let g:auto_save = 1  " enable AutoSave on Vim startup

set autoread  " Reload files changed outside vim
" Triger `autoread` when files changes on disk
" https://unix.stackexchange.com/questions/149209/refresh-changed-content-of-file-opened-in-vim/383044#383044
" https://vi.stackexchange.com/questions/13692/prevent-focusgained-autocmd-running-in-command-line-editing-mode
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
" Notification after file change
" https://vi.stackexchange.com/questions/13091/autocmd-event-for-autoread
autocmd FileChangedShellPost *
  \ echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
set list listchars=tab:\ \ ,trail:•" Display tabs and trailing spaces visually
" syntax on
filetype plugin indent on " Ruby syntax highlighting
"
" Auto indent pasted text
nnoremap p p=`]<C-o>
nnoremap P P=`]<C-o>

" normal mode mappings
nmap 0 ^
map tt :tabnew<cr>
map tc :tabclose<cr>
nmap <BS> <C-w>
nmap <leader>vr :tabe $MYVIMRC<cr>
nmap <leader>so :source $MYVIMRC<cr>
nmap <leader>; :
nmap <leader>w :w<CR>
"""""""""""""""""""""""""""""""""""""""""""""""""""
"             Search mappings                     "
"""""""""""""""""""""""""""""""""""""""""""""""""""
nmap     <C-F>f <Plug>CtrlSFPrompt
vmap     <C-F>f <Plug>CtrlSFVwordPath
" vmap     <C-F>F <Plug>CtrlSFVwordExec
nmap     <C-F>w <Plug>CtrlSFCwordPath
nnoremap <C-F>o :CtrlSFOpen<CR>
nnoremap <C-F>t :CtrlSFToggle<CR>
inoremap <C-F>t <Esc>:CtrlSFToggle<CR>


map , :NERDTreeToggle<CR>
nnoremap <silent> <expr> <Leader><Leader> (expand('%') =~ 'NERD_tree' ? "\<c-w>\<c-w>" : '').":FuzzyOpen\<cr>"
nmap <Leader>cf :silent !echo -n % \| pbcopy<Enter>
let g:NERDTreeWinPos = "right"
:let g:NERDTreeShowLineNumbers=1
:autocmd BufEnter NERD_* setlocal rnu

" insert mode mappings
imap jk <esc>
imap kj <esc>

" tweaked line numbers
set number relativenumber
:augroup numbertoggle
:  autocmd!
:  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
:  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
:augroup END



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                             Plugin: startify                               "
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Don't change to directory when selecting a file
let g:startify_files_number = 10
let g:startify_change_to_dir = 0
let g:startify_custom_header = [ ]
let g:startify_relative_path = 1
let g:startify_use_env = 1

" Custom startup list, only show MRU from current directory/project
let g:startify_lists = [
      \  { 'type': 'dir',       'header': [ 'Files '. getcwd() ] },
      \  { 'type': 'bookmarks', 'header': [ 'Bookmarks' ]      },
      \  { 'type': 'commands',  'header': [ 'Commands' ]       },
      \ ]

let g:startify_bookmarks = [
      \ { 'c': '~/.config/nvim/init.vim' },
      \ { 'g': '~/.gitconfig' },
      \ { 'z': '~/.zshrc' }
      \ ]

autocmd User Startified setlocal cursorline
nmap <leader>st :Startify<cr>

" use <tab> for trigger completion and navigate to the next complete item
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
