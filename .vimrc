set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'scrooloose/nerdcommenter'
Plugin 'vim-airline/vim-airline'
" Plugin 'vim-airline/vim-airline-themes'
Plugin 'ntpeters/vim-better-whitespace'
" Plugin 'w0rp/ale'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'altercation/vim-colors-solarized'
Plugin 'vim-syntastic/syntastic'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required


"Color Options
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

" copies to the system level clipboard
set clipboard=unnamedplus

" remove whitespace on write of python files
autocmd BufWritePre *.py :%s/\s\+$//e

" syntastic python linter
let g:syntastic_python_checkers = ['flake8']
