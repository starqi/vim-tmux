
" Neovim, Windows, Linux
" Try to be minimal

"--------------------------------------------------
"Auto install plugins, need bash
"--------------------------------------------------

if has("unix") 
    let b:base=expand('~/.config/nvim')
    let b:autoload=b:base . '/autoload'
    let b:plug=b:autoload . '/plug.vim'
else 
    let b:base=expand('$LOCALAPPDATA\nvim')
    let b:autoload=b:base . '\autoload'
    let b:plug=b:autoload . '\plug.vim'
endif

if !filereadable(b:plug)
    if has("unix")
        execute '!mkdir -p ' . b:autoload
    else
        "Windows mkdir, need Windows slashes
        execute '!mkdir ' . b:autoload 
    endif
    execute '!curl -fLo ' . b:plug . ' https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    echo 'Type :PlugInstall, :UpdateRemotePlugins'
endif

"--------------------------------------------------
"List of plugins, need git
"--------------------------------------------------

call plug#begin(b:base . '/plugged')

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
if has("unix")
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' } "Fuzzy search
    Plug 'junegunn/fzf.vim'
endif
Plug 'ctrlpvim/ctrlp.vim' "Use for buffers, MRU, fuzzy search on Windows
Plug 'tpope/vim-fugitive' "Git helper
Plug 'majutsushi/tagbar' "Ctags single file preview
Plug 'shougo/neco-vim' "VimL completion

"Specialized
Plug 'bitc/vim-hdevtools' "Sets up VIM commands for hdevtools features
Plug 'mhartington/nvim-typescript' "TSServer integration
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
au FileType typescript nnoremap <buffer> <F3> :TSType<CR>
au FileType typescript nnoremap <buffer> <F4> :TSDef<CR>
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

"--------------------------------------------------
"General
"--------------------------------------------------

let mapleader = ',' "Prefix key for many commands
set encoding=utf-8   
colorscheme hybrid_material
set clipboard+=unnamedplus "Copy all yanks to system clipboard
let g:yankring_history_file = '.my_yankring_history_file'

nnoremap <F12> :TagbarToggle<CR>

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

command! CopyPath redir @+ | echo expand('%:p') | redir END

"Exiting terminal insert mode with ESC
tnoremap <Esc> <C-\><C-n>

"Clear highlighting
nnoremap <Leader>g :noh<CR>

"Tab workflow
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#tabs_label = ''
let g:airline#extensions#tabline#show_splits = 0

"Fast fuzzy variety find
if has("unix")
    "Git repo files, doesn't work with SVN
    nnoremap <leader>- :GFiles<CR>
    nnoremap <leader>= :Buffers<CR>
endif

"Slow fuzzy, try to find project directory (has .svn/.git)
"Use on Windows, and for MRU files feature
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_map = ''
nnoremap <leader>0 :CtrlP<CR>

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

"TODO - Escape
vnoremap // y/<C-R>"<CR>
vnoremap <C-r> "hy:%s/<C-r>h//gc<left><left><left>

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
