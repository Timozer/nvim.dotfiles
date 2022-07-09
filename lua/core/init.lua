local M = {}

function M.SetKeymaps(keymaps)
    if keymaps == nil then
        return
    end

    for _, map in pairs(keymaps) do
        vim.api.nvim_set_keymap(map.mode, map.lhs, map.rhs, map.options)
    end
end

function M.SetOptions(options)
    if options == nil then
        return
    end

    for key, val in pairs(options) do
        vim.o[key] = val
    end
end

function M.ReadFile(path)
    local file = io.open(path,"r")
    local data = file:read("*a");
    file:close()
    return data
end

function M.StartsWith(text, prefix)
    return text:find(prefix, 1, true) == 1
end

return M