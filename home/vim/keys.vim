" Leader
let mapleader = "\<SPACE>"

" Spacemacs
let g:spacemacs#leader = '<SPACE>'
nnoremap <silent> <LEADER> :<C-U>LeaderGuide '<SPACE>'<CR>
vnoremap <silent> <LEADER> :<C-U>LeaderGuideVisual '<SPACE>'<CR>

" Number toggle
nnoremap <leader>rn :call NumberToggle()<Cr>

" Searching
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

" Remove trailing whitespace
nnoremap <leader>W :%s/\s\+$//<cr>:let @/=''<CR>

" Reselect pasted text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Make %% in command line expand to the path of the current buffer
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'

" Reselect after indent outdent
vnoremap < <gv
vnoremap > >gv

"Disable paste mode when leaving insert
au InsertLeave * set nopaste

" fugitive git bindings
nnoremap <space>ga :Git add %:p<CR><CR>
nnoremap <space>gs :Gstatus<CR>
nnoremap <space>gc :Gcommit -v -q<CR>
nnoremap <space>gt :Gcommit -v -q %:p<CR>
nnoremap <space>gd :Gdiff<CR>
nnoremap <space>ge :Gedit<CR>
nnoremap <space>gr :Gread<CR>
nnoremap <space>gw :Gwrite<CR><CR>
nnoremap <space>gl :silent! Glog<CR>:bot copen<CR>
nnoremap <space>gp :Ggrep<Space>
nnoremap <space>gm :Gmove<Space>
nnoremap <space>gb :Git branch<Space>
nnoremap <space>go :Git checkout<Space>

nnoremap <space>tc :tabnew<CR>
nnoremap <space>tn :tabnext<CR>
nnoremap <space>tp :tabprevious<CR>
nnoremap <space>tf :tabfirst<CR>
nnoremap <space>tl :tablast<CR>

" Spacemacs like buffer navigation
nnoremap <space>bb :Buffers<CR>

" Fuzzy File Finding with FZF
nnoremap <space>pf :GFiles<CR>
nnoremap <space>ff :Files<CR>

" Autogenerate doxygen comments
nnoremap <space>md :Dox<CR>
