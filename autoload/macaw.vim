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

let s:colors =
        \{ 16:  '#000000',  17: '#00005f',  18: '#000087',  19: '#0000af',
        \  20:  '#0000d7',  21: '#0000ff',  22: '#005f00',  23: '#005f5f',
        \  24:  '#005f87',  25: '#005faf',  26: '#005fd7',  27: '#005fff',
        \  28:  '#008700',  29: '#00875f',  30: '#008787',  31: '#0087af',
        \  32:  '#0087d7',  33: '#0087ff',  34: '#00af00',  35: '#00af5f',
        \  36:  '#00af87',  37: '#00afaf',  38: '#00afd7',  39: '#00afff',
        \  40:  '#00d700',  41: '#00d75f',  42: '#00d787',  43: '#00d7af',
        \  44:  '#00d7d7',  45: '#00d7ff',  46: '#00ff00',  47: '#00ff5f',
        \  48:  '#00ff87',  49: '#00ffaf',  50: '#00ffd7',  51: '#00ffff',
        \  52:  '#5f0000',  53: '#5f005f',  54: '#5f0087',  55: '#5f00af',
        \  56:  '#5f00d7',  57: '#5f00ff',  58: '#5f5f00',  59: '#5f5f5f',
        \  60:  '#5f5f87',  61: '#5f5faf',  62: '#5f5fd7',  63: '#5f5fff',
        \  64:  '#5f8700',  65: '#5f875f',  66: '#5f8787',  67: '#5f87af',
        \  68:  '#5f87d7',  69: '#5f87ff',  70: '#5faf00',  71: '#5faf5f',
        \  72:  '#5faf87',  73: '#5fafaf',  74: '#5fafd7',  75: '#5fafff',
        \  76:  '#5fd700',  77: '#5fd75f',  78: '#5fd787',  79: '#5fd7af',
        \  80:  '#5fd7d7',  81: '#5fd7ff',  82: '#5fff00',  83: '#5fff5f',
        \  84:  '#5fff87',  85: '#5fffaf',  86: '#5fffd7',  87: '#5fffff',
        \  88:  '#870000',  89: '#87005f',  90: '#870087',  91: '#8700af',
        \  92:  '#8700d7',  93: '#8700ff',  94: '#875f00',  95: '#875f5f',
        \  96:  '#875f87',  97: '#875faf',  98: '#875fd7',  99: '#875fff',
        \  100: '#878700', 101: '#87875f', 102: '#878787', 103: '#8787af',
        \  104: '#8787d7', 105: '#8787ff', 106: '#87af00', 107: '#87af5f',
        \  108: '#87af87', 109: '#87afaf', 110: '#87afd7', 111: '#87afff',
        \  112: '#87d700', 113: '#87d75f', 114: '#87d787', 115: '#87d7af',
        \  116: '#87d7d7', 117: '#87d7ff', 118: '#87ff00', 119: '#87ff5f',
        \  120: '#87ff87', 121: '#87ffaf', 122: '#87ffd7', 123: '#87ffff',
        \  124: '#af0000', 125: '#af005f', 126: '#af0087', 127: '#af00af',
        \  128: '#af00d7', 129: '#af00ff', 130: '#af5f00', 131: '#af5f5f',
        \  132: '#af5f87', 133: '#af5faf', 134: '#af5fd7', 135: '#af5fff',
        \  136: '#af8700', 137: '#af875f', 138: '#af8787', 139: '#af87af',
        \  140: '#af87d7', 141: '#af87ff', 142: '#afaf00', 143: '#afaf5f',
        \  144: '#afaf87', 145: '#afafaf', 146: '#afafd7', 147: '#afafff',
        \  148: '#afd700', 149: '#afd75f', 150: '#afd787', 151: '#afd7af',
        \  152: '#afd7d7', 153: '#afd7ff', 154: '#afff00', 155: '#afff5f',
        \  156: '#afff87', 157: '#afffaf', 158: '#afffd7', 159: '#afffff',
        \  160: '#d70000', 161: '#d7005f', 162: '#d70087', 163: '#d700af',
        \  164: '#d700d7', 165: '#d700ff', 166: '#d75f00', 167: '#d75f5f',
        \  168: '#d75f87', 169: '#d75faf', 170: '#d75fd7', 171: '#d75fff',
        \  172: '#d78700', 173: '#d7875f', 174: '#d78787', 175: '#d787af',
        \  176: '#d787d7', 177: '#d787ff', 178: '#d7af00', 179: '#d7af5f',
        \  180: '#d7af87', 181: '#d7afaf', 182: '#d7afd7', 183: '#d7afff',
        \  184: '#d7d700', 185: '#d7d75f', 186: '#d7d787', 187: '#d7d7af',
        \  188: '#d7d7d7', 189: '#d7d7ff', 190: '#d7ff00', 191: '#d7ff5f',
        \  192: '#d7ff87', 193: '#d7ffaf', 194: '#d7ffd7', 195: '#d7ffff',
        \  196: '#ff0000', 197: '#ff005f', 198: '#ff0087', 199: '#ff00af',
        \  200: '#ff00d7', 201: '#ff00ff', 202: '#ff5f00', 203: '#ff5f5f',
        \  204: '#ff5f87', 205: '#ff5faf', 206: '#ff5fd7', 207: '#ff5fff',
        \  208: '#ff8700', 209: '#ff875f', 210: '#ff8787', 211: '#ff87af',
        \  212: '#ff87d7', 213: '#ff87ff', 214: '#ffaf00', 215: '#ffaf5f',
        \  216: '#ffaf87', 217: '#ffafaf', 218: '#ffafd7', 219: '#ffafff',
        \  220: '#ffd700', 221: '#ffd75f', 222: '#ffd787', 223: '#ffd7af',
        \  224: '#ffd7d7', 225: '#ffd7ff', 226: '#ffff00', 227: '#ffff5f',
        \  228: '#ffff87', 229: '#ffffaf', 230: '#ffffd7', 231: '#ffffff',
        \  232: '#080808', 233: '#121212', 234: '#1c1c1c', 235: '#262626',
        \  236: '#303030', 237: '#3a3a3a', 238: '#444444', 239: '#4e4e4e',
        \  240: '#585858', 241: '#626262', 242: '#6c6c6c', 243: '#767676',
        \  244: '#808080', 245: '#8a8a8a', 246: '#949494', 247: '#9e9e9e',
        \  248: '#a8a8a8', 249: '#b2b2b2', 250: '#bcbcbc', 251: '#c6c6c6',
        \  252: '#d0d0d0', 253: '#dadada', 254: '#e4e4e4', 255: '#eeeeee' }

