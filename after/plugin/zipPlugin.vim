augroup zip
 au!
 au BufReadCmd   zipfile:*	call zip#Read(expand("<amatch>"), 1)
 au FileReadCmd  zipfile:*	call zip#Read(expand("<amatch>"), 0)
 au BufWriteCmd  zipfile:*	call zip#Write(expand("<abuf>"))
 au FileWriteCmd zipfile:*	call zip#Write(expand("<abuf>"))
 au BufEnter     *zipfile:*	exe "file ".expand('%:~:.')
    " countering a weird bug in gvim74-1024 for Windows

 if has("unix")
  au BufReadCmd   zipfile:*/*	call zip#Read(expand("<amatch>"), 1)
  au FileReadCmd  zipfile:*/*	call zip#Read(expand("<amatch>"), 0)
  au BufWriteCmd  zipfile:*/*	call zip#Write(expand("<abuf>"))
  au FileWriteCmd zipfile:*/*	call zip#Write(expand("<abuf>"))
  au BufEnter     *zipfile:*/*	exe "file ".expand('%:~:.')
 endif

 exe "au BufReadCmd ".g:zipPlugin_ext.' call zip#Browse(expand("<amatch>"))'
augroup END
