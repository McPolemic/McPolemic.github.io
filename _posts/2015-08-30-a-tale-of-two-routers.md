---
layout: post
title: A Tale of Two Routers  
date: 2015-08-30  
---

For about two years, I've run two routers. I acknowledge that's weird. Let me explain.

I originally owned a rather old Apple AirPort Extreme. It served me faithfully for a number of years, but I always had signal range problems. When we moved into a house with more than a few rooms, this started becoming untenable. 

It was at this point that I bought a TP-Link Archer C7. I was fairly impressed with its range, it's ability to do 802.11AC, and it's stability. I ran both routers concurrently with DHCP turned off on the TP-Link while I was trying it out. Wireless was broadcast on both 2.4 and 5 Ghz for both routers, meaning I had four house networks. I'm sure that drew some weird looks.

Everything was coming up aces for the TP-Link except for one oddity: I could connect to my work's VPN through it but, once connected, no data would flow through it. Connecting through the AirPort Extreme worked fine. 

I searched the vast reaches of the Internet but inevitably came up blank. It was clearly connecting because it would tell me whether my password was incorrect or not. Unfortunately, as soon as I was authenticated, it just stopped sending and receiving packets.

I would dig into the problem off and on for the next two years, all the while running four wireless networks. Whenever I connected, I'd have to choose between having wireless range or being able to connect to the work VPN.

Finally, last week I heard about a bizarre network problem occurring due to ["double NAT"](double_nat), where network address translation was happening twice before packets left a network. My ears perked up at the mention of "double". I promptly went home and checked. Lo and behold, NAT was still turned on for the TP-Link. Disabling that allowed me to connect to the work VPN with no problem and, with that, let me finally go down to one wireless router for the house network. 

Annoying that it happened, but hopefully this will help someone else facing the same problem. Or at least remind me about it the next time I buy a new router. 

[double_nat]: http://www.practicallynetworked.com/networking/fixing_double_nat.htm