function! s:x2d(hex)
    return printf("%d", "0x".a:hex) + 0
endfunction

function! s:color_rgb(color)
    let [r, g, b] = [a:color[1:2], a:color[3:4], a:color[5:6]]
    return [s:x2d(r), s:x2d(g), s:x2d(b)]
endfunction

let s:colors_rgb = {}
for c in keys(s:colors)
    let s:colors_rgb[c] = s:color_rgb(s:colors[c])
endfor

let s:default_orientation = 'vertical'
let s:default_command_vertical = 'vert botright 23 split'
let s:default_command_horizontal = 'topleft 6 split'

let s:path = expand("<sfile>:p:h")
let s:state = {
            \ 'help_shown': 0,
            \ 'buf_nr': -1,
            \ 'transposed': 0,
            \ 'syn_id': '',
            \ 'fg_or_bg': 'fg',
            \ 'rgb': 'r',
            \ }

" Private functions {{{1
function! s:syn_eid()
    return synIDtrans(s:state['syn_id'])
endfunction

function! s:color_nr()
    let color_nr = synIDattr(s:syn_eid(), s:state['fg_or_bg'])
    if color_nr == ""
        let background = synIDattr(hlID("Normal"), 'bg')
        let color_nr = s:state['fg_or_bg'] == "fg" ? 255 : background
    endif
    return color_nr
endfunction

function! s:highlight(color, ...)
    let color_group = synIDattr(s:syn_eid(), 'name')
    let command = "highlight ".color_group." cterm".s:state['fg_or_bg']."=".a:color
    exe command | let @c = command
    if get(a:, 1, 1)
        call search('\<'.a:color.'\>', "w")
    endif
endfunction

function! s:redraw_status_line()
    let color_group = synIDattr(s:syn_eid(), 'name')
    let rgb = s:state['rgb']
    let rgb_line = ((rgb == 'r') ? 'R' : 'r').((rgb == 'g') ? 'G' : 'g').((rgb == 'b') ? 'B' : 'b')
    exe 'setlocal statusline=>\ '.color_group.'/'.s:state['fg_or_bg'].'\ ['.rgb_line.']'
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

    exe split_command color_file
    let s:state['buf_nr'] = bufnr()

    setlocal filetype=colors 
    call s:set_buf_options()

    if !s:state['help_shown']
        echom "Press 'g?' to show Macaw mappings"
        let s:state['help_shown'] = 1
    endif
