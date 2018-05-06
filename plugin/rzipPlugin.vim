if &cp || exists("g:loaded_rzipPlugin")
    finish
endif
let g:loaded_rzip= "v27m-rzip"

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

if exists("g:rzipPlugin_extra_ext")
    let g:zipPlugin_ext = g:rzipPlugin_extra_ext
else
    let g:zipPlugin_ext = ""
endif

for key in keys(g:rzipPlugin_ext_dict)
    let item = ',*.'.key
    if empty(g:zipPlugin_ext)
        let item = '*.'.key
    endif
    let g:zipPlugin_ext = g:zipPlugin_ext.item
endfor

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
