local M = {}

local function keymap_exists(mode, lhs)
    local maps = vim.api.nvim_get_keymap(mode)

    for _, map in ipairs(maps) do
        -- 检查映射的左侧 (lhs) 是否匹配
        -- 并且确保它不是针对特定 buffer 的 (buf == 0 表示全局)
        -- 注意：在底层 API 中，<Leader> 是不会被展开的
        if map.lhs == lhs and map.buffer == 0 then
            return true
        end
    end
    return false
end

function M.config()
    local lsps = {
        'bashls',
        'clangd',
        -- 'cmake',
        'dockerls',
        'gopls',
        'jsonls',
        'lua_ls',
        'pyright'
    }
    require("mason").setup()
    require("mason-lspconfig").setup({ ensure_installed = lsps })

    vim.api.nvim_create_autocmd('LspAttach', {
      callback = function(args)
        -- Unset 'formatexpr'
        -- vim.bo[args.buf].formatexpr = nil
        -- Unset 'omnifunc'
        -- vim.bo[args.buf].omnifunc = nil
        -- Unmap K
        -- vim.keymap.del('n', 'K', { buffer = args.buf })
        print("lsp attach set keymap")
        if keymap_exists('n', 'grn') then
            vim.keymap.del('n', 'grn', {})
        end
        if keymap_exists('n', 'gra') then
            vim.keymap.del('n', 'gra', {})
        end
        if keymap_exists('n', 'grr') then
            vim.keymap.del('n', 'grr', {})
        end
        if keymap_exists('n', 'gri') then
            vim.keymap.del('n', 'gri', {})
        end
        if keymap_exists('n', 'grt') then
            vim.keymap.del('n', 'grt', {})
        end
        vim.api.nvim_buf_set_keymap(0, "n", "gD", ":lua vim.lsp.buf.declaration()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "gt", ":lua vim.lsp.buf.type_definition()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "gd", ":lua vim.lsp.buf.definition()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "gi", ":lua vim.lsp.buf.implementation()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "gr", ":Telescope lsp_references<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "[d", ":lua vim.diagnostic.goto_prev()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "]d", ":lua vim.diagnostic.goto_next()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", ":lua vim.lsp.buf.hover()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "<C-k>", ":lua vim.lsp.buf.signature_help()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>ca", ":lua vim.lsp.buf.code_action()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>dl", ":lua vim.diagnostic.setloclist()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "<F2>", ":lua vim.lsp.buf.rename()<cr>", {noremap=true, silent=true})
      end,
    })

    local cpb = require('cmp_nvim_lsp').default_capabilities()
    vim.lsp.config('*', {
        capabilities = cpb,
        root_markers = { '.git' },
    })

    require"fidget".setup{}
end

return M
