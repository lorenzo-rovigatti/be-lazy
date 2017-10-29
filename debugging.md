---

# Debugging

## GDB

Here is a a very short and non-comprehensive list of useful GDB commands:

* `break example.c:22` create a breakpoint at line 22 of the file `example.c`.
* `break example.c:22 if i == 100` create a conditional breakpoint. It gets triggered only when the condition is met.
* `where` print the stack-trace after a segfault (or similar error).
* `up/down` move up (down) the stack-trace.
* `ptype` output the type of a variable.
* `info locals` display the name and value of all local variables.
* `disable 1` disable breakpoint number 1.
