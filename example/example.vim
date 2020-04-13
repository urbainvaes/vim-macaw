set hidden
set number
" 1) Use 'yc' to change the color under cursor
nnoremap <a-b>  :Buffers<cr>
nnoremap <a-f>  :Files<cr>
nnoremap <a-g>  :GitFiles<cr>

" 2) Use arrow keys to interactively adjust r/g/b values of the variables
let g:tex_conceal= ''
let g:tex_flavor='latex'

" 3) Change background color of String
echom "Hello world!"

" 4) Change fg color of sign column

" 5) Save highlight commands for future use
command! -nargs=0 MacawWrite :put =macaw#write()

function! MyHighlights()
    " Macaw defines highlighting rules for color numbers
endfunction

augroup myHighlights
    autocmd!
    autocmd ColorScheme * call MyHighlights()
augroup END
