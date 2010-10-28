---
layout: default
title: Custom Functions
---

Custom Functions
================

Extend the Puppet interpreter by writing your own custom functions.

* * * 

# Writing your own functions

The Puppet language and interpreter is very extensible. One of the
places you can extend Puppet is in creating new functions to be
executed on the server (the host running puppetmasterd) at the time
that the manifest is compiled. To give you an idea of what you can
do with these functions, the built-in template and include
functions are implemented in exactly the same way as the functions
you're learning to write here.

To write functions, you'll want to have a fundamental understanding
of the Ruby programming language, since all functions must be
written in that language.

# Gotchas

There are a few things that can trip you up when you're writing
your functions:

-   Your function will be executed on the server. This means that
    any files or other resources you reference must be available on the
    server, and you can't do anything that requires direct access to
    the client machine.
-   There are actually two completely different types of functions
    available -- *statements* and *rvalues*. The difference is in
    whether the function is supposed to return a value or not. You must
    declare if your function is an ''rvalue'' by passing :type =>
    :rvalue when creating the function (see the examples below).
-   The name of the file you put your function into must be the
    same as the name of function, otherwise it won't get automatically
    loaded. This ''will'' bite you some day.
-   To use a *fact* about a client, use lookupvar('fact\_name')
    instead of Facter['fact\_name'].value. See examples below.

# Where to put your functions

Functions are loaded from files with a .rb extension in the
following locations:

-   $libdir/puppet/parser/functions
-   $moduledir/$modulename/plugins/puppet/parser/functions
-   puppet/parser/functions sub-directories in your Ruby
    $LOAD\_PATH

For example, if default libdir is /var/puppet/lib, then you would put your
functions in /var/puppet/lib/puppet/parser/functions.

The file name is derived from the name of the function that Puppet
is trying to run. So, let's say that /usr/local/lib/site\_ruby is
in your machine's $LOAD\_PATH (this is certainly true on
Debian/Ubuntu systems, I'd expect it to be true on a lot of other
platforms too), you can create the directory
/usr/local/lib/site\_ruby/puppet/parser/functions, then put the
code for the my\_function function in
/usr/local/lib/site\_ruby/puppet/parser/functions/my\_function.rb,
and it'll be loaded by the Puppetmaster when you first use that
function.

# Baby's First Function -- small steps

New functions are defined by executing the newfunction method
inside the Puppet::Parser::Functions module. You pass the name of
the function as a symbol to newfunction, and the code to be run as
a block. So a trivial function to write a string to a file /tmp
might look like this:

    module Puppet::Parser::Functions
      newfunction(:write_line_to_file) do |args|
        filename = args[0]
        str = args[1]
        File.open(args[0], 'a') {|fd| fd.puts str }
      end
    end

To use this function, it's as simple as using it in your manifest:

    write_line_to_file('/tmp/some_file', "Hello world!")

Now, before Luke has a coronary -- that is not a good example of a
useful function. I can't imagine why you would want to be able to
do this in Puppet in real life. This is purely an example of how a
function *can* be written.

The arguments to the function are passed into the block via the
args argument to the block. This is simply an array of all of the
arguments given in the manifest when the function is called.
There's no real parameter validation, so you'll need to do that
yourself.

This simple write\_line\_to\_file function is an example of a
*statement* function. It performs an action, and does not return a
value. Hence it must be used on its own. The other type of function
is an *rvalue* function, which you must use in a context which
requires a value, such as an if statement, case statement, or a
variable or attribute assignment. You could implement a rand
function like this:

    module Puppet::Parser::Functions
      newfunction(:rand, :type => :rvalue) do |args|
        rand(vals.empty? ? 0 : args[0])
      end
    end

This function works identically to the Ruby built-in rand function.
Randomising things isn't quite as useful as you might think,
though. The first use for a rand function that springs to mind is
probably to vary the minute of a cron job. For instance, to stop
all your machines from running a job at the same time, you might do
something like:

    cron { run_some_job_at_a_random_time:
      command => "/usr/local/sbin/some_job",
      minute => rand(60)
    }

