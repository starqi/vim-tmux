-- Neovim Modern Configuration
-- Dependencies: git, ripgrep, fd-find (optional, not the normal find on mac!),
-- Lang servers: pyright, tsserver, lua_ls, rust_analyzer

-- TODO -> ts_ls?
-- TODO Fix find/fd-find on Mac
-- TODO Get some comments back from old file
-- TODO Why does leader c take forever
-- TODO Marks not shown anymore
-- TODO Mason?
-- TODO Any other missing commands?
-- TODO noswapfile?
-- TODO Themes?
-- TODO nowritebackup
-- TODO Tabline

-- Initialize lazy.nvim (modern plugin manager)
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

-- Plugin Specification
require('lazy').setup({
    -- Essential plugins
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        config = function()
            require('nvim-treesitter.configs').setup({
                ensure_installed = { 'lua', 'vim', 'python', 'javascript', 'typescript', 'rust' },
                highlight = { enable = true },
            })
        end
    },

    -- LSP Support
    {
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
            local lspconfig = require('lspconfig')
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            -- Setup language servers
            lspconfig.pyright.setup({ capabilities = capabilities })
            lspconfig.tsserver.setup({ capabilities = capabilities })
            lspconfig.rust_analyzer.setup({ capabilities = capabilities })
            -- Add Lua LSP
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
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
                            library = vim.api.nvim_get_runtime_file("", true),
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
            vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition)
            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation)
            vim.keymap.set('n', 'gr', vim.lsp.buf.references)
            vim.keymap.set('n', 'K', vim.lsp.buf.hover)
            vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename)
            vim.keymap.set('n', '<leader>f', vim.lsp.buf.format)
            vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action)
            vim.keymap.set('n', '[g', vim.diagnostic.goto_prev) -- TODO
            vim.keymap.set('n', ']g', vim.diagnostic.goto_next)
        end
    },

    -- Completion
    {
        'hrsh7th/nvim-cmp',
        config = function()
            local cmp = require('cmp')
            local luasnip = require('luasnip')

            cmp.setup({
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
            })
        end
    },

    -- File Navigation and Search
    {
        'ibhagwan/fzf-lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local fzf = require('fzf-lua')
            vim.keymap.set('n', '<leader>0', fzf.files)
            vim.keymap.set('n', '<leader>fg', fzf.live_grep)
            vim.keymap.set('n', '<leader>fb', fzf.buffers)
            vim.keymap.set('n', '<leader>fh', fzf.help_tags)
        end
    },

    -- File Explorer
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('nvim-tree').setup()
            --TODO What is the point of 1?
            --vim.keymap.set('n', '<leader>1', ':NvimTreeFocus<CR>')
            vim.keymap.set('n', '<leader>2', ':NvimTreeToggle<CR>')
            vim.keymap.set('n', '<leader>4', ':NvimTreeFindFile<CR>')
        end
    },

    -- Status Line
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require('lualine').setup()
        end
    },

    -- Theme
    { 'folke/tokyonight.nvim' },
    { 'tpope/vim-fugitive' },
    { 'schickling/vim-bufonly' },

    -- Motion
    {
        'phaazon/hop.nvim',
        config = function()
            require('hop').setup()
            vim.keymap.set('n', 't', ':HopChar1<CR>')
        end
    },

    -- Session Management
    {
        'rmagatti/auto-session',
        config = function()
            require('auto-session').setup({
                log_level = 'error',
                auto_session_suppress_dirs = { '~/', '~/Projects', '~/Downloads' },
            })
        end
    },
})

-- Theme Setup
vim.cmd('colorscheme tokyonight')

-- Window Navigation
vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

-- Search
vim.keymap.set('v', '/', '"hy0/\\V<C-R>h<CR>')
vim.keymap.set('v', '<C-r>', ':s/\\V<C-r>///gc<left><left><left>')
vim.keymap.set('n', '<leader><C-r>', ':%s/\\V<C-r>///gc<left><left><left>')

-- Terminal Mappings
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')
vim.keymap.set('t', '<S-Space>', '<Space>')
vim.keymap.set('t', '<C-BS>', '<BS>')
vim.keymap.set('t', '<S-BS>', '<BS>')
vim.keymap.set('t', '<C-CR>', '<CR>')

-- Misc Mappings
vim.keymap.set('n', '<leader>g', ':noh<CR>')
vim.keymap.set('n', '<leader>W', ':set wrap!<CR>')

-- Tab Management
vim.keymap.set('n', '<expr> <leader>s', ':tabn<CR>')
vim.keymap.set('n', '<leader>q', ':tabp<CR>')
vim.keymap.set('n', '<leader>e', ':tabn<CR>')
vim.keymap.set('n', '<leader>d', ':bw!<CR>')
vim.keymap.set('n', '<leader>c', ':tabc!<CR>')
vim.keymap.set('n', '<leader>o', ':tabnew<CR>')
vim.keymap.set('n', '<leader>O', ':tabp<CR>:tabnew<CR>')

-- Directory Navigation
vim.keymap.set('n', '<leader>3', ':tcd %:p:h<CR>')
vim.keymap.set('n', '<leader><leader>3', ':cd %:p:h<CR>')

-- Commands
vim.api.nvim_create_user_command('GlobalCD', 'cd %:p:h', {})
vim.api.nvim_create_user_command('CopyPath', 'let @+ = expand("%:p")', {})
vim.api.nvim_create_user_command('EchoPath', 'echo expand("%:p")', {})

-- Old stuff too annoying to convert
vim.cmd([[
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
