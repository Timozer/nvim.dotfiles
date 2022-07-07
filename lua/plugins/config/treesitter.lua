local M = {}

function M.config()
    if not packer_plugins["nvim-treesitter"].loaded then
        vim.cmd [[packadd nvim-treesitter]]
    end
    if not packer_plugins["nvim-treesitter-textobjects"].loaded then
        vim.cmd [[packadd nvim-treesitter-textobjects]]
    end
    if not packer_plugins["nvim-treesitter-context"].loaded then
        vim.cmd [[packadd nvim-treesitter-context]]
    end
    if not packer_plugins["nvim-ts-rainbow"].loaded then
        vim.cmd [[packadd nvim-ts-rainbow]]
    end
    if not packer_plugins["nvim-ts-context-commentstring"].loaded then
        vim.cmd [[packadd nvim-ts-context-commentstring]]
    end

    vim.api.nvim_command('set foldmethod=expr')
    vim.api.nvim_command('set foldexpr=nvim_treesitter#foldexpr()')

    require'nvim-treesitter.configs'.setup {
        ensure_installed = {
            'bash', 'c', 'cmake', 'cpp', 'dockerfile', 'go', 
            'gomod', 'html', 'http', 'java', 'javascript', 'json',
            'lua', 'python', 'vim', 'yaml'
        },
        highlight = {enable = true, disable = {'vim'}},
        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner"
                }
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]["] = "@function.outer",
                    ["]m"] = "@class.outer"
                },
                goto_next_end = {
                    ["]]"] = "@function.outer",
                    ["]M"] = "@class.outer"
                },
                goto_previous_start = {
                    ["[["] = "@function.outer",
                    ["[m"] = "@class.outer"
                },
                goto_previous_end = {
                    ["[]"] = "@function.outer",
                    ["[M"] = "@class.outer"
                }
            },
            lsp_interop = {
                enable = true,
                border = 'none',
                peek_definition_code = {
                    ["<leader>pf"] = "@function.outer",
                    ["<leader>pF"] = "@class.outer",
                },
            },
        },
        rainbow = {
            enable = true,
            extended_mode = true, -- Highlight also non-parentheses delimiters, boolean or table: lang -> boolean
            max_file_lines = 1000 -- Do not enable for files with more than 1000 lines, int
        },
        context_commentstring = {enable = true, enable_autocmd = false},
        context = {enable = true, throttle = true}
    }
end

return M