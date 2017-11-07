---

# SSH

Connecting through [SSH](https://en.wikipedia.org/wiki/Secure_Shell) to a remote machine (be it your office computer, home desktop or HPC cluster) is one of the most common operations in the daily routine of many people who do this job. If you are one of these people, you will likely find yourself SSH-ing to this or that computer quite often. If you have an account `lorenzo` on the `powercluster.cool.univ.com` machine, you can use the following command to establish a remote connection with it[^ssh_openssh]

```bash
$ ssh lorenzo@powercluster.cool.univ.com
```

You will then be asked to input your password after which you will be given a shell on the remote machine. Some cautious (paranoid?) sys-admins like to disable the 22 port on which the ssh [daemon](https://en.wikipedia.org/wiki/Daemon_(computing)) listens by default. If you try to connect to a remote machine and you receive a `Connection refused` error, this might be way. In order to connect through another port (port 123456, for instance) use the `-p` option, like this:

```bash
$ ssh -p 123456 lorenzo@powercluster.cool.univ.com
```
    
**Nota Bene:** if you are using `scp` to copy files from/to a remote machine that accepts SSH connections only through a non-22 port, make sure you add `-P port` (with a capital `P`) and not `-p port` like you would do with `ssh`.

## How to avoid wasting time

If you find yourself typing the commands written above over and over, you will quickly realise how annoying it can get, especially if you have multiple computers you often connect to[^ssh_open_connections]. There are two (complementary) ways to save a lot of keystrokes:

1. Set up ssh keys
2. Set up the list of hosts in the ssh config file

### SSH keys

I will not delve into the technicalities of SSH keys because I am not expert and because I do not think this is the right place to have such a discussion. If you are interested you can find many resources online, starting, for instance, from [here](https://www.ssh.com/ssh/key/).

Here it suffices to know that you can set up the SSH connection between your local machine and a remote one so that you will not have to enter any password when using it. In order to do so, you will have to first generate an *SSH key* on your local machine. This can be done with the following command

```bash
$ ssh-keygen -t rsa
```

The first thing you will be asked is where to store the key. If you leave the field empty the key will be saved in the `~/.ssh/id_rsa` location, with `~` being your home directory. You will be then asked twice to enter a passphrase, which can be left empty. There can be security reasons why you would want to enter a non-empty passphrase. However, using a non-empty passphrase would defeat the purpose of this section, as it would make SSH ask for that passphrase every time you want to login on the remote machines you have copied your key to. In the following I will assume you saved the key to the default location and did not enter a passphrase during the key generation.

**Nota Bene:** the key you have generated is a (sort of) fingerprint of your user on the *specific* local machine you are generating it on. This means that you have to undergo this procedure once for each computer you connect *from*, regardless of the number of remote machines you will connect *to*.

On many systems there exists the `ssh-copy-id` utility that copies your key over to the right position on the remote machine. If this is your case just call it with the command line options you would use if you were to connect to the remote machine through the usual SSH command. For example,

```bash
$ ssh-copy-id lorenzo@powercluster.cool.univ.com
```
	
or, if you need to use a custom port:

```bash
$ ssh-copy-id -p 123456 lorenzo@powercluster.cool.univ.com
```

if everything goes smoothly this is the last time you will have to enter your password to connect to that specific remote computer :smile:

If your system lacks `ssh-copy-id` you will have to manually add your public key to the list of *authorized keys* stored on the remote machine. In order to do so you will have to 

 1. copy your public key, stored in the `~/.ssh/id_rsa.pub` file (here I am assuming your `ssh-keygen` was told to put the key in the default location). You should expect it to look like this:
    
    <pre>ssh-rsa GIBBERISH lorenzo@lorenzo-desktop</pre>
    
    where `GIBBERISH` is a very long string of seemingly random characters and the last token is just `your_username@your_host`
 2. establish a connection with the target remote machine and, with your preferred editor, open the `~/.ssh/authorized_keys` file. Paste your public key on a new line, save and exit
 
*Et voilà*: SSH will not prompt you for the password when accessing this specific remote machine any more!

**Nota Bene:** the aforementioned procedure lets you SSH passwordlessly from `user_on_A_host@A_host` to `user_on_B_host@B_host`. If you change either the user or the host from which you connect *from*, you will have to redo the proceudre. If you change either the user or the host you connect *to* you will have to update the corresponding `authorized_keys` file by adding the public key you already have.

### SSH config file

In this section we will see how to transform this:

```bash
$ ssh -p 123456 lorenzo@powercluster.cool.univ.com
```
    
Into this:

```bash
$ ssh pc
```
    
Looks neat, doesn't it? With SSH, just open the file `~/.ssh/config` (which may not exist yet) and, for each combination of `user@host` you want to create aliases for, add a few lines that specify the parameters for that specific connection, like this:

    Host pc
    HostName powercluster.cool.univ.com
    User lorenzo
    Port 123456
    
Save and exit. From now on you will be able to use `ssh pc` in place of `ssh -p 123456 lorenzo@powercluster.cool.univ.com`: you do not need to reload or restart anything.

A few comments:

 1. You can omit the `User` and `Port` fields if the default values (the current user and port 22, respectively) are fine
 2. You can set default values for all or some hosts by using wildcards. For example
 
    <pre>
    Host *univ.com
    User rovigatti
    
    Host *
    User lorenzo
    </pre>
    
    **Nota Bene:** the order with which you list the hosts is very important! SSH parses the `config` file from the top downwards and uses the *first* value found for each option whose corresponding `Host` matches the hostname given on the command line. For instance, in the above listing, inverting the order of the hosts will make SSH always use the username `lorenzo`, even for hostnames that match the `*univ.com` pattern.
    
 3. The list of available fields is [here](https://www.ssh.com/ssh/config/). A simpler tutorial can be found here [here](https://www.digitalocean.com/community/tutorials/how-to-configure-custom-connection-options-for-your-ssh-client)

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

[^ssh_openssh]: In the following I will assume you are using the [OpenSSH](https://www.openssh.com/) client
[^ssh_open_connections]: It is not uncommon (at least not for me :smile:) to have ten or more open connections at once!
[^ssh_escape]: [https://lonesysadmin.net/2011/11/08/ssh-escape-sequences-aka-kill-dead-ssh-sessions/amp/](https://lonesysadmin.net/2011/11/08/ssh-escape-sequences-aka-kill-dead-ssh-sessions/amp/)
