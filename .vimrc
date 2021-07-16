set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'vim-airline/vim-airline'
Plugin 'ntpeters/vim-better-whitespace'
Plugin 'plasticboy/vim-markdown'
Plugin 'altercation/vim-colors-solarized'
Plugin 'w0rp/ale'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'preservim/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'airblade/vim-rooter'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'hashivim/vim-terraform'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" NERDTree
nnoremap <silent> <C-n> :NERDTreeToggle <CR>
" Exit Vim if NERDTree is the only window remaining in the only tab.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Fzf
nnoremap <silent> <C-p> :Files <CR>
nnoremap <silent> <C-g> :GFiles <CR>
nnoremap <silent> <C-o> :Buffers <CR>
nnoremap <C-f> :Rg!<Space>

" Color Options
" For altercation/vim-colors-solarized plugin
syntax enable
set background=dark
colorscheme solarized
" To prevent grey in gutter. This, for some reason, must come after the
" color settings applied above.
highlight clear SignColumn

set tabstop=4
set shiftwidth=4
set expandtab

" Set line numbers
set number

" Set linebreak to stop breaking in middle of words
set linebreak

" No swap file
set noswapfile

" Python linters
let b:ale_linters = ['flake8', 'mypy', 'terraform']
let g:ale_python_flake8_options="--ignore=SC100,SC200"

:set backspace=indent,eol,start
