---
layout: post
title: TIL You Can Conditionally Include Git Configs
date: 2020-12-04
---

Cool git thing I learned today: In Git 2.13, you can have conditional includes to set certain options based on the directory you're in. So, I have the following in my main `.gitconfig`

```
[includeIf "gitdir:~/src/project_dir/"]
  path = ~/src/project_dir/.gitconfig_include
```

and `~/src/project_dir/.gitconfig_include` sets my work email, allowing my consulting email to be used everywhere else.

```
[user]
  name = Adam Lukens
  email = adam.lukens@company.com
```

More info here: https://git-scm.com/docs/git-config#_conditional_includes