endfunction

function! s:map_keys()
    nnoremap <silent> <buffer> <2-leftmouse> :<c-u>call macaw#set_color_at_cursor()<cr>
    nnoremap <silent> <buffer> <cr> :<c-u>call macaw#set_color_at_cursor()<cr>
    nnoremap <silent> <buffer> <c-a> :<c-u>call macaw#increment_color(1)<cr>
    nnoremap <silent> <buffer> <c-x> :<c-u>call macaw#increment_color(-1)<cr>
    nnoremap <silent> <buffer> T :call macaw#transpose()<cr>
    nnoremap <silent> <buffer> B :<c-u>call macaw#toggle_fg_bg()<cr>
    nnoremap <silent> <buffer> <up> :<c-u>call macaw#rgb(1)<cr>
    nnoremap <silent> <buffer> <down> :<c-u>call macaw#rgb(-1)<cr>
    nnoremap <silent> <buffer> <right> :<c-u>call macaw#cycle_rgb(1)<cr>
    nnoremap <silent> <buffer> <left> :<c-u>call macaw#cycle_rgb(-1)<cr>
    nnoremap <silent> <buffer> g? :call macaw#help()<cr>
    nnoremap <silent> <buffer> q :q!<cr>
endfunction

function! s:echo_rgb()
    syntax keyword Macaw_output this_should_never_match
    hi Macaw_ouput ctermfg=41
    let current_rgb = s:colors_rgb[s:color_nr()]
    echon '['
    for i in [0, 1, 2]
        if ['r', 'g', 'b'][i] == s:state['rgb']
            echohl Macaw_ouput
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
                \ nofoldenable sidescrolloff=0 noequalalways
endfunction

" Public functions {{{1
function! macaw#transpose()
    if bufwinnr(s:state['buf_nr']) == -1
        return
    endif
    exe 'bwipeout' s:state['buf_nr']
    let s:state['transposed'] = !s:state['transposed']
    call s:redraw()
endfunction

function! macaw#cycle_rgb(dir)
    let current = {'r': 0, 'g': 1, 'b': 2}[s:state['rgb']]
    let new_rgb = (current + a:dir) % 3
    let s:state['rgb'] = ['r', 'g', 'b'][new_rgb]
    call s:redraw_status_line()
    call s:echo_rgb()
endfunction

function! macaw#rgb(increment)
    let color_nr = s:color_nr()
    if color_nr < 16
        echom "This works only for colors ≥ 16..."
        return
    endif
    let color = s:colors[color_nr]
    let color = [s:x2d(color[1:2]), s:x2d(color[3:4]), s:x2d(color[5:6])]
    let index_rgb = {'r': 0, 'g': 1, 'b': 2}[s:state['rgb']]
    let increment = v:count1 * a:increment
    while macaw#interpolate(color) == color_nr
        let newcolor = color[index_rgb] + increment
        if newcolor < 0 || newcolor > 255 | return | endif
        let color[index_rgb] = newcolor
    endwhile
    call s:highlight(macaw#interpolate(color))
    call s:echo_rgb()
endfunction

function! macaw#increment_color(number)
    let increment = v:count1 * a:number
    let newcolor = (s:color_nr() + increment) % 256
    if newcolor < 0 | let newcolor += 256 | endif
    call s:highlight(newcolor)
endfunction

function! macaw#set_color_at_cursor()
    let color_group = synIDattr(s:syn_eid(), 'name')
    let cursor_syn_eid = synIDtrans(synID(line('.'), col('.'), 1))
    let cursor_color = synIDattr(cursor_syn_eid, 'bg')
    if cursor_color == ''
        echom "Click on a color..."
        return
    endif
    call s:highlight(cursor_color, 0)
endfunction

function! macaw#toggle_fg_bg()
    let s:state['fg_or_bg'] = s:state['fg_or_bg'] == 'fg' ? 'bg' : 'fg'
    call macaw#pick_color(s:state['syn_id'])
endfunction

function! macaw#help()
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
    setlocal statusline=>\ Press\ 'q'\ to\ leave
endfunction

function! macaw#pick_color(syn_id, ...)
    let s:state['fg_or_bg'] = get(a:, 1, s:state['fg_or_bg'])
    let s:state['syn_id'] = type(a:syn_id) == 1 ? hlID(a:syn_id) : a:syn_id
    call s:redraw()
endfunction

function! macaw#interpolate(color)
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
