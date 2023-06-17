local M = {}

function M.config()
    require('luasnip').config.set_config {
        history = true,
        updateevents = "TextChanged,TextChangedI"
    }
    require("luasnip.loaders.from_vscode").load()
    -- load snippets from path/of/your/nvim/config/my-cool-snippets
    -- require("luasnip.loaders.from_vscode").lazy_load({ paths = { "./my-cool-snippets" } })
end

return M