" Built in autocomplete
set nocompatible
filetype plugin indent on
syntax enable

set completeopt+=menuone 
set completeopt+=noselect
set completeopt+=noinsert
set shortmess+=c   " Shut off completion messages
set belloff+=ctrlg " If Vim beeps during completion
let g:mucomplete#enable_auto_at_startup = 1
