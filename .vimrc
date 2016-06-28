" -----------------------------------------------------
" Auto install plugins (on Windows, also use bash)
" -----------------------------------------------------

" Auto download plugin installer if not there
if !has("unix")
  	set rtp+=~/.vim
endif
let b:rtplocation=expand('~/.vim')
let b:baselocation=b:rtplocation . '/autoload'
let b:pluglocation=b:baselocation . '/plug.vim'
if !filereadable(b:pluglocation)
  echo 'Installing vim-plug, need to :PlugInstall'
  echo ''
  " --create-dirs is broken
  execute '!mkdir -p ' . b:baselocation
  execute '!curl -fLo ' . b:pluglocation . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
endif

" -----------------------------------------------------
" List GitHub plugins HERE
" -----------------------------------------------------

call plug#begin(b:rtplocation . '/plugged')

" SPECIALIZED LANGUAGE SUPPORT
" ----------
" HASKELL
Plug 'scrooloose/syntastic'
Plug 'bitc/vim-hdevtools' " Need separate install
" Also use --hasktags--

" GENERIC FEATURES
" ----------
" Show folder
Plug 'scrooloose/nerdtree'
" Jump to letters
Plug 'Lokaltog/vim-easymotion'
" Snippets for all languages
Plug 'msanders/snipmate.vim'
" Loop through copy/paste history
Plug 'vim-scripts/YankRing.vim'
" Buffer tabs and better bottom status bar
Plug 'bling/vim-airline'
" Fuzzy search
Plug 'ctrlpvim/ctrlp.vim'
" Better completion than default <C-P>
Plug 'Shougo/neocomplete.vim'

" EXTRA SYNTAX
" ----------
Plug 'pangloss/vim-javascript'
Plug 'neovimhaskell/haskell-vim'

" EXTRA COLORS
" ----------
Plug 'flazz/vim-colorschemes'

call plug#end()

" -----------------------------------------------------
" Settings
" -----------------------------------------------------

" DEFAULT COLORS
" ----------
if has("gui_running")
  colorscheme SlateDark
  set guifont=Courier\ 10\ Pitch\ 12
  "set guifont=Lucida_Console:h11
endif

" Prefix key for many commands
let mapleader = ','

" Manual syntax checking
nnoremap <F1> :SyntasticCheck<CR>
nnoremap <Leader><F1> :SyntasticReset<CR>
" Pop up the error list
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
" Passive mode, disable check on save/open/etc
let g:syntastic_mode_map = {"mode": "passive", "active_filetypes": [], "passive_filetypes": []}
" Get type of expression in Haskell
au FileType haskell nnoremap <buffer> <F2> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <Leader><F2> :HdevtoolsClear<CR>

set encoding=utf-8   
let g:neocomplete#enable_at_startup = 1
" Don't pop up previews
set completeopt-=preview

" Remove directory from buffer line names
let g:airline#extensions#tabline#fnamemod = ':t'

" Fuzzy file search, try to find project directory
let g:ctrlp_working_path_mode = 'ar'
let g:ctrlp_map = '<C-down>'

" Auto react to file type changes
filetype plugin indent on
" Show tabs, switch between (Manual :bd to close)
let g:airline#extensions#tabline#enabled = 1
nnoremap <C-right> :bn<CR>
nnoremap <C-left> :bp<CR>
" Enable syntax colors
syntax enable
" Jump to a letter
map t <Plug>(easymotion-s)
" Unhighlight the search text
nnoremap <C-h> :noh<CR>
" Relative line numbers for easy jump
set rnu nu
" New files don't need to be saved to browse another file...
set hidden 
" Current folder matches current buffer
set autochdir 
" No magic BS indent, use last line's indent
set autoindent 
" No line wrap
set nowrap 
" No start up screen, or menus
set shortmess+=I guioptions-=m guioptions-=T
" Highlight search results
set hlsearch
" Display toolbar
set laststatus=2
" Every tab everywhere is 2 spaces
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab shiftround
" Stop preventing backspace in certain places
set backspace=indent,eol,start
" Stop comment formatting
au FileType * setlocal fo-=c fo-=r fo-=o
