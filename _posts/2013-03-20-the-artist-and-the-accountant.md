---
layout: post
title: The Artist and The Accountant
date: 2013-03-20
---

There are two warring factions in your mind. They go by different names: Left/Right Brain, Creative/Analytic. I refer to them as the artist and the accountant. The artist is in charge of being violently creative, impulsive, and messy. The accountant is in charge of being organized, careful, and by-the-book. They're both necessary parts of your psyche, but either one can get in the way of doing good work.

# The Problem

I've noticed I tend to overthink projects. There's a very real danger in trying to do things *too* correctly when first starting out on a new project. It can cause analysis paralysis, catching your mind in an infinite loop of mapping things out in the hopes that you can save yourself some frustration later on. It's become clear to me that it's more important to get something written and iterating early than it is to get everything right at first.

Nearly every programming project I start, I'll get out a sheet of paper and start mapping things out. UI, data structures, program flow. Anything that can be written before code. I was taught that it's easier to move a diagram around than code and to try and have a correct design as often as possible.

The problem with this is that you are never truly sure of what you want until at least the first working version. You won't understand the problem domain until then. You won't understand the data structures needed. You may have an idea, and you can even be damn sure of this idea, but there will always be something that needs to change. By giving yourself permission to turn in a [shitty first draft][draft], you gain the speed and inertia that would otherwise keep you from starting your better second draft.

I said *nearly* every programming project earlier. I make this distinction because every successful private project I've completed has followed the same basic process:

1. Simple hack.
2. Expanded hack.
3. Rewrite into a respectable program.

Every one of them. I think there's a lesson here. 

# The Artist

At first, you need to let the artist take over. The artist is messy and creative. He doesn't care that all your dependencies are intertwined and that your classes and methods have more than one responsibility. He's fine with your tests being shoddy or \*gasp\* even non-existent. He's out to create something beautiful. He's short-sighted, but is full of enthusiasm. That's what you need at the beginning of a project.

# The Accountant

Once you have something that you can look at and say, "Man, this is starting to get somewhere," that is the point to switch to the accountant. The accountant is the part of you that looks for *correctness*. He's the one that adds tests. He's the one that reminds you ["Don't Repeat Yourself"][dry] and to keep to the [Single-Responsibility Principle][srp]. He'll allow your program to be tested, refactored, and extensible. If the artist is in charge of making sure the program's actions are beautiful, the accountant is in charge of making your code beautiful.

As [Joe Simmons][looper] said, "[...]This is a precise description of a fuzzy mechanism." You'll switch back and forth between the two during the course of your projects. When you need to make progress, you'll call in the artist. When you feel things getting dirty or when you have already made progress, you'll call in the accountant. I still stumble on which from time to time, and I don't get it right nearly as often as I'd like. 

However, I'm starting to believe that the path to expertise is in knowing when to switch.

[srp]: http://en.wikipedia.org/wiki/Single_responsibility_principle
[dry]: http://en.wikipedia.org/wiki/Don't_repeat_yourself
[draft]: http://wrd.as.uky.edu/sites/default/files/1-Shitty%20First%20Drafts.pdf
[looper]: http://www.imdb.com/character/ch0235637/quotes
