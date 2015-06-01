---
layout: post
title: Home Automation with Redis Pub/Sub
date: 2015-01-04
---

I've been thinking a lot about home automation lately. Turning lights on when you enter rooms, turning the television on and off from your smart phone, making sure the doors are locked when you're not home - there's a lot of use cases I'm interested in.

I've read a number of articles where people will do one of the above. The order is usually the same:

1. Get an Arduino/Raspberry Pi.
2. Wire it up to power.
3. Turn it on and off with a simple switch.

That didn't excite me very much. Some people went through the trouble of giving it a web front-end, so you could open `http://192.168.12.34/` to view or change the device. That's getting closer, but it's a little... user hostile. I don't want to remember random IP addresses, especially if I'll have more than one device in the house ("Was that the garage door I just turned on, or the coffee pot?").

I then came across an article titled ["Building a home automation system - The broker and sensors"][home_automation] by Stian Eikeland. He talks about having a central server that all devices can send their information to. It, in turn, will publish all received data. When you want to do something with the data, you simply connect to the central server and subscribe to the events you're interested in.

I have a number of Sonos speakers around the house and decided that would be a good testbed for how this sort of system would work. I can publish what's currently playing on each speaker to the central server. From there, various tools can connect to get the information. Perhaps in the future I'll even send out controlling events.

In lieu of ZeroMQ, I opted for Redis Pub/Sub. No particular reason why other than I already had the Redis gem installed and didn't want to learn a new API on top of trying this out.

First, I built the Sonos watcher. I used the awesome [Sonos][sonos] gem, which took away a large bit of difficulty actually interacting with the speakers. From there, the code was relatively easy:

<script src="https://gist.github.com/McPolemic/b7bf0a227736fad45613.js"></script>

After running the listener, we can see some of the output by running `redis-cli monitor`:

```
Watching Bedroom for changes...
Watching Kitchen for changes...
Watching Nika's Room for changes...

{:speaker=>"Nika's Room", :is_playing=>true, :song=>{:title=>"Angie", :artist=>"Rockabye Baby!", :album=>"Lullaby Renditions of The Rolling Stones", :info=>"", :queue_position=>"87", :track_duration=>"0:03:06", :current_position=>"0:00:22", :uri=>"x-sonos-spotify:spotify%3atrack%3a61BcO6t63xsc0x4bKNrHeZ?sid=12&flags=32&sn=2", :album_art=>"http://192.168.1.30:1400/getaa?s=1&u=x-sonos-spotify%3aspotify%253atrack%253a61BcO6t63xsc0x4bKNrHeZ%3fsid%3d12%26flags%3d32%26sn%3d2"}}
{:speaker=>"Kitchen", :is_playing=>true, :song=>{:title=>"Frei", :artist=>"Schandmaul", :album=>"Anderswelt", :info=>"", :queue_position=>"2", :track_duration=>"0:04:06", :current_position=>"0:02:54", :uri=>"x-sonosprog-http:station-song%3a1404502%2f16586533.mp4?sid=29&flags=32&sn=4", :album_art=>"http://192.168.1.6:1400/getaa?s=1&u=x-sonosprog-http%3astation-song%253a1404502%252f16586533.mp4%3fsid%3d29%26flags%3d32%26sn%3d4"}}
{:speaker=>"Bedroom", :is_playing=>true, :song=>{:title=>"Prelude No 4 In E Minor Op 28", :artist=>"Frédéric Chopin", :album=>"The Soloist - Classical Masters", :info=>"", :queue_position=>"2", :track_duration=>"0:02:05", :current_position=>"0:01:32", :uri=>"x-sonosprog-http:station-song%3a1395850%2f5496553.mp4?sid=29&flags=32&sn=4", :album_art=>"http://192.168.1.5:1400/getaa?s=1&u=x-sonosprog-http%3astation-song%253a1395850%252f5496553.mp4%3fsid%3d29%26flags%3d32%26sn%3d4"}}
{:speaker=>"Nika's Room", :is_playing=>true, :song=>{:title=>"Angie", :artist=>"Rockabye Baby!", :album=>"Lullaby Renditions of The Rolling Stones", :info=>"", :queue_position=>"87", :track_duration=>"0:03:06", :current_position=>"0:00:22", :uri=>"x-sonos-spotify:spotify%3atrack%3a61BcO6t63xsc0x4bKNrHeZ?sid=12&flags=32&sn=2", :album_art=>"http://192.168.1.30:1400/getaa?s=1&u=x-sonos-spotify%3aspotify%253atrack%253a61BcO6t63xsc0x4bKNrHeZ%3fsid%3d12%26flags%3d32%26sn%3d2"}}
{:speaker=>"Bedroom", :is_playing=>true, :song=>{:title=>"Prelude No 4 In E Minor Op 28", :artist=>"Frédéric Chopin", :album=>"The Soloist - Classical Masters", :info=>"", :queue_position=>"2", :track_duration=>"0:02:05", :current_position=>"0:01:32", :uri=>"x-sonosprog-http:station-song%3a1395850%2f5496553.mp4?sid=29&flags=32&sn=4", :album_art=>"http://192.168.1.5:1400/getaa?s=1&u=x-sonosprog-http%3astation-song%253a1395850%252f5496553.mp4%3fsid%3d29%26flags%3d32%26sn%3d4"}}
{:speaker=>"Kitchen", :is_playing=>true, :song=>{:title=>"Frei", :artist=>"Schandmaul", :album=>"Anderswelt", :info=>"", :queue_position=>"2", :track_duration=>"0:04:06", :current_position=>"0:02:54", :uri=>"x-sonosprog-http:station-song%3a1404502%2f16586533.mp4?sid=29&flags=32&sn=4", :album_art=>"http://192.168.1.6:1400/getaa?s=1&u=x-sonosprog-http%3astation-song%253a1404502%252f16586533.mp4%3fsid%3d29%26flags%3d32%26sn%3d4"}}
```

We're getting some decent information from just that small amount of code. From here, I created a small program to parse the data and show what was playing in each room. 

<video width=480 autoplay=true src="https://www.dropbox.com/sc/sezzmqvg5hp2wqy/AACaS554VbNDnGNUlCGDcpPsa/0?dl=1"></video>

I ended up really liking the idea of having a single server to publish events to. I can have a collection of small programs all sending and listening for events. It can be as simple as a generic way to get music information, or I can think grander by listening to more events (such as Stian's article above proposing aggregating temperature readings). It was a fun way to spend an hour or so, and I'm hoping I'll build this out into a better, more cogent system.

[home_automation]: http://blog.eikeland.se/2012/09/24/building-a-home-automation-system-the-broker-and-sensors-part-2/
[sonos]: https://github.com/soffes/sonos
