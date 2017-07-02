let zipdotvim = rzip#util#escapeFileName($VIMRUNTIME).'/autoload/zip.vim'

exec "source ".zipdotvim

let s:zipfile_escape = ' ?&;\'
let s:ERROR          = 2
let s:WARNING        = 1
let s:NOTE           = 0

fun! s:Rmdir(fname)
  if (has("win32") || has("win95") || has("win64") || has("win16")) && &shell !~? 'sh$'
   call system("rmdir /S/Q ".s:Escape(a:fname,0))
  else
   call system("/bin/rm -rf ".s:Escape(a:fname,0))
  endif
endfun

fun! s:Escape(fname,isfilt)
  if exists("*shellescape")
   if a:isfilt
    let qnameq= shellescape(a:fname,1)
   else
    let qnameq= shellescape(a:fname)
   endif
  else
   let qnameq= g:zip_shq.escape(a:fname,g:zip_shq).g:zip_shq
  endif
  return qnameq
endfun

fun! zip#Read(fname,mode)
  let repkeep= &report
  set report=10

  let fname = g:GetFileName(a:fname)
  if fname =~# "::"
      let zipfile = getbufvar("#","zipfile","")
      let fname = substitute(fname,'.*::\(.*\)','\1',"")
  else
      let zipfile = g:GetZipFile(a:fname)
  endif
  if !executable(substitute(g:zip_unzipcmd,'\s\+.*$','',''))
   redraw!
   echohl Error | echo "***error*** (zip#Read) sorry, your system doesn't appear to have the ".g:zip_unzipcmd." program" | echohl None
   let &report= repkeep
   return
  endif

  let extension   = fnamemodify(fname,':e')
  if has_key(g:zipPlugin_ext_dict,extension)
      return v:null  " let zip#Browse (triggered by an autocmd) handle the nested zip file
  endif
  let temp = tempname()
  let fn   = expand('%:p')
  exe "sil! !".g:zip_unzipcmd." -p -- ".s:Escape(zipfile,1)." ".s:Escape(fnameescape(fname),1).' > '.temp
  sil exe 'keepalt file '.temp
  sil keepj e!
  sil exe 'keepalt file '.fnameescape(fn)
  call delete(temp)

  filetype detect

  set nomod

  let &report= repkeep
endfun

function! g:GetZipFile(fname)
  if has("unix")
   let zipfile = substitute(a:fname,'zipfile:\(.\{-}\)::[^\\].*$','\1','')
  else
   let zipfile = substitute(a:fname,'^.\{-}zipfile:\(.\{-}\)::[^\\].*$','\1','')
  endif
  return zipfile
endfunction

function! g:GetFileName(fname)
  if has("unix")
   let fname   = substitute(a:fname,'zipfile:.\{-}::\([^\\].*\)$','\1','')
  else
   let fname   = substitute(a:fname,'^.\{-}zipfile:.\{-}::\([^\\].*\)$','\1','')
   let fname   = substitute(fname, '[', '[[]', 'g')
  endif
  return fname
endfunction


function! g:MakeZipPattern(zipfile,fname)
  return "zipfile:".a:zipfile.'::'.a:fname
endfunction

