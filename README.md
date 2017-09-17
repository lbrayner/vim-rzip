Extends stock zip.vim to allow recursively browsing and writing zip files.

VimL and system calls only (zip, unzip and copy file).

# Requirements

## To browse

In $PATH:

- an unzip compatible command.

## To write

In $PATH:

- a zip compatible command.

Vim:

- *Vim 7.4✝* or *Neovim 0.1.7*.

✝ Confirmed working on Vim 7.4-1024 for Windows.

# Configuration

Extra file extensions can be added with **g:zipPlugin_extra_ext**. For example:

```vim
let g:zipPlugin_extra_ext = '*.odt,*.mfh'
```

# Appendix

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
