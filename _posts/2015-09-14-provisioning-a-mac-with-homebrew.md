---
layout: post
date: 2015-09-14  
title: Provisioning a Mac With Homebrew
---

I've used OS X for about eight years. In that time, I've had to either provision a new machine or reinstall a few times, and I've always felt the process was a little cumbersome. The first few I merely set up manually. A little later, I tried setting up my machine with [Chef](chef). After not liking how much boilerplate that required, I switched to GitHub's [Boxen](boxen). Unfortunately, that project installed a lot of things via Homebrew in an nonstandard location, meaning that if you install the wrong package using [Homebrew](homebrew) outside of Boxen, it can break things. After realizing that I really like Homebrew, I started considering merely having a large shell script that installed a ton of things that way.

Luckily, it seems [Thoughtbot](thoughtbot) already had that thought and solved it in a much better way via a [Brewfile](brewfile*). 

First, install `brew bundle`:

```
brew tap homebrew/bundle && brew bundle
```

You write out the packages you'd like installed in a Gemfile-esque syntax, like so:

```
brew "ack"
brew "ansible"
brew "brew-cask"
brew "docker"
```

Save that in a file named `Brewfile` and run `brew bundle` to watch everything you'd like installed be set up. I haven't found much that I want that isn't either handled by the Mac App Store or Homebrew, and I [have a decent amount installed](my_brewfile).

I've found this strikes a nice balance between provisioning everything and having to type out everything I want done to my system. Give it a shot!

[chef]: https://www.chef.io/chef/
[boxen]: https://boxen.github.com/
[homebrew]: http://brew.sh/
[thoughtbot]: https://thoughtbot.com/
[brewfile]: https://robots.thoughtbot.com/brewfile-a-gemfile-but-for-homebrew
[my_brewfile]:  https://github.com/McPolemic/dotfiles/blob/master/Brewfile
