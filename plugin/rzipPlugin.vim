if &cp || exists("g:loaded_rzipPlugin")
    finish
endif

if &shell !~# 'sh'
    if &shellslash
        echomsg "shellslash and a non-Unix shell do not play well together."
    endif
endif

let g:loaded_rzipPlugin="v27m-rzip"

if exists("g:loaded_zipPlugin")
    unlet g:loaded_zipPlugin
endif
let zipPlugindotvim = rzip#util#escapeFileName($VIMRUNTIME).'/plugin/zipPlugin.vim'
exec "source ".zipPlugindotvim
let g:loaded_zipPlugin="v27"

" {{{ g:zipPlugin_ext's original value
let g:zipPlugin_ext='*.apk,*.celzip,*.crtx,*.docm,*.docx,*.dotm,*.dotx,*.ear,*.epub,*.gcsx,*.glox,*.gqsx,*.ja,*.jar,*.kmz,*.oxt,*.potm,*.potx,*.ppam,*.ppsm,*.ppsx,*.pptm,*.pptx,*.sldx,*.thmx,*.vdw,*.war,*.wsz,*.xap,*.xlam,*.xlsb,*.xlsm,*.xlsx,*.xltm,*.xltx,*.xpi,*.zip,.*xlam'
" }}}

if exists("g:rzipPlugin_extra_ext")
    let g:zipPlugin_ext .= ','.g:rzipPlugin_extra_ext
endif

try
    let s:ext_list = split(substitute(g:zipPlugin_ext,'[,.*]\+',' ','g'),' ')
    exe 'let g:rzipPlugin_ext_dict = {' 
                \ . join(map(s:ext_list,'"\"".v:val."\""'),':"",') . ':""}'
catch
    unlet g:loaded_zipPlugin
    unlet g:loaded_rzipPlugin
    echoe "There was an error processing g:zipPlugin_ext and " 
                \ . "g:rzipPlugin_extra_ext: " . v:exception
    finish
endtry

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

" vim: fdm=marker
