Extends stock zipPlugin.vim to allow recursively browsing and writing zip files.

VimL and system calls only (zip, unzip and copy file).

# Requirements

- *Vim 7.4✝* or *Neovim 0.1.7*.

✝ Confirmed working on Vim 7.4-1024 for Windows.

## To browse

In $PATH:

- an unzip compatible command.

## To write

In $PATH:

- a zip compatible command.

# Installation

## Vim 8.0+ (+packages)

If you're using Vim 8.0 or greater (if `:echo has("packages")` returns 1), you
can add *vim-rzip* as a package.

When you're done with the following steps make sure to read about packages:
`:h packages`.

- If your *.vim* folder is NOT a git repository:

```
$ mkdir ~/.vim/pack/bundle/start
$ cd ~/.vim/pack/bundle/start
start $ git clone 'https://github.com/lbrayner/vim-rzip'
```

- If your *.vim* folder IS a git repository:

```
$ mkdir ~/.vim/pack/bundle/start
$ cd ~/.vim
.vim $ git submodule add 'https://github.com/lbrayner/vim-rzip' pack/bundle/start/vim-rzip
.vim $ git submodule init --update
```

This will install *vim-rzip* as a
[git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules).

## Plugin manager

Either [vim-pathogen](https://github.com/tpope/vim-pathogen) or
[Vundle](https://github.com/VundleVim/Vundle.vim) are recommended.

## Verifying the installation

When you open a file with any of these extensions (per default) —
*.apk*, *.celzip*, *.crtx*, *.docm*, *.docx*, *.dotm*, *.dotx*, *.ear*, *.epub*,
*.gcsx*, *.glox*, *.gqsx*, *.ja*, *.jar*, *.kmz*, *.oxt*, *.potm*, *.potx*,
*.ppam*, *.ppsm*, *.ppsx*, *.pptm*, *.pptx*, *.sldx*, *.thmx*, *.vdw*, *.war*,
*.wsz*, *.xap*, *.xlam*, *.xlam*, *.xlsb*, *.xlsm*, *.xlsx*, *.xltm*, *.xltx*,
*.xpi*, *.zip* — you'll see the default zipPlugin.vim message, except that the
version, on the first line, should have a *m-rzip* suffix (e.g. *v27m-rzip*).

# Configuration

Extra file extensions can be added with **g:rzipPlugin_extra_ext**. For example:

```vim
let g:rzipPlugin_extra_ext = '*.odt,*.mfh'
```

# Appendix

On Unix just install zip and unzip packages.

You can get the *unzip.exe* binary for Windows [here](http://www.stahlworks.com/dev/index.php?tool=zipunzip).

A zip-compatible program need only implement the **-u** (*update*) command line switch.
An example of a zip-compatible dosbatch script for Windows using 7zip:

```bat
@echo off

if "%~1" == "-u" (
    if not "%~2" == "" (
        if not "%~3" == "" (
            if "%~4" == "" (
                7z u %2 %3
                exit /b 0
            )
        )
    )
)

7z %*
```

Save this as zip.bat and put in your $PATH.
