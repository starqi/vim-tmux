-- Neovim Modern Configuration
-- Dependencies: gcc (Treesitter), git, ripgrep, fzf, fd-find (optional, not the normal find on mac!)
-- Lang servers: basedpyright, ts_ls, lua_ls, rust_analyzer


-- Reminders:
-- gO

-- / TODO Fix unused imports Python -> basedpyright?
    -- / TODO Format not working? Lua formatting works.

-- TODO Fix unused imports TS -> selection is wrong?
-- TODO Fix find/fd-find on Mac

-- Minor TODO
-- YaroSpace/lua-console.nvim?
-- Avante?
-- Mason?


-- Initialize lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Core Vim Options
vim.g.mapleader = ','
vim.opt.signcolumn = 'yes'
vim.opt.cmdheight = 2
vim.opt.updatetime = 300
vim.opt.guicursor = ''
vim.opt.swapfile = false
vim.opt.encoding = 'utf-8'
vim.opt.clipboard = 'unnamedplus'
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.hidden = true
vim.opt.autoindent = true
vim.opt.wrap = false
vim.opt.shortmess:append('Ic')
vim.opt.hlsearch = true
vim.opt.laststatus = 2
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.shiftround = true
vim.opt.backspace = 'indent,eol,start'
vim.opt.foldmethod = 'indent'
vim.opt.foldlevel = 99
vim.opt.writebackup = false
vim.opt.previewheight = 12

--Removed hidden buffers and terminals, causing issues on Windows (???), and terminal reload never worked anyway
vim.opt.sessionoptions="blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
--vim.opt.sessionoptions="blank,curdir,folds,help,tabpages,winsize,winpos,localoptions"

