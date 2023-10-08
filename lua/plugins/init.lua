local M = {}

function M.setup()
	local lazypath = vim.fn.stdpath("data") .. "/folke/lazy.nvim"
	if not vim.loop.fs_stat(lazypath) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://ghproxy.com/https://github.com/folke/lazy.nvim.git",
			"--branch=stable", -- latest stable release
			lazypath,
		})
	end
	vim.opt.rtp:prepend(lazypath)	

	require("lazy").setup({
		-- plugins
		{ "nathom/filetype.nvim", config = require('plugins.config.filetype').config },
		{ 'sainnhe/edge', config = require('plugins.config.edge').config },
		{ "lukas-reineke/indent-blankline.nvim", config = require('plugins.config.indent_blankline').config },
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
                -- for vim.ui.{input, select}
                {'stevearc/dressing.nvim'},
				{'nvim-lua/plenary.nvim'},
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
			dependencies = {
				{'nvim-treesitter/nvim-treesitter-textobjects'},
				{'nvim-treesitter/nvim-treesitter-context'},
				{'JoosepAlviste/nvim-ts-context-commentstring'},
				{'p00f/nvim-ts-rainbow'},
				{'windwp/nvim-ts-autotag'},
			},
			config = require('plugins.config.treesitter').config
		},
		-- lsp
		{
			'neovim/nvim-lspconfig',
			event = { 'BufEnter' },
			dependencies = {
				{ "williamboman/mason.nvim", build = ":MasonUpdate", config = function() 
                    require('mason').setup({
                        github = {
                            download_url_template = "https://ghproxy.com/https://github.com/%s/releases/download/%s/%s",
                        }
                    })
                end },
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

		-- term
		{
			'numToStr/FTerm.nvim',
			keys = {
				{'<A-i>', '<CMD>lua require("FTerm").toggle()<CR>', mode = 'n', noremap = true},
				{'<A-i>', '<C-\\><C-n><CMD>lua require("FTerm").toggle()<cr>', mode = 't', noremap = true},
				{
					'<A-g>', 
					function()
							local fterm = require('FTerm')
							if fterm.term_gitui == nil then
								fterm.term_gitui = fterm:new({
									ft = 'TERM_GITUI',
									cmd = 'gitui',
									dimensions = { height = 0.9, width = 0.9, }
								})
							end
							fterm.term_gitui:toggle()
					end, mode = 'n', noremap = true
				},
				{
					'<A-g>', 
					function()
							local fterm = require('FTerm')
							if fterm.term_gitui ~= nil then
								fterm.term_gitui:toggle()
							end
					end, mode = 't', noremap = true
				},
			},
			config = function()
				require'FTerm'.setup({
					border = 'double',
					dimensions  = { height = 0.9, width = 0.9, },
				})
			end
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
            url_format = "https://ghproxy.com/https://github.com/%s.git"
        }
	})
end

return M
