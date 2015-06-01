---
layout: post
title: Pebbles and The New Year
date: 2013-1-18
---

I recently read Ted Spence's excellent article entitled ["Fix Your Pebbles"][pebbles]. He implies that it's not the one big problem that ruins your day, but a lot of little problems. One of the biggest investments you can make in your daily job is to fix some of these little problems. This clears the friction from your day, allowing you to focus on the big issues.

Recently, I've moved to a new work laptop, and had to go through the process of setting it up again. I can attest to the notion that having things slightly broken can destroy your productivity. I have a huge number of customizations that put easy, automated on the computer, freeing me to think of the problem at hand.

With this in mind, I've decided that I'm going to try and fix one small thing a day for each remaining work day in January. If this series becomes popular, I'll try and keep going through February. I'll always try to keep these small, understandable, and easily implementable. Hopefully you'll be able to pull some of these into your own workflow.

Today, I'm going to talk about on of my favorites. Every year around this time, I see people complaining about writing the wrong year when they write date. They'll write it in e-mails, work documents, and source code. You don't realize how often you write the date until the year changes. 

As a result, I've used one of my favorite "pebble" programs, [AutoHotKey][ahk]. For this particular problem, I've created a script called "textExpander.ahk" (named after my favorite [Mac and iOS application][Text Expander] that serves a similar purpose). 

<script src="https://gist.github.com/4565273.js"></script>

By way of introduction, all of my shortcuts begin with a semicolon. This ensures that I don't accidentally type them in normal usage. Using the semi-colon (or another memorable prefix) keeps it short and unique. If I named the shortcut "date", then every time I tried to type:

> Date: date

It would expand to:

> 12/25/2012: 12/25/2012


The first shortcut is activated by typing ";dt". This creates a standard date, separated by slashes. The opening options "*?" sets that the snippet can be run even in the middle of the word (which can come in handy sometimes if your editor [uses normal letters to insert text][vim]). Normal, stand-alone snippets use the following format.

	::snippet_to_be_typed::  
		Commands_to_be_run
		return

From there, it uses [FormatTime][FormatTime] to set a variable "CurrentDate" to the format "MM/dd/yyyy". After that, it sends the variable as keyboard input to the current application, and then returns. Sending keyboard input works pretty much anywhere, including SSH applications and command-line prompts. You want to ensure that every snippet ends in "return". Otherwise, it will continue running all of your shortcuts, which is almost certainly not what you want.

The second shortcut follows the same pattern, except it doesn't include slashes and prints the year, month, and day. This is used a lot at work as an easy way to use dates in source code.

Those two snippets have saved hours of typing, re-typing, and complaining about the new year over the last couple of years. They started me on the path to smoothing out my work life. 

Do you have anything you type repetitively that could be shortened or streamlined?

[pebbles]: http://www.altdevblogaday.com/2012/10/21/fix-your-pebbles/
[ahk]: http://www.autohotkey.com
[Text Expander]: http://smilesoftware.com/TextExpander/index.html
[vim]: http://www.vim.org
[FormatTime]: http://www.autohotkey.com/docs/commands/FormatTime.htm
