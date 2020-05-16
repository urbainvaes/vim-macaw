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

function! s:x2d(hex)
    return printf("%d", "0x".a:hex) + 0
endfunction

function! s:color_rgb(color)
    let [r, g, b] = [a:color[1:2], a:color[3:4], a:color[5:6]]
    return [s:x2d(r), s:x2d(g), s:x2d(b)]
endfunction

let s:colors_rgb = {}
for c in keys(g:macaw_colors)
    if c != "NONE"
        let s:colors_rgb[c] = s:color_rgb(g:macaw_colors[c])
    endif
endfor

let s:default_orientation = 'vertical'
let s:default_command_vertical = 'vert botright 23 split'
let s:default_command_horizontal = 'topleft 6 split'

let s:path = expand("<sfile>:p:h")
let s:tweaks = {}

" Should we reset fg_or_bg on group change?
let s:state = {
            \ 'help_shown': 0,
            \ 'buf_nr': -1,
            \ 'transposed': 0,
            \ 'syn_id': '',
            \ 'fg_or_bg': 'fg',
            \ 'id_or_eid': 'eid',
            \ 'rgb': 'r',
            \ }

" Private functions {{{1
function! s:syn_eid()
    return synIDtrans(s:state['syn_id'])
endfunction

function! s:syn_id_or_eid()
    if s:state['id_or_eid'] == 'id'
        return s:state['syn_id']
    else
        return s:syn_eid()
    endif
endfunction

function! s:color_nr()
    " Alternative synIDattr(s:syn_eid(), s:state['fg_or_bg'], 'cterm')
    let color_nr = synIDattr(s:syn_eid(), s:state['fg_or_bg'])
    let color_nr = color_nr =~ "^#" ? s:approximate(color_nr) : color_nr
    if color_nr == ""
        let background = synIDattr(hlID("Normal"), 'bg')
        let color_nr = s:state['fg_or_bg'] == "fg" ? 255 : background
    endif
    return color_nr
endfunction

function! s:highlight(color, ...)
    let color = a:color =~ "^#" ? s:approximate(a:color) : a:color
    let color_group = synIDattr(s:syn_id_or_eid(), 'name')
    let fg_or_bg = s:state['fg_or_bg']
    if !has_key(s:tweaks, color_group)
        let s:tweaks[color_group] = {}
    endif
    exe "highlight ".color_group." cterm".fg_or_bg."=".color
    let s:tweaks[color_group]['cterm'.fg_or_bg] = color
    " Looks convoluted but in vim str('h') == 'h' is false
    if (type(color) != 1 ? string(color) : color) == "NONE" || color > 15
        let gui_color = g:macaw_colors[color]
        let s:tweaks[color_group]['gui'.fg_or_bg] = gui_color
        exe "highlight ".color_group." gui".fg_or_bg."=".gui_color
    endif
    if get(a:, 1, 1)
        call search('\<'.color.'\>', "w")
    endif
    let @h = macaw#write()
    call s:echo_rgb()
endfunction

function! s:redraw_status_line()
    let color_group = synIDattr(s:syn_id_or_eid(), 'name')
    let rgb = s:state['rgb']
    let rgb_line = ((rgb == 'r') ? 'R' : 'r').((rgb == 'g') ? 'G' : 'g').((rgb == 'b') ? 'B' : 'b')
    exe 'setlocal statusline='.color_group.'/'.s:state['fg_or_bg'].'\ ['.rgb_line.']'
endfunction

function! s:redraw()
    let plugin_opened = buffer_exists(s:state['buf_nr'])
    let plugin_window = bufwinnr(s:state['buf_nr'])
    let plugin_visible = plugin_window != -1

    if plugin_opened && !plugin_visible
        exe 'bwipeout' s:state['buf_nr']
    endif

    if !plugin_visible
        call s:open()
        call s:map_keys()
    else
        exe plugin_window . 'wincmd w'
    endif
    call search('\<'.s:color_nr().'\>', "w")
    call s:redraw_status_line()
endfunction

function! s:open()
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

    silent exe split_command color_file
    let s:state['buf_nr'] = bufnr('%')

    setlocal filetype=colors mouse=n
    call s:set_buf_options()

    if !s:state['help_shown']
        echon "Press '"
        echohl Special
        echon "g?"
        echohl NONE
        echon "' to show mappings. The highlight commands will be copied to register '"
        echohl Special
        echon "h"
        echohl NONE
        echon "'. Happy hacking!"
        let s:state['help_shown'] = 1
    endif
endfunction

