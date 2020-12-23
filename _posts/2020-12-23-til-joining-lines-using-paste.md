---
layout: post
title: TIL Joining lines using paste
date: 2020-12-23
---

Today I had a need to join lines returned from a command-line app (similar to
Python's `','.join(array)`). I'd typically use something like `tr`, but that
also converts the last line to a comma.

```bash
$ my_command
first_identifier
second_identifier
third_identifier

$  my_command | tr '\n' ','
first_identifier,second_identifier,third_identifier,%
```

After some searching, I discovered the `paste` utility. As the man page states:

> The paste utility concatenates the corresponding lines of the given input
> files, replacing all but the last file's newline characters with a single
> tab character, and writes the resulting lines to standard output.

It allows changing the delimiter as well as taking input from STDIN, so this
allowed me to use this instead.

```bash
$  my_command | paste -sd ',' -
first_identifier,second_identifier,third_identifier
```
