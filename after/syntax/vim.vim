" Modification of default rule: vimHiCtermFg,vimHiCtermBg instead of vimHiCtermFgBg
syntax cluster vimHiCluster remove=vimHiCtermFgBg
syntax cluster vimHiCluster add=vimHiCtermFg,vimHiCtermBg

" Modification of default rule: @vimHiNmbrFgCluster,@vimHiNmbrBgCluster instead of vimHiNmbr
syntax match vimHiCtermFg /\cctermfg=/ contained nextgroup=@vimHiNmbrFgCluster,vimHiCtermColor,vimFgBgAttrib,vimHiCtermError
syntax match vimHiCtermBg /\cctermbg=/ contained nextgroup=@vimHiNmbrBgCluster,vimHiCtermColor,vimFgBgAttrib,vimHiCtermError
hi def link vimHiCtermFg vimHiCtermFgBg
hi def link vimHiCtermBg vimHiCtermFgBg

" Assemble syntax groups
let syntax_groups_fg = "vimHiNmbrFg1"
let syntax_groups_bg = "vimHiNmbrBg1"
for i in range(2, 255)
 let syntax_groups_fg = syntax_groups_fg.",vimHiNmbrFg".i
 let syntax_groups_bg = syntax_groups_bg.",vimHiNmbrBg".i
endfor

exe "syntax cluster vimHiNmbrFgCluster contains=".syntax_groups_fg
exe "syntax cluster vimHiNmbrBgCluster contains=".syntax_groups_bg

for i in range(1, 255)
    exe "syntax match vimHiNmbrFg".i." /".i."/ contained"
    exe "syntax match vimHiNmbrBg".i." /".i."/ contained"
endfor
