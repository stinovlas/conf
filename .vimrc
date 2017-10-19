set nocompatible              " required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" Add all your plugins here (note older versions of Vundle used Bundle instead of Plugin)
Plugin 'tpope/vim-fugitive'  " Git for VIM
Plugin 'vim-scripts/indentpython.vim'
"Plugin 'Valloric/YouCompleteMe'

"Plugin 'python-rope/ropevim'
" Python code autocompletition
Plugin 'davidhalter/jedi-vim'
"let g:jedi#completions_enabled = 0

"Plugin 'scrooloose/syntastic'
Plugin 'nvie/vim-flake8'
Plugin 'altercation/vim-colors-solarized'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim' " C-P for extended search
"Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'vim-airline/vim-airline'

" Async code checking
Plugin 'w0rp/ale'
" Track the engine.
Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'

Plugin 'luochen1990/rainbow'
let g:rainbow_active = 1

Plugin 'fisadev/vim-isort'  " isort for VIM

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

set encoding=utf-8

set backspace=2
set history=1000
set smartcase
set hlsearch
set incsearch

set autoindent
set smartindent

set number

set mouse=nv
set mousemodel=popup

set showmatch
set textwidth=0
set splitright
set splitbelow
set diffopt=filler,vertical

set scrolloff=5

nmap <silent> <A-Up> :wincmd k<CR>
nmap <silent> <A-Down> :wincmd j<CR>
nmap <silent> <A-Left> :wincmd h<CR>
nmap <silent> <A-Right> :wincmd l<CR>

set foldmethod=indent
set foldlevel=99
"nnoremap <space> za

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=119 |
    \ set expandtab |
    \ set smarttab |
    \ set autoindent |
    \ set fileformat=unix

"let g:ycm_autoclose_preview_window_after_completion=1
"map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>

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
elseif has('python')
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
let g:airline_powerline_fonts = 1
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
