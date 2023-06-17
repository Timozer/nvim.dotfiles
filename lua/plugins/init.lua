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
		-- plugins
		{ "nathom/filetype.nvim" },
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
		{ 'numToStr/Comment.nvim', config = function()
				require('Comment').setup({ mappings = nil })
				local maps = {
					{
						mode = "n",
						lhs = "<C-_>",
						rhs = ":lua require('Comment.api').toggle_current_linewise()<cr>",
						options = {noremap = true}
					},
					{
						mode = "v",
						lhs = "<C-_>",
						rhs = '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>',
						options = {noremap = true}
					},
				}
				require('core').SetKeymaps(maps)
			end
		},
		{
			"windwp/nvim-autopairs",
			event = {'InsertEnter'},
			config = function() require("nvim-autopairs").setup {} end
		},
		{'nvim-lua/plenary.nvim'},
		{
			'nvim-telescope/telescope.nvim',
			cmd = {'Telescope'},
			dependencies = {
                -- for vim.ui.{input, select}
                {'stevearc/dressing.nvim'},
				{'nvim-lua/plenary.nvim'},
				{
					'nvim-telescope/telescope-fzf-native.nvim',
					build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
				}
			},
			init = require('plugins.config.telescope').setup,
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
				{ "williamboman/nvim-lsp-installer", },
				{'hrsh7th/cmp-nvim-lsp'},
				{'j-hui/fidget.nvim'},
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

				-- snippets
				{'saadparwaiz1/cmp_luasnip'},

				-- lsp
				{'hrsh7th/cmp-nvim-lsp'},
				{'hrsh7th/cmp-nvim-lsp-document-symbol'},
				{'hrsh7th/cmp-nvim-lsp-signature-help'},

				-- kind
				{'onsails/lspkind.nvim'},

				{'windwp/nvim-autopairs'},
			},
			config = require('plugins.config.nvim_cmp').config
		},
		{
			'L3MON4D3/LuaSnip',
			after = 'nvim-cmp',
			dependencies = { 'rafamadriz/friendly-snippets' },
			config = function()
				require('luasnip').config.set_config {
					history = true,
					updateevents = "TextChanged,TextChangedI"
				}
				require("luasnip.loaders.from_vscode").load()
			end
		},

		-- term
		{
			'numToStr/FTerm.nvim',
			module = {'FTerm'},
			init = function()
				local maps = {
					{
						mode = 'n', lhs = '<A-i>', rhs = '<CMD>lua require("FTerm").toggle()<CR>', options = {noremap = true},
					},
					{
						mode = 't', lhs = '<A-i>', rhs = '<C-\\><C-n><CMD>lua require("FTerm").toggle()<cr>', options = {noremap = true},
					},
					{
						mode = 'n', lhs = '<A-g>', rhs = '', options = {noremap = true, callback = function()
							local fterm = require('FTerm')
							if fterm.term_gitui == nil then
								fterm.term_gitui = fterm:new({
									ft = 'TERM_GITUI',
									cmd = 'gitui',
									dimensions = {
										height = 0.9,
										width = 0.9,
									}
								})
							end
							fterm.term_gitui:toggle()
						end},
					},
					{
						mode = 't', lhs = '<A-g>', rhs = '', options = {noremap = true, callback = function()
							local fterm = require('FTerm')
							if fterm.term_gitui ~= nil then
								fterm.term_gitui:toggle()
							end
						end},
					}
				}
				require('core').SetKeymaps(maps)
			end,
			config = function()
				require'FTerm'.setup({
					border = 'double',
					dimensions  = {
						height = 0.9,
						width = 0.9,
					},
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
		{ 'sindrets/diffview.nvim', dependencies = 'nvim-lua/plenary.nvim' }
	}, {
		-- opts
	})
end

return M
