if has('nvim')
    let s:editor_root=expand("~/.config/nvim")
else
    let s:editor_root=expand("~/.vim")
endif

set nocompatible
filetype off  " Vundle required

" set the runtime path to include Vundle and initialize
set rtp+=~/.config/nvim/bundle/Vundle.vim
call vundle#begin(s:editor_root . '/bundle')
" General plugins
    Plugin 'gmarik/Vundle.vim' " let Vundle manage Vundle, required
    Plugin 'tpope/vim-fugitive' " Git for VIM
    Plugin 'airblade/vim-gitgutter' " Showing git diff in the gutter
    Plugin 'kien/ctrlp.vim' " C-P for extended search
    Plugin 'farmergreg/vim-lastplace' " Go to last cursor position in opened file

    Plugin 'scrooloose/nerdtree' " Filesystem explorer
    let NERDTreeIgnore=['\.pyc$', '\~$'] " Ignore files in NERDTree

" Programming plugins
    if has('python') || has('python3')
        Plugin 'vim-scripts/indentpython.vim'
        Plugin 'davidhalter/jedi-vim' " Python code autocompletition
        let g:jedi#completions_enabled = 0
        Plugin 'fisadev/vim-isort'  " isort for VIM
        Plugin 'jmcantrell/vim-virtualenv'
    endif

    Plugin 'SirVer/ultisnips' " Snippets  engine.
    Plugin 'honza/vim-snippets' " Snippets are separated from the engine. Add this if you want them:

" NeoVim specific plugins
    if has('nvim')
        Plugin 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
        let g:deoplete#enable_at_startup=1

        Plugin 'zchee/deoplete-jedi'
        autocmd InsertLeave * if pumvisible() == 0 | pclose | endif

        Plugin 'w0rp/ale' " Async code checking
    endif

" UI plugins
    Plugin 'vim-airline/vim-airline' " Fancy status line
    Plugin 'altercation/vim-colors-solarized' " Fancy color scheme
    Plugin 'luochen1990/rainbow' " Rainbow parentheses
    let g:rainbow_active = 1

call vundle#end()            " required
filetype plugin indent on    " required

set encoding=utf-8
set fileformat=unix
set backspace=2
set history=1000 " number of commands kept in history

" Search options
set ignorecase " ignore case
set smartcase " don't ignore case if upper case characters appear in pattern
set hlsearch " highlight all matches
set incsearch " search while typing

set showmatch " when a bracket is inserted, briefly jump to the matching one

" Window options
set splitright " hsplits appear on the right
set splitbelow " vsplits appear below
set number " show line numbers
set noshowmode " don't show mode in statusline
set scrolloff=5 " always show 5 lines context
set diffopt=filler,vertical " customize diff mode
set mouse=nv " use mouse in normal and visual mode
set guicursor=

" Enable virtualenv support
if has('python3')
python3 << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  #execfile(activate_this, dict(__file__=activate_this))
  with open(activate_this) as f:
    code = compile(f.read(), activate_this, 'exec')
    exec(code, dict(__file__=activate_this))
EOF
endif
if has('python')
python << EOF
import os
import sys
if 'VIRTUAL_ENV' in os.environ:
  project_base_dir = os.environ['VIRTUAL_ENV']
  activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
  execfile(activate_this, dict(__file__=activate_this))
EOF
endif

" Set syntax highlighting
let python_highligt_all=1
syntax on

" Styles settings
function! StyleSettings()
    set t_Co=256
    let g:solarized_termcolors=256
    set background=dark
    colorscheme solarized
    call togglebg#map("<F5>")
    let g:airline#extensions#tabline#enabled = 1 " Enable the list of tabs / buffers
    let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename
    let g:airline#extensions#ale#enabled = 1
    " Use powerline fonts
    " If showing gibberish, follow instructions on
    " https://powerline.readthedocs.io/en/master/installation/linux.html#fonts-installation
    " or set to 0
    let g:airline_powerline_fonts = 1
endfunction
call StyleSettings()

" ALE settings
function! AleSettings()
    let g:ale_sign_error = 'E>'
    let g:ale_sign_warning = 'W>'
    let g:ale_echo_msg_error_str = 'E'
    let g:ale_echo_msg_warning_str = 'W'
    let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
    "let g:ale_linters = {
    "\   'python': ['flake8', 'isort'],
    "\}
endfunction
call AleSettings()

function! KeyMapSettings()
    " Jump between windows using Alt + Arrow
    nmap <silent> <A-Up> :wincmd k<CR>
    nmap <silent> <A-Down> :wincmd j<CR>
    nmap <silent> <A-Left> :wincmd h<CR>
    nmap <silent> <A-Right> :wincmd l<CR>

    " Toggle NERDTree using <F3>
    nmap <F3> :NERDTreeToggle<CR>

    " Use Ctrl + b to search buffers
    nmap <C-b> :CtrlPBuffer<CR>

    " Use Shift + PageDown/PageUp to navigate tabs
    nmap <silent> <A-PageDown> :tabnext<CR>
    nmap <silent> <A-PageUp> :tabprevious<CR>

    " Navigate between errors with Ctrl + k/j
    nmap <silent> <C-k> <Plug>(ale_previous_wrap)
    nmap <silent> <C-j> <Plug>(ale_next_wrap)
endfunction
call KeyMapSettings()

" Trigger configuration. Do not use <Tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<Tab>"
let g:UltiSnipsJumpForwardTrigger="<C-n>"
let g:UltiSnipsJumpBackwardTrigger="<C-p>"
let g:UltiSnipsEditSplit="vertical" " If you want :UltiSnipsEdit to split your window.

if has('python') || has('python3')
    let g:jedi#show_call_signatures = "2"
    let g:jedi#use_splits_not_buffers = "right"
    "let g:jedi#use_tabs_not_buffers = 1
endif

set textwidth=119
set colorcolumn=120
set updatetime=500
"set completeopt=menuone,preview,noinsert

" Show trailing spaces
" (use :dig for list of digraphs)
set list
set listchars=tab:»\ ,trail:·
" Color trailing spaces and tabs
highlight ExtraWhitespace ctermfg=red cterm=bold term=bold
autocmd BufWinEnter,WinEnter * match ExtraWhitespace '\s\+$\|\t'
