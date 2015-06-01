---
title: XML and the Database
date: 2012-12-29
---

> Hypothesis: There's no good reason to put XML in a database.
> 
> I didn't think this would ever come up.
[https://twitter.com/spawn968/status/284392892284416001](https://twitter.com/spawn968/status/284392892284416001)
    
I posted the above to Twitter the other day. I listed it as a "hypothesis" not because I thought it was necessarily provable, but more that I wanted someone to tell me a case where it was necessary or even preferable. So far, my attempts to disprove it have come up dry. Let me explain a bit about why I'm annoyed. 

# A Brief Introduction to XML
XML is designed as a markup language, a way to add syntax to text to give it structure and convey additional meaning. In XML, this additional meaning is *almost* always data serialization, where we're trying to convey complex data (such as objects or series of objects) in a human-readable and machine-readable format. 

The problem with storing XML in a database row is that it violates everything that is useful both for XML and for a database. Databases also structure data in human-readable ways by putting the data in tables, columns, and rows. It makes the data more useful by allowing queries to be run against the data. Leaving it as XML in a table is redundent. Worse, large amounts of XML are kept as CLOBs, which drastically cut down on the available operators, making your data even harder to access. By keeping the information in XML, it misses the queryable nature of relational databases.

Since XML is a method for data serialization, it makes sense to parse the XML and store the resulting objects in the database. If it cannot be parsed, it can be logged as an error in the log files where it can be viewed, grepped through, even compressed when no longer needed. This seems to cover almost all use cases without requiring storing the overhead of XML in a database table. 


## Examples
As I said before, I was hoping to be shown wrong. I had thought of some use cases I had seen at work, and some friends have helpfully suggested others. Lets go through a couple and put this hypothesis to the test. 

### Web Services
This is a big one, and the reason I posted my hatred in the first place. Since the database is a shared location for both batch services and UI, it's often used as a dumping ground for anything that should be accessible to both. Web service calls usually fall into this bucket. 

A web service call (we'll assume SOAP in this instance, as it's XML-based) consists of an XML message sent as a request and an XML response. It could look something like this:

    <?xml version="1.0"?>
    <soap:Envelope xmlns:soap="http://www.w3.org/2003/05/soap-envelope">
      <soap:Header>
      </soap:Header>
      <soap:Body>
        <m:GetStockPrice xmlns:m="http://www.example.org/stock">
          <m:StockName>IBM</m:StockName>
        </m:GetStockPrice>
      </soap:Body>
    </soap:Envelope>

This is an extremely verbose way of saying, "Call the function `GetStockPrice` with the argument type `StockName` 'IBM'." If you want to keep track of when and what requests were made, you can keep that information in a database table.

    requests
    --------
    id (Integer, PK)
    source_ip (VarChar)
    function (VarChar)
    arguments (Integer, FK to argument cross-reference)
    logfile (VarChar)
    date_time (Date)
    
    arguments
    ---------
    id (Integer, PK)
    type (VarChar)
    body (VarChar)

In this example, I've stored everything I'd expect to need about the request while still keeping it database-centric. The full XML request is logged to a file, which is then referenced in `requests.filename` for easy reference. The arguments are split into another table, allowing multiple arguments per function call. 

Imagine that we discover a bug in the above code, that this function is giving the wrong amount for all APPL stock, and we need to find everyone who requested this data in order to inform them. It's now a simple SQL statement:

    select r.source_ip
      from requests r,
           arguments a,
     where r.arguments = a.id
       and r.function = 'GetStockPrice'
       and a.type = 'StockName'
       and a.body = 'IBM';
       
Even attempting a similar query where you log the XML to the database would require writing a program to cycle through every row, parse the XML, and *then* print out the data you're looking for. Less than optimal. 

If a request comes in that's not properly formed in some way, it's a simple matter of just filling in the source_ip, date_time, and log file (where the XML request has been logged). Now we're not losing any data, we're keeping relationality, and our tables are full of easy to read, non-markup data. 

### Documents and Reports
One example I hadn't originally considered were XML-based documents. A simple example of this would be XHTML. 

	<?xml version="1.0" encoding="UTF-8"?>
	<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "DTD/xhtml1-strict.dtd">
	<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
		<head>
			<title> Strict DTD XHTML Example </title>
		</head>
		<body>
		<p>
			Please Choose a Day:	<br /><br />
			<select name="day">
				<option selected="selected">Monday</option>
				<option>Tuesday</option>
				<option>Wednesday</option>
			</select>
		</p>
		</body>
	</html>

The above shows a document requesting that you choose a day. XHTML is used to display formatted content in cases where plain-text isn't powerful or flexible enough. Usually in these cases the XML was generated from a template, including data from the database. You should never store generated data in a database if you can help it. Since the same data should yield the same XHTML output, you can rely on the data already in the database to generate the letter. 

If you absolutely must keep it, I genuinely believe logging to a file makes more sense. If you have to pass the request through different systems, you could schedule transfers of the files, use a clustered file system, or (my preference) send the XML as a web service call to the machine needing the document. There's a number of ways to transfer XML without requiring cluttering up tables with marked up data. 

Storing XML in a database makes it hard to both query *and* compress. We've already shown that it's better to store the parsed data in order to allow querying for particular parameters. Parsing takes a non-trivial amount of time, so it's better to parse it when you receive it and store the resulting data in a database than to parse it every time you might need to access the information. 

Keeping XML in a database also doesn't allow much in the way of compressing your data. Databases are optimized for access and write speed, not disk usage. While you may want to keep all of your data all the time, you will almost always be working with recently-created documents. If you're storing XML on the filesystem, it's as simple as compressing files that are older than a certain number of days or weeks. Modern compression tools can let you reach space reductions [exceeding 90%](http://www.maximumcompression.com/data/log.php), resulting in substantial space savings. 

### Summary

I really hope that this helps you think a bit deeper about system design. Once you start using your database as a simple distributed file storage area, it's hard to reel the design back in. It's much easier to add a hard-drive to a system or expand an existing hard-drive without downtime than to migrate a database to a larger drive. I haven't run into a single case where logging XML makes sense, but I'd be more than welcome to hear some from you. If you can think of any, let me know on Twitter. 

Thanks to [@tsunaminoai](https://twitter.com/tsunaminoai), [@jhitze](https://twitter.com/jhitze), and [@falornan](https://twitter.com/falornan) for giving me use cases to consider for this.  
