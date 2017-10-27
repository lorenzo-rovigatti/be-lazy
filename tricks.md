# A Handbook for the Lazy

---

by Lorenzo Rovigatti

# Table of Contents

-   [Introduction](#introduction)
    -   [How to use this book](#how-to-use-this-book)
-   [Bash](#bash)
    -   [Useful shortcuts](#useful-shortcuts)
-   [Plotting](#plotting)
    -   [xmgrace](#xmgrace)
-   [SSH](#ssh)
    -   [How to avoid wasting time](#how-to-avoid-wasting-time)
        -   [SSH keys](#ssh-keys)
        -   [SSH config file](#ssh-config-file)
    -   [Escape sequences](#escape-sequences)
-   [Debugging](#debugging)
    -   [GDB](#gdb)
-   [Uncategorized](#uncategorized)
    -   [Making movies](#making-movies)
    -   [Adding a fading, rounded border to figures with
        GIMP](#adding-a-fading-rounded-border-to-figures-with-gimp)

Introduction
============

I am a computational physicist and I spend most of the day in front of a
computer. I consider myself quite the lazy person, and I find many of
the daily tasks that are associated with my job to be extremely boring
and repetitive. During the course of the years I have developed my own
way of dealing with these chores.

These notes contain many tricks of the trade I routinely use during my
everyday job to make my life easier and, which is of the outmost
importance for me, less boring. I am sure many of the solutions I have
found to cope with these common issues can be solved in multiple ways. I
am equally sure that many of the solutions I overlooked are plain better
than the paths I chose to take. If you find that this is the case, feel
free to drop me a line at <lorenzo.rovigatti@gmail.com> or to add your
own solution to the book and create a pull request!

How to use this book
--------------------

The book is written in
[Markdown](https://en.wikipedia.org/wiki/Markdown) and translated to
HTML using [Pandoc](https://pandoc.org/).

The `tricks.md` and `tricks.html` files contain the entirety of the book
in Markdown and HTML format, respectively.

If you want to change the content of the book just edit one or more
chapter files and then, if you have Bash and Pandoc installed on your
system (and the Pandoc executable is in your path) compile the book from
the source by running the `compile.sh` script. This will generate the
`tricks.md`, `tricks.html` and `README.md` files.

This is not a book to be read in one take. On the contrary, it should be
considered as a collection of tips & tricks to be referred to when the
need arises.

I plan to add as many figures and examples as possible. These will be
included in the source of the book.

[![License: CC BY
4.0](https://licensebuttons.net/l/by/4.0/80x15.png)](https://creativecommons.org/licenses/by/4.0/)

------------------------------------------------------------------------

Bash
====

Useful shortcuts
----------------

-   `!PATTERN` execute the most recent command in the shell history that
    begins with PATTERN (*e.g.* `!xm` will likely execute the last
    `xmgrace` command issued)
-   `ctrl + a` go to the beginning of the line
-   `ctrl + e` go to the end of the line
-   `ctrl + k` cut line after the cursor
-   `ctrl + u` cut line before the cursor
-   `alt + backspace` cut the word after the cursor
-   `ctrl + w` cut the word before the cursor
-   `ctrl + y` paste back the last thing you cut
-   `ctrl + p` previous command
-   `ctrl + n` next command
-   `ctrl + r` backward interactive command search
-   `ctrl + s` forward interactive command search (**NB:** `stty -ixon`
    should be first added to .bashrc)

Plotting
========

xmgrace
-------

SSH
===

Connecting through [`ssh`](https://en.wikipedia.org/wiki/Secure_Shell)
to a remote machine (be it your office computer, home desktop or HPC
cluster) is one of the most common operations in the daily routine of
many people who do this job. If you are one of these people, you will
likely find yourself `ssh`-ing to this or that computer quite often. If
you have an account `lorenzo` on the `powercluster.cool.univ.com`
machine, you can use the following command to establish a remote
connection with it[^1]

    $ ssh lorenzo@powercluster.cool.univ.com

You will then be asked to input your password after which you will be
given a shell on the remote machine. Some cautious (paranoid?)
sys-admins like to disable the 22 port on which the ssh
[daemon](https://en.wikipedia.org/wiki/Daemon_(computing)) listens by
default. If you try to connect to a remote machine and you receive a
`Connection refused` error, this might be way. In order to connect
through another port (port 123456, for instance) use the `-p` option,
like this:

    $ ssh -p 123456 lorenzo@powercluster.cool.univ.com

**Nota Bene:** if you are using `scp` to copy files from/to a remote
machine that accepts `ssh` connections only through a non-22 port, make
sure you add `-P port` (with a capital `P`) and not `-p port` like you
would do with `ssh`.

How to avoid wasting time
-------------------------

If you find yourself typing the commands written above over and over,
you will quickly realise how annoying it can get, especially if you have
multiple computers you often connect to[^2]. There are two
(complementary) ways to save a lot of keystrokes:

1.  Set up ssh keys
2.  Set up the list of hosts in the ssh config file

### SSH keys

### SSH config file

Escape sequences
----------------

OpenSSH provides a variety of escape sequences that can be used during
SSH sessions, even when the terminal is unresponsive [^3]. Typing `~?`
(a tilde followed by a question mark) during an SSH session will print
the list of available escape sequences which, with my OpenSSH client
v7.2, looks like

    ~.   - terminate connection (and any multiplexed sessions)
    ~B   - send a BREAK to the remote system
    ~C   - open a command line
    ~R   - request rekey
    ~V/v - decrease/increase verbosity (LogLevel)
    ~^Z  - suspend ssh
    ~#   - list forwarded connections
    ~&   - background ssh (when waiting for connections to terminate)
    ~?   - this message
    ~~   - send the escape character by typing it twice

The most useful escape sequence is undoubtly `~.` (a tilde followed by a
dot), which terminates the connection even when the terminal is
unresponsive. This comes in very handy when either your connection or
the remote machine's connection goes down and you want to get your
terminal back.

**Nota Bene:** `~` (the tilde character) should be the *very* first
character on the command line.

Debugging
=========

GDB
---

Here is a a very short and non-comprehensive list of useful GDB
commands:

-   `break example.c:22` create a breakpoint at line 22 of the file
    `example.c`.
-   `break example.c:22 if i == 100` create a conditional breakpoint. It
    gets triggered only when the condition is met.
-   `where` print the stack-trace after a segfault (or similar error).
-   `up/down` move up (down) the stack-trace.
-   `ptype` output the type of a variable.
-   `info locals` display the name and value of all local variables.
-   `disable 1` disable breakpoint number 1.

Uncategorized
=============

Making movies
-------------

We would like to generate a movie out of a (maybe very long) list of png
images. We first create a file containing the list of png files sorted
according to the order with which they should appear in the movie. If
the names of the files are `img-1.png`, `img-2.png`, *etc.*, this can be
accomplished by typing

    $ ls -1v img-*.png > list.dat

The `-v` option is a GNU extension that tells `ls` to order entries
according to the natural sorting of the numbers contained in the entry
names. If on your system this option is not supported or it does
something else (this might be the case on BSD/OSX systems), then you can
use the following command

    $ ls -1 img-*.png | sort -n -t'-' -k 2 > list.dat

`-n` applies natural sorting, `-t'-'` tells sort to use dashes as the
separators to split the entries it acts on into fields and `-k 2` to
sort according to the value of the second field

A movie of width WIDTH, height HEIGHT and framerate FPS can now be
generated by using `mencoder` with the following options:

    $ mencoder mf://@list.dat -mf w=WIDTH:h=HEIGHT:fps=FPS:type=png -ovc xvid -xvidencopts bitrate=200 -o output.avi

The `-ovc xvid` controls the type of output and may not be suitable on
all systems (or for all the purposes). The `-xvidencopts bitrate=200`
option sets a sort of *overall* quality of the output.

Adding a fading, rounded border to figures with GIMP
----------------------------------------------------

1.  Select the whole picture (`ctrl + a`)
2.  Shrink the border by an appropriate amount of pixels (Select
    → Shrink). I would say no more than 10% of the figure size.
3.  Round the selection (Select → Rounded Rectangle)
4.  Invert the selection (`ctrl + i`)
5.  Feather the border (Select → Feather). I usually choose a number
    similar to the one used in step 2.
6.  Delete the selected region (press delete)
7.  Turn white into alpha (Colours → Colour to Alpha)
8.  Create a new layer (same width and height as the figure) and put it
    underneath all other layers
9.  Fill the layer with the background colour you want your picture to
    fade to at the border (usually black)

[^1]: In the following I will assume you are using the
    \[OpenSSH\]\[https://www.openssh.com/\] client

[^2]: It is not uncommon (at least not for me 😄) to have ten or more
    open connections at once!

[^3]: <https://lonesysadmin.net/2011/11/08/ssh-escape-sequences-aka-kill-dead-ssh-sessions/amp/>
