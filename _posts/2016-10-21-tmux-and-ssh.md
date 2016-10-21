---
layout: post
title: SSH-Agent And tmux
date: 2016-10-01
---

```
~ $ git pull
Permission denied (publickey).
fatal: Could not read from remote repository.

Please make sure you have the correct access rights
and the repository exists.
~ $
```

Ugh. It's happened again. I use public keys to authenticate to GitHub. I use tmux for pairing. Somehow, tmux and ssh-agent are fighting over whether they can authenticate me. 

# Why?

## Public Keys

My GitHub key pairs are protected with a password. Typing it in is tedious, so I use ssh-agent to store the credentials while I'm logged in. SSH has a nifty feature called "Agent Forwarding" that will forward key requests on remote servers through an SSH tunnel to a locally running ssh-agent process. You can use it by passing the `-A` flag to ssh.

SSH forwards an agent by setting up a temporary socket file in your temp directory. It sets a few environment variables, primarily `SSH_AUTH_SOCK`. It sends requests to that socket. This temporary socket is wiped out when you end the SSH session (or the process ends by timing out), and you'll get a new one the next time you SSH back in.

```
~ $ ssh -A puck.local
Last login: Wed Oct 19 07:19:46 2016 from 192.168.1.14
~ $ echo $SSH_AUTH_SOCK
/tmp/ssh-4ubDInuAFh/agent.30599
~ $
```

## tmux

tmux is a great tool to creates a persistant, splittable, sharable interface to a terminal. It allows you to create a running terminal instance that survives you logging out, letting you keep an editor setup running even if you disconnect. 

Unfortunately, it's power is also it's failing. tmux allows you to run programs longer than your current SSH session, which causes a number of environment variables to go stale.

## Running Processes

When you run a process, you're actually forking the existing process, creating a parent and child. The parent continues on. The child process will load and run the new program, getting a copy of all existing environment variables (as well as access to file handles, etc). This is how programs we run have receive environment variables. This is why you can't edit environment variables outside of an already running process (or at least without a debugger connected to that process).

Now, tmux also lets you store and retrieve environment variables. There's a list of environment variables that are automatically updated every time you create or join a new tmux session. In fact, if you create a new window or pane on an old SSH session, it will give the current SSH_AUTH_SOCK variable for you.

That leaves old windows and panes, though. For that, we have two possible solutions.

## Just set the variable already

One way is to create a bash function that can query tmux and get the current value of these variables. 

<blockquote class="twitter-tweet" data-conversation="none" data-lang="en"><p lang="en" dir="ltr"><a href="https://twitter.com/McPolemic">@McPolemic</a> I just ended up with this function for tmux + agent issues:<br><br>fixssh() {<br> eval $(tmux show-env -s |grep &#39;^SSH_&#39;)<br>}</p>&mdash; Josh Greenwood (@JoshTGreenwood) <a href="https://twitter.com/JoshTGreenwood/status/786251510099214336">October 12, 2016</a></blockquote> <script async src="//platform.twitter.com/widgets.js" charset="utf-8"></script>

Props to Josh Greenwood for not only solving this problem but also fitting the fix into a tweet 😄. Unfortunately, that also means that every time you connect to tmux, you'll have to run this. In every window. In every pane. That can get a little repetitive. I was hoping to make this a little more automatic.

## The socket shouldn't really move

There are legitimate reasons to set the socket via temp files. It allows multiple SSH connections per user to have different ssh-agent settings for one. However, I don't need that. Let's disable that first. SSH allows you to create a file on the remote server with commands to run when you connect.

In `~/.ssh/rc`

``` 
#!/bin/bash

# Fix SSH auth socket location so agent forwarding works with tmux
if test "$SSH_AUTH_SOCK" ; then
  ln -sf $SSH_AUTH_SOCK ~/.ssh/ssh_auth_sock
fi
```

Good. Now we'll always have our most recent agent socket symlinked to `~/.ssh/ssh_auth_sock`. Now we want to tell tmux to use that tunnel.

In `~/.tmuxrc`

```
setenv -g SSH_AUTH_SOCK $HOME/.ssh/ssh_auth_sock
```

Now, while we may have to set this variable in any pre-existing windows, it will always be up-to-date going forward. As we disconnect and reconnect, our symlink will switch to the most recent `SSH_AUTH_SOCK` temp file.

This has a trade-off as well, though. Since it always takes the most recent socket, if you were to SSH in and disconnect, all sessions would be broken until you SSHed in again. I consider this a fair trade, though.

## Bonus

> Wait. I see more than one temporary-socket-looking-file in that /tmp folder. Does that mean I can access other user's SSH credentials?

Yes, sort of. If you have sudo access, you could use those sockets to authenticate requests for SSHing into other hosts or accessing certain resources on GitHub and other hosts. Do keep that in mind, and please don't forward on an agent connection if you don't trust a host or the people who have access to it.


(Many thanks to Josh Greenwood and Raelyn Bangel for help with this post!)
