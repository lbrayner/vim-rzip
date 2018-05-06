if &cp || exists("g:loaded_rzipPlugin")
    finish
endif
let g:loaded_rzip= "v27m-rzip"

augroup zip
 au!
 au BufReadCmd   zipfile:*	call rzip#Read(expand("<amatch>"), 1)
 au FileReadCmd  zipfile:*	call rzip#Read(expand("<amatch>"), 0)
 au BufWriteCmd  zipfile:*	call rzip#Write(expand("<abuf>"))
 au FileWriteCmd zipfile:*	call rzip#Write(expand("<abuf>"))
 au BufEnter     *zipfile:*	sil exe "file ".expand('%:~:.')
    " countering a weird bug in gvim74-1024 for Windows

 if has("unix")
  au BufReadCmd   zipfile:*/*	call rzip#Read(expand("<amatch>"), 1)
  au FileReadCmd  zipfile:*/*	call rzip#Read(expand("<amatch>"), 0)
  au BufWriteCmd  zipfile:*/*	call rzip#Write(expand("<abuf>"))
  au FileWriteCmd zipfile:*/*	call rzip#Write(expand("<abuf>"))
  au BufEnter     *zipfile:*/*	sil exe "file ".expand('%:~:.')
 endif

 exe "au BufReadCmd ".g:zipPlugin_ext.' call rzip#Browse(expand("<amatch>"))'
augroup END
