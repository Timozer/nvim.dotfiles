local M = {}

function M.setup()
	require('packer').startup(function(use)
		use { 'nathom/filetype.nvim', }
		use { 'sainnhe/edge', config = require('plugins.config.edge').config }
		use { "lukas-reineke/indent-blankline.nvim", config = require('plugins.config.indent_blankline').config }
		use {
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
		}
		use { 'Timozer/ftree.nvim' }

		-- for vim.ui.{input, select}
		use {'stevearc/dressing.nvim', config = require('plugins.config.dressing').config }

		-- editing
		use { 'junegunn/vim-easy-align', config = require('plugins.config.vim_easy_align').config }
		use { 'numToStr/Comment.nvim', config = function()
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
		}
		use {
			"windwp/nvim-autopairs",
			opt = true,
			event = {'InsertEnter'},
			config = function() require("nvim-autopairs").setup {} end
		}

		use {'nvim-lua/plenary.nvim'}
		use {
			'nvim-telescope/telescope.nvim',
			opt = true,
			cmd = {'Telescope'},
			module = {'telescope'},
			requires = {
				{'nvim-lua/plenary.nvim'},
				{
					'nvim-telescope/telescope-fzf-native.nvim',
					run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
				}
			},
			setup = require('plugins.config.telescope').setup,
			config = require('plugins.config.telescope').config
		}
		-- use {'tzachar/fuzzy.nvim', requires = {'nvim-telescope/telescope-fzf-native.nvim'}}

		use {
			'nvim-treesitter/nvim-treesitter',
			requires = {
				{'nvim-treesitter/nvim-treesitter-textobjects'},
				{'nvim-treesitter/nvim-treesitter-context'},
				{'JoosepAlviste/nvim-ts-context-commentstring'},
				{'p00f/nvim-ts-rainbow'},
				{'windwp/nvim-ts-autotag'},
			},
			config = require('plugins.config.treesitter').config
		}

		-- lsp
		use {
			'neovim/nvim-lspconfig',
			opt = true,
			event = { 'BufEnter' },
			requires = {
				{ "williamboman/nvim-lsp-installer", },
				{'hrsh7th/cmp-nvim-lsp'},
				{'j-hui/fidget.nvim'},
			},
			config = require('plugins.config.lspconfig').config
		}

		-- auto completion
		use {
			'hrsh7th/nvim-cmp',
			opt = true,
			event = { 'InsertEnter' },
			requires = {
				-- buffer sources
				{'hrsh7th/cmp-buffer'},
				{'hrsh7th/cmp-calc'},
				{'uga-rosa/cmp-dictionary'},

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

				-- fuzzy finding
				{'lukas-reineke/cmp-rg'},

				-- misc
				{'paopaol/cmp-doxygen'},

				-- kind
				{'onsails/lspkind.nvim'},

				{'windwp/nvim-autopairs'},
			},
			config = require('plugins.config.nvim_cmp').config
		}
		use {
			'L3MON4D3/LuaSnip',
			opt = true,
			after = 'nvim-cmp',
			requires = { 'rafamadriz/friendly-snippets' },
			config = function()
				if not packer_plugins["nvim-cmp"].loaded then
					vim.cmd [[packadd nvim-cmp]]
				end
				if not packer_plugins["LuaSnip"].loaded then
					vim.cmd [[packadd LuaSnip]]
				end
				if not packer_plugins["friendly-snippets"].loaded then
					vim.cmd [[packadd friendly-snippets]]
				end

				require('luasnip').config.set_config {
					history = true,
					updateevents = "TextChanged,TextChangedI"
				}
				require("luasnip.loaders.from_vscode").load()
			end
		}

		-- term
		use {
			'numToStr/FTerm.nvim',
			opt = true,
			module = {'FTerm'},
			setup = function()
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
		}

		-- git
		use {
			'lewis6991/gitsigns.nvim',
			opt = true,
			event = {'BufRead', 'BufNewFile' },
			requires = {'nvim-lua/plenary.nvim', opt=true,},
			config = require('plugins.config.gitsigns').config
		}
		use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }
	end)
end

return M
