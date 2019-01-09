Extends stock zip.vim to allow recursively browsing and writing zip files.

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
$ git submodule add 'https://github.com/lbrayner/vim-rzip' pack/bundle/start/vim-rzip
$ git submodule init --update
```

This will install *vim-rzip* as a
[git submodule](https://git-scm.com/book/en/v2/Git-Tools-Submodules).

## Plugin manager

Either [vim-pathogen](https://github.com/tpope/vim-pathogen) or
[Vundle](https://github.com/VundleVim/Vundle.vim).

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
