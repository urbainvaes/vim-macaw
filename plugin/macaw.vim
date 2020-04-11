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
let s:default_command_vertical = 'vert botright 23 split'
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

let s:state = {
            \ 'buf_nr': -1,
            \ 'transposed': 0,
            \ 'fg_or_bg': "fg",
            \ 'syn_id': "",
            \ 'color_nr': ""
            \ }

function! Macaw_transpose() abort
    if bufwinnr(s:state['buf_nr']) == -1
        return
    endif
    exe 'bwipeout' s:state['buf_nr']
    let s:state['transposed'] = !s:state['transposed']
    call Macaw_picker(s:syn_id, s:fg_or_bg)
endfunction

function! macaw#increment_color(number) abort
    let color_group = synIDattr(s:state['syn_eid'], 'name')
    let increment = v:count1 * a:number
    let newcolor = (s:state['color_nr'] + increment) % 256
    exe "highlight ".color_group." cterm".s:state['fg_or_bg']."=".newcolor
    call search('\<'.newcolor.'\>', "w")
    let s:state['color_nr'] = newcolor
endfunction

function! Macaw_open() abort
    let plugin_opened = buffer_exists(s:state['buf_nr'])
    let plugin_window = bufwinnr(s:state['buf_nr'])
    let plugin_visible = plugin_window != -1

    if plugin_opened && !plugin_visible
        exe 'bwipeout' s:state['buf_nr']
    endif

    if !plugin_visible
        let orientation = get(g:, 'macaw_orientation', s:default_orientation)
        if s:state['transposed']
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
        let s:state['buf_nr'] = bufnr()

        setlocal filetype=colors nonumber nospell buftype=nofile bufhidden=hide
              \ nobuflisted nowrap nomodifiable cursorline cursorcolumn nofoldenable
              \ sidescrolloff=0 noequalalways mouse=n
    else
        exe plugin_window . 'wincmd w'
    endif
endfunction

function! Macaw_update() abort

    call search('\<'.s:state['color_nr'].'\>', "w")
endfunction

function! Macaw_set_color_at_cursor() abort
    let color_group = synIDattr(s:state['syn_eid'], 'name')
    let cursor_syn_eid = synIDtrans(synID(line('.'), col('.'), 1))
    let cursor_color = synIDattr(cursor_syn_eid, 'bg')
    exe "highlight ".color_group." cterm".s:state['fg_or_bg']."=".cursor_color
    let s:state['color_nr'] = cursor_color
endfunction

function! macaw#toggle_fg_bg()
    let s:state['fg_or_bg'] = s:state['fg_or_bg'] == 'fg' ? 'bg' : 'fg'
    call Macaw_picker(s:state['syn_id'])
endfunction

function! Macaw_picker(syn_id, ...) abort
    call Macaw_open()

    " Update state
    let fg_or_bg = get(a:, 1, s:state['fg_or_bg'])
    let syn_id = type(a:syn_id) == 1 ? hlID(a:syn_id) : a:syn_id
    let syn_eid = synIDtrans(syn_id)

    let color_nr = synIDattr(syn_eid, fg_or_bg)
    if color_nr == ""
        let background = synIDattr(hlID("Normal"), 'bg')
        let color_nr = fg_or_bg == "fg" ? 255 : background
    endif

    call extend(s:state, {
                \ 'syn_id': a:syn_id,
                \ 'syn_eid': syn_eid,
                \ 'color_nr': color_nr,
                \ 'fg_or_bg': fg_or_bg})

    call search('\<'.color_nr.'\>', "w")
    let color_group = synIDattr(s:state['syn_eid'], 'name')
    exe 'setlocal statusline=>\ '.color_group.'\ -\ '.fg_or_bg

    nnoremap <silent> <buffer> <cr> :<c-u> call Macaw_set_color_at_cursor()<cr>
    nmap <buffer> <2-leftmouse> <cr>
    nnoremap <silent> <buffer> <c-a> :<c-u>call macaw#increment_color(1)<cr>
    nnoremap <silent> <buffer> <c-x> :<c-u>call macaw#increment_color(-1)<cr>
    nnoremap <silent> <buffer> <c-t> :call Macaw_transpose()<cr>
    nnoremap <silent> <buffer> B :<c-u>call macaw#toggle_fg_bg()<cr>
    nnoremap <buffer> q :q!<cr>
endfunction

inoremap <expr> <F10> Interpolate(trim(system('grabc')))
nnoremap <silent> yc :call Macaw_picker(synID(line('.'), col('.'), 1))<cr>

augroup highlight_colors
    autocmd!
    autocmd ColorScheme * call s:highlight_colors()
augroup END

call s:highlight_colors()
