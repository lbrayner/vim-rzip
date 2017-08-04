Extends stock zip.vim to allow recursively browsing and writing zip files.

VimL and system calls only (zip, unzip and copy file).

# Requirements

In $PATH:

- an unzip compatible command to browse;
- a zip compatible one to write;
- and the builtin **getbufinfo✝** function.

✝ Avalialble in *Vim 8.0* and *Neovim 0.2.0*.

# Appendix

An example of a zip compatible dosbatch script for Windows using 7zip:

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
