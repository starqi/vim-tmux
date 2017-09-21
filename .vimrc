
"[ Vim/Neovim, any OS ]

"--------------------------------------------------
"Auto install plugins, need bash
"--------------------------------------------------

if !has("unix")
  "Don't use vimfiles
  set rtp+=~/.vim
endif
let b:rtplocation=expand('~/.vim')
let b:baselocation=b:rtplocation . '/autoload'
let b:pluglocation=b:baselocation . '/plug.vim'
if !filereadable(b:pluglocation)
  "--create-dirs is broken, use mkdir
  execute '!mkdir -p ' . b:baselocation
  execute '!curl -fLo ' . b:pluglocation . ' --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  echo 'Type :PlugInstall!'
endif

"--------------------------------------------------
"List of plugins
"--------------------------------------------------

call plug#begin(b:rtplocation . '/plugged')

if has("nvim") "Basic completion
  Plug 'Shougo/deoplete.nvim' 
else
  Plug 'Shougo/neocomplete.vim' 
endif

Plug 'rafi/awesome-vim-colorschemes'
Plug 'scrooloose/syntastic' 
Plug 'bitc/vim-hdevtools' "Sets up VIM commands for hdevtools features
Plug 'scrooloose/nerdtree' "Folder trees
Plug 'Lokaltog/vim-easymotion' "Jump to letters
Plug 'msanders/snipmate.vim' "Snippets for all languages
Plug 'vim-scripts/YankRing.vim' "Loop through copy paste history
Plug 'bling/vim-airline' "Pretty status bar
Plug 'ctrlpvim/ctrlp.vim' "Fuzzy search
Plug 'pangloss/vim-javascript' "Syntax
Plug 'mxw/vim-jsx' "Syntax
Plug 'neovimhaskell/haskell-vim' "Syntax

call plug#end()

"--------------------------------------------------
"Settings
"--------------------------------------------------

let mapleader = ',' "Prefix key for many commands
set encoding=utf-8   
colorscheme happy_hacking

let g:yankring_history_file = '.my_yankring_history_file'
let g:jsx_ext_required = 0 "JSX highlighting for JS files

"Exiting terminal insert mode
if has("nvim")
  tnoremap <Esc> <C-\><C-n>
endif

command CopyPath redir @+ | echo expand('%:p') | redir END
"Clear highlighting
nnoremap <Leader>g :noh<CR>

"Manual syntax checking
nnoremap <F2> :SyntasticCheck<CR>
nnoremap <Leader><F2> :SyntasticReset<CR>
"Pop up the error list when errors
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
"Disable syntax check on save/open/etc
let g:syntastic_mode_map = {"mode": "passive", "active_filetypes": [], "passive_filetypes": []}

"JSX, need eslint and local config file
let g:syntastic_javascript_checkers = ['eslint']

"Haskell, need hdevtools & hasktags, don't add to g:syntastic_haskell_checkers
"Get type of expression in Haskell
au FileType haskell nnoremap <buffer> <F3> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <Leader><F3> :HdevtoolsClear<CR>

"Simple autocompletion
let g:deoplete#enable_at_startup = 1
let g:neocomplete#enable_at_startup = 1
set completeopt-=preview "Don't pop up previews

" Tab workflow
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#tabs_label = ''
let g:airline#extensions#tabline#show_splits = 0

"Fuzzy file search, try to find project directory
let g:ctrlp_working_path_mode = 'ar'
let g:ctrlp_map = ''
nnoremap <leader>0 :CtrlP<CR>

nnoremap <Leader>q :tabp<CR>
nnoremap <Leader>e :tabn<CR>
nnoremap <Leader>c :tabc<CR> 
nnoremap <Leader>o :tabnew<CR>

"NERDTree
nnoremap <Leader>1 :NERDTreeFocus<CR> 
nnoremap <Leader>2 :NERDTreeToggle<CR>

map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

"Jump to a letter
map t <Plug>(easymotion-s)

filetype plugin indent on "Auto react to file type changes
syntax enable "Enable syntax colors
set rnu nu "Relative line numbers for easy jump
set hidden  "New files don't need to be saved to browse another file...
set autochdir "Current folder matches current buffer
set autoindent "No magic BS indent, use last line's indent
set nowrap "No line wrap
set shortmess+=I guioptions-=m guioptions-=T "No start up screen, or menus
set hlsearch "Highlight search results
set laststatus=2 "Display toolbar
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab shiftround "Every tab everywhere is 4 spaces
set backspace=indent,eol,start "Stop preventing backspace in certain places
set foldmethod=indent foldlevel=99 "Easily collapse with z[OocR], don't collapse on start
au FileType * setlocal fo-=c fo-=r fo-=o "Stop comment formatting
