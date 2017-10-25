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
Plugin 'scrooloose/nerdtree' " Filesystem explorer
Plugin 'kien/ctrlp.vim' " C-P for extended search

" Programming plugins
Plugin 'vim-scripts/indentpython.vim'
Plugin 'davidhalter/jedi-vim' " Python code autocompletition
Plugin 'w0rp/ale' " Async code checking
Plugin 'SirVer/ultisnips' " Snippets  engine.
Plugin 'honza/vim-snippets' " Snippets are separated from the engine. Add this if you want them:
Plugin 'airblade/vim-gitgutter' " TODO check with neovim
Plugin 'fisadev/vim-isort'  " isort for VIM
"let g:vim_isort_python_version = 'python3'

" UI plugins
Plugin 'vim-airline/vim-airline' " Fancy status line
Plugin 'altercation/vim-colors-solarized' " Fancy color scheme
Plugin 'luochen1990/rainbow' " Rainbow parentheses
let g:rainbow_active = 1

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set encoding=utf-8

set backspace=2

set history=1000 " number of commands kept in history

" Search options
set ignorecase " ignore case
set smartcase " don't ignore case if upper case characters appear in pattern
set hlsearch " highlight all matches
set incsearch " search while typing

" Indentation options
set autoindent " copy indent from previous line
set smartindent " increase / decrease indent according to context




set showmatch " when a bracket is inserted, briefly jump to the matching one
set textwidth=0

" Window options
set splitright " hsplits appear on the right
set splitbelow " vsplits appear below
set number " show line numbers
set scrolloff=5 " always show 5 lines context
set diffopt=filler,vertical " customize diff mode
set mouse=nv " use mouse in normal and visual mode
set guicursor=


nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

"set foldmethod=indent
"set foldlevel=99
"nnoremap <space> za

"au BufNewFile,BufRead *.py
au FileType python
    \ set tabstop=4 |      " <Tab> is 4 spaces wide
    \ set softtabstop=4 |  " <Tab> counds as 4 spaces wide while performing editing operations
    \ set shiftwidth=4 |   " indentation level is 4 spaces wide
    \ set textwidth=119 |
    \ set expandtab |      " insert spaces instead of <Tab>
    \ set smarttab |       " number of spaces inserted on <Tab> depends on context
    \ set fileformat=unix


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

" Ignore files in NERDTree
let NERDTreeIgnore=['\.pyc$', '\~$'] 
nmap <F3> :NERDTreeToggle<CR>

nmap <C-b> :CtrlPBuffer<CR>

" Syntastic settings
"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

" Set syntax highlighting
let python_highligt_all=1
syntax on

set t_Co=256
let g:solarized_termcolors=256
set background=dark
colorscheme solarized
call togglebg#map("<F5>")

" Show trailing whitespaces and tab characters
" (use :dig for list of digraphs)
set list
set listchars=tab:»»,trail:·
" Color trailing whitespace and tab characters.
" Note that the foreground colors are overridden here, so this only works with the "set list" settings above.
highlight ExtraWhitespace ctermfg=red cterm=bold term=bold
match ExtraWhitespace '\s\+$\|\t'
" Highlight in newly opened files
autocmd BufWinEnter * match ExtraWhitespace '\s\+$\|\t'
" Highlight in splits, see http://vim.wikia.com/wiki/Detect_window_creation_with_WinEnter for details.
autocmd WinEnter * match ExtraWhitespace '\s\+$\|\t'

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1
" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'
"let g:airline_powerline_fonts = 1
let g:airline#extensions#ale#enabled = 1

let g:ale_sign_error = 'E>'
let g:ale_sign_warning = 'W>'

let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

"let g:ale_open_list = 1
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-p>"

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:jedi#show_call_signatures = "2" " or 1 (default)?
set noshowmode
let g:jedi#use_splits_not_buffers = "right"
"let g:jedi#use_tabs_not_buffers = 1

let g:ale_linters = {
\   'python': ['flake8', 'isort'],
\}

" YouCompleteMe settings
"let g:ycm_key_list_select_completion=[]
"let g:ycm_key_list_previous_completion=[]
"let g:ycm_autoclose_preview_window_after_completion=1
"let g:ycm_min_num_of_chars_for_completion = 2

" Use both ropevim and jedi-vim for auto completion.Python-mode
" let ropevim_vim_completion = 1
"let ropevim_extended_complete = 1
"let ropevim_enable_autoimport = 1
"let g:ropevim_autoimport_modules = ["os.*","traceback","django.*"]
"imap <s-space> <C-R>=RopeCodeAssistInsertMode()<CR>
"
"let g:jedi#completions_command = "<C-Space>"
"let g:jedi#auto_close_doc = 1

set colorcolumn=120
set laststatus=2
set updatetime=500
"set completeopt=menuone,preview,noinsert

