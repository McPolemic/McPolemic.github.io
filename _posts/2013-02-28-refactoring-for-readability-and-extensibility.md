---
layout: post
title: Refactoring for Readability and Extensibility
date: 2013-2-28
published: false
---


# Refactoring for Readability and Extensibility

Your code was overall very readable. The big for loop at the end looked a little scary, though, and I wasn't quite sure what it was doing. Rather than just giving you a changed script or tips on how to improve it, however, I figured I'd walk you through why I was changing what I was changing in order to give you an idea of how my mind works when I'm looking at code I don't understand. 

(I may end up making a blog post out of this, hence the full write up and the numerous quotes. With your permission, of course.)

Here's the code we're starting with:

<script src="https://gist.github.com/McPolemic/83d09fa20150810af05f/2dd222b2609ddb1e216a55b50cfde7a19b0cd63c.js"></script>

As a developer, you always have to look out for readability. This is one of those concepts that's a little vague until you've read quite a bit of code. As a good rule, always ask yourself, "If I came back to this after a year, would I be able to read it?" I'm not able to discern exactly how this works just yet. This makes this code very dangerous to refactor, because I could break it without realizing it. 

In order to make this a bit safer to change, my first step is to add tests. These tests exist to tell me that, no matter what changes, I'll still have the same functionality I started with. We'll create the tests off the old code, change it to be more readable, and rerun throughout to ensure that I haven't broken anything. 

## Poking at the Code

I can see two files being opened, `bsr.csv` and `bsr.txt`. They're both being split by newlines, so I need to include files with multiple lines. I also see that we're creating new files by appending in the current directory. It doesn't look like anything else is modified in the folder. With all that said, I'm going to create a new folder, throw in some dummy data, and see if we can get a preliminary result.

    august@Light[~/temp]
    $ mkdir bsr_refactor

    august@Light[~/temp]
    $ mv bsr.py bsr_refactor 

    august@Light[~/temp]
    $ cd bsr_refactor 

    august@Light[~/temp/bsr_refactor]
    $ cat > bsr.txt
    I am not quite sure 
    how this will affect anything.

    august@Light[~/temp/bsr_refactor]
    $ cat > bsr.csv
    this,seems,to,need,multiple,lines
    I,don't,know,if,this,works
    this,seems,like,a,fair,test

With that, we try the script.

    august@Light[~/temp/bsr_refactor]
    $ python bsr.py
    done

    august@Light[~/temp/bsr_refactor]
    $ ls
    bsr.csv     bsr.py      bsr.txt     output1.txt output2.txt

    august@Light[~/temp/bsr_refactor]
    $ cat bsr.txt
    I am not quite sure 
    how this will affect anything.

    august@Light[~/temp/bsr_refactor]
    $ cat bsr.csv
    this,seems,to,need,multiple,lines
    I,don't,know,if,this,works
    this,seems,like,a,fair,test

    august@Light[~/temp/bsr_refactor]
    $ cat output1.txt
    I am not quite sure 
    how I will affect anything.

    august@Light[~/temp/bsr_refactor]
    $ cat output2.txt
    I am not quite sure 
    how this will affect anything.

We can tell a couple of things. 

1. It does not appear that `bsr.txt` or `bsr.csv` are changed by running the program, as this outputs multiple versions of the output.  
2. The program outputs multiple files.
3. Based on the changes, it looks like it uses the first line of the CSV as the fields to find and change, and every subsequent line lists what information it should be changed to.

To expand on point three, note that output1.txt has had the word "this" has been replaced with "I". Looking back at the code, I see the following lines:

    ll[i] = ll[i].replace(csv[0][j],csv[i][j])

It appears that it is replacing all instances of a field in the first line of the CSV with the corresponding field in other lines of the CSV. The only other special bit of logic is that if "<hostname>" is the first field of the first line of the CSV and the first field of any other line is not blank, it changes the output file name. With all that said, it looks like we have a close enough grasp to start refactoring.

I'll create two new tests to capitalize on what we now know:

    august@Light[~/temp/bsr_refactor]
    $ cat > bsr.csv
    <hostname>,var1,var2,other
    server1,hello,good bye,another
    ,hi,adios,last change

    august@Light[~/temp/bsr_refactor]
    $ cat > bsr.txt
    var1,     

    This is <hostname>. other problems exist.

    var2.

    $ python bsr.py 
    done

    august@Light[~/temp/bsr_refactor]
    $ ls
    mbsr.csv         bsr.py          bsr.txt         output2.txt     server1.txt

    august@Light[~/temp/bsr_refactor]
    $ cat server1.txt 
    hello,

    This is server1. another problems exist.

    good bye.

    august@Light[~/temp/bsr_refactor]
    $ cat output2.txt 
    hi,

    This is . last change problems exist.

    adios.

    |-- bsr.csv
    |-- bsr.py
    |-- bsr.txt
    `-- good
        |-- output2.txt
        `-- server1.txt

 
Fantastic. We have our tests, and we're able to start refactoring.

<script src="https://gist.github.com/McPolemic/83d09fa20150810af05f/12ec86526641c11f0298106f8986abb2ed7d8aa4.js"></script>

 