-- Plugins
require('lazy').setup {
    { 'rafi/awesome-vim-colorschemes' },
    { 'kshenoy/vim-signature' }, -- Mark management
    { 'jeetsukumaran/vim-indentwise' }, -- Indent hoping
    -- Colors
    { 'folke/tokyonight.nvim' },
    { 'olimorris/onedarkpro.nvim', priority = 1000, -- Ensure it loads first
    },
    { -- Syntax highlighting
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { 'lua', 'vim', 'python', 'javascript', 'typescript', 'rust', 'java', 'markdown', 'kotlin' },
                highlight = {
                    enable = true,
                    disable = { 'rust' }
                },
            }
        end
    },
    { -- Language servers

        -- https://neovim.io/doc/user/lsp.html
        'neovim/nvim-lspconfig',
        dependencies = {
            'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
        },
        config = function()
            -- Setup language servers
            -- Using Nvim 0.11+ vim.lsp.enable() syntax
            -- TODO Read capabilities
            local capabilities = require('cmp_nvim_lsp').default_capabilities()
            
            vim.lsp.enable('basedpyright')
            vim.lsp.config('basedpyright', { capabilities = capabilities })
            
            vim.lsp.enable('ts_ls')
            vim.lsp.config('ts_ls', { capabilities = capabilities })
            
            vim.lsp.enable('rust_analyzer')
            vim.lsp.config('rust_analyzer', { capabilities = capabilities })
            
            vim.lsp.enable('lua_ls')
            vim.lsp.config('lua_ls', {
                capabilities = capabilities,
                settings = {
                    Lua = { -- From AI / default settings
                        runtime = {
                            -- Tell the language server which version of Lua you're using
                            version = 'LuaJIT'
                        },
                        diagnostics = {
                            -- Get the language server to recognize the `vim` global
                            globals = { 'vim' }
                        },
                        workspace = {
                            -- Make the server aware of Neovim runtime files

                            -- Or pull in all of 'runtimepath'.
                            -- NOTE: this is a lot slower and will cause issues when working on
                            -- your own configuration.
                            -- See https://github.com/neovim/nvim-lspconfig/issues/3189
                            --library = vim.api.nvim_get_runtime_file("", true),

                            library = {
                                vim.env.VIMRUNTIME
                            },
                            checkThirdParty = false, -- Disable third party checking
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })

            -- LSP Keybindings
            vim.keymap.set('n', 'gd', vim.lsp.buf.definition)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover)
            vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
            vim.keymap.set('v', '<leader>f', vim.lsp.buf.format)
            vim.keymap.set({'v', 'n'}, '<leader>a', vim.lsp.buf.code_action)
            vim.keymap.set('n', '[g', function()
                vim.diagnostic.jump({count = 1, severity = vim.diagnostic.severity.ERROR})
            end)
            vim.keymap.set('n', ']g', function()
                vim.diagnostic.jump({count = 1, severity = vim.diagnostic.severity.ERROR})
            end)
            vim.keymap.set('n', '[w', function()
                vim.diagnostic.jump({count = 1, severity = vim.diagnostic.severity.WARN})
            end)
            vim.keymap.set('n', ']w', function()
                vim.diagnostic.jump({count = 1, severity = vim.diagnostic.severity.WARN})
            end)
        end
    },
    { -- Completion
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            cmp.setup {
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ['<Tab>'] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, { 'i', 's' }),
                }),
                sources = {
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                    { name = 'buffer' },
                    { name = 'path' },
                },
            }
        end
    },
    { -- Searching
        'ibhagwan/fzf-lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local fzf = require('fzf-lua')
            vim.keymap.set('n', '<leader>ff', fzf.files)
            vim.keymap.set('n', '<leader>0', fzf.files)
            vim.keymap.set('n', '<leader>fg', fzf.live_grep)
            vim.keymap.set('n', '<leader>fb', fzf.buffers)
            vim.keymap.set('n', '<leader>fh', fzf.help_tags)
            vim.keymap.set('n', '<leader>fm', fzf.oldfiles)
        end
    },
    { -- File system
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('nvim-tree').setup()
            --TODO What is the point of 1?
            --vim.keymap.set('n', '<leader>1', ':NvimTreeFocus<CR>')
            vim.keymap.set('n', '<leader>2', ':NvimTreeToggle<CR>')
            vim.keymap.set('n', '<leader>4', ':NvimTreeFindFile!<CR>')
            --TODO Minor, can't jump windows
            --vim.keymap.del("n", "<C-k>")
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        --enabled = false,
        config = function()
            require('lualine').setup {
                options = {
                    component_separators = { left = '', right = ' '},
                    always_divide_middle = false,
                    max_length = vim.o.columns
                },
                sections = {
                    lualine_a = { 'mode' },
                    --lualine_b = { 'branch', 'diff', 'diagnostics' },
                    lualine_b = { 'branch' },
                    lualine_c = { 'filename' },
                    --lualine_x = { 'encoding', 'fileformat', 'filetype' },
                    lualine_x = { 'encoding', 'filetype' },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
                tabline = {
                    lualine_a = {{
                        'tabs', mode = 2, use_mode_colors = false,
                        tabs_color = {
                            -- This place is the reason why default colorscheme doesn't highlight active tab, TabLineSel active works...
                            -- TODO Read more highlight groups and custom ones: lualine_a_inactive
                            active = 'TabLineSel',
                            inactive = 'lualine_a_inactive'
                        },
                    }},
                    lualine_b = {},
                    lualine_c = {},
                    lualine_x = {},
                    lualine_y = {},
                    lualine_z = {}
                }
            }
        end
    },
    { 'tpope/vim-fugitive' }, -- Git
    { 'schickling/vim-bufonly' },
    {
        'phaazon/hop.nvim', -- EasyMotion
        config = function()
            require('hop').setup()
            vim.keymap.set('n', 't', ':HopChar1<CR>')
        end
    },
    { -- Sessions
        'rmagatti/auto-session',
        config = function()
            require('auto-session').setup {
                log_level = 'error',
                -- Restore sessions attached to a directory, but empty if some random directory
                auto_restore = true,
                auto_restore_last_session = false
            }
        end
    },
}

