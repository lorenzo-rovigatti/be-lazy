
# SSH

Connecting through [`ssh`](https://en.wikipedia.org/wiki/Secure_Shell) to a remote machine (be it your office computer, home desktop or HPC cluster) is one of the most common operations in the daily routine of many people who do this job. If you are one of these people, you will likely find yourself `ssh`-ing to this or that computer quite often. If you have an account `lorenzo` on the `powercluster.cool.univ.com` machine, you can use the following command to establish a remote connection with it[^ssh_openssh]

    $ ssh lorenzo@powercluster.cool.univ.com

You will then be asked to input your password after which you will be given a shell on the remote machine. Some cautious (paranoid?) sys-admins like to disable the 22 port on which the ssh [daemon](https://en.wikipedia.org/wiki/Daemon_(computing)) listens by default. If you try to connect to a remote machine and you receive a `Connection refused` error, this might be way. In order to connect through another port (port 123456, for instance) use the `-p` option, like this:

    $ ssh -p 123456 lorenzo@powercluster.cool.univ.com
    
**Nota Bene:** if you are using `scp` to copy files from/to a remote machine that accepts `ssh` connections only through a non-22 port, make sure you add `-P port` (with a capital `P`) and not `-p port` like you would do with `ssh`.

## How to avoid wasting time

If you find yourself typing the commands written above over and over, you will quickly realise how annoying it can get, especially if you have multiple computers you often connect to[^ssh_open_connections]. There are two (complementary) ways to save a lot of keystrokes:

1. Set up ssh keys
2. Set up the list of hosts in the ssh config file

### SSH keys

### SSH config file

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
    
The most useful escape sequence is undoubtly `~.` (a tilde followed by a dot), which terminates the connection even when the terminal is unresponsive. This comes in very handy when either your connection or the remote machine's connection goes down and you want to get your terminal back.

**Nota Bene:** `~` (the tilde character) should be the *very* first character on the command line.

[^ssh_openssh]: In the following I will assume you are using the [OpenSSH][https://www.openssh.com/] client
[^ssh_open_connections]: It is not uncommon (at least not for me :smile:) to have ten or more open connections at once!
[^ssh_escape]: [https://lonesysadmin.net/2011/11/08/ssh-escape-sequences-aka-kill-dead-ssh-sessions/amp/](https://lonesysadmin.net/2011/11/08/ssh-escape-sequences-aka-kill-dead-ssh-sessions/amp/)
