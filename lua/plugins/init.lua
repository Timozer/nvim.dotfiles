local M = {}

function M.setup()
	require('packer').startup(function(use)
		use { 'nathom/filetype.nvim', }
		use { 'sainnhe/edge', config = require('plugins.config.edge').config }
		use { "lukas-reineke/indent-blankline.nvim", config = require('plugins.config.indent_blankline').config }
		use { 'junegunn/vim-easy-align', config = require('plugins.config.vim_easy_align').config }
		use { 'numToStr/Comment.nvim', config = function() require('Comment').setup() end }
		use { 'neovim/nvim-lspconfig', require('plugins.config.lspconfig').config }
		use {
			'nvim-telescope/telescope.nvim',
			requires = { {'nvim-lua/plenary.nvim'} },
			config = require('plugins.config.telescope').config
		}
		use {
			'nvim-telescope/telescope-fzf-native.nvim',
			run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build',
			config = function() require('telescope').load_extension('fzf')
		}

		use {
			'nvim-treesitter/nvim-treesitter',
			requires = {
				{'nvim-treesitter/nvim-treesitter-textobjects'},
				{'nvim-treesitter/nvim-treesitter-context'},
				{'JoosepAlviste/nvim-ts-context-commentstring'},
				{'p00f/nvim-ts-rainbow'},
			},
			config = require('plugins.config.treesitter').config
		}
	end)
end

return M
