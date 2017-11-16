# A Handbook for the Lazy

---

by Lorenzo Rovigatti

# Table of Contents

-   [Introduction](#introduction)
    -   [How to use this book](#how-to-use-this-book)
-   [Bash](#bash)
    -   [Files and directories](#files-and-directories)
    -   [Redirection and piping](#redirection-and-piping)
        -   [Input/output redirection](#inputoutput-redirection)
        -   [Piping](#piping)
    -   [~~"if" statements~~](#if-statements)
    -   [~~"for" loops~~](#for-loops)
    -   [Useful shortcuts](#useful-shortcuts)
-   [~~Command-line tools~~](#command-line-tools)
    -   [~~AWK~~](#awk)
    -   [~~cat, cut and paste~~](#cat-cut-and-paste)
    -   [~~grep, find and locate~~](#grep-find-and-locate)
-   [~~Plotting~~](#plotting)
    -   [~~xmgrace~~](#xmgrace)
-   [SSH](#ssh)
    -   [How to avoid wasting time](#how-to-avoid-wasting-time)
        -   [SSH keys](#ssh-keys)
        -   [SSH config file](#ssh-config-file)
    -   [Escape sequences](#escape-sequences)
-   [Debugging](#debugging)
    -   [GDB](#gdb)
-   [Uncategorized](#uncategorized)
    -   [Setting up NFS](#setting-up-nfs)
    -   [Making movies](#making-movies)
    -   [Adding a fading, rounded border to figures with
        GIMP](#adding-a-fading-rounded-border-to-figures-with-gimp)
-   [Glossary](#glossary)

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

In the following I will assume that Bash is the default [shell](#shell)
of your system and that you know how to start a new terminal, which
usually boils down to writing "terminal" in your OS' search bar and
starting up the first search result.

[Bash](https://www.gnu.org/software/bash/) is probably the most common
[Unix shell](https://en.wikipedia.org/wiki/Unix_shell). It is the
default login shells of many LInux distributions, as well as of Apple's
Mac OS X. For our purposes, Bash is the command line through which we
communicate with and operate on the files and directories stored on the
[filesystem](#filesystem).

**Nota Bene:** `man COMMAND` will show the manual associated to
`COMMAND`, listing all the supported command-line arguments, the most
common use-cases and some examples. Use the `man` command as often as
possible, and **never** use a command without knowing what it does.

Files and directories
---------------------

The first task you will likely use the shell for is to browse through
the [filesystem](#filesystem) to work with files and directories
(create, delete, move or edit them, execute programs, *etc.*). Think of
the filesystem as a tree-like structure: leaves are files, branches are
directories (and leaf-less branches are empty directories). An example
of a part of a filesystem (as output by the `tree` command), with
directories being coloured in blue and files in black is

<pre>
<span style="color:blue">root_directory</span>
├── a_file
├── <span style="color:blue">first_directory</span>
│   ├── <span style="color:blue">another_directory</span>
│   │   └── a_nested_file
│   ├── another_file
│   └── one_more
└── <span style="color:blue">second_directory</span>
</pre>
In [\*nix](#unix-like) systems, the filesystem tree starts in the
directory indicated by `/`, which is aptly called the *root* directory.
When you open a shell (or a terminal), you will be placed in a starting
directory which, most likely, will be your own home directory. By
default, its path is `/home/your_username` (*e.g.* `/home/lorenzo`).

You can use the `pwd` command, which prints to screen the name of the
(current) working directory, to find out where you are. The same can be
achieved by printing the `PWD` environment variable (`echo $PWD`), which
Bash sets to the current directory every time the working directory is
changed.

You can change the current directory with the `cd` command. If you want
to move to the `other_dir` directory just type `cd other_dir`. `cd`
accepts both absolute and relative paths.

Redirection and piping
----------------------

The main strength of Bash (and of all the other shells) comes from the
[Unix philosophy](https://en.wikipedia.org/wiki/Unix_philosophy), which
can be summarised as [^1]

> 1.  Write programs that do one thing and do it well.
> 2.  Write programs to work together.
> 3.  Write programs to handle text streams, because that is a
>     universal interface.

Most of the command-line utilities that can be find in a Unix-like
environment (such as Linux, BSD, Mac OS X) follow, more or less closely,
this philosophy. As a consequence of the wide adoption of the principles
listed above, many of said utilities can perform only very specific
duties. Moreover, most of the communication to and from these programs
is text-based and carried out through their input and output streams. It
is therefore very common to split the task at hand in *subtasks* that
are performed by several programs in a serial fashion: each program
manipulates an input and pass the resulting output to the next program.
The mechanism that makes it possible to forward the output of a program
to the input of another program is called *piping* and is signalled by
the presence of the pipe sign, ~|~. At the end of this process it is a
common patter to *redirect* the final output to a file.

### Input/output redirection

There are three standard input/output (I/O or just IO) streams: the
standard input, or `stdin`, the standard output, or `stdout`, and the
standard error, or `stderr`:

-   `stdin` is used to acquire (possibly interactive) input (see *e.g.*
    the `scanf()` or `fscanf(stdin)` C functions)
-   `stdout` is to print the *regular* output of the program (see *e.g.*
    the `printf()` or `fprintf(stdout)` C functions)
-   `stderr` is for printing warnings, diagnostics or error messages
    (see *e.g.* the `fprintf(stderr)` C function)

In Bash, the default behaviour for programs that expect input is to
prompt the user for input. However, the `stdin` can be redirected by
using a `<` sign. For example, a program `my_program` that reads from
the standard input can be instead fed a file `my_input.txt` by using
`my_program < my_input.txt`.

For the output streams, the default behaviour is to write them on
screen. In order to redirect a output stream to file, use the `>` sign.
For example, `echo "Hello beauty!" > msg.txt` will put the
`"Hello beauty"` text in the `msg.txt` file.

By contrast, the `stderr` can be redirected by using the `2>` token. For
example, `ls wrong_file 2> error.txt` will put an error message
(provided there is no file or directory named `wrong_file` in the
current directory 😄) in the `error.txt` file.

It is possible to redirect **both** `stdout` and `stderr` streams by
using the `&>` sign.

In general, all the above output redirection signs will write the output
of the programs that are on their left-hand side to the files whose name
is on their right-hand side, possibly overwriting any previous content.
In order to *append*, rather than write, the output to those files is
sufficient to add a `>` to each token. Thus, `>` becomes `>>`, `2>`
becomes `2>>` and `&>` becomes `&>>`.

**Nota Bene:** all multi-character tokens used for redirection should
not contain spaces. In other words, be careful: `&>` and `& >` are
**not** the same thing.

### Piping

If you follow the Unix philosophy, you will often need to feed a program
with the output of another program. This is called *piping* and it is
done through the `|` (pipe) symbol. The pipe tells the shell to redirect
the standard output of the command on the left-hand side of the pipe to
the standard input of the command which is on the right-hand side of the
pipe. For instance, take a directory containing a lot of files and/or
folders. Imagine you want to have a look at the contents of the
directory. This can be done by piping the output of `ls` (here
complemented by the `-1` argument which tells `ls` to list one entry per
line) to `less`, which is used to page through text, in this way:

``` {.bash}
ls -1 | less
```

Use the arrow keys or the page-up/page-down buttons to page through the
text and `q` to quit.

Do not be deceived by the simplicity of the above example: the
possibility of chaining together different processes is at the core of
the Unix philosophy and makes it possible to easily create extremely
complicated and powerful *pipelines* (that is, sequences of processes
linked together by `|`). For instance, the following pipeline uses

1.  `grep` to extract from the `prova.dat` file only those lines that
    contain integer numbers
2.  `sort` to numerically sort them
3.  `tail` to take the two largest numbers
4.  `awk` to print the average over these two values

``` {.bash}
grep -E "^[0-9]+$" prova.dat | sort -n | tail -n 2 | awk '{a+=$1; t++} END {print a/t}'
```

You do not have to understand all the details, but just realise the
sheer power of being able to combine the multitude of basic commands
that a modern Linux shell provides.

~~"if" statements~~
-------------------

~~"for" loops~~
---------------

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

------------------------------------------------------------------------

~~Command-line tools~~
======================

~~AWK~~
-------

~~cat, cut and paste~~
----------------------

~~grep, find and locate~~
-------------------------

------------------------------------------------------------------------

~~Plotting~~
============

~~xmgrace~~
-----------

------------------------------------------------------------------------

SSH
===

Connecting through [SSH](https://en.wikipedia.org/wiki/Secure_Shell) to
a remote machine (be it your office computer, home desktop or HPC
cluster) is one of the most common operations in the daily routine of
many people who do this job. If you are one of these people, you will
likely find yourself SSH-ing to this or that computer quite often. If
you have an account `lorenzo` on the `powercluster.cool.univ.com`
machine, you can use the following command to establish a remote
connection with it[^2]

``` {.bash}
$ ssh lorenzo@powercluster.cool.univ.com
```

You will then be asked to input your password after which you will be
given a shell on the remote machine. Some cautious (paranoid?)
sys-admins like to disable the 22 port on which the ssh
[daemon](https://en.wikipedia.org/wiki/Daemon_(computing)) listens by
default. If you try to connect to a remote machine and you receive a
`Connection refused` error, this might be way. In order to connect
through another port (port 123456, for instance) use the `-p` option,
like this:

``` {.bash}
$ ssh -p 123456 lorenzo@powercluster.cool.univ.com
```

**Nota Bene:** if you are using `scp` to copy files from/to a remote
machine that accepts SSH connections only through a non-22 port, make
sure you add `-P port` (with a capital `P`) and not `-p port` like you
would do with `ssh`.

How to avoid wasting time
-------------------------

If you find yourself typing the commands written above over and over,
you will quickly realise how annoying it can get, especially if you have
multiple computers you often connect to[^3]. There are two
(complementary) ways to save a lot of keystrokes:

1.  Set up ssh keys
2.  Set up the list of hosts in the ssh config file

### SSH keys

I will not delve into the technicalities of SSH keys because I am not
expert and because I do not think this is the right place to have such a
discussion. If you are interested you can find many resources online,
starting, for instance, from [here](https://www.ssh.com/ssh/key/).

Here it suffices to know that you can set up the SSH connection between
your local machine and a remote one so that you will not have to enter
any password when using it. In order to do so, you will have to first
generate an *SSH key* on your local machine. This can be done with the
following command

``` {.bash}
$ ssh-keygen -t rsa
```

The first thing you will be asked is where to store the key. If you
leave the field empty the key will be saved in the `~/.ssh/id_rsa`
location, with `~` being your home directory. You will be then asked
twice to enter a passphrase, which can be left empty. There can be
security reasons why you would want to enter a non-empty passphrase.
However, using a non-empty passphrase would defeat the purpose of this
section, as it would make SSH ask for that passphrase every time you
want to login on the remote machines you have copied your key to. In the
following I will assume you saved the key to the default location and
did not enter a passphrase during the key generation.

**Nota Bene:** the key you have generated is a (sort of) fingerprint of
your user on the *specific* local machine you are generating it on. This
means that you have to undergo this procedure once for each computer you
connect *from*, regardless of the number of remote machines you will
connect *to*.

On many systems there exists the `ssh-copy-id` utility that copies your
key over to the right position on the remote machine. If this is your
case just call it with the command line options you would use if you
were to connect to the remote machine through the usual SSH command. For
example,

``` {.bash}
$ ssh-copy-id lorenzo@powercluster.cool.univ.com
```

or, if you need to use a custom port:

``` {.bash}
$ ssh-copy-id -p 123456 lorenzo@powercluster.cool.univ.com
```

if everything goes smoothly this is the last time you will have to enter
your password to connect to that specific remote computer 😄

If your system lacks `ssh-copy-id` you will have to manually add your
public key to the list of *authorized keys* stored on the remote
machine. In order to do so you will have to

1.  copy your public key, stored in the `~/.ssh/id_rsa.pub` file (here I
    am assuming your `ssh-keygen` was told to put the key in the
    default location). You should expect it to look like this:

    <pre>ssh-rsa GIBBERISH lorenzo@lorenzo-desktop</pre>
    where `GIBBERISH` is a very long string of seemingly random
    characters and the last token is just `your_username@your_host`
2.  establish a connection with the target remote machine and, with your
    preferred editor, open the `~/.ssh/authorized_keys` file. Paste your
    public key on a new line, save and exit

*Et voilà*: SSH will not prompt you for the password when accessing this
specific remote machine any more!

**Nota Bene:** the aforementioned procedure lets you SSH passwordlessly
from `user_on_A_host@A_host` to `user_on_B_host@B_host`. If you change
either the user or the host from which you connect *from*, you will have
to redo the proceudre. If you change either the user or the host you
connect *to* you will have to update the corresponding `authorized_keys`
file by adding the public key you already have.

### SSH config file

In this section we will see how to transform this:

``` {.bash}
$ ssh -p 123456 lorenzo@powercluster.cool.univ.com
```

Into this:

``` {.bash}
$ ssh pc
```

Looks neat, doesn't it? With SSH, just open the file `~/.ssh/config`
(which may not exist yet) and, for each combination of `user@host` you
want to create aliases for, add a few lines that specify the parameters
for that specific connection, like this:

    Host pc
    HostName powercluster.cool.univ.com
    User lorenzo
    Port 123456

Save and exit. From now on you will be able to use `ssh pc` in place of
`ssh -p 123456 lorenzo@powercluster.cool.univ.com`: you do not need to
reload or restart anything.

A few comments:

1.  You can omit the `User` and `Port` fields if the default values (the
    current user and port 22, respectively) are fine
2.  You can set default values for all or some hosts by using wildcards.
    For example

    <pre>
    Host *univ.com
    User rovigatti

    Host *
    User lorenzo
    </pre>
    **Nota Bene:** the order with which you list the hosts is very
    important! SSH parses the `config` file from the top downwards and
    uses the *first* value found for each option whose corresponding
    `Host` matches the hostname given on the command line. For instance,
    in the above listing, inverting the order of the hosts will make SSH
    always use the username `lorenzo`, even for hostnames that match the
    `*univ.com` pattern.

3.  The list of available fields is
    [here](https://www.ssh.com/ssh/config/). A simpler tutorial can be
    found here
    [here](https://www.digitalocean.com/community/tutorials/how-to-configure-custom-connection-options-for-your-ssh-client)

Escape sequences
----------------

OpenSSH provides a variety of escape sequences that can be used during
SSH sessions, even when the terminal is unresponsive [^4]. Typing `~?`
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

------------------------------------------------------------------------

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

------------------------------------------------------------------------

Uncategorized
=============

Setting up NFS
--------------

[NFS](https://en.wikipedia.org/wiki/Network_File_System) (Network File
System) is a protocol that makes it possible to remotely (and
transparently) access a file system over the network. Here I will
explain how to setup a remote machine (aka the *server*) so that a local
machine (aka the *client*) can have access to one or more of its
directories.

1.  Install the NFS server. On Ubuntu, this boils down to installing the
    `nfs-kernel-server` package.
2.  Open (with root privilegies) the /etc/exports file. Add a line for
    each folder you want to export. The syntax is

    `PATH_TO_DIRECTORY  CLIENT(OPTIONS)`

    Note the lack of whitespace between CLIENT and the open parenthesis.
    The CLIENT field can be an IP address or a DNS name and can contain
    wildcards (*e.g.* `*` or `?`). The list of available options depend
    on the NFS server version and can be found online (for example
    [here](https://linux.die.net/man/5/exports)). Valid configuration
    examples are

    `/home/lorenzo/RESULTS 192.168.0.10(rw,no_root_squash)`
    `/home/lorenzo/RESULTS *(ro,no_root_squash)`

    The above lines export the `/home/lorenzo/RESULTS` directory in
    read/write mode for the client identified by the IP address
    `192.168.0.10` and in read-only mode for everybody else.

3.  Restart the NFS server. On many Linux distros this can be done with
    the command `sudo service nfs-kernel-server restart`
4.  On the client, install the NFS client (the `nfs-common` package
    on Ubuntu)
5.  The remote filesystem can be mounted either manually
    (`sudo mount 192.168.0.1:/home/lorenzo/RESULTS /home/lorenzo/SERVER_RESULTS`)
    or automatically by adding a line like this to the `/etc/fstab`
    file:

    `192.168.0.1:/home/lorenzo/RESULTS /home/lorenzo/SERVER_RESULTS nfs rw,user,auto 0 0`

    and then using `sudo mount -a`. Here I assumed that the server has
    IP address `192.168.0.1` and that the directory
    `/home/lorenzo/CLIENT_RESULTS` exists on the client.

**Nota Bene:** on default installations, the shared directories are
owned by the user and group identified by the `uid` and `gid` of the
server, respectively. If the user on the client has a different `uid`
and/or `gid`, its access to these directories may be limited. If this is
the case (and if you are sure there will be no issues arising from such
a drastic change) the best course of action is to change the user and
group ids on either machine in order to make them match. This can done
with the `usermod` command (*e.g.* `usermod -g 1110 -u 1205 lorenzo`
will change lorenzo's `gid` and `uid` to 1110 and 1205, respectively).
Note that `usermod` will change the ownership of all the files and
directories that are in the user's home directory and are owned by them.
The ownership of any other file or directory must be fixed manually.

Making movies
-------------

We would like to generate a movie out of a (maybe very long) list of png
images. We first create a file containing the list of png files sorted
according to the order with which they should appear in the movie. If
the names of the files are `img-1.png`, `img-2.png`, *etc.*, this can be
accomplished by typing

``` {.bash}
$ ls -1v img-*.png > list.dat
```

The `-v` option is a GNU extension that tells `ls` to order entries
according to the natural sorting of the numbers contained in the entry
names. If on your system this option is not supported or it does
something else (this might be the case on BSD/OSX systems), then you can
use the following command

``` {.bash}
$ ls -1 img-*.png | sort -n -t'-' -k 2 > list.dat
```

`-n` applies natural sorting, `-t'-'` tells sort to use dashes as the
separators to split the entries it acts on into fields and `-k 2` to
sort according to the value of the second field

A movie of width WIDTH, height HEIGHT and framerate FPS can now be
generated by using `mencoder` with the following options:

``` {.bash}
$ mencoder mf://@list.dat -mf w=WIDTH:h=HEIGHT:fps=FPS:type=png -ovc xvid -xvidencopts bitrate=200 -o output.avi
```

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

------------------------------------------------------------------------

Glossary
========

<a id="filesystem" class="glossary_entry">Filesystem</a>

:   The data structure used by the OS to manage and provide access to
    the files and directories to a user
    ([wikipedia](https://en.wikipedia.org/wiki/File_system))

<a id="shell" class="glossary_entry">Shell</a>

:   The interface through which a user access the operating
    system's services. Although shells are, in general, either graphic
    user interfaces (GUIs) or command-line interfaces (CLIs), the term
    "shell" is most often used to refer to CLIs
    ([wikipedia](https://en.wikipedia.org/wiki/Shell_(computing)))

<a id="unix-like" class="glossary_entry">Unix-like, \*nix, UN\*x</a>

:   An operating system that behaves similarly to a Unix system. It is
    often used loosely
    ([wikipedia](https://en.wikipedia.org/wiki/Unix-like))

[^1]: <http://www.catb.org/~esr/writings/taoup/html/ch01s06.html>

[^2]: In the following I will assume you are using the
    [OpenSSH](https://www.openssh.com/) client

[^3]: It is not uncommon (at least not for me 😄) to have ten or more
    open connections at once!

[^4]: <https://lonesysadmin.net/2011/11/08/ssh-escape-sequences-aka-kill-dead-ssh-sessions/amp/>
