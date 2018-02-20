---
layout: post
date: 2018-02-20
title: Music Cards
---

# Music Cards

Our family loves music. We almost have some sort of music going on in the background at our house. We have a number of Sonos speakers and subscriptions to the major music providers, giving us a lot of flexibility in what to listen to and where. 

Unfortunately, having the world's music at the ready has some downsides. Especially if you're four years old.

This is Nika. She also loves music. Unfortunately, she does not yet know how to read, which is a real pain when she wants to pick out music. One option would be to buy CDs, but then she has to keep them from getting scratched and remember which tracks are the songs she likes. Also, we'd have to buy a huge amount of CDs (or burn a similar number of CDs) and a CD player when we already have three subscription music services and speakers throughout the house. I hoped for a better way.

## Hardware

What I wanted was something sturdier and cheaper than CDs. I don't really need them to _store_ audio. We have Spotify for that. I'd rather they just _identify_ what audio Nika would like to play.

RFID cards were a good candidate than this. They're sturdy, relatively cheap (I bought 50 for $13), and have good support for USB readers. I bought [this RFID reader](https://www.amazon.com/gp/product/B018C8C162/ref=oh_aui_detailpage_o02_s00?ie=UTF8&psc=1) and [these RFID cards](https://www.amazon.com/gp/product/B00GXV4IGC/ref=oh_aui_detailpage_o03_s01?ie=UTF8&psc=1). I hooked them both up to a Raspberry Pi 3 running Raspbian.

![RFID card reader and RFID cards](https://www.dropbox.com/s/edw1sjop1upsm7n/cards%20and%20reader.jpg?dl=1)

Each RFID card has a serial number encoded in it. This is the value the reader will be picking up. The RFID reader acts like a USB keyboard. When you scan one of the cards, it "types" in the eight character serial number printed on the front of the card. We'll map that eight digit code to a song, album, or playlist that Nika wants to play and send that to a specified speaker.

## Software
_Disclaimer: This is a hobby project. There are no tests. It's not well-factored. I hope it helps you all the same._

The full code is located here: [https://github.com/McPolemic/nika_tunes/](https://github.com/McPolemic/nika_tunes/)

It consists of two parts: a [`reader.py`](https://github.com/McPolemic/nika_tunes/blob/master/reader.py) that connects to the USB reader and outputs the serial numbers, and [`nika_tunes.rb`](https://github.com/McPolemic/nika_tunes/blob/master/nika_tunes.rb), which reads in the unique codes, looks up songs via Spotify, and plays them.

I didn't realize I'd need `reader.py` at first. I was going to read the codes from STDIN. Unfortunately, I didn't think ahead. When I started putting things together, I realized that I wanted this to work without logging in (which means no STDIN). I needed to read raw keys from the RFID reader, which means digging down into Linux's `evdev` system. I looked through Rubygems but didn't find a library that worked to my liking. Luckily, Python has quite good `evdev` support, so I wrote this small script to handle decoding keyboard events into strings.

The output is piped into `nika_tunes.rb`, which has the bulk of the logic.

This file has three classes:
* Spotify
* Jukebox 
* CodeReader

`Spotify` is a wrapper for the `rspotify` gem. It handles searching for individual songs and playlists. Searching takes between 1/10th and 1/4 of a second, which can add up, so it also handles caching the results locally. Once we have the result saved, it takes around 1/1000th of a second.

`Jukebox` wraps all interactions with the Sonos speakers. It takes in a speaker name and a Spotify wrapper. Notably, because I ran into some problems getting the `sonos` gem to work with Spotify URLs, it handles the less-than-pleasant encoding workarounds.

Finally, `CodeReader` orchestrates the whole thing. It has a dictionary that maps between our unique codes (e.g. '08931021') and the action we'd like the jukebox to play (`jukebox.play_spotify_track('Remember Me')`). By using Spotify to search for the track instead of encode specific tracks, I've (hopefully) made it easier to read and easier to manage down the road as we add more songs and albums. It runs forever in the `repl` method, which waits for input, runs the resulting action, and repeats.

## Result

By scanning a card, it finds and plays the specified song pretty quickly.

<iframe width="560" height="315" src="https://www.youtube.com/embed/bZl9W__iSDY" frameborder="0" allow="autoplay; encrypted-media" allowfullscreen></iframe>

We printed out pictures and glued them to the various RFID cards. I started out with nine to see how she felt.

![The RFID reader and RFID cards with graphics glued on the front](https://www.dropbox.com/s/bpdbox5iw9ruspv/assembled%20reader.jpg?dl=1)
![A text message from Liz stating, "Nika is really excited about her 'music cards'. :)"](https://www.dropbox.com/s/cj8cuvnec374gdd/nika_excited.jpg?dl=1)

## Challenges

Often, I feel like posts like this don't delve enough into the challenges someone can run into, making it feel like everything went swimmingly. I ran quite a few challenges, which are worth mentioning for a second. 

* I didn't realize RFID cards and readers have different frequencies and bought the wrong reader at first. I returned it and bought the right one.
* I thought I could always read from STDIN. Only after assembling it did I realize I'd have to read directly from the keyboard.
* Sonos apparently rolled out some encrypted method of retrieving metadata from Spotify, breaking third-party integration. I don't really understand this, but it means that I have to escape the URL and do without song/artist name in the Sonos controller. In practice, this isn't a big deal.
* I was really worried about the responsiveness of this. If Nika scanned a card and it played two seconds later, it would feel broken. I ended up adding a lot of timing logging and caching to ensure it feels snappy.
* I originally used Nika's glitter glue to glue the printed out pictures to the RFID cards. You can imagine my surprise when I realized glitter glue doesn't work super well. Luckily, Liz has more craft experience than I do and had some recommendations.
I used Docker so I could develop on my fast desktop and then deploy it to the Raspberry Pi. I didn't realize/remember that they are different platforms (x86 vs ARM), which comes with a whole mess of problems. I still like Docker for packaging, but I should've moved it sooner onto the Raspberry Pi.

## Future Plans

Of course, now that it's a hit, the first thing she wants is more songs! While editing the source code and redeploying is _okay_ for now, I think I'm going to want to move the lookup from unique code to action. It likely belongs in a SQLite database with a small web frontend so that Liz can edit it without too much hassle.