-- More LSP/diagnostics
vim.diagnostic.config({
    virtual_text = true,
    signs = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
})
-- TODO vim.diagnostic.open_float() will do a popup
vim.keymap.set('n', '<leader>K', vim.diagnostic.open_float)

-- Window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Search and replace
vim.keymap.set('v', '/', '"hy0/\\V<C-R>h<CR>')
vim.keymap.set('v', '<C-r>', ':s/\\V<C-r>///gc<left><left><left>')
vim.keymap.set('n', '<leader><C-r>', ':%s/\\V<C-r>///gc<left><left><left>')

-- Terminal
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<S-Space>', '<Space>')
vim.keymap.set('t', '<C-BS>', '<BS>')
vim.keymap.set('t', '<S-BS>', '<BS>')
vim.keymap.set('t', '<C-CR>', '<CR>')

-- Misc
vim.keymap.set('n', '<leader>g', ':noh<CR>')
vim.keymap.set('n', '<leader>W', ':set wrap!<CR>')
vim.keymap.set('n', ']c', ':cnext<CR>')
vim.keymap.set('n', '[c', ':cprev<CR>')

-- Tabs
vim.keymap.set('n', '<expr> <leader>s', ':tabn<CR>')
vim.keymap.set('n', '<leader>q', ':tabp<CR>')
vim.keymap.set('n', '<leader>e', ':tabn<CR>')
vim.keymap.set('n', '<leader>d', ':bw!<CR>')
vim.keymap.set('n', '<leader>c', ':tabc!<CR>')
vim.keymap.set('n', '<leader>o', ':tabnew<CR>')
vim.keymap.set('n', '<leader>O', ':tabp<CR>:tabnew<CR>')

-- Change cwd, dirs
vim.keymap.set('n', '<leader>3', ':tcd %:p:h<CR>')
vim.keymap.set('n', '<leader><leader>3', ':cd %:p:h<CR>')
vim.api.nvim_create_user_command('GlobalCD', 'cd %:p:h', {})
vim.api.nvim_create_user_command('CopyPath', 'let @+ = expand("%:p")', {})
vim.api.nvim_create_user_command('EchoPath', 'echo expand("%:p")', {})

vim.api.nvim_create_user_command('Te2', 'te "C:\\Program Files\\Git\\bin\\bash.exe"', {}) -- Windows only
vim.api.nvim_create_user_command('SR', 'SessionRestore', {})

-- Lua is not always better
vim.cmd([[
    colorscheme one-dark

    cnoreabbrev sr SessionRestore
    cnoreabbrev ss SessionSave

    command! -nargs=1 ExtCmd execute 'new | read !' . '<args>'
    command! -nargs=1 ExtVimCmd execute 'new | put=execute(''<args>'')'

    "TODO Applicable?
    augroup custom
        au!
        au FileType * setlocal fo-=cro "Stop comment formatting
        au FileType qf setlocal wrap "Wrap errors in quick fix window
    augroup END

    function! DeleteHiddenBuffers()
        let tpbl=[]
        "For 1 to # of tabs, temp var = v:val, add all buffer ids inside tab to `tpbl`
        call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
        "Loop through 1 to max/last buffer number, deleting all those not in `tpbl` (visible)
        for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
            silent execute 'bwipeout!' buf
        endfor
    endfunction
    command! DeleteHiddenBuffers call DeleteHiddenBuffers()

    command! -nargs=1 ExtCmd execute 'new | read !' . '<args>'

    "Jump to tab _
    nnoremap <expr> <leader>w ":tabn " . nr2char(getchar()) . "<CR>"
    "Move tab after _
    nnoremap <expr> <leader>s ":tabm " . nr2char(getchar()) . "<CR>"
    "TODO What do other people do now?

    vnoremap <leader>c :s/\([,(]\\|.\()\)\@=\)\ \?/\1\r/g<CR>v%=
]])