function! s:map_keys()
    nnoremap <silent> <buffer> <2-leftmouse> :<c-u>call <SID>set_color_at_cursor()<cr>
    nnoremap <silent> <buffer> <cr> :<c-u>call <SID>set_color_at_cursor()<cr>
    nnoremap <silent> <buffer> <c-a> :<c-u>call <SID>increment_color(1)<cr>
    nnoremap <silent> <buffer> <c-x> :<c-u>call <SID>increment_color(-1)<cr>
    nnoremap <silent> <buffer> <right> :<c-u>call <SID>cycle_rgb(1)<cr>
    nnoremap <silent> <buffer> <left> :<c-u>call <SID>cycle_rgb(-1)<cr>
    nnoremap <silent> <buffer> <up> :<c-u>call <SID>rgb(1)<cr>
    nnoremap <silent> <buffer> <down> :<c-u>call <SID>rgb(-1)<cr>
    nnoremap <silent> <buffer> <bs> :<c-u>call <SID>highlight("NONE", 0)<cr>
    nnoremap <silent> <buffer> T :<c-u> call <SID>transpose()<cr>
    nnoremap <silent> <buffer> B :<c-u>call <SID>toggle_fg_bg()<cr>
    nnoremap <silent> <buffer> I :<c-u>call <SID>toggle_id_or_eid()<cr>
    nnoremap <silent> <buffer> R :<c-u>call <SID>rotate_rgb()<cr>
    nnoremap <silent> <buffer> ! :call <SID>external()<cr>
    nnoremap <silent> <buffer> - :call <SID>select_group()<cr>
    nnoremap <silent> <buffer> g? :help macaw-mappings<cr>
    nnoremap <silent> <buffer> q :q!<cr>
endfunction

function! s:echo_rgb()
    let c = 41
    exe "hi Macaw_output ctermfg=".c." guifg=".g:macaw_colors[c]
    if s:color_nr() < 16 | return | endif
    let current_rgb = s:colors_rgb[s:color_nr()]
    echon '['
    for i in [0, 1, 2]
        if ['r', 'g', 'b'][i] == s:state['rgb']
            echohl Macaw_output
            echon current_rgb[i]
            echohl NONE
        else
            echon current_rgb[i]
        endif
        if i < 2
            echon ', '
        endif
    endfor
    echon ']'
endfunction

function! s:set_buf_options()
    setlocal nonumber nospell buftype=nofile bufhidden=hide nobuflisted
                \ nowrap nomodifiable nocursorline nocursorcolumn
                \ nofoldenable sidescrolloff=0 noequalalways noswapfile
endfunction

function! s:transpose()
    if bufwinnr(s:state['buf_nr']) == -1
        return
    endif
    exe 'bwipeout' s:state['buf_nr']
    let s:state['transposed'] = !s:state['transposed']
    call s:redraw()
endfunction

function! s:cycle_rgb(dir)
    let current = {'r': 0, 'g': 1, 'b': 2}[s:state['rgb']]
    let new_rgb = (current + a:dir) % 3
    let s:state['rgb'] = ['r', 'g', 'b'][new_rgb]
    call s:redraw_status_line()
    call s:echo_rgb()
endfunction

function! s:rotate_rgb()
    let color_nr = s:color_nr()
    if !has_key(s:colors_rgb, color_nr)
        " This should not happen
        echom "Macaw: unknown color number…"
        return
    endif
    let color = s:colors_rgb[color_nr]
    let new_color = s:approximate([color[1], color[2], color[0]])
    call s:highlight(new_color)
endfunction

function! s:rgb(increment)
    let color_nr = s:color_nr()
    if color_nr < 16
        echom "This works only for colors ≥ 16..."
        return
    endif
    let color = g:macaw_colors[color_nr]
    let color = [s:x2d(color[1:2]), s:x2d(color[3:4]), s:x2d(color[5:6])]
    let index_rgb = {'r': 0, 'g': 1, 'b': 2}[s:state['rgb']]
    while s:approximate(color) == color_nr
        let newcolor = color[index_rgb] + a:increment
        if newcolor < 0 || newcolor > 255 | return | endif
        let color[index_rgb] = newcolor
    endwhile
    call s:highlight(s:approximate(color))
endfunction

function! s:increment_color(number)
    let increment = v:count1 * a:number
    let newcolor = (s:color_nr() + increment) % 256
    if newcolor < 0 | let newcolor += 256 | endif
    call s:highlight(newcolor)
endfunction

function! s:set_color_at_cursor()
    let cursor_syn_eid = synIDtrans(synID(line('.'), col('.'), 1))
    let cursor_color = synIDattr(cursor_syn_eid, 'bg', 'cterm')
    if cursor_color == ''
        echom "Click on a color..."
        return
    endif
    call s:highlight(cursor_color, 0)
endfunction

