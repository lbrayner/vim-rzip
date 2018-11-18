if &cp || exists("g:loaded_rzipPlugin")
    finish
endif

if &shell !~# 'sh'
    if &shellslash
        echomsg "shellslash and a non-Unix shell do not play well together."
    endif
endif

let g:loaded_rzip="v27m-rzip"

if exists("g:loaded_zip")
    unlet g:loaded_zip
endif
let zipPlugindotvim = rzip#util#escapeFileName($VIMRUNTIME).'/plugin/zipPlugin.vim'
exec "source ".zipPlugindotvim
let g:loaded_zip=1

let g:rzipPlugin_ext_dict = {
            \ 'apk': '','celzip': '','crtx': '','docm': '',
            \ 'docx': '','dotm': '','dotx': '','ear': '',
            \ 'epub': '','gcsx': '','glox': '','gqsx': '',
            \ 'ja': '','jar': '','kmz': '','oxt': '',
            \ 'potm': '','potx': '','ppam': '','ppsm': '',
            \ 'ppsx': '','pptm': '','pptx': '','sldx': '',
            \ 'thmx': '','vdw': '','war': '','wsz': '',
            \ 'xap': '','xlam': '','xlsb': '',
            \ 'xlsm': '','xlsx': '','xltm': '','xltx': '',
            \ 'xpi': '','zip': ''
            \ } " duplicate entry xlam removed

let g:zipPlugin_ext = join(keys(g:rzipPlugin_ext_dict),',*.')
let g:zipPlugin_ext = '*.'.g:zipPlugin_ext

if exists("g:rzipPlugin_extra_ext")
    let g:zipPlugin_ext .= ','.g:rzipPlugin_extra_ext
endif

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
