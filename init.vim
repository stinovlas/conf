let s:editor_root=expand("~/.config/nvim")
let g:python3_host_prog=expand('~/.envs/neovim3/bin/python')
let g:python_host_prog=expand('~/.envs/neovim2/bin/python')

let mapleader=','

let g:plug_threads = 8
let g:plug_timeout = 30

call plug#begin('~/.config/nvim/plugged')
" General plugins
Plug 'tpope/vim-fugitive'           " Git for VIM
Plug 'airblade/vim-gitgutter'       " Showing git diff in the gutter
Plug 'kien/ctrlp.vim'               " C-P for extended search
Plug 'mbbill/undotree'              " Easy access to undo tree
Plug 'farmergreg/vim-lastplace'     " Go to last cursor position in opened file
Plug 'easymotion/vim-easymotion'    " Easy motion in (and across) files
Plug 'tpope/vim-repeat'             " Repeat mapped actions on dot

" On-demand loading
Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }     " File browser
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }          " ctags browser

" General programming plugins
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }   " Dark powered autocompletition engine
Plug 'w0rp/ale'                                                 " Async code checking
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'             " Snippets engine and actual snippets
Plug 'tpope/vim-commentary'                                     " Comment stuff out

" Python plugins
Plug 'vim-scripts/indentpython.vim', { 'for': 'python' }    " Python indentation
Plug 'davidhalter/jedi-vim', { 'for': 'python' }            " Static analysis of Python code
Plug 'fisadev/vim-isort', { 'for': 'python' }               " Python isort
Plug 'jmcantrell/vim-virtualenv', { 'for': 'python' }       " Virtualenv support
Plug 'zchee/deoplete-jedi', { 'for': 'python' }             " Deoplete source for Python

" UI plugins
Plug 'vim-airline/vim-airline' " Fancy status line
Plug 'vim-airline/vim-airline-themes' " Airline themes
Plug 'lifepillar/vim-solarized8'
Plug 'luochen1990/rainbow' " Rainbow parentheses
call plug#end()

set fileformat=unix
set backspace=2
set history=1000 " number of commands kept in history

" Turn on persistent undo
if has('persistent_undo')
    let &undodir = s:editor_root . '/undodir/'
    set undofile
endif

" Search options
set ignorecase  " ignore case
set smartcase   " don't ignore case if upper case characters appear in pattern
set hlsearch    " highlight all matches
set incsearch   " search while typing

set showmatch   " when a bracket is inserted, briefly jump to the matching one

" Window options
set splitright  " hsplits appear on the right
set splitbelow  " vsplits appear below
set number      " show line numbers
set noshowmode  " don't show mode in statusline (it's already in Airline)
set scrolloff=5 " always show 5 lines context
set diffopt=filler,vertical " customize diff mode
set mouse=nv    " use mouse in normal and visual mode
set hidden      " buffer can be abandoned unsaved

let python_highligt_all=1

" Styles settings
function! StyleSettings()
    set guicursor=  " fix for wierd cursor behaviour
    set termguicolors
    set background=dark
    colorscheme solarized8_high

    "Airline Configuration
    let g:airline_theme='base16_3024'
    let g:airline#extensions#tabline#enabled = 1        " Enable the list of tabs / buffers
    let g:airline#extensions#tabline#fnamemod = ':t'    " Show just the filename
    let g:airline#extensions#ale#enabled = 1            " Show ALE warnings / errors
    let g:airline#extensions#tabline#buffer_nr_show = 1 " Show buffer numbers in tabline
    let g:airline#extensions#tabline#buffer_nr_format = '%s '
    let g:airline_powerline_fonts = 1   " Use powerline fonts. If showing gibberish, follow instructions on
                                        " https://powerline.readthedocs.io/en/master/installation/linux.html#fonts-installation
                                        " or set to 0

    " Rainbow parentheses colors
    let g:rainbow_conf = { 'ctermfgs': ['darkblue', 'darkyellow', 'darkmagenta', 'darkgreen'] }
    let g:rainbow_active = 1

    hi Cursor gui=reverse guibg=NONE guifg=NONE

    " Show trailing spaces and tabs
    " (use :dig for list of digraphs)
    set list
    set listchars=tab:»\ ,trail:·
    " Color trailing spaces and tabs
    highlight ExtraWhitespace ctermfg=red cterm=bold term=bold
    autocmd BufWinEnter,WinEnter * match ExtraWhitespace '\s\+$\|\t'
endfunction

