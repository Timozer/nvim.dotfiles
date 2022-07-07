local M = {}

function M.config()
    local lsp_attach = function (client)
        vim.api.nvim_buf_set_keymap(0, "n", "gD", ":lua vim.lsp.buf.declaration()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "gt", ":lua vim.lsp.buf.type_definition()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "gd", ":lua vim.lsp.buf.definition()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "gi", ":lua vim.lsp.buf.implementation()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "gr", ":lua vim.lsp.buf.references()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "[d", ":lua vim.diagnostic.goto_prev()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "]d", ":lua vim.diagnostic.goto_next()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", ":lua vim.lsp.buf.hover()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "<C-k>", ":lua vim.lsp.buf.signature_help()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>ca", ":lua vim.lsp.buf.code_action()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "<leader>dl", ":lua vim.diagnostic.setloclist()<cr>", {noremap=true, silent=true})
        vim.api.nvim_buf_set_keymap(0, "n", "<S-F6>", ":lua vim.lsp.buf.rename()<cr>", {noremap=true, silent=true})
    end

    local lspconfig = require('lspconfig')
    local cpb = vim.lsp.protocol.make_client_capabilities()

    cpb.textDocument.completion.completionItem.documentationFormat = {
        "markdown", "plaintext"
    }
    cpb.textDocument.completion.completionItem.snippetSupport = true
    cpb.textDocument.completion.completionItem.preselectSupport = true
    cpb.textDocument.completion.completionItem.insertReplaceSupport = true
    cpb.textDocument.completion.completionItem.labelDetailsSupport = true
    cpb.textDocument.completion.completionItem.deprecatedSupport = true
    cpb.textDocument.completion.completionItem.commitCharactersSupport = true
    cpb.textDocument.completion.completionItem.tagSupport = {
        valueSet = {1}
    }
    cpb.textDocument.completion.completionItem.resolveSupport = {
        properties = {"documentation", "detail", "additionalTextEdits"}
    }

    local data = require('core').ReadFile(vim.fn.stdpath('config')..'/settings.json')
    local settings = vim.json.decode(data)
    local root = vim.fn.expand(settings.lsp.root)
    for server, cfg in pairs(settings.lsp.servers) do
        if cfg.enable then
            cfg.opts.on_attach = lsp_attach
            cfg.opts.capabilities = cpb
            cfg.opts.flags = { debounce_text_changes = 500 }
            if cfg.opts['cmd'] then
                if require('core').StartsWith(cfg.opts.cmd[1], '#') then
                    cfg.opts.cmd[1] = root..'/'..server..'/'..string.sub(cfg.opts.cmd[1], 2)
                end
            end
            lspconfig[server].setup(cfg.opts)
        end
    end
end

return M