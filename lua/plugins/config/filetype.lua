local M = {}

function M.config()
    require("filetype").setup({
        overrides = {
            extensions = {
                h = "cpp",
            },
        }
    })
end

return M