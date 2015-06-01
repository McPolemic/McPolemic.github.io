---
layout: post
title: Why Would One Proxy Web Applications?
date: 2013-12-05
---


I've had to look this up a number of times. It always feels like you should be able to just launch an application and it can start talking HTTP. In some cases (e.g. Go), you can. However, HTTP has a lot of things to handle. Load balancing, SSL termination, serving static assets. It seems people normally load a web application into an application server (usually WSGI-based) and then put it behind a proper web server to handle all these concerns.   
