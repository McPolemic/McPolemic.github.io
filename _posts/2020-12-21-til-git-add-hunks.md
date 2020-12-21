---
layout: post
title: TIL More Options For Git Staging
date: 2020-12-21
---

TIL some of the more advanced prompts when staging things in Git. I tend to use `git add -p .` because it shows changes per hunk rather than per file or all at once. You can use `y` or `n` so stage or leave a portion of code unstaged.

But today I'm doing a lot of refactoring and I wanted to commit things in a certain order (easy changes first, then a commit per type of change I made). This prompts per hunk rather than per file, so I wasn't always sure if I wanted to stage a change or not without looking at the rest of the file's changes.

Here's some cool commands you can use at the `git add` prompt:
* `j` => Skip this hunk and leave it undecided. Move on to the next hunk. It'll come back in the listing after you've run through every hunk in a file.
* `d` => Skip this hunk and all remaining hunks in a file.
