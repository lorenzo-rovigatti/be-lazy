---

# Bash

In the following I will assume that Bash is the default [shell](#shell) of your system and that you know how to start a new terminal, which usually boils down to writing "terminal" in your OS' search bar and starting up the first search result.

[Bash](https://www.gnu.org/software/bash/) is probably the most common [Unix shell](https://en.wikipedia.org/wiki/Unix_shell). It is the default login shells of many LInux distributions, as well as of Apple's Mac OS X. For our purposes, Bash is the command line through which we communicate with and operate on the files and directories stored on the [filesystem](#filesystem).

## Files and directories

The first task you will likely use the shell for is to browse through the [filesystem](#filesystem) to work with files and directories (create, delete, move or edit them, execute programs, *etc.*). Think of the filesystem as a tree-like structure: leaves are files, branches are directories (and leaf-less branches are empty directories). An example of a part of a filesystem (as output by the `tree` command), with directories being coloured in blue and files in black is

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

In [*nix](#unix-like) systems, the filesystem tree starts in the directory indicated by `/`, which is aptly called the *root* directory. When you open a shell (or a terminal), you will be placed in a starting directory which, most likely, will be your own home directory. By default, its path is `/home/your_username` (*e.g.* `/home/lorenzo`).

You can use the `pwd` command, which prints to screen the name of the (current) working directory, to find out where you are. The same can be achieved by printing the `PWD` environment variable (`echo $PWD`), which Bash sets to the current directory every time the working directory is changed.

You can change the current directory with the `cd` command. If you want to move to the `other_dir` directory just type `cd other_dir`. `cd` accepts both absolute and relative paths.

## Redirection and piping

The main strength of Bash (and of all the other shells) comes from the [Unix philosophy](https://en.wikipedia.org/wiki/Unix_philosophy), which can be summarised as [^bash_philosophy]

> 1. Write programs that do one thing and do it well.
> 2. Write programs to work together.
> 3. Write programs to handle text streams, because that is a universal interface.

Most of the command-line utilities that can be find in a Unix-like environment (such as Linux, BSD, Mac OS X) follow, more or less closely, this philosophy. As a consequence of the wide adoption of the principles listed above, many of said utilities can perform only very specific duties. Moreover, most of the communication to and from these programs is text-based and carried out through their input and output streams. It is therefore very common to split the task at hand in *subtasks* that are performed by several programs in a serial fashion: each program manipulates an input and pass the resulting output to the next program. The mechanism that makes it possible to forward the output of a program to the input of another program is called *piping* and is signalled by the presence of the pipe sign, ~|~. At the end of this process it is a common patter to *redirect* the final output to a file.

### Input/output redirection

There are three standard input/output (I/O or just IO) streams: the standard input, or `stdin`, the standard output, or `stdout`, and the standard error, or `stderr`:

* `stdin` is used to acquire (possibly interactive) input (see *e.g.* the `scanf()` or `fscanf(stdin)` C functions)
* `stdout` is to print the *regular* output of the program (see *e.g.* the `printf()` or `fprintf(stdout)` C functions)
* `stderr` is for printing warnings, diagnostics or error messages (see *e.g.* the `fprintf(stderr)` C function)

In Bash, the default behaviour for programs that expect input is to prompt the user for input. However, the `stdin` can be redirected by using a `<` sign. For example, a program `my_program` that reads from the standard input can be instead fed a file `my_input.txt` by using `my_program < my_input.txt`.

For the output streams, the default behaviour is to write them on screen. In order to redirect a output stream to file, use the `>` sign. For example, `echo "Hello beauty!" > msg.txt` will put the `"Hello beauty"` text in the `msg.txt` file.

By contrast, the `stderr` can be redirected by using the `2>` token. For example, `ls wrong_file 2> error.txt` will put an error message (provided there is no file or directory named `wrong_file` in the current directory :smile:) in the `error.txt` file.

It is possible to redirect **both** `stdout` and `stderr` streams by using the `&>` sign. 

In general, all the above output redirection signs will write the output of the programs that are on their left-hand side to the files whose name is on their right-hand side, possibly overwriting any previous content. In order to *append*, rather than write, the output to those files is sufficient to add a `>` to each token. Thus, `>` becomes `>>`, `2>` becomes `2>>` and `&>` becomes `&>>`.

**Nota Bene:** all multi-character tokens used for redirection should not contain spaces. In other words, be careful: `&>` and `& >` are **not** the same thing.

### ~~Piping~~

## ~~"if" statements~~

## ~~"for" loops~~

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
