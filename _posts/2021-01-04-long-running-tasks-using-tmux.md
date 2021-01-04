---
layout: post
title: Long-running Tasks Using Tmux
date: 2021-01-04
---

A lot of folks use [tmux][tmux] to have a number of terminals grouped together for a given purpose, but I think an undersung feature is the ability to spin up a session that will run until finished without having to background/disown it.

For any long-running task, you can start it in a tmux session by running it as `tmux new <command> <arg1> <etc>`. It will spin up a new tmux session, run the command, and automatically close the session when it completes. You can even start it detached with `tmux new -d <command>`.

[tmux]: https://github.com/tmux/tmux/wiki
