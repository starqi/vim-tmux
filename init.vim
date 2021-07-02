
" Neovim, Windows, Linux
" Dependencies: curl, git, ag, depending on plugins... Python, Node, make

"--------------------------------------------------
"Auto install plugins
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
    execute 'source ' . b:plug
    let b:auto_run_plug_install=1
endif

"--------------------------------------------------
"Plugins
"--------------------------------------------------

call plug#begin(b:base . '/plugged')

Plug 'xolox/vim-misc' 
Plug 'xolox/vim-session' 
Plug 'rafi/awesome-vim-colorschemes'
Plug 'scrooloose/nerdtree' 
Plug 'Lokaltog/vim-easymotion' 
Plug 'vim-scripts/YankRing.vim' 
Plug 'bling/vim-airline' 
Plug 'vim-airline/vim-airline-themes'
Plug 'kshenoy/vim-signature' 
Plug 'vim-scripts/BufOnly.vim' 
Plug 'ctrlpvim/ctrlp.vim' 
Plug 'tpope/vim-fugitive' 
Plug 'majutsushi/tagbar' 
Plug 'ludovicchabant/vim-gutentags'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"Basic language support
Plug 'HerringtonDarkholme/yats.vim' 
Plug 'pangloss/vim-javascript' 
Plug 'mxw/vim-jsx' 
Plug 'neovimhaskell/haskell-vim' 
Plug 'udalov/kotlin-vim' 
Plug 'ekalinin/Dockerfile.vim'

call plug#end()

if exists('b:auto_run_plug_install')
    :PlugInstall
endif

let mapleader = ','

"--------------------------------------------------
"Coc
"--------------------------------------------------

let g:coc_global_extensions = [
            \ 'coc-jedi', 
            \ 'coc-tsserver',
            \ 'coc-rls',
            \ 'coc-json'
            \ ]

"Mostly copy/pasted default suggestions

set signcolumn=yes
set cmdheight=2
set updatetime=300

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> [w <Plug>(coc-diagnostic-prev)
nmap <silent> ]w <Plug>(coc-diagnostic-next)
nmap <silent> [g <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]g <Plug>(coc-diagnostic-next-error)
nmap <leader>rn <Plug>(coc-rename)
xmap <leader>f <Plug>(coc-format-selected)
nmap <leader>f <Plug>(coc-format-selected)
xmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>a <Plug>(coc-codeaction-selected)
nmap <leader>ac <Plug>(coc-codeaction)
nmap <leader>lf <Plug>(coc-fix-current)

