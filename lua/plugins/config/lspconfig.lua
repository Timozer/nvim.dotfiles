local M = {}

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

    local lsp_attach = function (client)
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
    end

    local lspconfig = require('lspconfig')
    local cpb = require('cmp_nvim_lsp').default_capabilities()
    for _, lsp in ipairs(lsps) do
        lspconfig[lsp].setup({
            on_attach = lsp_attach,
            capabilities = cpb,
            flags = { debounce_text_changes = 500 },
        })
    end

    require"fidget".setup{}
end

return M
