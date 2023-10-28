local M = {}

function M.config()
    require("ibl").setup({
        exclude = {
            filetypes = {
                "startify", "dashboard", "dotooagenda", "log", "fugitive",
                "gitcommit", "packer", "vimwiki", "markdown", "json", "txt",
                "vista", "help", "todoist", "NvimTree", "peekaboo", "git",
                "TelescopePrompt", "undotree", "flutterToolsOutline", "" -- for all buffers without a file type
            },
            buftypes = {
                "terminal", "nofile"
            }
        }
    })
end

return M
