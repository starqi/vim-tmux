
"--------------------------------------------------
" Vim/Neovim, all OS, no GUI
"--------------------------------------------------

" Auto install plugins, need bash
if !has("unix")
  " Don't use vimfiles
  set rtp+=~/.vim
endif
let b:rtplocation=expand('~/.vim')
let b:baselocation=b:rtplocation . '/autoload'
let b:pluglocation=b:baselocation . '/plug.vim'
if !filereadable(b:pluglocation)
  " --create-dirs is broken
  execute '!mkdir -p ' . b:baselocation
  execute '!curl -fLo ' . b:pluglocation . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  echo 'Type :PlugInstall!'
endif

" List of plugins
call plug#begin(b:rtplocation . '/plugged')
Plug 'scrooloose/syntastic' " Syntax checking
Plug 'Shougo/deoplete.nvim' " Completion
Plug 'bitc/vim-hdevtools' " For Haskell, also need separate install, also use hasktags
Plug 'scrooloose/nerdtree' " Folder trees
Plug 'Lokaltog/vim-easymotion' " Jump to letters
Plug 'msanders/snipmate.vim' " Snippets for all languages
Plug 'vim-scripts/YankRing.vim' " Loop through copy paste history
Plug 'bling/vim-airline' " Pretty status bar
Plug 'ctrlpvim/ctrlp.vim' " Fuzzy search
Plug 'pangloss/vim-javascript' " Syntax
Plug 'neovimhaskell/haskell-vim' " Syntax
call plug#end()

" Settings
set clipboard+=unnamed
set encoding=utf-8   
colorscheme elflord
if has("nvim")
  " Exiting terminal insert mode
  tnoremap <Esc> <C-\><C-n>
endif
let mapleader = ',' " Prefix key for many commands
" Manual syntax checking
nnoremap <F2> :SyntasticCheck<CR>
nnoremap <Leader><F2> :SyntasticReset<CR>
" Clear highlighting
nnoremap <C-j> :noh<CR>
" Pop up the error list
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
" Disable syntax check on save/open/etc
let g:syntastic_mode_map = {"mode": "passive", "active_filetypes": [], "passive_filetypes": []}
" Get type of expression in Haskell
au FileType haskell nnoremap <buffer> <F3> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <Leader><F3> :HdevtoolsClear<CR>
let g:deoplete#enable_at_startup = 1
" Don't pop up previews
set completeopt-=preview
" Remove directory from buffer line names
let g:airline#extensions#tabline#fnamemod = ':t'
" Fuzzy file search, try to find project directory
let g:ctrlp_working_path_mode = 'ar'
let g:ctrlp_map = ''
nnoremap <leader>p :CtrlP<CR>
" Auto react to file type changes
filetype plugin indent on
" Show tabs, switch between
let g:airline#extensions#tabline#enabled = 1
nnoremap <C-b>l :bn<CR>
nnoremap <C-b>h :bp<CR>
nnoremap <C-b>d :bd<CR>
syntax enable " Enable syntax colors
" Jump to a letter
map t <Plug>(easymotion-s)
set rnu nu " Relative line numbers for easy jump
set hidden  " New files don't need to be saved to browse another file...
set autochdir " Current folder matches current buffer
set autoindent " No magic BS indent, use last line's indent
set nowrap " No line wrap
set shortmess+=I guioptions-=m guioptions-=T " No start up screen, or menus
set hlsearch " Highlight search results
set laststatus=2 " Display toolbar
" Every tab everywhere is 2 spaces
set tabstop=2 softtabstop=2 shiftwidth=2 expandtab shiftround
set backspace=indent,eol,start " Stop preventing backspace in certain places
au FileType * setlocal fo-=c fo-=r fo-=o " Stop comment formatting
