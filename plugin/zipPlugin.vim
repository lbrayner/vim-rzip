let g:zipPlugin_ext_dict = {
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

if exists("g:zipPlugin_extra_ext")
    let g:zipPlugin_ext = g:zipPlugin_extra_ext
else
    let g:zipPlugin_ext = ""
endif

for key in keys(g:zipPlugin_ext_dict)
    let item = ',*.'.key
    if empty(g:zipPlugin_ext)
        let item = '*.'.key
    endif
    let g:zipPlugin_ext = g:zipPlugin_ext.item
endfor
