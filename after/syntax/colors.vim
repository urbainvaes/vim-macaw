for i in range(0, 255)
    if i < 10
        exe "syntax match Color".i." /".i."  /"
    elseif i < 100
        exe "syntax match Color".i." /".i." /"
    else
        exe "syntax match Color".i." /".i."/"
    endif
endfor
