---

# SSH

Connecting through [SSH](https://en.wikipedia.org/wiki/Secure_Shell) to a remote machine (be it your office computer, home desktop or HPC cluster) is one of the most common operations in the daily routine of many people who do this job. If you are one of these people, you will likely find yourself SSH-ing to this or that computer quite often. If you have an account `lorenzo` on the `powercluster.cool.univ.com` machine, you can use the following command to establish a remote connection with it[^ssh_openssh]

    $ ssh lorenzo@powercluster.cool.univ.com

You will then be asked to input your password after which you will be given a shell on the remote machine. Some cautious (paranoid?) sys-admins like to disable the 22 port on which the ssh [daemon](https://en.wikipedia.org/wiki/Daemon_(computing)) listens by default. If you try to connect to a remote machine and you receive a `Connection refused` error, this might be way. In order to connect through another port (port 123456, for instance) use the `-p` option, like this:

    $ ssh -p 123456 lorenzo@powercluster.cool.univ.com
    
**Nota Bene:** if you are using `scp` to copy files from/to a remote machine that accepts SSH connections only through a non-22 port, make sure you add `-P port` (with a capital `P`) and not `-p port` like you would do with `ssh`.

## How to avoid wasting time

If you find yourself typing the commands written above over and over, you will quickly realise how annoying it can get, especially if you have multiple computers you often connect to[^ssh_open_connections]. There are two (complementary) ways to save a lot of keystrokes:

1. Set up ssh keys
2. Set up the list of hosts in the ssh config file

### SSH keys

I will not delve into the technicalities of SSH keys because I am not expert and because I do not think this is the right place to have such a discussion. If you are interested you can find many resources online, starting, for instance, from [here](https://www.ssh.com/ssh/key/).

Here it suffices to know that you can set up the SSH connection between your local machine and a remote one so that you will not have to enter any password when using it. In order to do so, you will have to first generate an *SSH key* on your local machine. This can be done with the following command

	$ ssh-keygen -t rsa

The first thing you will be asked is where to store the key. If you leave the field empty the key will be saved in the `~/.ssh/id_rsa` location, with `~` being your home directory. You will be then asked twice to enter a passphrase, which can be left empty. There can be security reasons why you would want to enter a non-empty passphrase. However, using a non-empty passphrase would defeat the purpose of this section, as it would make SSH ask for that passphrase every time you want to login on the remote machines you have copied your key to. In the following I will assume you saved the key to the default location and did not enter a passphrase during the key generation.

On many systems there exists the `ssh-copy-id` utility that copies your key over to the right position on the remote machine. If this is your case just call it with the command line options you would use if you were to connect to the remote machine through the usual SSH command. For example,

	$ ssh-copy-id lorenzo@powercluster.cool.univ.com
	
or, if you need to use a custom port:

	$ ssh-copy-id -p 123456 lorenzo@powercluster.cool.univ.com

if everything goes smoothly this is the last time you will have to enter your password to connect to that specific remote computer :smile:

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
