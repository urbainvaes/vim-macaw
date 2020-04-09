let s:color_file = expand("<sfile>:p:h")."/256.colors"

function! s:highlight_colors()
    for i in range(1, 255)
        exe "highlight vimHiNmbrFg".i." ctermfg=".i
        exe "highlight vimHiNmbrBg".i." ctermfg=black ctermbg=".i
    endfor

    for i in range(1, 255)
        exe "highlight Color".i." ctermbg=".i
    endfor
endfunction

augroup highlight_colors
    autocmd!
    autocmd ColorScheme * call s:highlight_colors()
augroup END

" https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim
function! SynGroup()
    let l:s = synID(line('.'), col('.'), 1)
    return [synIDattr(l:s, 'name'), synIDattr(synIDtrans(l:s), 'name')]
endfun

function! ColorPicker(...)
    let group = ""
    let color_file = expand("<sfile>:p:h")."/256.colors"
    if a:0 > 0
        let group = a:1
    endif
    exe "botright 27 vsplit" s:color_file
    setlocal filetype=colors number nospell buftype=nofile bufhidden=hide
          \ nobuflisted nowrap nomodifiable  nocursorline nofoldenable sidescrolloff=0
    exe "setlocal statusline=>\\ Group:\\ ".group
    " We want local `group` but remote `<cword>`, hence nested `exe`
    exe "nnoremap <buffer> <cr> :exe \"highlight ".group." ctermfg=\".expand(\"<cword>\")<cr>"
    nnoremap <buffer> q :q!<cr>
    " bdel
endfunction

nnoremap yc :call ColorPicker(SynGroup()[-1])<cr>
