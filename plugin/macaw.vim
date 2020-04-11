" The MIT License (MIT)
"
" Copyright (c) 2020 Urbain Vaes
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in
" all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.

if exists('g:loaded_macaw') || &compatible
    finish
endif
let g:loaded_macaw = 1

function! s:highlight_colors()
    for i in range(1, 255)
        exe "highlight zVimHiNmbrFg".i." ctermfg=".i
        exe "highlight zVimHiNmbrBg".i." ctermfg=black ctermbg=".i
    endfor
    for i in range(1, 255)
        exe "highlight zColor".i." ctermbg=".i
    endfor
endfunction

augroup highlight_colors
    autocmd!
    autocmd ColorScheme * call s:highlight_colors()
augroup END

call s:highlight_colors()

" mapcheck() conflicts with Remembrall 'y' mapping
if empty(maparg('yc', 'n'))
    nnoremap <silent> yc :call macaw#macaw()<cr>
endif

command! -nargs=* -complete=highlight Macaw call macaw#macaw(<q-args>)
