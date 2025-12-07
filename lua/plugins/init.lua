local M = {}

function M.setup()
    local lazypath = vim.fn.stdpath("data") .. "/folke/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable", -- latest stable release
            lazypath,
        })
    end
    vim.opt.rtp:prepend(lazypath)

    require("lazy").setup({
        {
            "folke/snacks.nvim",
            priority = 1000,
            lazy = false,
            ---@type snacks.Config
            opts = {
                bigfile = { enabled = false },
                dashboard = { enabled = false },
                explorer = { enabled = false },
                indent = { enabled = false },
                input = { enabled = true, },
                notifier = { enabled = false, },
                picker = { enabled = false },
                quickfile = { enabled = false },
                scope = { enabled = false },
                scroll = { enabled = false },
                statuscolumn = { enabled = false },
                words = { enabled = false },
                styles = {
                    notification = {
                        -- wo = { wrap = true } -- Wrap notifications
                    },
                }
            },
            config = function ()
                vim.ui.input = Snacks.input.input
            end
        },
        -- plugins
        { 'sainnhe/edge', config = require('plugins.config.edge').config },
        { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}, config = require('plugins.config.indent_blankline').config },
        {
            'Timozer/sline.nvim',
            config = function()
                require('sline').setup({
                    data = {
                        {
                            "%#SlineFilename#%{%v:lua.require('sline.components').Filename('relative')%}%#SlineFileStatus#%m%r %#SlineDefault#%{get(g:,'gitsigns_head','')} %{get(b:,'gitsigns_status','')}"
                        },
                        {
                            "%#SlineFiletype#",
                            require("sline.components").Filetype,
                            "%#SlineFileformat#",
                            require("sline.components").Fileformat,
                            "%#SlineEncoding#",
                            require("sline.components").Encoding,
                            "%#SlineLocation#",
                            "%3p%% : %l/%L,%c"
                        },
                    },
                    disabled_filetypes = {
                        "FTree"
                    }
                })
            end
        },
        {
            'Timozer/ftree.nvim',
            cmd = {'FTreeToggle', 'FTreeFocus'},
            init = require("plugins.config.ftree").setup,
            config = require("plugins.config.ftree").config,
        },
        -- editing
        { 'junegunn/vim-easy-align', config = require('plugins.config.vim_easy_align').config },
        { 'numToStr/Comment.nvim',
        keys = {
            { "<C-_>", ":lua require('Comment.api').toggle.linewise.current()<cr>", mode = 'n', noremap = true },
            { "<C-_>", '<ESC><CMD>lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>', mode = 'v', noremap = true },
        },
        config = function() require('Comment').setup({mappings = nil}) end
    },
    {
        "windwp/nvim-autopairs",
        event = {'InsertEnter'},
        config = function() require("nvim-autopairs").setup {} end
    },
    {
        'nvim-telescope/telescope.nvim',
        cmd = {'Telescope'},
        keys = {
            { "<leader>ff", ":Telescope find_files<cr>", mode = 'n', noremap = true },
            { "<leader>fb", ":Telescope buffers<cr>", mode = 'n', noremap = true },
            { "<leader>fg", ":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>", mode = 'n', noremap = true },
            -- { "<leader>fg", ":Telescope live_grep<cr>", mode = 'n', noremap = true },
            { "<leader>fh", ":Telescope help_tags<cr>", mode = 'n', noremap = true },
            { "<leader>fs", ":lua require('telescope-live-grep-args.shortcuts').grep_word_under_cursor()<CR>", mode = 'n', noremap = true },
            -- { "<leader>fs", ":Telescope grep_string<cr>", mode = 'n', noremap = true },
        },
        dependencies = {
            {'nvim-lua/plenary.nvim'},
            {'nvim-telescope/telescope-ui-select.nvim'},
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
            },
            {
                "nvim-telescope/telescope-live-grep-args.nvim" ,
                -- This will not install any breaking changes.
                -- For major updates, this must be adjusted manually.
                version = "^1.0.0",
            }
        },
        config = require('plugins.config.telescope').config
    },
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = 'main',
        build = ':TSUpdate',
        init = require('plugins.config.treesitter').init,
        config = require('plugins.config.treesitter').config,
        dependencies = {
            -- {
            --    'nvim-treesitter/nvim-treesitter-textobjects',
            --    branch = 'main',
            -- },
            {
                'JoosepAlviste/nvim-ts-context-commentstring',
            }
        },
    },
    -- lsp
    {
        'neovim/nvim-lspconfig',
        event = { 'BufEnter' },
        dependencies = {
            {
                "williamboman/mason.nvim",
                build = ":MasonUpdate",
                config = function()
                    require('mason').setup({
                        github = {
                            download_url_template = "https://github.com/%s/releases/download/%s/%s",
                        }
                    })
                end
            },
            { 'williamboman/mason-lspconfig.nvim', config = function() end },
            {'hrsh7th/cmp-nvim-lsp'},
            {'j-hui/fidget.nvim', tag = 'legacy'},
        },
        config = require('plugins.config.lspconfig').config
    },
    -- auto completion
    {
        'hrsh7th/nvim-cmp',
        event = { 'InsertEnter' },
        dependencies = {
            -- buffer sources
            {'hrsh7th/cmp-buffer'},
            {'hrsh7th/cmp-calc'},

            -- path
            {'hrsh7th/cmp-path'},

            -- cmdline
            {'hrsh7th/cmp-cmdline'},

            -- lsp
            {'hrsh7th/cmp-nvim-lsp'},
            {'hrsh7th/cmp-nvim-lsp-document-symbol'},
            {'hrsh7th/cmp-nvim-lsp-signature-help'},

            -- ai
            -- { 'vappolinario/cmp-clippy' },

            -- treesitter
            {'ray-x/cmp-treesitter'},

            -- kind
            {'onsails/lspkind.nvim'},

            {'windwp/nvim-autopairs'},

            -- snippets
            {'saadparwaiz1/cmp_luasnip'},
            -- {'L3MON4D3/cmp-luasnip-choice'},
            {
            'L3MON4D3/LuaSnip',
            build = 'make install_jsregexp',
            dependencies = { 'rafamadriz/friendly-snippets' },
            config = require('plugins.config.luasnip').config
            },
        },
        config = require('plugins.config.nvim_cmp').config
    },
    -- git
    {
        'lewis6991/gitsigns.nvim',
        event = {'BufRead', 'BufNewFile' },
        dependencies = {'nvim-lua/plenary.nvim'},
        config = require('plugins.config.gitsigns').config
    },
    {
        'sindrets/diffview.nvim',
        dependencies = 'nvim-lua/plenary.nvim',
        cmd = { 'DiffviewFileHistory', 'DiffviewOpen', 'DiffviewFocusFiles', }
    },
    -- editor
    {
        'MagicDuck/grug-far.nvim',
        -- Note (lazy loading): grug-far.lua defers all it's requires so it's lazy by default
        -- additional lazy config to defer loading is not really needed...
        config = function()
            -- optional setup call to override plugin options
            -- alternatively you can set options with vim.g.grug_far = { ... }
            require('grug-far').setup({
                -- options, see Configuration section below
                -- there are no required options atm
            });
        end
    },
    -- dev
    --      {
    --          dir = '/home/wangzhenyu/.config/nvim/sr',
    --          name = 'sr',
    --          dev = true,
    -- dependencies = {'nvim-lua/plenary.nvim'},
    -- config = function ()
    --     print('sr plugin')
    -- end
    --      }
    }, {
        -- opts
        git = {
        url_format = "https://github.com/%s.git"
    }
})
end

return M
