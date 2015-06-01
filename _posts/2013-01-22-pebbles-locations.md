---
layout: post
title: Pebbles and File Folders
date: 2013-01-22
---

I use AutoHotKey for a lot of things. I'm just a happier person when I don't have to deal with the mundane and repetitive throughout my work day. Since this week started out busy (after a three-day weekend), I'm going to fall back on some more in order to keep with the my ever-ambitious post-a-day schedule. 

I tend to keep a fairly steady number of folders for different types of work. I have my normal Dropbox folders, a folder of work notes, a folder for all paperwork associated with a specific work task. While Windows has a "Favorites" part of its save dialog, it can only hold so many folders before it becomes unwieldy.

You may or may not be aware, but when confronted with an "Open" or "Save" dialog in Windows, you can type in a file path in the filename, and it will navigate to that folder, keeping the original name. We can use this to our advantage and automate a fair amount of locations.

I have an AutoHotKey script that loads on boot called `locations.ahk`. It is full of entries like the following:

	::;ahk::
		SendInput, C:\Users\lukens\Documents\AutoHotkey{Enter}
		return

Once again, you can see that I preface all shortcuts with a semi-colon to ensure I don't accidentally type it. This will type in the path to my AutoHotKey folder and hit enter. It seems like a small and silly thing, but if you compound that to 30-40 paths that you use with muscle memory, you can become very quick. 

If you're constantly navigating to a specific folder, you may consider making a shortcut or snippet for it. It has worked in every Windows application I've tried, even the less reliable Java UIs (I'm looking at you, SQL Developer).
