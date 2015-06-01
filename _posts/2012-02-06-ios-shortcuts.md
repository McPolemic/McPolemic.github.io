---
layout: post
title: iOS Shortcuts (and their idiosyncracies)
date: 2012-2-6
---

David Sparks recently wrote an article on [his usage of TextExpander in Omnifocus][sparks].  In it, he writes about curiosities regarding the iOS shortcut system.

> For reasons beyond me, the snippet cannot start with a period (.), 
> so I start them with an “x”. Moreover, you can’t simply insert the
> cursor at the beginning of some text and expand. There must be a 
>leading space. 

From what I've seen, this is because iOS shortcuts are implemented by shoehorning them into the autocorrect system.  This explains a number of things.

1. A shortcut can't contain certain punctuation (period, question mark, space, quote, etc.), as this ends a word and activates a prompted autocorrect.

2. A shortcut doesn't require an actual shortcut to expand (only a phrase), as this just adds the phrase to the autocorrect dictionary.

<img src="http://db.tt/etbcQMbU" alt="iPad Shortcut Dialog" />

It's a pity that we don't have system-wide TextExpander support, but hopefully it will at least be available via Omnifocus on iOS in the near future.

[sparks]: http://www.macsparky.com/blog/2012/2/1/text-expander-and-omnifocus.html
