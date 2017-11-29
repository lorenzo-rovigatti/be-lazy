---

# Bash

In the following I will assume that Bash is the default [shell](#shell) of your system and that you know how to start a new terminal, which usually boils down to writing "terminal" in your OS' search bar and starting up the first search result.

[Bash](https://www.gnu.org/software/bash/) is probably the most common [Unix shell](https://en.wikipedia.org/wiki/Unix_shell). It is the default login shells of many LInux distributions, as well as of Apple's Mac OS X. For our purposes, Bash is the command line through which we communicate with and operate on the files and directories stored on the [filesystem](#filesystem).

**Nota Bene:** `man COMMAND` will show the manual associated to `COMMAND`, listing all the supported command-line arguments, the most common use-cases and some examples. Use the `man` command as often as possible, and **never** use a command without knowing what it does.

## Commands and programs

**Nota Bene:** Many commands (most of the default ones) support combining switches  when used in their short form. For example, `ls -lhS` is equivalent to `ls -l -h -S`.

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

### `cd`

* `cd ..` move to the parent of the current working directory
* `cd -` move back to the previous working directory
* `cd` or `cd ~` move to your home directory

### `ls`

`ls` is very powerful. Its output can be finely tuned by using the appropriate switches. Here are some of the switches (and switch combinations) I find most useful:

* `ls -lrth` show the entries in a long listing format (`-l`) with their size in human-readable form (`-h`) and sorted by reverse (`-r`) modification time (`-t`). 
* `ls -S` sort the entries by size (from large to small). Use `-r` to reverse the sorting
* `ls -1` list one entry per line
* `ls -d` list the directories themselves, not their content. File entries are not affected

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

### Piping

If you follow the Unix philosophy, you will often need to feed a program with the output of another program. This is called *piping* and it is done through the `|` (pipe) symbol. The pipe tells the shell to redirect the standard output of the command on the left-hand side of the pipe  to the standard input of the command which is on the right-hand side of the pipe. For instance, take a directory containing a lot of files and/or folders. Imagine you want to have a look at the contents of the directory. This can be done by piping the output of `ls` (here complemented by the `-1` argument which tells `ls` to list one entry per line) to `less`, which is used to page through text, in this way:

```bash
ls -1 | less
```

Use the arrow keys or the page-up/page-down buttons to page through the text and `q` to quit.

Do not be deceived by the simplicity of the above example: the possibility of chaining together different processes is at the core of the Unix philosophy and makes it possible to easily create extremely complicated and powerful *pipelines* (that is, sequences of processes linked together by `|`). For instance, the following pipeline uses 

1. `grep` to extract from the `prova.dat` file only those lines that contain integer numbers
2. `sort` to numerically sort them
3. `tail` to take the two largest numbers
4. `awk` to print the average of these two values

```bash
grep -E "^[0-9]+$" prova.dat | sort -n | tail -n 2 | awk '{a+=$1; t++} END {print a/t}'
```

You do not have to understand all the details, but just realise the sheer power of being able to combine the multitude of basic commands that a modern Linux shell provides.

## Aliases

With Bash it is possible to create shortcuts (aka *aliases*) for commands which are used often, difficult to remember or both. This can be easily done by using the `alias` built-in. For example, many versions of the `ls` command can colorise their output by passing it the `--color=auto` switch. On many Linux distributions (*e.g.* Ubuntu), `ls` is just an alias to `ls --color=auto`, set with:

```bash
alias ls='ls --color=auto'
```

I do not use many aliases, but the ones I cannot do without are

```bash
alias 'cp=cp -i'
alias 'mv=mv -i'
alias 'rm=rm -i'
alias 'll=ls -lh'
alias 'ssh= ssh -Y'
```

The `-i` in the first three makes them ask the user before overwriting or deleting any files. This makes it harder (but not impossible) to do stupid mistakes. The effect of `-i` can be counteracated by `-f`: `rm -f .` will *not* ask confirmation to delete all the files in the folder!

The `-Y` switch passed to `ssh` enables X11 forwarding. In other words, makes it possible to remotely open applications that have X11-compatible graphical interfaces (*e.g.* plotting tools).

If called without arguments, `alias` prints a list of the currently-defined aliases. `unalias` removes a previously-set alias. By default, once an alias has been defined, it will live till it is unaliased or the terminal it was defined in is closed. In order to make an alias permanent, put its definition in the `.bashrc` or `.bash_profile` files in your home folder. See [.bashrc](#making-things-permanent-.bashrc) for more details.

## ~~Making things permanent: .bashrc~~

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
