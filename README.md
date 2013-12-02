#Java GC Tools

Java GC Tools is my repo that holds all the various scripts that I write to help me grok Java's GC logs.

##timestamper.rb

   **timestamper.rb** *gclogfile* [*timestamp*] 

Normally, the GC logs look something like this:

    515652.524: [GC 515652.524: [ParNew: 2230956K->319442K(2516608K), 0.1406450 secs] 5723123K->3829083K(22439552K), 0.1407400 secs] [Times: user=1.22 sys=0.00, real=0.14 secs]

That first field (515652.524) is the number of seconds since the JVM started up.  To most humans, that really doesn't mean much.  timestamper.rb will seek to the last line of the file (without reading the entire file first), and grab the last timestamp in seconds.  It will then check the last mtime of the logfile.  It will then start at the beginning of the file, and rewrite all the numeric timestamps into human readable timestamps and output the result to STDOUT.  Here's an example:

    11/25/2013 09:40:33.321: [GC 515715.321: [ParNew: 2206930K->420674K(2516608K), 0.1496960 secs] 5716571K->3947799K(22439552K), 0.1497900 secs] [Times: user=1.30 sys=0.00, real=0.15 secs]

While this method may not be accurate to the millisecond due to output buffering and concurrency, it gets pretty close.  This will also break if you scp an old logfile to a workstation and run it there (scp'ing updates the file's mtime).

If you should happen to know when the JVM was started, you can supply that to the script as an optional second parameter.

    ./timestamper.rb gc.out "Nov 25 09:41"

The script will then use that as the start time, and format the output accordingly.