fun! s:ZipBrowseSelect(zipfname)
  let repkeep= &report
  set report=10
  let fname= getline(".")

  if fname =~ '^"'
   let &report= repkeep
   return
  endif
  if fname =~ '/$'
   redraw!
   echohl Error | echo "***error*** (zip#Browse) Please specify a file, not a directory" | echohl None
   let &report= repkeep
   return
  endif

  let zipfile = b:zipfile
  let curfile= expand("%")

  new
  if !exists("g:zip_nomax") || g:zip_nomax == 0
   wincmd _
  endif
  let s:zipfile_{winnr()}= curfile
  let zipfname = a:zipfname
  if(zipfname =~# 'zipfile:')
      exe "keepalt e ".fnameescape(zipfname.'::'.fname)
  else
      exe "e ".fnameescape("zipfile:".zipfile.'::'.fname)
  endif
  filetype detect

  let &report= repkeep
endfun

function! g:GetNestedZipFile(zipfile)
    let head = g:GetZipFile(a:zipfile)
    let ziplist = split(a:zipfile,'::')[1:]
    let ziplist = insert(ziplist,head)
    let index = 1
    unlet! l:container
    while index < len(ziplist)
        if !exists("l:container")
            let container = ziplist[index-1]
        else
            let container = temp
        endif
        let temp = tempname()
        let target = ziplist[index]
        exe "sil! !".g:zip_unzipcmd." -p -- ".s:Escape(container,1)." "
                    \ .s:Escape(fnameescape(target),1).' > '.temp
        if index > 1
            call delete(container)
        endif
        let index = index + 1
    endwhile
    return temp
endfunction

fun! s:ChgDir(newdir,errlvl,errmsg)
  try
   exe "cd ".fnameescape(a:newdir)
  catch /^Vim\%((\a\+)\)\=:E344/
   redraw!
   if a:errlvl == s:NOTE
    echo "***note*** ".a:errmsg
   elseif a:errlvl == s:WARNING
    echohl WarningMsg | echo "***warning*** ".a:errmsg | echohl NONE
   elseif a:errlvl == s:ERROR
    echohl Error | echo "***error*** ".a:errmsg | echohl NONE
   endif
   return 1
  endtry

  return 0
endfun

fun! zip#Browse(zipfile)
    let zipfile = a:zipfile
  if !filereadable(zipfile) || readfile(zipfile, "", 1)[0] !~ '^PK'
        if !filereadable(g:GetZipFile(zipfile))
            exe "noautocmd e ".fnameescape(zipfile)
            return
        else
            let head = g:GetZipFile(zipfile)
            let tail = g:GetFileName(zipfile)
            let zipfilename = g:MakeZipPattern(head,tail)
            let zipdelete = 1
            let zipfile = g:GetNestedZipFile(zipfile)
        endif
  else
        let zipfilename = zipfile
  endif

  let repkeep= &report
  set report=10

  if !exists("*fnameescape")
   if &verbose > 1
    echoerr "the zip plugin is not available (your vim doens't support fnameescape())"
   endif
   return
  endif
  if !executable(g:zip_unzipcmd)
   redraw!
   echohl Error | echo "***error*** (zip#Browse) unzip not available on your system"
   let &report= repkeep
   return
  endif
  if !filereadable(zipfile)
   if zipfile !~# '^\a\+://'
    redraw!
    echohl Error | echo "***error*** (zip#Browse) File not readable<".zipfile.">" | echohl None
   endif
   let &report= repkeep
   return
  endif
  if &ma != 1
   set ma
  endif
  let b:zipfile= zipfile

  setlocal noswapfile
  setlocal buftype=nofile
  setlocal bufhidden=hide
  setlocal nobuflisted
  setlocal nowrap
  set ft=tar

  call append(0, ['" zip.vim version '.g:loaded_zip,
 \                '" Browsing zipfile '.zipfilename,
 \                '" Select a file with cursor and press ENTER'])
  keepj $

  exe "keepj sil! r! ".g:zip_unzipcmd." -Z -1 -- ".s:Escape(zipfile,1)
  if v:shell_error != 0
   redraw!
   echohl WarningMsg | echo "***warning*** (zip#Browse) ".fnameescape(zipfile)." is not a zip file" | echohl None
   keepj sil! %d
   let eikeep= &ei
   set ei=BufReadCmd,FileReadCmd
   exe "keepj r ".fnameescape(zipfile)
   let &ei= eikeep
   keepj 1d
   return
  endif

  setlocal noma nomod ro
  noremap <silent> <buffer> <cr>	:exec "call <SID>ZipBrowseSelect('".expand('%')."')"<cr>
  noremap <silent> <buffer> x		:call zip#Extract()<cr>

  if exists("l:zipdelete")
      autocmd! BufUnload <buffer> exe "exe \"call "
                  \ . "delete('\".getbufvar(".expand('<abuf>').",'zipfile').\"')\""
  endif

  let &report= repkeep
endfun

fun! zip#Write(fname)
  let repkeep= &report
  set report=10

  if !executable(substitute(g:zip_zipcmd,'\s\+.*$','',''))
   redraw!
   echohl Error | echo "***error*** (zip#Write) sorry, your system doesn't appear to have the ".g:zip_zipcmd." program" | echohl None
   let &report= repkeep
   return
  endif
  if !exists("*mkdir")
   redraw!
   echohl Error | echo "***error*** (zip#Write) sorry, mkdir() doesn't work on your system" | echohl None
   let &report= repkeep
   return
  endif

  let curdir= getcwd()
  let tmpdir= tempname()
  if tmpdir =~ '\.'
   let tmpdir= substitute(tmpdir,'\.[^.]*$','','e')
  endif
  call mkdir(tmpdir,"p")

  if s:ChgDir(tmpdir,s:ERROR,"(zip#Write) cannot cd to temporary directory")
   let &report= repkeep
   return
  endif

  if isdirectory("_ZIPVIM_")
   call s:Rmdir("_ZIPVIM_")
  endif
  call mkdir("_ZIPVIM_")
  cd _ZIPVIM_

  let fname = g:GetFileName(a:fname)
  let zipfile = g:GetZipFile(a:fname)

  if fname =~ '/'
   let dirpath = substitute(fname,'/[^/]\+$','','e')
   if has("win32unix") && executable("cygpath")
    let dirpath = substitute(system("cygpath ".s:Escape(dirpath,0)),'\n','','e')
   endif
   call mkdir(dirpath,"p")
  endif
  if zipfile !~ '/'
   let zipfile= curdir.'/'.zipfile
  endif

  if fname =~# "::"
      let zipfile = getbufvar("#","zipfile","")
      let fname = substitute(fname,'.*::\(.*\)','\1',"")
  else
      let zipfile = g:GetZipFile(a:fname)
  endif

  exe "w! ".fnameescape(fname)
  if has("win32unix") && executable("cygpath")
   let zipfile = substitute(system("cygpath ".s:Escape(zipfile,0)),'\n','','e')
  endif

  if (has("win32") || has("win95") || has("win64") || has("win16")) && &shell !~? 'sh$'
    let fname = substitute(fname, '[', '[[]', 'g')
  endif

  call system(g:zip_zipcmd." -u ".s:Escape(fnamemodify(zipfile,":p"),0)." ".s:Escape(fname,0))
  if v:shell_error != 0
   redraw!
   echohl Error | echo "***error*** (zip#Write) sorry, unable to update ".zipfile." with ".fname | echohl None

  elseif s:zipfile_{winnr()} =~ '^\a\+://'
   let netzipfile= s:zipfile_{winnr()}
   1split|enew
   let binkeep= &binary
   let eikeep = &ei
   set binary ei=all
   exe "e! ".fnameescape(zipfile)
   call netrw#NetWrite(netzipfile)
   let &ei     = eikeep
   let &binary = binkeep
   q!
   unlet s:zipfile_{winnr()}
  endif
  
  cd ..
  call s:Rmdir("_ZIPVIM_")
  call s:ChgDir(curdir,s:WARNING,"(zip#Write) unable to return to ".curdir."!")
  call s:Rmdir(tmpdir)
  setlocal nomod

  let &report= repkeep
endfun
