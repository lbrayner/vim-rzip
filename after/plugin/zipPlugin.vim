augroup zip
 au!
 au BufReadCmd   zipfile:*	call zip#Read(expand("<amatch>"), 1)
 au FileReadCmd  zipfile:*	call zip#Read(expand("<amatch>"), 0)
 au BufWriteCmd  zipfile:*	call zip#Write(expand("<abuf>"))
 au FileWriteCmd zipfile:*	call zip#Write(expand("<abuf>"))

 if has("unix")
  au BufReadCmd   zipfile:*/*	call zip#Read(expand("<amatch>"), 1)
  au FileReadCmd  zipfile:*/*	call zip#Read(expand("<amatch>"), 0)
  au BufWriteCmd  zipfile:*/*	call zip#Write(expand("<abuf>"))
  au FileWriteCmd zipfile:*/*	call zip#Write(expand("<abuf>"))
 endif

 exe "au BufReadCmd ".g:zipPlugin_ext.' call zip#Browse(expand("<amatch>"))'
augroup END
