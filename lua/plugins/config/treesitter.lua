local M = {}

local function patch_parser_urls(parsers, prefix, base_url)
    local cfg = require('nvim-treesitter.parsers')
    if not cfg then return end

    for _, name in ipairs(parsers) do
        if cfg[name] and cfg[name].install_info and cfg[name].install_info.url then
            if vim.startswith(cfg[name].install_info.url, base_url) then
                cfg[name].install_info.url = prefix .. cfg[name].install_info.url
            end
        end
    end
end

local need_installed_parsers = {
    'bash', 'c', 'cmake', 'cpp', 'dockerfile', 'go', 'gomod', 'gosum',
    'html', 'http', 'java', 'javascript', 'json', 'lua', 'python', 'vim', 'yaml',
    'sql'
}

function M.init()
    local gh_proxy_prefix = "https://ghfast.top/"
    local github_url = "https://github.com/"
    patch_parser_urls(need_installed_parsers, gh_proxy_prefix, github_url)
end

function M.config()
    require('nvim-treesitter').install(need_installed_parsers)

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
