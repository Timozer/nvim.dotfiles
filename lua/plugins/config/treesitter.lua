local M = {}

function M.config()
    require('nvim-treesitter').install({
        'bash', 'c', 'cmake', 'cpp', 'dockerfile', 'go', 'gomod', 'gosum',
        'html', 'http', 'java', 'javascript', 'json', 'lua', 'python', 'vim', 'yaml',
        'sql'
    })

    vim.api.nvim_create_autocmd('FileType', {
        pattern = {
            'bash', 'c', 'cmake', 'cpp', 'dockerfile', 'go', 'gomod', 'gosum',
            'html', 'http', 'java', 'javascript', 'json', 'lua', 'python', 'vim', 'yaml',
            'sql'
        },
        callback = function()
            vim.treesitter.start()
            vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
            vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
    })
end

return M
