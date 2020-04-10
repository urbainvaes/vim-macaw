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

let s:path = expand("<sfile>:p:h")

let s:default_orientation = 'vertical'
let s:default_command_vertical = 'vert botright 24 split'
let s:default_command_horizontal = 'topleft 6 split'

" Hexadecimal to decimal
function! X2d(hex)
    return printf("%d", "0x".a:hex)
endfunction

function! Interpolate(color) abort
    let [r, g, b] = [a:color[1:2], a:color[3:4], a:color[5:6]]
    let [r, g, b] = [X2d(r), X2d(g), X2d(b)]
    let [argmin, min] = [-1, 256*3]
    for i in range(16, 255)
        let c = g:colors[i]
        let [ri, gi, bi] = [c[1:2], c[3:4], c[5:6]]
        let [ri, gi, bi] = [X2d(ri), X2d(gi), X2d(bi)]
        let norm = abs(ri - r) + abs(gi - g) + abs(bi - b)
        if norm < min
            let [argmin, min] = [i, norm]
        endif
    endfor
    return argmin
endfunction

function! s:highlight_colors()
    for i in range(1, 255)
        exe "highlight vimHiNmbrFg".i." ctermfg=".i
        exe "highlight vimHiNmbrBg".i." ctermfg=black ctermbg=".i
    endfor

    for i in range(1, 255)
        exe "highlight Color".i." ctermbg=".i
    endfor
endfunction

function! SynGroup()
    let effective_id = synIDtrans(synID(line('.'), col('.'), 1))
    return [synIDattr(effective_id, 'fg'),
                \ synIDattr(effective_id, 'bg'),
                \ synIDattr(effective_id, 'name')]
endfun

let s:plugin_buffer = -1
let s:transposed = 0
let s:syn_id = ""
let s:fg_or_bg = ""
let s:current_color = ""

function! Macaw_transpose() abort
    if bufwinnr(s:plugin_buffer) == -1
        return
    endif

    exe 'bwipeout' s:plugin_buffer
    let s:transposed = !s:transposed
    call Macaw_picker(s:syn_id, s:fg_or_bg)
endfunction

function! macaw#increment_color(number, group, fg_or_bg) abort
    echom [s:current_color, type(s:current_color)]
    let increment = v:count1 * a:number
    let s:current_color = (s:current_color + increment) % 256
    exe "highlight ".a:group." cterm".a:fg_or_bg."=".s:current_color
    call search('\<'.s:current_color.'\>', "w")
endfunction

function! Macaw_picker(syn_id, fg_or_bg) abort
    let [s:syn_id, s:fg_or_bg] = [a:syn_id, a:fg_or_bg]

    let syn_id = type(a:syn_id) == 1 ? hlID(a:syn_id) : a:syn_id
    let effective_id = synIDtrans(syn_id)
    let s:current_color = synIDattr(effective_id, a:fg_or_bg)
    let current_group = synIDattr(effective_id, 'name')
    echom [effective_id, a:fg_or_bg, s:current_color, current_group]

    let plugin_opened = buffer_exists(s:plugin_buffer)
    let plugin_window = bufwinnr(s:plugin_buffer)
    let plugin_visible = plugin_window != -1

    if plugin_opened && !plugin_visible
        exe 'bwipeout' s:plugin_buffer
    endif

    if !plugin_visible
        let orientation = get(g:, 'macaw_orientation', s:default_orientation)
        if s:transposed
            let orientation = (orientation == 'vertical' ? 'horizontal' : 'vertical')
        endif

        if orientation == 'vertical'
            let split_command = get(g:, 'macaw_command_vertical', s:default_command_vertical)
            let color_file = s:path."/256-columns.colors"
        else
            let split_command = get(g:, 'macaw_command_horizontal', s:default_command_horizontal)
            let color_file = s:path."/256-lines.colors"
        endif

        exe split_command color_file
        let s:plugin_buffer = bufnr()

        setlocal filetype=colors nonumber nospell buftype=nofile bufhidden=hide
              \ nobuflisted nowrap nomodifiable cursorline cursorcolumn nofoldenable sidescrolloff=0
    else
        exe plugin_window . 'wincmd w'
    endif

    if s:current_color == ""
        let background = synIDattr(hlID("Normal"), 'bg')
        let s:current_color = a:fg_or_bg == "fg" ? 255 : background
    endif
    call search('\<'.s:current_color.'\>', "w")

    exe "setlocal statusline=>\\ Group:\\ ".current_group
    exe "nnoremap <silent> <buffer> <cr> :exe \"highlight ".current_group." cterm".a:fg_or_bg."=\".expand(\"<cword>\")<cr>"
    exe "nnoremap <silent> <buffer> <c-a> :<c-u>call macaw#increment_color(1, \"".current_group."\", \"".a:fg_or_bg."\")<cr>"
    exe "nnoremap <silent> <buffer> <c-x> :<c-u>call macaw#increment_color(-1, \"".current_group."\", \"".a:fg_or_bg."\")<cr>"
    nnoremap <buffer> <c-t> :call Macaw_transpose()<cr>
    nnoremap <buffer> q :q!<cr>
endfunction

inoremap <expr> <F10> Interpolate(trim(system('grabc')))
nnoremap ycf :call Macaw_picker(synID(line('.'), col('.'), 1), 'fg')<cr>
nnoremap ycb :call Macaw_picker(synID(line('.'), col('.'), 1), 'bg')<cr>

augroup highlight_colors
    autocmd!
    autocmd ColorScheme * call s:highlight_colors()
augroup END

call s:highlight_colors()