But the problem here is quite simple: every time the Puppet client
runs, the rand function gets re-evaluated, and your cron job moves
around. The moral: just because a function *seems* like a good
idea, don't be so quick to assume that it'll be the answer to all
your problems.

# Using Facts and Variables

"But damnit", you say, "now you've got this idea of splaying my
cron jobs on different machines, and I just ''have'' to do this
now. You can't leave me hanging like this." Well, it can be done.
The trick is to tie your minute value to something that's invariant
in time, but different across machines. Personally, I like the MD5
hash of the hostname, modulo 60, or perhaps the IP address of the
host, converted to an integer, modulo 60. Neither of them will
guarantee uniqueness, but you can't really expect that with a range
of no more than 60 anyway.

But how do you get at the hostname or IP address of the client
machine? "You already told us that functions are run on the server,
so that's your idea up in smoke then." Aaah, but we have *facts*.
Not opinions, but cold hard facts. And we can use them in our
functions.

## Example 1

    require 'ipaddr'
    
    module Puppet::Parser::Functions
      newfunction(:minute_from_address, :type => :rvalue) do |args|
        IPAddr.new(lookupvar('ipaddress')).to_i % 60
      end
    end

## Example 2

    require 'md5'
    
    module Puppet::Parser::Functions
      newfunction(:hour_from_fqdn, :type => :rvalue) do |args|
        MD5.new(lookupvar('fqdn')).to_s.hex % 24
      end
    end

Basically, to get a fact's or variable's value, you just call
lookupvar('name').

# Accessing Files

If your function will be accessing files, then you need to let the
parser know that it must recompile the configuration if that file
changes. In 0.23.2, this can be achieved by adding this to the
function:

    self.interp.newfile($filename)

In future releases, this will change to
parser.watch\_file($filename).

Finally, an example. This function takes a filename as argument and
returns the last line of that file as its value:

    module Puppet::Parser::Functions
      newfunction(:file_last_line, :type => :rvalue) do |args|
        self.interp.newfile(args[0])
        lines = IO.readlines(args[0])
        lines[lines.length - 1]
      end
    end

A directory name may also be passed. The exact behaviour may be
platform-dependent, but on my GNU/Linux system, this caused it to
watch for files being added, removed, or modified in that
directory.

Note that there may be a delay before Puppet picks up the changed
file, so if your Puppet clients are contacting the master very
regularly (I test with a 3 second delay), then it may be a few runs
through the configuration before the file change is detected.

# Calling Functions from Functions

Functions can be accessed from other functions by prefixing them
with "function" and underscore.

## Example

    module Puppet::Parser::Functions
      newfunction(:myfunc2, :type => :rvalue) do |args|
        function_myfunc1(...)
      end
    end

# Handling Errors

To throw a parse/compile error in your function, in a similar
manner to the fail() function:

    raise Puppet::ParseError, "my error"

# Troubleshooting Functions

If you're experiencing problems with your functions loading,
there's a couple of things you can do to see what might be causing
the issue:

1 - Make sure your function is parsing correctly, by running:

    ruby -rpuppet my_funct.rb

This should return nothing if the function is parsing correctly,
otherwise you'll get an exception which should help troubleshoot
the problem.

2 - Check that the function is available to Puppet:

    irb
    > require 'puppet'
    > require '/path/to/puppet/functions/my_funct.rb'
    > Puppet::Parser::Functions.function(:my_funct)
    => "function_my_funct"

Substitute :my\_funct with the name of your function, and it should
return something similar to "function\_my\_funct" if the function
is seen by Puppet. Otherwise it will just return false, indicating
that you still have a problem (and you'll more than likely get a
"Unknown Function" error on your clients).

Referencing Custom Functions In Templates
-----------------------------------------

To call a custom function within a [Puppet Template](./templating.html), you can do:

   <%= scope.function_namegoeshere(["one","two"]) %>

Replace "namegoeshere" with the function name, and even if there is only one argument, still
include the array brackets.



