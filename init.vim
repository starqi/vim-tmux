
" Neovim, Windows, Linux

"--------------------------------------------------
"Auto install plugins, need <curl>
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
    echo 'Type :PlugInstall'
endif

"--------------------------------------------------
"Plugins, need <git, make (MinGW)>
"--------------------------------------------------

":PlugInstall! for postupdate retry
call plug#begin(b:base . '/plugged')

Plug 'xolox/vim-misc' "This guy's personal libraries
Plug 'xolox/vim-session' "Session management
Plug 'rafi/awesome-vim-colorschemes'
Plug 'scrooloose/syntastic' "Lint
Plug 'scrooloose/nerdtree' "File browser
Plug 'Lokaltog/vim-easymotion' "Jump to letters
Plug 'vim-scripts/YankRing.vim' "Loop through copy paste history
Plug 'bling/vim-airline' "Pretty status bar
Plug 'vim-airline/vim-airline-themes'
Plug 'kshenoy/vim-signature' "Mark management
Plug 'vim-scripts/BufOnly.vim' "When too many buffers open
Plug 'ctrlpvim/ctrlp.vim' "Buffers, MRU, fuzzy search 
Plug 'tpope/vim-fugitive' "Git helper
Plug 'majutsushi/tagbar' "Ctags single file preview

if has("unix")
    Plug 'Shougo/vimproc.vim', {'do': 'make'} "Vim 7.4 async
else
    Plug 'Shougo/vimproc.vim', {'do': 'C:\MinGW\bin\mingw32-make.exe -f make_mingw64.mak'}
endif

Plug 'ajh17/VimCompletesMe' "Lightweight completion
Plug 'ludovicchabant/vim-gutentags' "Tag regen

"Specialized
Plug 'vimwiki/vimwiki'
Plug 'bitc/vim-hdevtools' "Sets up VIM commands for hdevtools features
Plug 'Quramy/tsuquyomi' "TSServer integration
Plug 'leafgarland/typescript-vim'
Plug 'pangloss/vim-javascript' 
Plug 'mxw/vim-jsx' 
Plug 'neovimhaskell/haskell-vim' 

call plug#end()

"--------------------------------------------------
"Specialized
"--------------------------------------------------

"** JSX **, need <eslint>
let g:syntastic_javascript_checkers = ['eslint']
let g:jsx_ext_required = 0 "JSX highlighting for JS files

"** Haskell **, need <hdevtools, hasktags> (Don't add to g:syntastic_haskell_checkers)
au FileType haskell nnoremap <buffer> <F3> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <Leader><F3> :HdevtoolsClear<CR>

"** Typescript **, need <typescript/tsserver, new ~/.ctags definition, tslint>
au FileType typescript map <buffer> <leader>- <Plug>(TsuquyomiSignatureHelp)
au FileType typescript map <buffer> <C-[> <Plug>(TsuquyomiDefinition)
au FileType typescript map <buffer> <F3> :TsuquyomiGeterr<CR>
au FileType typescript map <buffer> <Leader><F3> :cclose<CR>
au FileType typescript setlocal previewheight=3
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
let g:tsuquyomi_completion_detail = 1 "Show types
let g:tsuquyomi_disable_quickfix = 1 "Don't check on save
let g:syntastic_typescript_checkers = ['tslint']

"--------------------------------------------------

command! PlugCleanUpdateRemote PlugClean | UpdateRemotePlugins

let mapleader = ','
set encoding=utf-8   
colorscheme gruvbox
set bg=dark
set clipboard+=unnamedplus "Copy all yanks to system clipboard
let g:yankring_history_file = '.my_yankring_history_file'
set completeopt+=menuone "Show menu on one item for type sigs

let g:session_autosave = 'yes'
let g:session_autoload = 'no'

nnoremap <F12> :TagbarToggle<CR>
let g:gutentags_enabled = 0 "Enable when .notags/roots set up

"Manual syntax checking
nnoremap <F2> :SyntasticCheck<CR>
nnoremap <Leader><F2> :SyntasticReset<CR>

"Pop up the error list if there are errors after :SyntasticCheck
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
"Disable syntax check on save/open
let g:syntastic_mode_map = {"mode": "passive", "active_filetypes": [], "passive_filetypes": []}

" Move through error list and tags
nnoremap [l :lprev<CR>
nnoremap ]l :lnext<CR>
nnoremap [t :tprev<CR>
nnoremap ]t :tnext<CR>

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

"Use ctags -R --extras=f . to include file name in tags
"Deal with large repos using CWD, not 'ra'
let g:ctrlp_working_path_mode = 'a'
let g:ctrlp_map = '<leader>0' "Clear default keys
let g:ctrlp_extensions = ['tag', 'changes'] "Search tags, change history

" Search only git repo files
let b:ctrlp_lsfiles_command = 'cd %s && git ls-files -oc --exclude-standard'
if executable('ag')
    set grepprg=ag\ --nocolor
    "https://github.com/ggreer/the_silver_searcher
    "Match file names only, not contents
    let g:ctrlp_user_command = ['.git', b:ctrlp_lsfiles_command, 'ag %s --nogroup --nocolor --files-with-matches --filename-pattern ""'] 
else
    "--exclude-standard especially for node_modules
    let g:ctrlp_user_command = ['.git', b:ctrlp_lsfiles_command]
endif

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
"Change root directories to current file
nnoremap <Leader>3 :tcd %:p:h<CR>
command! GlobalCD cd %:p:h
"Show/edit current path, not CWD
command! CopyPath let @+ = expand('%:p')
command! EchoPath echo expand('%:p')
nnoremap <Leader>4 :e<C-R>=expand('%:p:h')<CR><CR>

"Fast move between windows
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l

"Jump to a letter
map t <Plug>(easymotion-s2)

"Find and replace
vnoremap / "hy/<C-R>"<CR>
vnoremap <C-r> :s/<C-r>h//gc<left><left><left>
nnoremap <Leader><C-r> :%s/<C-r>h//gc<left><left><left>

command! -nargs=1 ExtCmd execute 'new | read !' . '<args>'

"Vim Wiki
let g:vimwiki_folding = 'expr'

filetype plugin indent on "Auto react to file type changes
syntax enable "Enable syntax colors
set rnu nu "Relative line numbers for easy jump
set hidden  "New files don't need to be saved to browse another file...
set autoindent "No magic BS indent, use last line's indent
set nowrap "No line wrap
set shortmess+=Ic "No intro, no completion message
set hlsearch "Highlight search results
set laststatus=2 "Display toolbar
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab shiftround "Every tab everywhere is 4 spaces
set backspace=indent,eol,start "Stop preventing backspace in certain places
set foldmethod=syntax foldlevel=99 " Don't collapse on start
au FileType * setlocal fo-=cro "Stop comment formatting
