---
layout: post
date: 2015-12-24
title: Installing a Certificate Authority for Ruby
---

This morning, tragedy struck:

<pre>
➜  dev_dashboard git:(master) ✗ pry
[1] pry(main)> require './lib/internal'
=> true
[2] pry(main)> client = Internal.new.connect
=> #<Faraday::Client:0x3ff0b1da47c4>
[3] pry(main)> client.issues
Faraday::SSLError: SSL_connect returned=1 errno=0 state=error: certificate verify failed
from /Users/august/.rbenv/versions/2.2.3/lib/ruby/2.2.0/net/http.rb:923:in `connect'
[4] pry(main)
</pre>

During the course of work, I realized that I had yet to install our internal Certificate Authority on my laptop in a place that Ruby could find.
Ruby uses OpenSSL to verify the various certificates it comes across, and thanks to Homebrew and various other tools, I have a couple of OpenSSL installs on my machine.
It took a bit of detective work to track down the right answer, so hopefully writing it down will help someone.

First, we need to find out where OpenSSL is looking for certificates.

<pre>
$ ruby -ropenssl -e 'puts OpenSSL::X509::DEFAULT_CERT_FILE'
/usr/local/etc/openssl/cert.pem
</pre>

Then, we can install the CA certs.

<pre>
➜  dev_dashboard git:(master) ✗ cat ~/Desktop/root_certs/*.pem >> /usr/local/etc/openssl/cert.pem
➜  dev_dashboard git:(master) ✗ pry
[1] pry(main)> require './lib/internal'
=> true
[2] pry(main)> client = Internal.new.connect
=> #<Faraday::Client:0x3fe6f8c6f420>
[3] pry(main)> client.issues
=> [{:url=>"https://git.company.com/api/v3/repos/Company/Project/issues/44",
...
</pre>

Success!
