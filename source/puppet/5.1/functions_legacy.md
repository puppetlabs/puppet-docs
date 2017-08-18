---
title: "The legacy Ruby functions API"
---

[environments]: ./environments.html
[func_modern]: ./functions_ruby_overview.html
[func_puppet]: ./lang_write_functions_in_puppet.html

Puppet includes two Ruby APIs for writing custom functions. This page is about the legacy API, which uses the `Puppet::Parser::Functions` namespace.

> **Important:** This API has severe problems --- most notably, functions that use it will leak between [environments][]. You should never use this API unless you absolutely must support Puppet 3.
>
> * If you want to write functions in Ruby without this API's failures and limitations, use [the modern Ruby functions API.][func_modern]
> * If you want an easier way to write functions, try [writing them in the Puppet language.][func_puppet]



## Where to put your functions

Functions are implemented in individual .rb files (whose filenames must match the names of their respective functions), and should be distributed in modules. Put custom functions in the lib/puppet/parser/functions subdirectory of your module.

## First Function --- small steps

New functions are defined by executing the `newfunction` method
inside the `Puppet::Parser::Functions` module. You pass the name of
the function as a symbol to `newfunction`, and the code to be run as
a block. So a trivial function to write a string to a file in /tmp
might look like this:

~~~ ruby
    module Puppet::Parser::Functions
      newfunction(:write_line_to_file) do |args|
        filename = args[0]
        str = args[1]
        File.open(filename, 'a') {|fd| fd.puts str }
      end
    end
~~~

To use this function, it's as simple as using it in your manifest:

~~~ ruby
    write_line_to_file('/tmp/some_file', "Hello world!")
~~~

(Note that this is not a useful function by any stretch of the imagination.)

The arguments to the function are passed into the block via the
`args` argument to the block. This is simply an array of all of the
arguments given in the manifest when the function is called.
There's no real parameter validation, so you'll need to do that
yourself.

> **Note:** Accepting an `args` argument in the `newfunction() do` block is mandatory, even if you won't be doing anything with the arguments.

This simple `write_line_to_file` function is an example of a
*statement* function. It performs an action, and does not return a
value. The other type of function
is an *rvalue* function, which you must use in a context which
requires a value, such as an `if` statement, a `case` statement, or a
variable or attribute assignment. You could implement a `rand`
function like this:

~~~ ruby
    module Puppet::Parser::Functions
      newfunction(:rand, :type => :rvalue) do |args|
        rand(args.empty? ? 0 : args[0])
      end
    end
~~~

This function works identically to the Ruby built-in rand function.
Randomising things isn't quite as useful as you might think,
though. The first use for a `rand` function that springs to mind is
probably to vary the minute of a cron job. For instance, to stop
all your machines from running a job at the same time, you might do
something like:

~~~ ruby
    cron { run_some_job_at_a_random_time:
      command => "/usr/local/sbin/some_job",
      minute => rand(60)
    }
~~~

But the problem here is quite simple: every time the Puppet client
runs, the rand function gets re-evaluated, and your cron job moves
around. The moral: just because a function *seems* like a good
idea, don't be so quick to assume that it'll be the answer to all
your problems.

## Using Facts and Variables

Which raises the question: what _should_ you do if you want to splay
your cron jobs on different machines?
The trick is to tie the minute value to something that's invariant
in time, but different across machines. Perhaps the MD5
hash of the hostname, modulo 60, or maybe the IP address of the
host converted to an integer, modulo 60. Neither
guarantees uniqueness, but you can't really expect that with a range
of no more than 60 anyway.

But given that functions are run on the puppet master, how do you get at
the hostname or IP address of the agent node?
The answer is that facts returned by facter can be used in our
functions.

### Example 1

~~~ ruby
    require 'ipaddr'

    module Puppet::Parser::Functions
      newfunction(:minute_from_address, :type => :rvalue) do |args|
        IPAddr.new(lookupvar('ipaddress')).to_i % 60
      end
    end
~~~

### Example 2

~~~ ruby
    require 'md5'

    module Puppet::Parser::Functions
      newfunction(:hour_from_fqdn, :type => :rvalue) do |args|
        MD5.new(lookupvar('fqdn')).to_s.hex % 24
      end
    end
~~~

### Example 3

~~~ ruby
    module Puppet::Parser::Functions
      newfunction(:has_fact, :type => :rvalue) do |arg|
        lookupvar(arg[0]) != nil
      end
    end
~~~

Basically, to get a fact's or variable's value, you just call
`lookupvar('FACT NAME')`.

## Calling Functions from Functions

Functions can be accessed from other functions by
prepending `function_` to the name of the function you are trying to call. This will cause Puppet to automatically locate and load the function; you shouldn't need to call any special methods to make a function available.

Also keep in mind that when calling a puppet function from the puppet DSL, arguments are all passed in as an anonymous array.  This is not the case when calling the function from within Ruby.  To work around this, you must create the anonymous array yourself by putting the arguments (even if there is only one argument) inside square brackets like this:

~~~ ruby
    [ arg1, arg1, arg3 ]
~~~

### Example

~~~ ruby
    module Puppet::Parser::Functions
      newfunction(:myfunc2, :type => :rvalue) do |args|
        function_myfunc1( [ arg1, arg2, ... ] )
      end
    end
~~~

## Handling Errors

To throw a parse/compile error in your function, in a similar
manner to the `fail()` function:

~~~ ruby
    raise Puppet::ParseError, "my error"
~~~

## Referencing Custom Functions In Templates

To call a custom function within a [Puppet Template](./templating.html), you can do:

    <%= scope.function_namegoeshere(["one","two"]) %>

Replace "namegoeshere" with the function name, and even if there is only one argument, still
include the array brackets.

## Notes on Backward Compatibility

### Accessing Files With Older Versions of Puppet

In Puppet 2.6.0 and later, functions can access files with the expectation that
it will just work. In versions prior to 2.6.0, functions that accessed files
had to explicitly warn the parser to recompile the configuration if the files
they relied on changed.

If you find yourself needing to write custom functions for older versions of Puppet, the relevant instructions are preserved below.

#### Accessing Files in Puppet 0.23.2 through 0.24.9

Until Puppet 0.25.0, safe file access was achieved by adding `self.interp.newfile($filename)` to the function. E.g., to accept a file name and return the last line of that file:

~~~ ruby
    module Puppet::Parser::Functions
      newfunction(:file_last_line, :type => :rvalue) do |args|
        self.interp.newfile(args[0])
        lines = IO.readlines(args[0])
        lines[lines.length - 1]
      end
    end
~~~

#### Accessing Files in Puppet 0.25.x

In release 0.25.0, the necessary code changed to:

~~~ ruby
    parser = Puppet::Parser::Parser.new(environment)
    parser.watch_file($filename)
~~~

This new code was used identically to the older code:

~~~ ruby
    module Puppet::Parser::Functions
      newfunction(:file_last_line, :type => :rvalue) do |args|
        parser = Puppet::Parser::Parser.new(environment)
        parser.watch_file($filename)
        lines = IO.readlines(args[0])
        lines[lines.length - 1]
      end
    end
~~~

