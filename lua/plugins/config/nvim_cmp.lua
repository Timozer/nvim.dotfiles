local M = {}

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

function M.config()
    local cmp = require'cmp'

    cmp.setup({
        snippet = {
            expand = function(args) require('luasnip').lsp_expand(args.body) end,
        },
        mapping = {
            ['<Tab>'] = cmp.mapping(function(fallback)
                local cmp = require('cmp')
                if cmp.visible() then
                    cmp.select_next_item()
                elseif require('luasnip').expand_or_jumpable() then
                    require('luasnip').expand_or_jump()
                else
                    vim.api.nvim_eval([[feedkeys("\<tab>", "n")]])
                    -- fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif require('luasnip').jumpable(-1) then
                    require('luasnip').jump(-1)
                else
                    vim.api.nvim_eval([[feedkeys("\<s-tab>", "n")]])
                end
            end, { "i", "s" }),
            ['<PageUp>']   = cmp.mapping(cmp.mapping.scroll_docs(-10), { 'i', 'c' }),
            ['<PageDown>'] = cmp.mapping(cmp.mapping.scroll_docs(10), { 'i', 'c' }),
            ['<CR>']       = cmp.mapping(function(fallback) 
                if cmp.visible() then
                    cmp.confirm({select = true})
                else
                    vim.api.nvim_eval([[feedkeys("\<cr>", "n")]])
                end
            end),
            -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
            ['<C-Space>']  = cmp.config.disable,
            ['<C-y>']      = cmp.config.disable,
            ['<C-e>']      = cmp.config.disable,
            ['<C-n>']      = cmp.config.disable,
            ['<C-p>']      = cmp.config.disable,
            ['<Down>']     = cmp.config.disable,
            ['<Up>']       = cmp.config.disable,
            ['<C-b>']      = cmp.config.disable,
            ['<C-f>']      = cmp.config.disable,
        },
        sources = cmp.config.sources({
            { name = 'buffer' },
            { name = 'calc' },
            { name = 'path' },
            { name = 'luasnip' },
            { name = 'nvim_lsp' },
            { name = 'nvim_lsp_signature_help' },
        }),
        formatting = {
            format = require("lspkind").cmp_format({with_text = false, menu = ({
                buffer = "[Buf]",
                nvim_lsp = "[LSP]",
                luasnip = "[Snip]",
                path = "[Path]",
            })}),
        }
    })

    -- for spell
    vim.opt.spell = true
    vim.opt.spelllang = { 'en_us' }

    -- {{ for cmdline
    -- require'cmp'.setup.cmdline(':', {
    --     sources = { { name = 'cmdline' } }
    -- })

    -- require'cmp'.setup.cmdline('/', {
    --     sources = cmp.config.sources(
    --         { { name = 'nvim_lsp_document_symbol' } }, 
    --         { { name = 'buffer' } }
    --     )
    -- })

    -- }}

    -- for autopairs
    -- If you want insert `(` after select function or method item
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
end

return M
