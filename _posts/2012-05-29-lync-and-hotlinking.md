---
title: Lync and Hot-linking
date: 2012-5-29
---

Today, an upgrade was pushed out for my company to switch from Office Communicator 2007 to Lync.  This had a number of changes, but the most notable was that contact pictures were enabled by default.  In looking at the preferences screen, I noticed that the picture input wasn't a file browser, but a URL entry field.

!["Lync Settings"](http://dl.dropbox.com/u/1470741/Site/Lync/Lync%20Preferences.jpg)


Managing photos corporation-wide is a difficult thing to do, so I can understand why Microsoft decided to just allow a URL entry and pass the URL to the clients to load.  However, it presents a number of interesting side effects.

One such side effect is that you can change your picture without broadcasting it to others.  By giving a URL you control (in my case, I used Dropbox), you can change the link to another picture when you feel like it.  Lync appears to cache the image until either you restart the client or the owner of the image refreshes it by going into Preferences->My Picture and hitting "Okay" to update the image.  With this understanding, you *could* set up a service that returns a random photo on every request, on a daily basis, etc.  So long as the URL returns a picture file (JPG, GIF), the URL doesn't have to end in a specific extension.  Variety is the spice of life.

Another side effect is that you can track the number of accesses and from what IP address your picture is being pulled from.  After I finished messing with Dropbox and picture refreshing, I changed the link to a [bit.ly](http://bit.ly) link.  When logged in, this allows you to view how often a link is "clicked" (or loaded by a Lync instance), from what country, at what time.  While serving next to no practical purpose, it is fun to watch.

Lastly, since the URL is being passed to the client, there is the possibility of determining private domain names.  Some people take pride in owning their own domain names, and it can be easier to serve files from there rather than from a third-party service.  I haven't had time to delve into the API to determine whether this is scrapable or not yet, but it's something to bear in mind.

Thanks to @Tsunaminoai and @falornan for working with me to determine the limits of what pictures could do in Lync.
