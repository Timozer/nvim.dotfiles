local basic_opts = {
    encoding="utf-8",
    fileencoding = "utf-8",
    fileencodings="utf-8,ucs-bom,gbk,cp936,gb2312,gb18030",
    scrolloff = 8,
    sidescrolloff = 8,
    number = true,
    relativenumber = true,
    signcolumn = "yes",
    background = "dark",
    termguicolors = true,
    cul = true,
    cuc = true,
    ruler = true,
    textwidth = 80,
    colorcolumn = "+1",
    smartindent=true,
    smarttab=true,
    joinspaces=false,
    wrap=false,
    tabstop = 4,
    shiftwidth = 4,
    softtabstop = 4,
    expandtab = true,
    completeopt="menu,menuone,noselect",
    sessionoptions="buffers,curdir,folds,options,localoptions,winsize,resize,winpos",
    autoread=true,
    cmdheight=2,
    laststatus=2,
    confirm=true,
    list=true,
    listchars="tab:› ,eol:↵,trail:•,extends:#,nbsp:.",
    splitright=true,
    backup=false,
    swapfile=false,
}

require('core').SetOptions(basic_opts)

vim.g.mapleader = ","
vim.g.maplocalleader = ","
vim.g.did_load_filetypes = 1

local basic_maps = {
	{
		mode = "n",
		lhs = "Y",
		rhs = "y$",
		options = {
			silent = false,
			noremap = false,
			nowait = false,
			expr = false,
		}
	},
	{
		mode = "n",
		lhs = "j",
		rhs = "gj",
		options = {
			silent = false,
			noremap = false,
			nowait = false,
			expr = false,
		}
	},
	{
		mode = "n",
		lhs = "k",
		rhs = "gk",
		options = {
			silent = false,
			noremap = false,
			nowait = false,
			expr = false,
		}
	},
	{
		mode = "n",
		lhs = "<leader>q",
		rhs = ":q<CR>",
		options = {
			silent = false,
			noremap = false,
			nowait = false,
			expr = false,
		}
	},
	{
		mode = "n",
		lhs = "<leader>w",
		rhs = ":w!<CR>",
		options = {
			silent = false,
			noremap = false,
			nowait = false,
			expr = false,
		}
	},
	{
		mode = "n",
		lhs = "Q",
		rhs = ":qa<CR>",
		options = {
			silent = false,
			noremap = false,
			nowait = false,
			expr = false,
		}
	},
	{
		mode = "n",
		lhs = "<leader>lw",
		rhs = "<C-W>l",
		options = {
			silent = false,
			noremap = true,
			nowait = false,
			expr = false,
		}
	},
	{
		mode = "n",
		lhs = "<leader>hw",
		rhs = "<C-W>h",
		options = {
			silent = false,
			noremap = true,
			nowait = false,
			expr = false,
		}
	},
	{
		mode = "n",
		lhs = "<leader>jw",
		rhs = "<C-W>j",
		options = {
			silent = false,
			noremap = true,
			nowait = false,
			expr = false,
		}
	},
	{
		mode = "n",
		lhs = "<leader>kw",
		rhs = "<C-W>k",
		options = {
			silent = false,
			noremap = true,
			nowait = false,
			expr = false,
		}
	},
	{
		mode = "n",
		lhs = "<C-Right>",
		rhs = ":vertical resize +10<CR>",
		options = {
			silent = false,
			noremap = true,
			nowait = false,
			expr = false,
		}
	},
	{
		mode = "n",
		lhs = "<C-Left>",
		rhs = ":vertical resize -10<CR>",
		options = {
			silent = false,
			noremap = true,
			nowait = false,
			expr = false,
		}
	},
}

require('core').SetKeymaps(basic_maps)

-- plugins
require('plugins').setup()
