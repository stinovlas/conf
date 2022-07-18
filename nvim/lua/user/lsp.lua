local lspconfig = require('lspconfig')
local cmp = require('cmp')
local luasnip = require('luasnip')

local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match('%s') == nil
end

-- LSP settings
local on_attach = function(_, bufnr)
    local map = require('user.utils').map
    local opts = { noremap = true, silent = true, buffer = bufnr }

    map({ 'n', '<leader>gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts })
    map({ 'n', '<leader>gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts })
    map({ 'n', '<leader>gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts })
    map({ 'n', '<leader>gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts })
    map({ 'n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts })
    map({ 'n', '<leader>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts })
    map({ 'n', '<leader>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts })
    map({ 'n', '<leader>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts })
    map({ 'n', '<leader>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts })
    map({ 'n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts })
    map({ 'n', '<leader>ff', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts })
    map({ 'v', '<leader>ff', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts })
    map({ 'n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts })
    map({ 'n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts })
    map({ 'n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts })
    map({ 'n', '<C-k>', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts })
    map({ 'n', '<C-j>', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts })
    map({ 'n', '<leader>so', [[<cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>]], opts })
    vim.cmd([[ command! Format execute 'lua vim.lsp.buf.formatting()' ]])
end

local kind_icons = {
    Text = '',
    Method = '',
    Function = '',
    Constructor = '',
    Field = '',
    Variable = '',
    Class = 'ﴯ',
    Interface = '',
    Module = '',
    Property = 'ﰠ',
    Unit = '',
    Value = '',
    Enum = '',
    Keyword = '',
    Snippet = '',
    Color = '',
    File = '',
    Reference = '',
    Folder = '',
    EnumMember = '',
    Constant = '',
    Struct = '',
    Event = '',
    Operator = '',
    TypeParameter = '',
}

local magic_last_comparator = function(entry1, entry2)
    -- Put __magic_methods__ at the end of the list
    magic1 = string.find(entry1.completion_item.label, '__') == 1
    magic2 = string.find(entry2.completion_item.label, '__') == 1
    if magic1 and not magic2 then
        return false
    elseif not magic1 and magic2 then
        return true
    end
end

local lspkind_comparator = function(conf)
    local lsp_types = require('cmp.types').lsp
    return function(entry1, entry2)
        if entry1.source.name ~= 'nvim_lsp' then
            if entry2.source.name == 'nvim_lsp' then
                return false
            else
                return nil
            end
        end

        local kind1 = lsp_types.CompletionItemKind[entry1:get_kind()]
        local kind2 = lsp_types.CompletionItemKind[entry2:get_kind()]

        local priority1 = conf.kind_priority[kind1] or 0
        local priority2 = conf.kind_priority[kind2] or 0
        if priority1 == priority2 then
            return nil
        end
        return priority2 < priority1
    end
end

cmp.setup({
    sorting = {
        comparators = {
            magic_last_comparator,
            lspkind_comparator({
                kind_priority = {
                    Field = 11,
                    Property = 11,
                    Constant = 10,
                    Enum = 10,
                    EnumMember = 10,
                    Event = 10,
                    Function = 10,
                    Method = 10,
                    Operator = 10,
                    Reference = 10,
                    Struct = 10,
                    Variable = 9,
                    File = 8,
                    Folder = 8,
                    Class = 5,
                    Color = 5,
                    Module = 5,
                    Keyword = 2,
                    Constructor = 1,
                    Interface = 1,
                    Text = 1,
                    TypeParameter = 1,
                    Unit = 1,
                    Value = 1,
                    Snippet = 0,
                },
            }),
            cmp.config.compare.sort_text,
        },
    },
    formatting = {
        format = function(entry, vim_item)
            vim_item.abbr = vim_item.abbr:gsub('%~', '')
            -- Kind icons
            vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            -- Source
            vim_item.menu = ({
                buffer = '[Buffer]',
                nvim_lsp = '[LSP]',
                luasnip = '[LuaSnip]',
                nvim_lua = '[Lua]',
                latex_symbols = '[LaTeX]',
            })[entry.source.name]
            return vim_item
        end,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = false }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.

        ['<Tab>'] = cmp.mapping(function(fallback)
            if luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
    }),
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    sources = {
        { name = 'buffer' },
    },
    mapping = cmp.mapping.preset.cmdline({}),
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    sources = cmp.config.sources({
        { name = 'path', option = { trailing_slash = true } },
    }, {
        { name = 'cmdline', keyword_length = 2 },
    }),
    mapping = cmp.mapping.preset.cmdline({}),
})

-- Setup lspconfig.
local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
lspconfig.jedi_language_server.setup({
    on_attach = on_attach,
    capabilities = capabilities,
})

require('luasnip.loaders.from_vscode').load({ include = { 'python' } })
require('lsp_signature').setup({
    bind = true,
    handler_opts = {
        border = 'none',
    },
    hint_enable = false,
    extra_trigger_chars = { '(', ',', '=' },
})

local null_ls = require('null-ls')
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
null_ls.setup({
    on_attach = on_attach,
    sources = {
        -- General
        code_actions.gitsigns,
        formatting.trim_whitespace,
        formatting.trim_newlines,
        -- Python
        diagnostics.flake8,
        -- diagnostics.pydocstyle.with({ extra_args = { '--config', vim.loop.cwd() .. '/setup.cfg' } }),
        diagnostics.mypy,
        formatting.isort,
        -- JavaScript
        diagnostics.eslint,
        -- Lua
        formatting.stylua,
    },
    diagnostics_format = '#{s}: #{m} [#{c}]',
})
vim.diagnostic.config({
    virtual_text = true, -- { source = true }, -- severity=vim.diagnostic.severity.ERROR },
    -- virtual_lines = true,
    signs = true,
    underline = false,
    update_in_insert = false,
    severity_sort = true,
})

local signs = { Error = ' ', Warn = ' ', Hint = ' ', Info = ' ' }
for type, icon in pairs(signs) do
    local hl = 'DiagnosticSign' .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
require('trouble').setup({
    auto_open = false,
    auto_close = true,
    use_diagnostic_signs = true,
})
