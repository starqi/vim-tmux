
" Vim/Neovim, any OS
" Try to be minimal

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
"List of plugins, need git
"--------------------------------------------------

call plug#begin(b:rtplocation . '/plugged')

Plug 'Shougo/deoplete.nvim' "Autocompletion
Plug 'rafi/awesome-vim-colorschemes'
Plug 'scrooloose/syntastic' "Lint
Plug 'scrooloose/nerdtree' "Folder trees
Plug 'Lokaltog/vim-easymotion' "Jump to letters
Plug 'vim-scripts/YankRing.vim' "Loop through copy paste history
Plug 'bling/vim-airline' "Pretty status bar
Plug 'vim-airline/vim-airline-themes'
Plug 'kshenoy/vim-signature' "Mark management
Plug 'vim-scripts/BufOnly.vim' "When too many buffers open
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' } "Fuzzy search
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive' "Git helper
Plug 'majutsushi/tagbar' "Ctags single file preview

"Specialized
Plug 'bitc/vim-hdevtools' "Sets up VIM commands for hdevtools features
Plug 'mhartington/nvim-typescript' "TSServer integration
"Syntax
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript' 
Plug 'mxw/vim-jsx' 
Plug 'neovimhaskell/haskell-vim' 

call plug#end()

"--------------------------------------------------
"Specialized
"--------------------------------------------------

"** JSX **, need eslint and local config file
let g:syntastic_javascript_checkers = ['eslint']
let g:jsx_ext_required = 0 "JSX highlighting for JS files

"** Haskell **, need hdevtools & hasktags, don't add to g:syntastic_haskell_checkers
"Get type of expression
au FileType haskell nnoremap <buffer> <F3> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <Leader><F3> :HdevtoolsClear<CR>

"** Typescript **, need tsserver
"...TODO - nvim-typescript settings
"Also tags for tagbar support, need ctags w/ https://github.com/jb55/typescript-ctags 
let g:tagbar_type_typescript = {
  \ 'ctagstype': 'typescript',
  \ 'kinds': [
    \ 'c:classes',
    \ 'n:modules',
    \ 'f:functions',
    \ 'v:variables',
    \ 'v:varlambdas',
    \ 'm:members',
    \ 'i:interfaces',
    \ 'e:enums',
  \ ]
\ }

"** VimL ** TODO - Deoplete

"--------------------------------------------------
"General
"--------------------------------------------------

let mapleader = ',' "Prefix key for many commands
set encoding=utf-8   
colorscheme gruvbox
set clipboard+=unnamedplus "Copy all yanks to system clipboard
let g:yankring_history_file = '.my_yankring_history_file'

nnoremap <F4> :TagbarToggle<CR>

"Manual syntax checking
nnoremap <F2> :SyntasticCheck<CR>
nnoremap <Leader><F2> :SyntasticReset<CR>
"Pop up the error list when errors
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
"Disable syntax check on save/open/etc
let g:syntastic_mode_map = {"mode": "passive", "active_filetypes": [], "passive_filetypes": []}

"Text autocompletion
let g:deoplete#enable_at_startup = 1
set completeopt-=preview "Don't pop up previews

command CopyPath redir @+ | echo expand('%:p') | redir END

"Exiting terminal insert mode with ESC
if has("nvim")
  tnoremap <Esc> <C-\><C-n>
endif

"Clear highlighting
nnoremap <Leader>g :noh<CR>

" Tab workflow
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#tabs_label = ''
let g:airline#extensions#tabline#show_splits = 0

" Fuzzy find git repo files
nnoremap <leader>0 :GFiles<CR>
nnoremap <leader>9 :Buffers<CR>

"Jump to tab _
nnoremap <expr> <Leader>w ":tabn " . nr2char(getchar()) . "<CR>"
"Move tab after _
nnoremap <expr> <Leader>s ":tabm " . nr2char(getchar()) . "<CR>"
nnoremap <Leader>q :tabp<CR>
nnoremap <Leader>e :tabn<CR>
nnoremap <Leader>c :tabc<CR> 
nnoremap <Leader>o :tabnew<CR>

"Browse directory
nnoremap <Leader>1 :NERDTreeFocus<CR> 
nnoremap <Leader>2 :NERDTreeToggle<CR>

"Fast move beetween windows
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-C> <C-W>c

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
set foldmethod=indent foldlevel=99 " Don't collapse on start
au FileType * setlocal fo-=c fo-=r fo-=o "Stop comment formatting
