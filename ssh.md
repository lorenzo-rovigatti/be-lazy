
# SSH

## Escape sequences

OpenSSH provides a variety of escape sequences that can be used during SSH sessions, even when the terminal is unresponsive [^ssh_escape]. Typing `~?` (a tilde followed by a question mark) during an SSH session will print the list of available escape sequences which, with my OpenSSH client v7.2, looks like

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

**Nota Bene:** `~` (the tilde character) should be the *very* first character on the command line.

[^ssh_escape]: [https://lonesysadmin.net/2011/11/08/ssh-escape-sequences-aka-kill-dead-ssh-sessions/amp/](https://lonesysadmin.net/2011/11/08/ssh-escape-sequences-aka-kill-dead-ssh-sessions/amp/)
