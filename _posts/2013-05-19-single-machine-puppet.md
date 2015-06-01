---
layout: post
title: Single Machine Puppet
date: 2013-05-19
draft: True
---

## Preparation
- Download the Puppet Learning VM
    - [http://info.puppetlabs.com/download-learning-puppet-VM.html]()
    - I picked VirtualBox
- Boot up the VM. It loads a CentOS-based Linux machine with Puppet preinstalled.
- Make sure that puppet is installed
    - Tell us some info about the root user
    - puppet resource user root
    -  ^command
    -                 ^user resource
    -                        ^ root user
        user { 'root':
          ensure           => 'present',
          comment          => 'root',
          gid              => '0',
          groups           => ['root', 'bin', 'daemon', 'sys', 'adm', 'disk', 'wheel'],
          home             => '/root',
          password         => '$1$jrm5tnjw$h8JJ9mCZLmJvIxvDLjw1M/',
          password_max_age => '99999',
          password_min_age => '0',
          shell            => '/bin/bash',
          uid              => '0',
        }

## Install a package
    [root@learn ~]# puppet resource package java-1.7.0-openjdk-devel.i386
    warning: Package gpg-pubkey found in both yum and yum; skipping the yum version
    package { 'java-1.7.0-openjdk-devel.i386':
      ensure => 'absent',
    }

Create manifest/default.pp
    package {"java-1.7.0-openjdk-devel.i386":
      ensure => "installed"
    }

Run the puppet instructions
    [root@learn ~]# puppet apply manifest/default.pp 
    notice: /Stage[main]//Package[java-1.7.0-openjdk-devel.i386]/ensure: created
    notice: Finished catalog run in 22.60 seconds

Now Puppet reports it's installed.
    [root@learn ~]# puppet resource package java-1.7.0-openjdk-devel.i386
    warning: Package gpg-pubkey found in both yum and yum; skipping the yum version
    package { 'java-1.7.0-openjdk-devel.i386':
      ensure => '1.7.0.19-2.3.9.1.el5_9',
    }
