---
layout: post
title: "Setting Up a Virtual Hadoop Cluster with Vagrant: Part 1"
date: 2013-04-21
---

There's a project at work that deals with generating a huge number of bank statements. Each of these statements deals with only one account, with no related information. This seemed to be a great case for running multiple copies of the code in parallel on multiple machines. As a result, I've been reading up on MapReduce and, in particular, Apache Hadoop.

Before we get started, let's introduce the tools.

# MapReduce

MapReduce is a pattern of handling a specific subset of problems that lend itself to running in parallel. It was originally explained in a paper released by Google, but they never released their implementation to the public. The most popular program for using MapReduce outside of Google is [Apache Hadoop][hadoop]. 

In MapReduce, you follow a procedure for splitting up your data, running the same function over all the split up data, and then run a function to combine it back together. If, for example, you were tasked with counting how often certain words were used in *War and Peace*, there's a number of ways you could go about doing it. To write it in parallel, one tactic would be as follows:

> "Well, Prince, so Genoa and Lucca are now just family estates of the Buonapartes. But I warn you, if you don't tell me that this means war, if you still try to defend the infamies and horrors perpetrated by that Antichrist—I really believe he is Antichrist—I will have nothing more to do with you and you are no longer my friend, no longer my 'faithful slave,' as you call yourself! But how do you do? I see I have frightened you—sit down and tell me all the news."


1. Splits the text given into sections of roughly equal length. 

        ["Well, Prince, so Genoa and Lucca are now just family estates of the",  
        "Buonapartes. But I warn you, if you don't tell me that this means war, ",  
        "if you still try to defend the infamies and horrors perpetrated by that ",  
        "Antichrist—I really believe he is Antichrist—I will have nothing more ",  
        "to do with you and you are no longer my friend, no longer my 'faithful ",  
        "slave,' as you call yourself! But how do you do? I see I have frightened ",  
        "you—sit down and tell me all the news."]  

2. Pass the equal length sections to each running computer. 

        Worker 1: "Well, Prince, so Genoa and Lucca are now just family estates of the"  
        Worker 2: "Buonapartes. But I warn you, if you don't tell me that this means war, "  
        Worker 3: "if you still try to defend the infamies and horrors perpetrated by that "  
        Worker 4: "Antichrist I really believe he is Antichrist I will have nothing more "  
        Worker 5: "to do with you and you are no longer my friend, no longer my 'faithful "  
        Worker 6: "slave,' as you call yourself! But how do you do? I see I have frightened "  
        Worker 7: "you sit down and tell me all the news."  

3. On each worker computer:  
> 1. Strip out all punctuation outside of a group of letters   
> 2. Convert the string to lowercase.  
> 3. Split on each space.   
> 4. Return a key/value pair of `["word": 1]` indicating that for that word, there was a word found.

        Worker 1: "[['well,', 1], ['prince,', 1], ['so', 1], ['genoa', 1], ['and', 1], ['lucca', 1], ['are', 1], ['now', 1], ['just', 1], ['family', 1], ['estates', 1], ['of', 1], ['the', 1]]"  
        Worker 2: "[['buonapartes.', 1], ['but', 1], ['i', 1], ['warn', 1], ['you,', 1], ['if', 1], ['you', 1], ["don't", 1], ['tell', 1], ['me', 1], ['that', 1], ['this', 1], ['means', 1], ['war,', 1]]"  
        Worker 3: "[['if', 1], ['you', 1], ['still', 1], ['try', 1], ['to', 1], ['defend', 1], ['the', 1], ['infamies', 1], ['and', 1], ['horrors', 1], ['perpetrated', 1], ['by', 1], ['that', 1]]"  
        Worker 4: "[['antichrist', 1], ['i', 1], ['really', 1], ['believe', 1], ['he', 1], ['is', 1], ['antichrist', 1], ['i', 1], ['will', 1], ['have', 1], ['nothing', 1], ['more', 1]]"  
        Worker 5: "[['to', 1], ['do', 1], ['with', 1], ['you', 1], ['and', 1], ['you', 1], ['are', 1], ['no', 1], ['longer', 1], ['my', 1], ['friend,', 1], ['no', 1], ['longer', 1], ['my', 1], ["'faithful", 1]]"  
        Worker 6: "[["slave,'", 1], ['as', 1], ['you', 1], ['call', 1], ['yourself!', 1], ['but', 1], ['how', 1], ['do', 1], ['you', 1], ['do?', 1], ['i', 1], ['see', 1], ['i', 1], ['have', 1], ['frightened', 1]]" 
        Worker 7: "[['you', 1], ['sit', 1], ['down', 1], ['and', 1], ['tell', 1], ['me', 1], ['all', 1], ['the', 1], ['news', 1]]"  
        