nnoremap K :call <SID>show_documentation()<CR>
function! s:show_documentation()
    if (index(['vim','help'], &filetype) >= 0)
        execute 'h '.expand('<cword>')
    elseif (coc#rpc#ready())
        call CocActionAsync('doHover')
    else
        execute '!' . &keywordprg . " " . expand('<cword>')
    endif
endfunction

autocmd CursorHold * silent call CocActionAsync('highlight')
command! -nargs=0 OrgImportsCoc :call CocAction('runCommand', 'editor.action.organizeImport')

"--------------------------------------------------

function! DeleteHiddenBuffers()
    let tpbl=[]
    "For 1 to # of tabs, temp var = v:val, add all window ids inside buffer to `tpbl`
    call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
    "Loop through 1 to max/last buffer number, deleting all those not in `tpbl` (visible)
    for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
        silent execute 'bwipeout!' buf
    endfor
endfunction
command! DeleteHiddenBuffers call DeleteHiddenBuffers()

"Fix terminal incompatibilities with blinking cursor
set guicursor=
set noswapfile
set encoding=utf-8
colorscheme meta5
set bg=dark
set clipboard+=unnamedplus "Copy all yanks to system clipboard
let g:yankring_history_file = '.my_yankring_history_file'

"Sessions
let g:session_autosave = 'yes'
let g:session_autoload = 'yes'

"Tags
"Use ctags -R --extras=f . to include file name in tags
nnoremap <F12> :TagbarToggle<CR>
let g:gutentags_enabled = 0 "Enable only when .notags/roots set up

"Close quickfix, location, preview windows
nnoremap <leader><leader>c :cclose<CR>
nnoremap <leader><leader>l :lclose<CR>
nnoremap <leader><leader>p :pclose<CR>
nnoremap <leader><space>c :copen<CR>
nnoremap <leader><space>l :lopen<CR>

" Move through error list and tags
nnoremap [l :lprev<CR>
nnoremap ]l :lnext<CR>
" [c is built-in for navigating diffs
nnoremap [v :cprev<CR>
nnoremap ]v :cnext<CR>
nnoremap [t :tprev<CR>
nnoremap ]t :tnext<CR>

"Exiting terminal insert mode with ESC
tnoremap <Esc> <C-\><C-n>
"Terminal shenanigans
tnoremap <S-Space> <Space>
tnoremap <C-BS> <BS>

nnoremap <leader>g :noh<CR>
nnoremap <leader>f :sign unplace *<CR>
nnoremap <leader>W :set wrap!<CR>

"Tab workflow
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#tab_nr_type = 1
let g:airline#extensions#tabline#tabs_label = ''
let g:airline#extensions#tabline#show_splits = 0

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
    let g:ctrlp_user_command = ['.git', b:ctrlp_lsfiles_command, 'ag %s --nogroup --nocolor --files-with-matches --ignore node_modules --ignore node_modulesLOL --ignore dist --filename-pattern ""'] 
else
    "--exclude-standard especially for node_modules
    let g:ctrlp_user_command = ['.git', b:ctrlp_lsfiles_command]
endif

"Jump to tab _
nnoremap <expr> <leader>w ":tabn " . nr2char(getchar()) . "<CR>"
"Move tab after _
nnoremap <expr> <leader>s ":tabm " . nr2char(getchar()) . "<CR>"
nnoremap <leader>q :tabp<CR>
nnoremap <leader>e :tabn<CR>
nnoremap <leader>c :tabc<CR> 
nnoremap <leader>o :tabnew<CR>
nnoremap <leader>O :tabp<CR>:tabnew<CR>

"Browse directory
nnoremap <leader>1 :NERDTreeFocus<CR> 
nnoremap <leader>2 :NERDTreeToggle<CR>
"Set each tab to its own workspace
nnoremap <leader>3 :tcd %:p:h<CR>
nnoremap <leader><leader>3 :cd %:p:h<CR>
command! GlobalCD cd %:p:h
command! CopyPath let @+ = expand('%:p')
command! EchoPath echo expand('%:p')
"View current folder
nnoremap <leader>4 :NERDTreeFind<CR>

"Fast move between windows
nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <leader>d :bw!<CR> 

"Jump to a letter
map t <Plug>(easymotion-s)

"Find and replace highlight
vnoremap / "hy0/\V<C-R>h<CR>
vnoremap <C-r> :s/\V<C-r>///gc<left><left><left>
nnoremap <leader><C-r> :%s/\V<C-r>///gc<left><left><left>

"Split function calls
vnoremap <leader>c :s/\([,(]\\|.\()\)\@=\)\ \?/\1\r/g<CR>v%=

command! -nargs=1 ExtCmd execute 'new | read !' . '<args>'
command! -nargs=1 Find ExtCmd ag --ignore node_modules --ignore dist <args>
command! -nargs=1 FindFile ExtCmd ag -g --ignore node_modules --ignore dist <args>

set previewheight=12
filetype plugin indent on "Auto react to file type changes
syntax enable "Enable syntax colors
set rnu nu "Relative line numbers for easy jump
set hidden "New files don't need to be saved to browse another file...
set autoindent "No magic BS indent, use last line's indent
set nowrap
set shortmess+=Ic "No intro, no completion message
set hlsearch "Highlight search results
set laststatus=2 "Display toolbar
set tabstop=4 softtabstop=4 shiftwidth=4 expandtab shiftround "Every tab everywhere is 4 spaces
set backspace=indent,eol,start "Stop preventing backspace in certain places
set foldmethod=indent foldlevel=99 "Don't collapse on start
set nowritebackup

augroup custom
    au!
    au BufRead * setlocal fileformat=unix
    au FileType * setlocal fo-=cro "Stop comment formatting
    au FileType qf setlocal wrap "Wrap errors in quick fix window
augroup END
