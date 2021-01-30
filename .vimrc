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
Plugin 'davidhalter/jedi-vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'preservim/nerdtree'
Plugin 'airblade/vim-gitgutter'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

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
let b:ale_linters = ['flake8', 'mypy']
let g:ale_python_flake8_options="--ignore=SC100,SC200"
