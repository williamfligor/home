let s:darwin = has('mac')

" Spacemacs
let g:spacemacs#excludes = [
  \ 'b',
  \ 'p',
\ ]

" Editorconfig
let g:EditorConfig_exclude_patterns = ['fugitive://.*', 'scp://.*']

" Rainbow always on
autocmd FileType * RainbowParentheses

" Disable markdown folding
let g:vim_markdown_folding_disabled = 1
