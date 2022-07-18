-- Automatically install packer
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    PACKER_BOOTSTRAP = vim.fn.system({
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path,
    })
    print('Installing packer close and reopen Neovim...')
    vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, 'packer')
if not status_ok then
    return
end

packer.startup(function(use)
    use('wbthomason/packer.nvim') -- package manager
    -- Solarized color scheme
    use('lifepillar/vim-solarized8')
    -- Fancy status line
    use({
        'vim-airline/vim-airline',
        config = require('user.ui').airline_config,
        lock = true,
    })
    -- Airline themes
    use({
        'vim-airline/vim-airline-themes',
        requires = { 'vim-airline/vim-airline' },
        config = function()
            vim.g.airline_theme = 'base16_3024'
        end,
    })
    -- use({
    --     'nvim-lualine/lualine.nvim',
    --     requires = { 'kyazdani42/nvim-web-devicons', opt = true },
    -- })

    -- Rainbow parentheses
    use({
        'luochen1990/rainbow',
        config = function()
            vim.g.rainbow_active = 1
            vim.g.rainbow_conf = { ctermfgs = { 'darkblue', 'darkyellow', 'darkmagenta', 'darkgreen' } }
        end,
    })

    -- Seamless navigation between vim and tmux
    use({
        'christoomey/vim-tmux-navigator',
        config = function()
            vim.g.tmux_navigator_no_mappings = 1
        end,
    })
    -- Comment stuff out
    use('tpope/vim-commentary')
    -- Case sensitive substitution (and more)
    use('tpope/vim-abolish')
    use('tpope/vim-fugitive')
    use('tpope/vim-repeat')

    use('neovim/nvim-lspconfig')
    use({'hrsh7th/cmp-nvim-lsp', lock=true})
    use({'hrsh7th/cmp-buffer', lock=true})
    use({'hrsh7th/cmp-path', lock=true})
    use({'hrsh7th/cmp-cmdline', lock=true})
    use({'hrsh7th/nvim-cmp', commit='bba6fb67fdafc0af7c5454058dfbabc2182741f4'})
    use('L3MON4D3/LuaSnip')
    use({'saadparwaiz1/cmp_luasnip', commit='b10829736542e7cc9291e60bab134df1273165c9'})
    use('rafamadriz/friendly-snippets')
    use('ray-x/lsp_signature.nvim')
    use('nvim-lua/plenary.nvim')
    use('jose-elias-alvarez/null-ls.nvim')
    use('kyazdani42/nvim-web-devicons')
    use('folke/trouble.nvim')
    use('farmergreg/vim-lastplace')
    use({ 'vim-scripts/indentpython.vim', opt = true, ft = { 'python' } })
    -- use('posva/vim-vue')

    -- Gitsigns
    use({
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('gitsigns').setup({
                signcolumn = true,
                attach_to_untracked = false,
                numhl = true,
                preview_config = {
                    border = 'none',
                },
            })
        end,
    })

    -- use('w0rp/ale')
    -- use({
    --     'https://git.sr.ht/~whynothugo/lsp_lines.nvim',
    --     config = function()
    --         require('lsp_lines').register_lsp_virtual_lines()
    --     end,
    -- })

    -- use({
    --     'goolord/alpha-nvim',
    --     requires = { 'kyazdani42/nvim-web-devicons' },
    --     config = function()
    --         require('alpha').setup(require('alpha.themes.startify').config)
    --     end,
    -- })
end)