5. After you've processed the entire text, combine all the pairs. For each key, add up all the values into an array. We'll have a list of each unique word, as well as an array of 1's as long as the number of times a word appears.

        {'and': [1, 1, 1, 1], 'perpetrated': [1], 'all': [1], 'friend,': [1], 'infamies': [1], 'family': [1], "don't": [1], 'is': [1], 'horrors': [1], 'well,': [1], 'war,': [1], 'are': [1, 1], 'have': [1, 1], 'news': [1], 'still': [1], 'frightened': [1], 'as': [1], 'if': [1, 1], 'will': [1], 'believe': [1], 'just': [1], 'no': [1, 1], 'defend': [1], 'means': [1], 'by': [1], 'to': [1, 1], 'call': [1], 'do?': [1], 'estates': [1], 'you': [1, 1, 1, 1, 1, 1, 1], 'really': [1], 'tell': [1, 1], 'more': [1], 'buonapartes.': [1], 'do': [1, 1], 'you,': [1], 'sit': [1], 'see': [1], 'that': [1, 1], 'but': [1, 1], 'warn': [1], 'how': [1], 'nothing': [1], 'antichrist': [1, 1], 'now': [1], 'with': [1], 'prince,': [1], 'he': [1], 'me': [1, 1], 'down': [1], 'longer': [1, 1], 'i': [1, 1, 1, 1, 1], 'of': [1], "'faithful": [1], "slave,'": [1], 'yourself!': [1], 'try': [1], 'this': [1], 'so': [1], 'the': [1, 1, 1], 'genoa': [1], 'my': [1, 1], 'lucca': [1]}

6. Finally, for each unique key, sum up all of the 1's to get the number of times a word appears.

        {'and': 4, 'perpetrated': 1, 'all': 1, 'friend,': 1, 'infamies': 1, 'family': 1, "don't": 1, 'is': 1, 'horrors': 1, 'well,': 1, 'war,': 1, 'are': 2, 'have': 2, 'news': 1, 'still': 1, 'frightened': 1, 'as': 1, 'if': 2, 'will': 1, 'believe': 1, 'just': 1, 'no': 2, 'defend': 1, 'means': 1, 'by': 1, 'to': 2, 'call': 1, 'do?': 1, 'estates': 1, 'you': 7, 'really': 1, 'tell': 2, 'more': 1, 'buonapartes.': 1, 'do': 2, 'you,': 1, 'sit': 1, 'see': 1, 'that': 2, 'but': 2, 'warn': 1, 'how': 1, 'nothing': 1, 'antichrist': 2, 'now': 1, 'with': 1, 'prince,': 1, 'he': 1, 'me': 2, 'down': 1, 'longer': 2, 'i': 5, 'of': 1, "'faithful": 1, "slave,'": 1, 'yourself!': 1, 'try': 1, 'this': 1, 'so': 1, 'the': 3, 'genoa': 1, 'my': 2, 'lucca': 1}
        
This process is an example of MapReduce. After splitting up the work, we **map** the data with a function (in our case, lower-case/remove characters/split on spaces). After the map is complete, we'll be left with a number of key/value pairs. Then we **reduce**, or cut the number of key/value pairs down by applying a function to combine the various values (in our case, summing the arrays for each unique key). 

A surprisingly large number of problems fall into this, and with services like EC2, it's often easier to run these jobs with many large machines than it is to run a single long-running program. [The New York Times][new-york-times] used MapReduce to condense their entire public domain collection of issues as images into a series of PDFs, utilizing 100 EC2 instances to condense the entire collection in just 24 hours. Rather than letting it run long on the Times' machines, or request new hardware for the job to be run, the developer was able to spin up the new machines, process the work, and pay only for the time he used.

#Puppet & Vagrant

In order to make this a proper test, we'll be setting up a small virtual network using [Vagrant][vagrant] and [Puppet][puppet]. Vagrant is a tool that allows you to easily set up one or many VirtualBox machines, networking them together, and saving the configuration so that others can repeat it. Puppet is a provisioning tool, allowing you to create a series of configuration files and run it either locally or remotely to install, configure, and run software, as well as copy files and fill templates. Everything necessary to go from a freshly installed OS or VM image to a fully-working system.

# The Plan

I had found a couple of good articles on running a Hadoop cluster virtually, but one article that stands out was Carlo Scarioni's ["Setting up a Hadoop Virtual Cluster with Vagrant"][java-hadoop]. It gave a good outline of how to set up the virtual cluster as well as provision it using Puppet. However, there were a number of typos and incompatibilities, and I had to research quite a bit to get it working.

With that in mind, I figured I'd post an updated version of that article. Part one is this introduction. Part two will show exactly how I set up Hadoop using Vagrant and Puppet. Part three will detail writing a simple Hadoop program.

[java-hadoop]: http://cscarioni.blogspot.com/2012/09/setting-up-hadoop-virtual-cluster-with.html
[new-york-times]: http://open.blogs.nytimes.com/2007/11/01/self-service-prorated-super-computing-fun/
[vagrant]: http://www.vagrantup.com/
[puppet]: https://puppetlabs.com/
[hadoop]: http://hadoop.apache.org/
