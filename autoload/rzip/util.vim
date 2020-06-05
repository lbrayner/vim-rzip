function! rzip#util#vimmap(leftside,keyseq,keyseqtarget)
    if ! hasmapto(a:keyseqtarget)
        exec a:leftside." "a:keyseq." "a:keyseqtarget
    endif
endfunction

function! rzip#util#escapeFileName(filename)
    return substitute(a:filename, '\', '/', 'g')
endfunction
