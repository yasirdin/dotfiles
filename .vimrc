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

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required

" Color Options
syntax enable
set background=dark
let g:solarized_termtrans = 1
colorscheme solarized

set tabstop=4
set shiftwidth=4
set expandtab

" Set line numbers
set number
set relativenumber

" Python linters
let b:ale_linters = ['flake8', 'mypy']
let g:ale_python_flake8_options="--ignore=SC100,SC200"
