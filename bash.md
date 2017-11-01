---

# Bash

In the following I will assume that Bash is the default shell of your system and that you know how to start a new terminal, which usually boils down to writing "terminal" in your OS' search bar and starting up the first search result.

[Bash](https://www.gnu.org/software/bash/) is probably the most common [Unix shell](https://en.wikipedia.org/wiki/Unix_shell). It is the default login shells of many LInux distributions, as well as of Apple's Mac OS X. For our purposes, Bash is the command line through which we communicate with and operate on the files and directories stored on the filesystem.

## Redirection and piping

The main strength of Bash (and of all the other shells) comes from the [Unix philosophy](https://en.wikipedia.org/wiki/Unix_philosophy), which can be summarised as[^bash_philosophy]

> 1. Write programs that do one thing and do it well.
> 2. Write programs to work together.
> 3. Write programs to handle text streams, because that is a universal interface.

The mechanism that makes it possible to pass as the input of a program the output of another program is called *piping*,

## Files and directories

## "if" statements

## "for" loops

## Useful shortcuts

* `!PATTERN` execute the most recent command in the shell history that begins with PATTERN (*e.g.* `!xm` will likely execute the last `xmgrace` command issued)
* `ctrl + a` go to the beginning of the line
* `ctrl + e` go to the end of the line
* `ctrl + k` cut line after the cursor
* `ctrl + u` cut line before the cursor
* `alt + backspace` cut the word after the cursor
* `ctrl + w` cut the word before the cursor
* `ctrl + y` paste back the last thing you cut
* `ctrl + p` previous command
* `ctrl + n` next command
* `ctrl + r` backward interactive command search
* `ctrl + s` forward interactive command search (**NB:** `stty -ixon` should be first added to .bashrc)

[^bash_philosophy]: [http://www.catb.org/~esr/writings/taoup/html/ch01s06.html](http://www.catb.org/~esr/writings/taoup/html/ch01s06.html)