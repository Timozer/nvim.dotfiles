local M = {}

function M.config()
    vim.opt.list = true
    vim.opt.listchars:append("eol:↴")
    require("indent_blankline").setup {
        char = "│",
        show_first_indent_level = true,
        filetype_exclude = {
            "startify", "dashboard", "dotooagenda", "log", "fugitive",
            "gitcommit", "packer", "vimwiki", "markdown", "json", "txt",
            "vista", "help", "todoist", "NvimTree", "peekaboo", "git",
            "TelescopePrompt", "undotree", "flutterToolsOutline", "" -- for all buffers without a file type
        },
        buftype_exclude = {"terminal", "nofile"},
        show_trailing_blankline_indent = false,
        context_patterns = {
            "class", "function", "method", "block", "list_literal", "selector",
            "^if", "^table", "if_statement", "while", "for", "type", "var",
            "import"
        },
        space_char_blankline = " ",
        show_current_context = true,
        show_current_context_start = true,
        show_end_of_line = true,
    }
    -- because lazy load indent-blankline so need readd this autocmd
    vim.cmd('autocmd CursorMoved * IndentBlanklineRefresh')
end

return M
