---
layout: post
title: "Setting Up a Virtual Hadoop Cluster with Vagrant: Part 2"
date: 2013-04-26
---

Welcome back to my three part series on running a virtual Hadoop cluster (See [Part One][part-one] for the introduction and reasoning. In part two, we'll take care of setting up the cluster, using Vagrant to automate the creation of five virtual machines and Puppet for installing software and copying files.

# Installing Vagrant

First things first, we'll need to have the right software installed. You'll need to install [VirtualBox][virtualbox] and [Vagrant][vagrant]. Instructions are available on the sites, but they're as expected (MSI for Windows, DMG for OS X).

# Setting up a Sample Machine

We'll start by setting up a single machine. Let's add a 64-bit Ubuntu install. Go to [http://vagrantbox.es]() and look up "Ubuntu lucid 64". The link points to a box file, which is a VirtualBox machine Vagrant will use as base to create new machines. From there, we'll add it to Vagrant so it knows what we're talking about.

        $ vagrant box add base-hadoop http://files.vagrantup.com/lucid64.box

This imports the base box "lucid64" under the name "base-hadoop". We'll use that as the box name from now on. From here, let's set up a directory for our machines to live in.

        august@light[~]
        $ mkdir hadoop-test
        
        august@light[~]
        $ cd hadoop-test
        
        august@light[~/hadoop-test]
        $ vagrant init base-hadoop
        A `Vagrantfile` has been placed in this directory. You are now
        ready to `vagrant up` your first virtual environment! Please read
        the comments in the Vagrantfile as well as documentation on
        `vagrantup.com` for more information on using Vagrant.

From here, let's clean up the Vagrantfile. I'm removing most of the comments and filling in some information in case we want to give this file to someone else. I'm left with the following:

<script src="http://gist.github.com/McPolemic/5443527/fb29ed201e57510bba95fb59c2728a9d6a884352.js?file=Vagrantfile"></script>

We can check that it's working by running:

        august@light[~/hadoop-test]
        $ vagrant up
        Bringing machine 'default' up with 'virtualbox' provider...
        [default] Importing base box 'base-hadoop'...
        [default] Matching MAC address for NAT networking...
        [default] Setting the name of the VM...
        [default] Clearing any previously set forwarded ports...
        [default] Fixed port collision for 22 => 2222. Now on port 2200.
        [default] Creating shared folders metadata...
        [default] Clearing any previously set network interfaces...
        [default] Preparing network interfaces based on configuration...
        [default] Forwarding ports...
        [default] -- 22 => 2200 (adapter 1)
        [default] Booting VM...
        [default] Waiting for VM to boot. This can take a few minutes.
        [default] VM booted and ready for use!
        [default] Configuring and enabling network interfaces...
        [default] Mounting shared folders...
        [default] -- /vagrant
        
        august@light[~/hadoop-test]
        $ vagrant ssh
        Linux lucid64 2.6.32-38-server #83-Ubuntu SMP Wed Jan 4 11:26:59 UTC 2012 x86_64 GNU/Linux
        Ubuntu 10.04.4 LTS
        
        Welcome to the Ubuntu Server!
         * Documentation:  http://www.ubuntu.com/server/doc
        New release 'precise' available.
        Run 'do-release-upgrade' to upgrade to it.
        
        Welcome to your Vagrant-built virtual machine.
        Last login: Fri Sep 14 07:31:39 2012 from 10.0.2.2
        vagrant@lucid64:~$ hostname
        lucid64
        vagrant@lucid64:~$ 

Great! Our machine is booting as expected, and we can run commands on it. From here, let's set up installing our files.

# Installing Necessary Files with Puppet

Now we're going to work on getting Puppet up and running. First, we'll tell Vagrant that we'll be using Puppet to provision our VM and set some basic options. In `Vagrantfile`:

<script src="http://gist.github.com/McPolemic/5443527/ddccfbe14b62a95b474377fbf973d35b88363fec.js?file=Vagrantfile"></script>

Now we'll create our Puppet manifests, which is where the configuration files for Puppet are stored. From your main computer (not the VM), run the following:

        august@light[~/hadoop-test]
        $ mkdir manifests

In that directory, we'll create a file `base-hadoop.pp`:

<script src="http://gist.github.com/McPolemic/5443527/ddccfbe14b62a95b474377fbf973d35b88363fec.js?file=base-hadoop.pp"></script>

With these basic options set, let's do a quick test to ensure that it still boots and that Puppet is running.

        august@light[~/hadoop-test]
        $ vagrant reload
        [default] Attempting graceful shutdown of VM...
        [default] Setting the name of the VM...
        [default] Clearing any previously set forwarded ports...
        [default] Fixed port collision for 22 => 2222. Now on port 2201.
        [default] Creating shared folders metadata...
        [default] Clearing any previously set network interfaces...
        [default] Preparing network interfaces based on configuration...
        [default] Forwarding ports...
        [default] -- 22 => 2201 (adapter 1)
        [default] Booting VM...
        [default] Waiting for VM to boot. This can take a few minutes.
        [default] VM booted and ready for use!
        [default] Configuring and enabling network interfaces...
        [default] Mounting shared folders...
        [default] -- /vagrant
        [default] -- /tmp/vagrant-puppet/manifests
        [default] Running provisioner: puppet...
        Running Puppet with base-hadoop.pp...
        stdin: is not a tty
        notice: Finished catalog run in 0.02 seconds

        august@light[~/hadoop-test]
        $ 

Great! You can see near the end that Puppet is running with our config file, and finishes running in 0.02 seconds. 

Next, we'll tell puppet to update apt-get and install Java. We'll add the following to `base-hadoop.pp`:

<script src="http://gist.github.com/McPolemic/5443527/aea60140a8bab97c52ea3bc1e2e5d043c761a50f.js?file=Vagrantfile"></script>

The exec block names an executable action "apt-get update", and tells Puppet that it can find apt-get in "/usr/bin". The package block states that it should ensure `openjdk-6-jdk` is installed, and that it requires the "apt-get update" action to run first. In this way, we can set up requirements for each stage, and Puppet will figure out what needs to be installed and in what order. Let's do another `vagrant reload` to test our configuration.

        august@light[~/hadoop-test]
        $ vagrant reload                   
        [default] Attempting graceful shutdown of VM...
        [default] Setting the name of the VM...
        [default] Clearing any previously set forwarded ports...
        [default] Fixed port collision for 22 => 2222. Now on port 2201.
        [default] Creating shared folders metadata...
        [default] Clearing any previously set network interfaces...
        [default] Preparing network interfaces based on configuration...
        [default] Forwarding ports...
        [default] -- 22 => 2201 (adapter 1)
        [default] Booting VM...
        [default] Waiting for VM to boot. This can take a few minutes.
        [default] VM booted and ready for use!
        [default] Configuring and enabling network interfaces...
        [default] Mounting shared folders...
        [default] -- /vagrant
        [default] -- /tmp/vagrant-puppet/manifests
        [default] Running provisioner: puppet...
        Running Puppet with base-hadoop.pp...
        stdin: is not a tty
        notice: /Stage[main]//Exec[apt-get update]/returns: executed successfully
        notice: /Stage[main]//Package[openjdk-6-jdk]/ensure: ensure changed 'purged' to 'present'
        notice: Finished catalog run in 33.02 seconds

        august@light[~/hadoop-test]
        $ vagrant ssh
        Linux lucid64 2.6.32-38-server #83-Ubuntu SMP Wed Jan 4 11:26:59 UTC 2012 x86_64 GNU/Linux
        Ubuntu 10.04.4 LTS

        Welcome to the Ubuntu Server!
         * Documentation:  http://www.ubuntu.com/server/doc
        New release 'precise' available.
        Run 'do-release-upgrade' to upgrade to it.

        Welcome to your Vagrant-built virtual machine.
        Last login: Fri Sep 14 07:31:39 2012 from 10.0.2.2
        vagrant@lucid64:~$ java -version
        java version "1.6.0_27"
        OpenJDK Runtime Environment (IcedTea6 1.12.3) (6b27-1.12.3-0ubuntu1~10.04.1)
        OpenJDK 64-Bit Server VM (build 20.0-b12, mixed mode)
        vagrant@lucid64:~$ 

Now that that's installed, we'll install Hadoop. For this, we're going to create a new Puppet module that downloads it from Apache and extracts it to /opt/hadoop. Let's create a modules directory for Hadoop.

        august@light[~/hadoop-test]
        $ mkdir -p modules/hadoop/manifests

Note that the Puppet configuration for a module goes in a manifests directory, just like our main manifest. Now we'll let Puppet know that we're using the "modules" directory to store all of our modules. Modify `Vagrantfile` to show the following:

<script src="http://gist.github.com/McPolemic/5443527/cd93f1c15e8fd83630571931fb233601fe796f71.js?file=Vagrantfile"></script>

The default file that runs in a module's manifests directory is named `init.pp`. Let's fill out modules/hadoop/manifests/init.pp

<script src="http://gist.github.com/McPolemic/5443527/cd93f1c15e8fd83630571931fb233601fe796f71.js?file=init.pp"></script>

Finally, we'll modify `manifests/base-hadoop.pp` to let Puppet know we want to install the Hadoop module we just created.

<script src="http://gist.github.com/McPolemic/5443527/cd93f1c15e8fd83630571931fb233601fe796f71.js?file=base-hadoop.pp"></script>

Again, let's reload our Vagrant VM.

        august@light[~/hadoop-test]
        $ vagrant reload
        [default] Attempting graceful shutdown of VM...
        [default] Setting the name of the VM...
        [default] Clearing any previously set forwarded ports...
        [default] Fixed port collision for 22 => 2222. Now on port 2201.
        [default] Creating shared folders metadata...
        [default] Clearing any previously set network interfaces...
        [default] Preparing network interfaces based on configuration...
        [default] Forwarding ports...
        [default] -- 22 => 2201 (adapter 1)
        [default] Booting VM...
        [default] Waiting for VM to boot. This can take a few minutes.
        [default] VM booted and ready for use!
        [default] Configuring and enabling network interfaces...
        [default] Mounting shared folders...
        [default] -- /vagrant
        [default] -- /tmp/vagrant-puppet/manifests
        [default] -- /tmp/vagrant-puppet/modules-0
        [default] Running provisioner: puppet...
        Running Puppet with base-hadoop.pp...
        stdin: is not a tty
        notice: /Stage[main]//Exec[apt-get update]/returns: executed successfully
        notice: /Stage[main]/Hadoop/Exec[download_hadoop]/returns: executed successfully
        notice: /Stage[main]/Hadoop/Exec[unpack_hadoop]/returns: executed successfully
        notice: Finished catalog run in 45.08 seconds

Note that it didn't reinstall Java. Puppet analyzes the system and does just enough work to get the system to match your manifests. Since we already had Java installed, it was able to skip that.

Alright, pat yourself on the back. We've got a fully installed machine up and running! How difficult would you imagine it would be to get five machines up and running?

Let's get rid of our currently configured single system and build up a network.

        august@light[~/hadoop-test]
        $ vagrant destroy
        Are you sure you want to destroy the 'default' VM? [y/N] y
        [default] Forcing shutdown of VM...
        [default] Destroying VM and associated drives...


# Growing Your Network

We want our network to have five machines: A master, a backup, and three worker machines. Open up the Vagrantfile and make the following modifications.

<script src="http://gist.github.com/McPolemic/5443527/bf6c4a5a11b3464685a8a25ae8e321b638b8f0de.js?file=Vagrantfile"></script>

**NOTE**: I also switched the Hadoop package to download from the pair.com mirror, due to it taking too long to download the package.

<script src="http://gist.github.com/McPolemic/5443527/bf6c4a5a11b3464685a8a25ae8e321b638b8f0de.js?file=init.pp"></script>

This sets up the five machines we mentioned, setting IP addresses for each one. By setting `:private_network`, we'll be able to access the VMs and they'll be able to access each other, but no other machine on the network can reach them. Let's start up the cluster.

        august@light[~/hadoop-test]
        $ vagrant up
        Bringing machine 'master' up with 'virtualbox' provider...
        Bringing machine 'backup' up with 'virtualbox' provider...
        Bringing machine 'hadoop1' up with 'virtualbox' provider...
        Bringing machine 'hadoop2' up with 'virtualbox' provider...
        Bringing machine 'hadoop3' up with 'virtualbox' provider...
        [master] Importing base box 'base-hadoop'...
        **SNIP**
        [master] Running provisioner: puppet...
        Running Puppet with base-hadoop.pp...
        stdin: is not a tty
        notice: /Stage[main]//Exec[apt-get update]/returns: executed successfully
        notice: /Stage[main]//Package[openjdk-6-jdk]/ensure: ensure changed 'purged' to 'present'
        notice: /Stage[main]/Hadoop/Exec[download_hadoop]/returns: executed successfully
        notice: /Stage[main]/Hadoop/Exec[unpack_hadoop]/returns: executed successfully
        notice: Finished catalog run in 89.91 seconds
        [backup] Importing base box 'base-hadoop'...
        **SNIP**
        [hadoop1] Importing base box 'base-hadoop'...
        **SNIP**
        [hadoop2] Importing base box 'base-hadoop'...
        **SNIP**
        [hadoop3] Importing base box 'base-hadoop'...
        **SNIP**

Great! We have all five machines up and running.

# Configure Hadoop

We have Hadoop downloaded and extracted, but we still need to set it up to run. For that, we'll need to create some XML files. As these files are configuring Hadoop, we'll create them in `modules/hadoop/` in a new directory named "files".

        august@light[~/hadoop-test]
        $ mkdir modules/hadoop/files

In this directory, we'll create these five files:

<script src="http://gist.github.com/McPolemic/5443527/9e449bb9715e8be852acb77ab855507750c0950d.js?file=masters"></script>

<script src="http://gist.github.com/McPolemic/5443527/9e449bb9715e8be852acb77ab855507750c0950d.js?file=slaves"></script>

<script src="http://gist.github.com/McPolemic/5443527/9e449bb9715e8be852acb77ab855507750c0950d.js?file=core-site.xml"></script>

<script src="http://gist.github.com/McPolemic/5443527/9e449bb9715e8be852acb77ab855507750c0950d.js?file=hdfs-site.xml"></script>

<script src="http://gist.github.com/McPolemic/5443527/9e449bb9715e8be852acb77ab855507750c0950d.js?file=mapred-site.xml"></script>

We'll tell modules/hadoop/manifests/init.pp to copy over the files from the Hadoop files section.

<script src="http://gist.github.com/McPolemic/5443527/9e449bb9715e8be852acb77ab855507750c0950d.js?file=init.pp"></script>

With everything set up, we'll provision again to copy the files over.

        august@light[~/hadoop-test/modules/hadoop/files]
        $ vagrant provision
        [master] Running provisioner: puppet...
        Running Puppet with base-hadoop.pp...
        stdin: is not a tty
        notice: /Stage[main]//Exec[apt-get update]/returns: executed successfully
        notice: /Stage[main]/Hadoop/File[/opt/hadoop-1.0.4/conf/masters]/content: content changed '{md5}b8419160170a41ae01abab13a3b887df' to '{md5}bcb98aa83d69c09152ba38629ec1d7f8'
        notice: /Stage[main]/Hadoop/File[/opt/hadoop-1.0.4/conf/masters]/mode: mode changed '0664' to '0644'
        notice: /Stage[main]/Hadoop/File[/opt/hadoop-1.0.4/conf/mapred-site.xml]/content: content changed '{md5}5248c973f1cd3c22fefd056024434bcb' to '{md5}46ab33dc36bb9dec326f9340dee44a28'
        notice: /Stage[main]/Hadoop/File[/opt/hadoop-1.0.4/conf/mapred-site.xml]/mode: mode changed '0664' to '0644'
        notice: /Stage[main]/Hadoop/File[/opt/hadoop-1.0.4/conf/hdfs-site.xml]/content: content changed '{md5}5248c973f1cd3c22fefd056024434bcb' to '{md5}f45e42cdfef07afa9cec86ecc81d2f22'
        notice: /Stage[main]/Hadoop/File[/opt/hadoop-1.0.4/conf/hdfs-site.xml]/mode: mode changed '0664' to '0644'
        notice: /Stage[main]/Hadoop/File[/opt/hadoop-1.0.4/conf/core-site.xml]/content: content changed '{md5}5248c973f1cd3c22fefd056024434bcb' to '{md5}a176d57eb1e590f24056da9a09f5c39f'
        notice: /Stage[main]/Hadoop/File[/opt/hadoop-1.0.4/conf/core-site.xml]/mode: mode changed '0664' to '0644'
        notice: /Stage[main]/Hadoop/File[/opt/hadoop-1.0.4/conf/slaves]/content: content changed '{md5}b8419160170a41ae01abab13a3b887df' to '{md5}f57c2d6949e92bbc98d9b0941cc99946'
        notice: /Stage[main]/Hadoop/File[/opt/hadoop-1.0.4/conf/slaves]/mode: mode changed '0664' to '0644'
        notice: Finished catalog run in 1.19 seconds
        [backup] Running provisioner: puppet...
        **SNIP**

Let's set up password-less public keys for SSH, so that we won't be prompted for passwords while Hadoop sends work out.

        august@light[~/hadoop-test/modules/hadoop/files]
        $ ssh-keygen -t rsa
        Generating public/private rsa key pair.
        Enter file in which to save the key (/Users/august/.ssh/id_rsa): ./id_rsa
        Enter passphrase (empty for no passphrase): 
        Enter same passphrase again: 
        Your identification has been saved in ./id_rsa.
        Your public key has been saved in ./id_rsa.pub.
        The key fingerprint is:
        52:b6:51:04:f1:5e:01:96:f3:7d:05:5c:f6:60:54:c1 august@light.private
        The key's randomart image is:
        +--[ RSA 2048]----+
        |        o+=o.o*==|
        |         +o  o.Eo|
        |        + .o..  o|
        |       o + .. . .|
        |      . S .    . |
        |       .         |
        |                 |
        |                 |
        |                 |
        +-----------------+

        august@light[~/hadoop-test/modules/hadoop/files]
        $ cat id_rsa.pub 
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDEFC7jZNwXhqwdms4AGbyDASGplPPlsMnn6Sidrv4pUY8A5R0DGJCweKMh3cel+W1r3iczZCreV80MXVbvTCeCgrlignC+qaxgZ/RYIe1e9w5wjGEhAW2YRrz4cIntXiD79FdOWCe7O/VsNk4piFPDVG2JQztjP+6nREvGDDB6wa5BHQvr/9kRg16eutrmlNSeaPvTRKF5EFOq1dCqhedV17LxS0gSDgd1v/fOhlm2JNCI5CaaGxS3MPn1eMTA1Mf3W1X9y8w01oRUxiojnXw6zhWXHSDQiJliZkV0wovHkCOd3bdBNiusQara9sdLc5I/kkT8UbEBU7uevNSEH0/R august@light.private

Note that your fingerprint and randomart will be different. Let's add our key to manifests/base-hadoop.pp. Note that we're putting the key from id_rsa.pub in the base-hadoop.pp file.

<script src="http://gist.github.com/McPolemic/5443527/a783f835ba89adf2b7dab9ae1ec2bdf84ea8ad16.js?file=base-hadoop.pp"></script>

We'll copy out the hadoop-env.sh script out of the Hadoop distribution and set the JAVA_HOME variable.

        august@light[~/hadoop-test]
        $ cd modules/hadoop/files 

        august@light[~/hadoop-test/modules/hadoop/files]
        $ vagrant ssh master -- cat /opt/hadoop-1.0.4/conf/hadoop-env.sh > hadoop-env.sh

Edit it to match the following:

<script src="http://gist.github.com/McPolemic/5443527/a783f835ba89adf2b7dab9ae1ec2bdf84ea8ad16.js?file=hadoop-env.sh"></script>

We'll copy that file to the various machines by adding it as a "file" block to modules/hadoop/manifests/init.pp.

<script src="http://gist.github.com/McPolemic/5443527/a783f835ba89adf2b7dab9ae1ec2bdf84ea8ad16.js?file=init.pp"></script>

Lastly, let's give all five machines hostnames so it's easier to address them.

<script src="http://gist.github.com/McPolemic/5443527/b176159284da2f17aa161abed6eb37386c51a3e1.js?file=Vagrantfile"></script>

Since we've made some pretty substantial changes, we'll reload the VMs to reapply all settings.

        august@light[~/hadoop-test]
        $ vagrant reload

# Starting the Cluster

We have the machines. We have the software. Now we just have to start it all up. Let's ssh into the master machine and start up the cluster. 

        august@light[~/hadoop-test]
        $ vagrant ssh master
        Linux master 2.6.32-38-server #83-Ubuntu SMP Wed Jan 4 11:26:59 UTC 2012 x86_64 GNU/Linux
        Ubuntu 10.04.4 LTS
        
        Welcome to the Ubuntu Server!
         * Documentation:  http://www.ubuntu.com/server/doc
        New release 'precise' available.
        Run 'do-release-upgrade' to upgrade to it.
        
        Welcome to your Vagrant-built virtual machine.
        Last login: Fri Apr 26 01:44:17 2013 from 10.0.2.2
        
        
        vagrant@master:~$ cd /opt/hadoop-1.0.4/bin
        vagrant@master:/opt/hadoop-1.0.4/bin$ sudo ./hadoop namenode -format
        13/04/26 01:48:01 INFO namenode.NameNode: STARTUP_MSG: 
        /************************************************************
        STARTUP_MSG: Starting NameNode
        STARTUP_MSG:   host = master/127.0.1.1
        STARTUP_MSG:   args = [-format]
        STARTUP_MSG:   version = 1.0.4
        STARTUP_MSG:   build = https://svn.apache.org/repos/asf/hadoop/common/branches/branch-1.0 -r 1393290; compiled by 'hortonfo' on Wed Oct  3 05:1
        3:58 UTC 2012
        ************************************************************/
        13/04/26 01:48:01 INFO util.GSet: VM type       = 64-bit
        13/04/26 01:48:01 INFO util.GSet: 2% max memory = 19.33375 MB
        13/04/26 01:48:01 INFO util.GSet: capacity      = 2^21 = 2097152 entries
        13/04/26 01:48:01 INFO util.GSet: recommended=2097152, actual=2097152
        13/04/26 01:48:01 INFO namenode.FSNamesystem: fsOwner=root
        13/04/26 01:48:01 INFO namenode.FSNamesystem: supergroup=supergroup
        13/04/26 01:48:01 INFO namenode.FSNamesystem: isPermissionEnabled=true
        13/04/26 01:48:01 INFO namenode.FSNamesystem: dfs.block.invalidate.limit=100
        13/04/26 01:48:01 INFO namenode.FSNamesystem: isAccessTokenEnabled=false accessKeyUpdateInterval=0 min(s), accessTokenLifetime=0 min(s)
        13/04/26 01:48:01 INFO namenode.NameNode: Caching file names occuring more than 10 times 
        13/04/26 01:48:01 INFO common.Storage: Image file of size 110 saved in 0 seconds.
        13/04/26 01:48:01 INFO common.Storage: Storage directory /tmp/hadoop-root/dfs/name has been successfully formatted.
        13/04/26 01:48:01 INFO namenode.NameNode: SHUTDOWN_MSG: 
        /************************************************************
        SHUTDOWN_MSG: Shutting down NameNode at master/127.0.1.1
        ************************************************************/
        
        
        vagrant@master:/opt/hadoop-1.0.4/bin$ sudo ./start-all.sh 
        starting namenode, logging to /opt/hadoop-1.0.4/libexec/../logs/hadoop-root-namenode-master.out
        The authenticity of host '192.168.2.12 (192.168.2.12)' can't be established.
        RSA key fingerprint is e7:8f:07:57:69:08:6e:fa:82:bc:1c:f6:53:3f:12:9e.
        Are you sure you want to continue connecting (yes/no)? The authenticity of host '192.168.2.14 (192.168.2.14)' can't be established.
        RSA key fingerprint is e7:8f:07:57:69:08:6e:fa:82:bc:1c:f6:53:3f:12:9e.
        Are you sure you want to continue connecting (yes/no)? The authenticity of host '192.168.2.13 (192.168.2.13)' can't be established.
        RSA key fingerprint is e7:8f:07:57:69:08:6e:fa:82:bc:1c:f6:53:3f:12:9e.
        Are you sure you want to continue connecting (yes/no)? yes
        192.168.2.12: Warning: Permanently added '192.168.2.12' (RSA) to the list of known hosts.
        192.168.2.12: starting datanode, logging to /opt/hadoop-1.0.4/libexec/../logs/hadoop-root-datanode-hadoop1.out
        yes
        192.168.2.14: Warning: Permanently added '192.168.2.14' (RSA) to the list of known hosts.
        192.168.2.14: starting datanode, logging to /opt/hadoop-1.0.4/libexec/../logs/hadoop-root-datanode-hadoop3.out
        yes
        192.168.2.13: Warning: Permanently added '192.168.2.13' (RSA) to the list of known hosts.
        192.168.2.13: starting datanode, logging to /opt/hadoop-1.0.4/libexec/../logs/hadoop-root-datanode-hadoop2.out
        The authenticity of host '192.168.2.10 (192.168.2.10)' can't be established.
        RSA key fingerprint is e7:8f:07:57:69:08:6e:fa:82:bc:1c:f6:53:3f:12:9e.
        Are you sure you want to continue connecting (yes/no)? yes
        192.168.2.10: Warning: Permanently added '192.168.2.10' (RSA) to the list of known hosts.
        192.168.2.10: starting secondarynamenode, logging to /opt/hadoop-1.0.4/libexec/../logs/hadoop-root-secondarynamenode-master.out
        starting jobtracker, logging to /opt/hadoop-1.0.4/libexec/../logs/hadoop-root-jobtracker-master.out
        192.168.2.12: starting tasktracker, logging to /opt/hadoop-1.0.4/libexec/../logs/hadoop-root-tasktracker-hadoop1.out
        192.168.2.14: starting tasktracker, logging to /opt/hadoop-1.0.4/libexec/../logs/hadoop-root-tasktracker-hadoop3.out
        192.168.2.13: starting tasktracker, logging to /opt/hadoop-1.0.4/libexec/../logs/hadoop-root-tasktracker-hadoop2.out
        vagrant@master:/opt/hadoop-1.0.4/bin$ 


Note that, as we now have a cluster of named machines, you have to specify which machine you want to ssh with. Running `hadoop namenode -format` formats and starts the Hadoop distributed file system. `start-all.sh` starts all of the various nodes via ssh (natch). You can view the now running master node by going to [http://192.168.1.10:50070/](). 

It's been a long journey, but we now have a full Hadoop cluster up and running. We can destroy and rebuild the entire architecture with two commands. 


[part-one]: http://blog.mcpolemic.com/post/setting-up-a-virtual-hadoop-cluster-with-vagrant-part-1
[vagrant]: http://downloads.vagrantup.com
[virtualbox]: https://www.virtualbox.org/wiki/Downloads
