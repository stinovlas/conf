local M = {}

-- Style settings
vim.o.guicursor = '' -- fix for wierd cursor behaviour
vim.o.termguicolors = true
vim.o.background = 'dark'

vim.cmd([[colorscheme solarized8]])
-- vim.cmd([[highlight TrailingWhitespace ctermbg=darkred guibg=darkred]])
-- vim.cmd([[match TrailingWhitespace /\s\+$/]])

M.airline_config = function()
    vim.g['airline#extensions#tabline#enabled'] = 1 -- enable the list of tabs / buffers
    vim.g['airline#extensions#tabline#fnamemod'] = ':t' -- show just the filename
    vim.g['airline#extensions#tabline#buffer_nr_show'] = 1 -- show buffer numbers in tabline
    vim.g['airline#extensions#tabline#buffer_nr_format'] = '%s '
    vim.g['airline_powerline_fonts'] = 1 -- Use powerline fonts. If showing gibberish, follow instructions on
    -- https://powerline.readthedocs.io/en/master/installation/linux.html#fonts-installation
    -- or set to 0
end

-- require('lualine').setup({
--     options = {
--         -- icons_enabled = true,
--         theme = 'codedark',
--         -- component_separators = { left = '', right = ''},
--         -- component_separators = { left = '|', right = '|'},
--         -- section_separators = { left = '', right = ''},
--         section_separators = { left = '', right = '' },
--         -- disabled_filetypes = {},
--         -- always_divide_middle = true,
--     },
--     sections = {
--         lualine_a = { 'mode' },
--         lualine_b = { 'branch', 'diff', 'diagnostics' },
--         lualine_c = { { 'filename', path = 1 } },
--         lualine_x = { 'encoding', 'fileformat', 'filetype' },
--         lualine_y = { 'progress' },
--         lualine_z = { 'location' },
--     },
--     -- inactive_sections = {
--     --   lualine_a = {},
--     --   lualine_b = {},
--     --   lualine_c = {'filename'},
--     --   lualine_x = {'location'},
--     --   lualine_y = {},
--     --   lualine_z = {}
--     -- },
--     tabline = {
--         lualine_a = { { 'buffers', mode = 2, icons_enabled = false } },
--     },
--     extensions = {},
-- })

return M