function! CodeSettings()
    " ALE configuration
    let g:ale_sign_error = 'E>'
    let g:ale_sign_warning = 'W>'
    let g:ale_echo_msg_error_str = 'E'
    let g:ale_echo_msg_warning_str = 'W'
    let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
    let g:ale_fixers = {
    \   'python': [
    \       'autopep8',
    \   ],
    \}

    " Jedi configuration
    let g:jedi#completions_enabled = 0          " Use vim-jedi only for static code analysis, not autocompletion.
    let g:jedi#show_call_signatures = 2         " Show call signatures in ex line.
    let g:jedi#use_splits_not_buffers = 'right' " Open jedi goto in splits.

    " Deoplete and deoplete-jedi configuration
    let g:deoplete#enable_at_startup = 1
    autocmd InsertLeave * if pumvisible() == 0 | pclose | endif

    " UltiSnips trigger configuration
    let g:UltiSnipsExpandTrigger = '<Tab>'
    let g:UltiSnipsJumpForwardTrigger = '<C-n>'
    let g:UltiSnipsJumpBackwardTrigger = '<C-p>'
    let g:UltiSnipsEditSplit = 'vertical'   " If you want :UltiSnipsEdit to split your window.

    let g:tagbar_autofocus = 1              " Focus Tagbar when opened
    let NERDTreeIgnore=['\.pyc$', '\~$']    " Ignore files in NERDTree
    let g:gitgutter_max_signs = 9999
endfunction

function! KeyMapSettings()
    " Some useful basic mappings
    nnoremap q :
    inoremap jj <Esc>

    " Jump between windows using Alt + Arrow
    nnoremap <silent> <A-Up> :wincmd k<CR>
    nnoremap <silent> <A-Down> :wincmd j<CR>
    nnoremap <silent> <A-Left> :wincmd h<CR>
    nnoremap <silent> <A-Right> :wincmd l<CR>

    " Also jump between windows using Alt + hjkl
    nnoremap <silent> <A-k> :wincmd k<CR>
    nnoremap <silent> <A-j> :wincmd j<CR>
    nnoremap <silent> <A-h> :wincmd h<CR>
    nnoremap <silent> <A-l> :wincmd l<CR>

    " EesyMotion mappings
    let g:EasyMotion_do_mapping = 0     " Disable default mappings
    let g:EasyMotion_smartcase = 1      " Turn on case insensitive feature
    let g:EasyMotion_startofline = 0    " keep cursor column when JK motion

    map s <Plug>(easymotion-s2)
    map <leader>W <Plug>(easymotion-bd-W)
    map <leader>w <Plug>(easymotion-bd-w)
    nmap <leader>w <Plug>(easymotion-overwin-w)
    map <leader>l <Plug>(easymotion-lineanywhere)
    map <leader>j <Plug>(easymotion-bd-jk)

    " Hard mode (for learning purposes)
    " inoremap <Esc> <Nop>
    " noremap <Up> <Nop>
    " noremap <Down> <Nop>
    " noremap <Left> <Nop>
    " noremap <Right> <Nop>

    " Toggle NERDTree using <F3>
    nnoremap <F3> :NERDTreeToggle<CR>
    " Toggle Tagbar using <F2>
    nnoremap <F2> :TagbarToggle<CR>

    " Use Ctrl + b to search buffers
    nnoremap <leader>b :CtrlPBuffer<CR>

    " Use Alt + PageDown/PageUp to navigate buffers
    nnoremap <silent> <A-PageDown> :bn<CR>
    nnoremap <silent> <A-PageUp> :bp<CR>

    " Navigate between errors with Ctrl + k/j
    nnoremap <silent> <C-k> :ALEPreviousWrap<CR>
    nnoremap <silent> <C-j> :ALENextWrap<CR>
endfunction

set textwidth=119
set colorcolumn=120
set updatetime=500
"set completeopt=menuone,preview,noinsert

set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

call StyleSettings()
call CodeSettings()
call KeyMapSettings()

" Read local configuration files
function! ReadLocalRC()
    if !exists('g:localrc_file')
        let g:localrc_file = '.vimlocal'
    endif

    let l:path = getcwd()
    let l:list = []
    while l:path !=# '/'
        "echom 'Scanning localrc path ' . l:path
        let l:file = l:path . '/' . g:localrc_file
        if filereadable(l:file)
            let l:list = l:list + [ l:file ]
        endif
        let l:path = fnamemodify(l:path, ':h')
    endwhile
    call reverse(l:list)
    for l:localrc in l:list
        execute "source " . l:localrc
        "echom 'Reading localrc file ' . l:localrc
    endfor
endfunction

call ReadLocalRC()
"let g:deoplete#sources#jedi#extra_path = [ '...' ] + g:deoplete#sources#jedi#extra_path
