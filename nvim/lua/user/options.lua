vim.g.mapleader = ','
vim.g.python3_host_prog='/usr/bin/python3.8'
vim.g.loaded_python_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0

vim.bo.fileformat = 'unix'
vim.o.backspace = '2'
vim.o.history = 1000
vim.wo.signcolumn = 'auto'

-- Search options
vim.o.ignorecase = true -- ignore case
vim.o.smartcase = true -- don't ignore case if upper case characters appear in pattern
-- vim.o.hlsearch = true  -- highlight all matches
-- vim.o.incsearch = true  -- search while typing

vim.o.showmatch = true -- when a bracket is inserted, briefly jump to the matching one

-- Window options
vim.o.splitright = true -- hsplits appear on the right
vim.o.splitbelow = true -- vsplits appear below
vim.wo.number = true -- show line numbers
vim.o.showmode = false -- don't show mode in statusline (it's already in Airline)
vim.o.scrolloff = 5 -- always show 5 lines context
vim.o.diffopt = 'filler,vertical' -- customize diff mode
vim.o.mouse = 'nv' -- use mouse in normal and visual mode
vim.o.hidden = true -- buffer can be abandoned unsaved

-- Turn on persistent undo
vim.bo.undofile = true

vim.bo.expandtab = true
vim.bo.tabstop = 4
vim.bo.softtabstop = 4
vim.bo.shiftwidth = 4
vim.o.smarttab = true

vim.g.pyindent_open_paren = 'shiftwidth()'
vim.o.colorcolumn = '120'
vim.o.list = true
vim.o.listchars = 'tab:»·,trail:·'
