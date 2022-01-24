set nocompatible              " be iMproved, required
filetype off                  " required

" Automatic installation of vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
  silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'scrooloose/nerdcommenter'
Plug 'vim-airline/vim-airline'
Plug 'ntpeters/vim-better-whitespace'
Plug 'plasticboy/vim-markdown'
Plug 'altercation/vim-colors-solarized'
Plug 'alexghergh/nvim-tmux-navigation'
Plug 'airblade/vim-rooter'
Plug 'hashivim/vim-terraform'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'kyazdani42/nvim-tree.lua'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lua/plenary.nvim'
Plug 'lewis6991/gitsigns.nvim'
Plug 'akinsho/toggleterm.nvim'
Plug 'Mofiqul/vscode.nvim'
call plug#end()

" Color Options
" For altercation/vim-colors-solarized plugin
" syntax enable
" set background=dark
" colorscheme solarized
" To prevent grey in gutter. This, for some reason, must come after the
" color settings applied above.
" highlight clear SignColumn

let g:vscode_style = "dark"
let g:vscode_italic_comment = 1
colorscheme vscode

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

set backspace=indent,eol,start

set mouse=a

" Use <Tab> and <S-Tab> to navigate the completion list
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
