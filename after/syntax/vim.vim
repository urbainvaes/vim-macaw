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

" Modification of default rule: vimHiCtermFg,vimHiCtermBg instead of vimHiCtermFgBg
syntax cluster vimHiCluster remove=vimHiCtermFgBg
syntax cluster vimHiCluster add=vimHiCtermFg,vimHiCtermBg

" Modification of default rule: @vimHiNmbrFgCluster,@vimHiNmbrBgCluster instead of vimHiNmbr
syntax match vimHiCtermFg /\cctermfg=/ contained nextgroup=@vimHiNmbrFgCluster,vimHiCtermColor,vimFgBgAttrib,vimHiCtermError
syntax match vimHiCtermBg /\cctermbg=/ contained nextgroup=@vimHiNmbrBgCluster,vimHiCtermColor,vimFgBgAttrib,vimHiCtermError
hi def link vimHiCtermFg vimHiCtermFgBg
hi def link vimHiCtermBg vimHiCtermFgBg

" Assemble syntax groups (z to appear at the end of completion list)
let syntax_groups_fg = "zVimHiNmbrFg1"
let syntax_groups_bg = "zVimHiNmbrBg1"
for i in range(2, 255)
 let syntax_groups_fg = syntax_groups_fg.",zVimHiNmbrFg".i
 let syntax_groups_bg = syntax_groups_bg.",zVimHiNmbrBg".i
endfor

exe "syntax cluster vimHiNmbrFgCluster contains=".syntax_groups_fg
exe "syntax cluster vimHiNmbrBgCluster contains=".syntax_groups_bg

for i in range(1, 255)
    exe "syntax match zVimHiNmbrFg".i." /".i."/ contained"
    exe "syntax match zVimHiNmbrBg".i." /".i."/ contained"
endfor