function! s:toggle_fg_bg()
    let s:state['fg_or_bg'] = s:state['fg_or_bg'] == 'fg' ? 'bg' : 'fg'
    call s:redraw()
endfunction

function! s:toggle_id_or_eid()
    let s:state['id_or_eid'] = s:state['id_or_eid'] == 'id' ? 'eid' : 'id'
    call s:redraw_status_line()
endfunction

function! s:help()
    " Unclear why this fix works...
    let winrestcmd = substitute(winrestcmd(), "|", "<bar>", "g")
    if winwidth('.') < 34
        vertical resize 34
    endif
    if winheight('.') < 14
        resize 14
    endif
    exe "edit ".s:path."/macaw.mappings"
    setlocal filetype=mappings
    call s:set_buf_options()
    exe 'nmap <silent> <buffer> q :buffer #<cr>:bdelete #<cr>:'.winrestcmd.'<cr>'
    setlocal statusline=q:\ leave
endfunction

function! s:close_select_group(change_group)
    let group = expand("<cword>")
    buffer # | bdelete #
    if a:change_group
        let s:state.syn_id = hlID(group)
        call s:redraw()
    endif
endfunction

function! s:select_group()
    exe "edit ".s:path."/core.syngroups"
    call s:set_buf_options()
    setlocal filetype=syngroups keywordprg=:help
    setlocal statusline=<cr>:\ select,\ K:\ help
    nnoremap <silent> <buffer> q :call <SID>close_select_group(0)<cr>
    nnoremap <silent> <buffer> <cr> :call <SID>close_select_group(1)<cr>
endfunction

function! s:approximate(color)
    let [r, g, b] = type(a:color) == 1 ? s:color_rgb(a:color) : a:color
    let [argmin, min] = [-1, 256*3]
    for i in range(16, 255)
        let [ri, gi, bi] = s:colors_rgb[i]
        let norm = abs(ri - r) + abs(gi - g) + abs(bi - b)
        if norm < min
            let [argmin, min] = [i, norm]
        endif
    endfor
    return argmin
endfunction

function! s:external()
    let color = s:approximate(trim(system('grabc')))
    call s:highlight(color)
endfunction

function! s:pick_color(syn_id, fg_or_bg)
    let syn_id = type(a:syn_id) == 1 ? hlID(a:syn_id) : a:syn_id
    if synIDattr(synIDtrans(syn_id), "name", "cterm") == ""
        call s:pick_color("Normal", "bg")
        return
    endif
    let s:state['syn_id'] = syn_id
    let s:state['fg_or_bg'] = a:fg_or_bg
    call s:redraw()
endfunction

" Public functions {{{1
function! macaw#macaw(...)
    if a:0 == 0 || a:1 == ""
        let syn_id = synID(line('.'), col('.'), 1)
    else
        let syn_id = a:1
    endif
    let fg_or_bg = get(a:, 2, "fg")
    call s:pick_color(syn_id, fg_or_bg)
endfunction

function! macaw#write()
    let output = ""
    for [group, rules] in items(s:tweaks)
        let output = output."highlight ".group
        for [cterm_fgbg, color] in items(rules)
            let output = output." ".cterm_fgbg."=".color
        endfor
        let output = output."\n"
    endfor
    return output
endfunction

function! macaw#rotate()
    let s:tweaks = {} | let @h = ""
    for group in g:macaw_groups
        let syn_id = hlID(group)
        let syn_eid = synIDtrans(syn_id)
        if syn_id != syn_eid
            continue
        endif
        " cterm
        let fg_nr = synIDattr(syn_eid, 'fg')
        let bg_nr = synIDattr(syn_eid, 'bg')
        if has_key(s:colors_rgb, fg_nr)
            let fg = s:colors_rgb[fg_nr]
            let newfg = s:approximate([fg[1], fg[2], fg[0]])
            exe "highlight ".group." ctermfg=".newfg
        endif
        if has_key(s:colors_rgb, bg_nr)
            let bg = s:colors_rgb[bg_nr]
            let newbg = s:approximate([bg[1], bg[2], bg[0]])
            exe "highlight ".group." ctermbg=".newbg
        endif
        " Gui
        if fg_nr =~ "^#"
            let fg = s:color_rgb(fg_nr)
            let newfg = printf("#%02x%02x%02x", fg[1], fg[2], fg[0])
            exe "highlight ".group." guifg=".newfg
        endif
        if bg_nr =~ "^#"
            let bg = s:color_rgb(bg_nr)
            let newbg = printf("#%02x%02x%02x", bg[1], bg[2], bg[0])
            exe "highlight ".group." guibg=".newbg
        endif
    endfor
endfunction
