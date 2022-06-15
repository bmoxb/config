filetype on
syntax on

set number
set shiftwidth=4
set tabstop=4
set expandtab
set nowrap

set nobackup
set nowritebackup

set incsearch
set showmatch
set hlsearch

set history=1000

set autoindent
set smartindent

colorscheme peachpuff

let g:tex_flavor = 'latex'

lua require('plugins')
