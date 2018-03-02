# A Handbook for the Lazy

---

by Lorenzo Rovigatti

# Table of Contents

-   [Introduction](#introduction)
    -   [How to use this book](#how-to-use-this-book)
-   [Bash](#bash)
    -   [Commands and programs](#commands-and-programs)
    -   [Files and directories](#files-and-directories)
        -   [`cd`](#cd)
        -   [`ls`](#ls)
        -   [~~Executable files~~](#executable-files)
    -   [Variables](#variables)
    -   [The Bash environment and environment
        variables](#the-bash-environment-and-environment-variables)
    -   [Redirection and piping](#redirection-and-piping)
        -   [Input/output redirection](#inputoutput-redirection)
        -   [Piping](#piping)
    -   [Aliases](#aliases)
    -   [~~Make your changes permanent:
        .bashrc~~](#make-your-changes-permanent-.bashrc)
    -   [~~"if" statements~~](#if-statements)
    -   [~~"for" loops~~](#for-loops)
    -   [Useful shortcuts](#useful-shortcuts)
-   [~~Command-line tools~~](#command-line-tools)
    -   [~~AWK~~](#awk)
    -   [~~cat, cut and paste~~](#cat-cut-and-paste)
    -   [~~grep, find and locate~~](#grep-find-and-locate)
-   [Coding](#coding)
    -   [Exposing c/c++ code to Python with Boost
        Python](#exposing-cc-code-to-python-with-boost-python)
        -   [Speeding-up compilation and reducing memory
            consumption](#speeding-up-compilation-and-reducing-memory-consumption)
        -   [Compiling with CMake](#compiling-with-cmake)
-   [Plotting](#plotting)
    -   [xmgrace](#xmgrace)
        -   [Improve the default style](#improve-the-default-style)
        -   [Upgrade the default colours](#upgrade-the-default-colours)
-   [SSH](#ssh)
    -   [How to avoid wasting time](#how-to-avoid-wasting-time)
        -   [SSH keys](#ssh-keys)
        -   [SSH config file](#ssh-config-file)
    -   [Escape sequences](#escape-sequences)
-   [Debugging](#debugging)
    -   [GDB](#gdb)
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

The `be-lazy.md` and `be-lazy.html` files contain the entirety of the
book in Markdown and HTML format, respectively.

If you want to change the content of the book just edit one or more
chapter files and then, if you have Bash and Pandoc installed on your
system (and the Pandoc executable is in your path) compile the book from
the source by running the `compile.sh` script. This will generate the
`be-lazy.md`, `be-lazy.html` and `README.md` files.

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

Commands and programs
---------------------

There are two types of shell commands: builtins and programs (there are
also Bash
[functions](http://tldp.org/HOWTO/Bash-Prog-Intro-HOWTO-8.html), which
behaves similarly to builtins). The former are a (small) number of
commands that are provided by the shell out of the box. The ones I use
the most are

-   `alias` and `unalias` (see [Aliases](#aliases))
-   `echo`, which outputs its arguments and is often used to generate
    the input consumed by another program (see [Piping](#piping))
-   `read`, which can be used to parse input lines by splitting them up
    into words and assigning them to shell variables

The great majority of commands one uses are external programs. Many of
the main (and most used) external programs are shipped in nearly every
[\*nix](#unix-like) distribution. Indeed, commands such as `ls`, `cd`,
`mv`, `rm`, *etc.* are always available. However keep in mind that,
while the bulk of their features is standard (either truly or *de
facto*), their options differ from platform to platform. For instance,
[GNU](https://www.gnu.org/home.html) provides some handy extensions that
are not present on Apple systems.

**Nota Bene:** Many commands (most of the default ones) support
combining switches when these are used in their short form. For example,
`ls -lhS` is equivalent to `ls -l -h -S`.

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

### `cd`

-   `cd ..` move to the parent of the current working directory
-   `cd -` move back to the previous working directory
-   `cd` or `cd ~` move to your home directory

### `ls`

`ls` is very powerful. Its output can be finely tuned by using the
appropriate switches. Here are some of the switches (and switch
combinations) I find most useful:

-   `ls -lrth` show the entries in a long listing format (`-l`) with
    their size in human-readable form (`-h`) and sorted by reverse
    (`-r`) modification time (`-t`).
-   `ls -S` sort the entries by size (from large to small). Use `-r` to
    reverse the sorting
-   `ls -1` list one entry per line
-   `ls -d` list the directories themselves, not their content. File
    entries are not affected

### ~~Executable files~~

Variables
---------

Similarly to any other programming language, Bash supports variables.
However, Bash does not have data types, meaning that variables can
contain integers, floating point numbers, strings, single characters,
*etc.* Compared to more modern programming language, Bash variables feel
somewhat quirky. However, they get the job done reasonably well. As an
example, the following box contains a "Hello World!" example that makes
use of variables:

    #!/bin/bash
    TO_PRINT="Hello World!"
    echo $TO_PRINT

There are several things that are worth noting:

1.  The first line contains the so-called \*shebang". A shebang (the
    character sequence `#!`, followed by a command) is used by the shell
    whenever a text file (commonly referred to as a [script](#script))
    is [executed](#executable-files) in order to pass it to the
    right interpreter. For instance, the first line of a `python` script
    should be `#!/usr/bin/python` (or, even better
    `#!/usr/bin/env python`, as explained
    [here](https://mail.python.org/pipermail/tutor/2007-June/054816.html)).
2.  The syntax for variable assignment is `KEY=VALUE`. **NB:** No spaces
    are allowed around the equal sign.
3.  The *value* of a variable can be accessed by prepending a `$` to the
    variable name .

**Nota Bene:** variables need not be declared. In fact, they can be used
before even having been set or initialised! This is a common source of
bugs, as shown by the following lines:

    #!/bin/bash
    TO_PRINT="Hello World!"
    echo $TO_PRNIT

The misspelt name of the variable will not cause any warnings or errors,
and the code will misbehave.

Variables defined with the syntax shown above are dubbed shell or local
variables, as they exist only within the shell (or script) in which they
are set or defined. The topic of *global* variables will be touched upon
in the next section.

The Bash environment and environment variables
----------------------------------------------

The Bash (or, more generally, shell) environment is the set of
information that determines the shell behaviour (how it interacts with
the user, how it accesses the system's resources, *etc.*). On a
practical level, Bash uses the content of a variety of (global and user)
configuration files spread throughout the filesystem to compile a list
of key-value pairs: the environment. For each pair, the key is the
*name* of the environment variable which can be used to access its
value(s). Traditionally, these variable names are all uppercase. The
complete list of environment variables (that is, the whole environment)
can be printed with the `printenv` command.

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
4.  `awk` to print the average of these two values

``` {.bash}
grep -E "^[0-9]+$" prova.dat | sort -n | tail -n 2 | awk '{a+=$1; t++} END {print a/t}'
```

You do not have to understand all the details, but just realise the
sheer power of being able to combine the multitude of basic commands
that a modern Linux shell provides.

Aliases
-------

With Bash it is possible to create shortcuts (aka *aliases*) for
commands which are used often, difficult to remember or both. This can
be easily done by using the `alias` built-in. For example, many versions
of the `ls` command can colorise their output by passing it the
`--color=auto` switch. On many Linux distributions (*e.g.* Ubuntu), `ls`
is just an alias to `ls --color=auto`, set with:

``` {.bash}
alias ls='ls --color=auto'
```

I do not use many aliases, but the ones I cannot do without are

``` {.bash}
alias 'cp=cp -i'
alias 'mv=mv -i'
alias 'rm=rm -i'
alias 'll=ls -lh'
alias 'ssh= ssh -Y'
```

The `-i` in the first three makes them ask the user before overwriting
or deleting any files. This makes it harder (but not impossible) to do
stupid mistakes. The effect of `-i` can be counteracated by `-f`:
`rm -f .` will *not* ask confirmation to delete all the files in the
folder!

The `-Y` switch passed to `ssh` enables X11 forwarding. In other words,
makes it possible to remotely open applications that have X11-compatible
graphical interfaces (*e.g.* plotting tools).

If called without arguments, `alias` prints a list of the
currently-defined aliases. `unalias` can be used to remove a
previously-set alias. By default, once an alias has been defined, it
will live till it is unaliased or the terminal it was defined in is
closed. In order to make an alias permanent, put its definition in the
`.bashrc` or `.bash_profile` files in your home folder. See
[.bashrc](#make-your-changes-permanent-.bashrc) for more details.

~~Make your changes permanent: .bashrc~~
----------------------------------------

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
-   `ctrl + s` forward interactive command search (**NB:** it requires
    the command `stty -ixon` in the
    [.bashrc](#make-your-changes-permanent-.bashrc) file)

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

Coding
======

Exposing c/c++ code to Python with Boost Python
-----------------------------------------------

There are many ways to create dynamic libraries written in c or c++ that
can directly imported by Python. Here we will discuss Boost Python. On
Ubuntu (and, I suppose, on other Debian-related distros) Boost Python
requires the `libboost-python-dev` package.

**Nota Bene:** Boost is a collection of very powerful c++ libraries.
However, since c++ is (roughly speaking) a subset of c, Boost Python can
also be used to create python bindings for code written in c. However,
note that the code will have to be compiled with `g++` (or an equivalent
c++ compiler).

Here is a simple example that will generate a dynamic library exposing a
class and a function to python. Copy the following code to the "Foo.cpp"
file:

``` {.cpp}
#include <iostream>
#include <boost/python.hpp>

class Foo {
public:
    Foo() {

    }
    virtual ~Foo() {

    }
    void print_something(std::string something) {
            std::cout << something << std::endl;
    }
    void print_special(std::string special) {
        std::cout << "special: " << special << std::endl;
    }
};

void print_without_class(std::string something) {
    std::cout << something << std::endl;
}

BOOST_PYTHON_MODULE(foo) {
    boost::python::class_<Foo>("Foo")
            .def("print_something", &Foo::print_something);
            
    def("print_without_class", print_without_class);
}
```

Not all the public interface functions and methods have to be exposed to
python. For this specific example, we have decided to export a function
and a class with the default constructor and one of its two public
methods). Now we build the shared libray. Pay attention to the arguments
of the `-I` and `-l` options:

    g++ -fPIC -I/usr/include/python2.7  -c Foo.cpp -o foo.o
    g++ -shared -o foo.so foo.o -lpython2.7 -lboost_python -lboost_system

We have nothing else to do: the library is now freely importable by
python:

``` {.python}
>>> import foo
>>> f = foo.Foo()
>>> f.print_something("Hello, world!")
Hello, world!
>>> foo.print_without_class("I hate classes!")
I hate classes!
>>> f.print_special("My special text")
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
AttributeError: 'Foo' object has no attribute 'print_special'
```

As can be seen from the error above, only the methods, classes and
functions that are explicitly mentioned in the exporting function can be
accessible from python.

**Nota Bene:** The name of the python module (which is set by the only
argument of the `BOOST_PYTHON_MODULE` macro) **must** match the name of
the library file or python will complain by throwing a
`ImportError: dynamic module does not define init function` exception.

Boost python has a lot of features (for instance, it supports templates,
inheritance, *etc.*). Check out the
[documentation](http://www.boost.org/doc/libs/1_66_0/libs/python/doc/html/)
for more complex examples and for the reference manual.

### Speeding-up compilation and reducing memory consumption

Compilation time and memory footprint of large projects can become an
issue. These problems can be mitigated by a simple *divide et impera*
procedure. For instance, take a project containing two classes, `Foo`
and `Bar`. Each class has its own `.h` and `.cpp` files. Then, at the
end of each `.cpp` file we put a function that performs the actual
exporting. For example, burrowing from the previously-defined `Foo`
class one might have:

``` {.cpp}
void export_foo() {
    boost::python::class_<Foo>("Foo")
            .def("print_something", &Foo::print_something);
    /* export here everything that needs to be exported for this compilation unit */
}
```

Now we round up all these exporting function in a single file
`mylib.cpp` where the actual module-creation is carried out. For the
specific case considered here, the content of such a file would be

``` {.cpp}
#include "Foo.h"
#include "Bar.h"
#include <boost/python.hpp>

void export_foo();
void export_bar();

BOOST_PYTHON_MODULE(mylib) {
    export_foo();
    export_bar();
}
```

### Compiling with CMake

Compiling python modules with CMake is straightforward. First of all, we
need to find all the packages that are required to correctly compile the
module:

    FIND_PACKAGE( PythonLibs 2.7 REQUIRED )
    INCLUDE_DIRECTORIES( ${PYTHON_INCLUDE_DIRS} )

    FIND_PACKAGE( Boost COMPONENTS python REQUIRED )
    INCLUDE_DIRECTORIES( ${Boost_INCLUDE_DIR} )

Note that you need to choose the python version you want to create
bindings for. Now create a new target, ensuring that is linked against
the right libraries (here we assume that the source files are listed in
`mylib_SOURCES`):

    ADD_LIBRARY(mylib SHARED ${mylib_SOURCES})
    TARGET_LINK_LIBRARIES(mylib ${Boost_LIBRARIES} ${PYTHON_LIBRARIES})

And do not forget to ensure that no prefixes are added to the library
name, lest python will refuse to import the module:

    SET_TARGET_PROPERTIES(mylib PROPERTIES PREFIX "")

On Mac Os X, dynamic libraries have extensions ".dylib". Unfortunately,
some python installations do not recognized those as modules. A
workaround might be:

    IF(APPLE)
        SET_TARGET_PROPERTIES(mylib PROPERTIES SUFFIX ".so")
    ENDIF(APPLE)

**Tip:** if you are using the Boost logging facilities, you will need to
declare the `BOOST_LOG_DYN_LINK` macro or python will complain. This can
be done with

    ADD_DEFINITIONS(-DBOOST_LOG_DYN_LINK)

------------------------------------------------------------------------

Plotting
========

There exists a lot of software devoted to the production of scientific
(or more in general, data) plots. However, almost every single
scientific community has its own preferred tool. The most common in my
own community are [xmgrace](http://plasma-gate.weizmann.ac.il/Grace/),
gnuplot, Mathematica and matplotlib.

xmgrace
-------

For unknown (but mostly historical, I suppose) reasons, many people in
the water/numerical soft matter communities love to use
[xmgrace](http://plasma-gate.weizmann.ac.il/Grace/). It is ugly, old and
supports 2D graphics only, but if your PhD advisor uses it, chances are
you will have to get used to it as well 😄

### Improve the default style

There is no other way of putting it: the default xmgrace style sucks.
Hard. The great majority of the people who start using it goes through
the process of setting up the graph style for every single plot they
need to prepare. Fortunately, xmgrace provides an easy way out:

-   Take an empty `agr` file and edit its style to suit your needs.
-   Name it `Default.agr` and place it in the
    `~/.grace/templates/` folder. Note that it might be necessary to
    create the folder beforehand.

My actual `Default.agr`, which can be used as a starting point to make
your own custom style, is included in the `misc` folder.

### Upgrade the default colours

The default xmgrace colour palette is quite lackluster, to say the
least. Luckily, it is very easy to change the default colours. Open your
`Default.agr` (see previous section) and look for the `@map color`
lines. Add any line you want (taking care not to have repeated colour
indeces), or change the existing ones. Colours should be specified with
the RGB format and are always fully opaque.

Once you are done just save the file and open `xmgrace`. You will be
greeted by a (hopefully) much more colourful palette!

For instance, the following lines (contained in the `misc/Default.agr`
example file)

    @map color 0 to (255, 255, 255), "white"
    @map color 1 to (0, 0, 0), "black"
    @map color 2 to (227,26,28), "red"
    @map color 3 to (51,160,44), "green"
    @map color 4 to (31,100,180), "blue"
    @map color 5 to (255, 127, 0), "orange"
    @map color 6 to (106,61,154), "violet"
    @map color 7 to (177,89,40), "brown"
    @map color 8 to (220, 220, 220), "grey"
    @map color 9 to (251,154,153), "light red"
    @map color 10 to (178,223,138), "light green"
    @map color 11 to (166,206,227), "light blue"
    @map color 12 to (253,191,111), "light orange"
    @map color 13 to (202,178,214), "lilla"
    @map color 14 to (212,184,127), "light brown"
    @map color 15 to (139, 0, 0), "red4"
    @map color 16 to (0, 139, 0), "green4"
    @map color 17 to (0, 0, 139), "blue4"
    @map color 18 to (139, 139, 139), "grey4"

generate the colour palette shown below

![The colour palette specified in the
`/misc/Default.agr`](images/xmgrace_palette.png)

**Nota Bene:** the colour palette of old plots (or of plots generated on
computers that use a different `Default.agr`) will not be affected.
However, plots generated with your own style will look the same wherever
you (or anyone else) will open them!

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

Glossary
========

<a id="filesystem" class="glossary_entry">Filesystem</a>

:   The data structure used by the OS to manage and provide access to
    the files and directories to a user
    ([wikipedia](https://en.wikipedia.org/wiki/File_system))

<a id="script" class="glossary_entry">Script</a>

TODO

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
