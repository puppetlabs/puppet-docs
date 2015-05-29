---
layout: default
title: "Facter 1.7: Custom Facts"
---

Custom Facts
============

Extend facter by writing your own custom facts to provide information to Puppet.

* * *

[executionpolicy]: http://technet.microsoft.com/en-us/library/ee176949.aspx

## Adding Custom Facts to Facter

Sometimes you need to be able to write conditional expressions
based on site-specific data that just isn't available via Facter,
or perhaps you'd like to include it in a template.

Since you can't include arbitrary ruby code in your manifests,
the best solution is to add a new fact to Facter. These additional facts
can then be distributed to Puppet clients and are available for use
in manifests and templates, just like any other fact would be.

## The Concept

You can add new facts by writing snippets of ruby code on the
Puppet master. Puppet will then use [Plugins in Modules](/guides/plugins_in_modules.html)
to distribute the facts to the client.

## Loading Custom Facts

Facter offers a few methods of loading facts:

 * $LOAD\_PATH, or the ruby library load path
 * The environment variable 'FACTERLIB'
 * Facts distributed using pluginsync

You can use these methods of loading facts do to things like test files locally
before distributing them, or you can arrange to have a specific set of facts available on certain
machines.

Facter will search all directories in the ruby $LOAD\_PATH variable for
subdirectories named 'facter', and will load all ruby files in those directories.
If you had some directory in your $LOAD\_PATH like ~/lib/ruby, set up like
this:

    #~/lib/ruby
    └── facter
        ├── rackspace.rb
        ├── system_load.rb
        └── users.rb

Facter would try to load 'facter/system\_load.rb', 'facter/users.rb', and
'facter/rackspace.rb'.

Facter also will check the environment variable `FACTERLIB` for a colon-delimited
set of directories, and will try to load all ruby files in those directories.
This allows you to do something like this:

    $ ls my_facts
    system_load.rb
    $ ls my_other_facts
    users.rb
    $ export FACTERLIB="./my_facts:./my_other_facts"
    $ facter system_load users
    system_load => 0.25
    users => thomas,pat

Facter can also easily load fact files distributed using pluginsync. Running
`facter -p` will load all the facts that have been distributed via pluginsync,
so if you're using a lot of custom facts inside puppet, you can easily use
these facts with standalone facter.

Custom facts can be distributed to clients using the [Plugins In Modules](/guides/plugins_in_modules.html) method.

## Two Parts of Every Fact

Setting aside external facts for now, every fact has at least two elements:

 1. a call to `Facter.add('fact_name')`, which determines the name of the fact
 2. a `setcode` statement, which will be evaluated to determine the fact's value.

Facts *can* get a lot more complicated than that, but those two together are the
minimum that you will see in every fact.

## Executing Shell Commands in Facts

Puppet gets information about a system from Facter, and the most common way for Facter to
get that information is by executing shell commands. You can then parse and manipulate the
output from those commands using standard ruby code. The Facter API gives you two ways to
execute shell commands:

  * if all you want to do is run the command and use the output, verbatim, as your fact's value,
  you can pass the command into `setcode` directly. For example: `setcode "uname --hardware-platform"`
  * if your fact is any more complicated than that, you'll have to call `Facter::Util::Resolution.exec('uname --hardware-platform')`
  from within the `setcode do`...`end` block. As always, whatever the `setcode` statement returns will be used as the fact's value.

It's important to note that *not everything that works in the terminal will work in a fact*. You can use the pipe (`|`) and similar operators just as you normally would, but Bash-specific syntax like `if` will not work. The best way to handle this limitation is to write your conditional logic in ruby.

### An Example

Let's say you need to get the output of `uname --hardware-platform` to single out a
specific type of workstation. To do this, you would create a new custom
fact. Start by giving the fact a name, in this case, `hardware_platform`,
and create your new fact in a file, `hardware_platform.rb`, on the
Puppet master server:

~~~ ruby
    # hardware_platform.rb

    Facter.add('hardware_platform') do
      setcode do
        Facter::Util::Resolution.exec('/bin/uname --hardware-platform')
      end
    end
~~~

You can then use the instructions in [Plugins In Modules](/guides/plugins_in_modules.html) page to copy
the new fact to a module and distribute it. During your next Puppet run, the value of the new fact
will be available to use in your manifests and templates.

The best place to get ideas about how to write your own custom facts is to look at the [code for Facter's core facts](https://github.com/puppetlabs/facter/tree/master/lib/facter). There you will find a wealth of examples of how to retrieve different types of system data and return useful facts.

## Using other facts

You can write a fact which uses other facts by accessing
`Facter.value('somefact')`.

For example:

~~~ ruby
    Facter.add('osfamily') do
      setcode do
        distid = Facter.value('lsbdistid')
        case distid
        when /RedHatEnterprise|CentOS|Fedora/
          'redhat'
        when 'ubuntu'
          'debian'
        else
          distid
        end
      end
    end
~~~

## Configuring Facts

Facts have a few properties that you can use to customize how facts are evaluated.

### Confining Facts

One of the more commonly used properties is the `confine` statement, which
restricts the fact to only run on systems that matches another given fact.

An example of the confine statement would be something like the following:

~~~ ruby
    Facter.add(:powerstates) do
      confine :kernel => 'Linux'
      setcode do
        Facter::Util::Resolution.exec('cat /sys/power/states')
      end
    end
~~~

This fact uses sysfs on linux to get a list of the power states that are
available on the given system. Since this is only available on Linux systems,
we use the confine statement to ensure that this fact isn't needlessly run on
systems that don't support this type of enumeration.

### Fact precedence

A single fact can have multiple **resolutions**, each of which is a different way
of ascertaining what the value of the fact should be. It's very common to have
different resolutions for different operating systems, for example. It's easy to
confuse facts and resolutions because they are superficially identical --- to add
a new resolution to a fact, you simply add the fact again, only with a different
`setcode` statement.

When a fact does have more than one resolution, you'll want to make sure that only one of them
gets executed. Otherwise, each subsequent resolution would override the one before it,
and you might not get the value that you want.

The way that Facter decides the issue of precedence is the weight property.
Once Facter rules out any resolutions that are excluded because of `confine` statments,
the resolution with the highest weight will be executed. If that resolution doesn't return
a value, Facter will move on to the next resolution (by descending weight) until it gets
a suitable value for the fact.

By default, the weight of a fact is the number of confines for that resolution, so
that more specific resolutions will take priority over less specific resolutions.

~~~ ruby
    # Check to see if this server has been marked as a postgres server
    Facter.add(:role) do
      has_weight 100
      setcode do
        if File.exist? '/etc/postgres_server'
          'postgres_server'
        end
      end
    end

    # Guess if this is a server by the presence of the pg_create binary
    Facter.add(:role) do
      has_weight 50
      setcode do
        if File.exist? '/usr/sbin/pg_create'
          'postgres_server'
        end
      end
    end

    # If this server doesn't look like a server, it must be a desktop
    Facter.add(:role) do
      setcode do
        'desktop'
      end
    end
~~~

### Timing out

If you have facts that are unreliable and may not finish running, you can use
the `timeout` property. If a fact is defined with a timeout and the evaluation
of the setcode block exceeds the timeout, Facter will halt the resolution of
that fact and move on.

~~~ ruby
    # Sleep
    Facter.add(:sleep, :timeout => 10) do
      setcode do
          sleep 999999
      end
    end
~~~

## Viewing Fact Values

[inventory]: /guides/inventory_service.html
[puppetdb]: /puppetdb/latest

If your puppet master(s) are configured to use [PuppetDB][] and/or the [inventory service][inventory], you can view and search all of the facts for any node, including custom facts. See the PuppetDB or inventory service docs for more info.

External Facts
--------------

### What are external facts?

External facts provide a way to use arbitrary executables or scripts as facts, or set facts statically with structured data. If you've ever wanted to write a custom fact in Perl, C, or a one-line text file, this is how.

### Fact Locations

External facts must go in a standard directory. The location of this directory varies depending on your operating system, whether your deployment uses Puppet Enterprise or open source releases, and whether you are running as root/Administrator. When calling facter from the command line, you can specify the external facts directory with the `--external-dir` option.

> **Note:** These directories will not necessarily exist by default; you may need to create them. If you create the directory, make sure
to restrict access so that only Administrators can write to the
directory.

On Unix/Linux/Mac OS X:

    /etc/facter/facts.d/ # Puppet Open Source
    /etc/puppetlabs/facter/facts.d/ # Puppet Enterprise

On Windows 2003:

    C:\Documents and Settings\All Users\Application Data\PuppetLabs\facter\facts.d\

On other supported Windows Operating Systems (Windows Vista, 7, 8, 2008, 2012):

    C:\ProgramData\PuppetLabs\facter\facts.d\

When running as a non-root / non-Administrator user: (Facter 1.7.4 or later, on both \*nix and Windows)

    <HOME DIRECTORY>/.facter/facts.d/

### Executable facts --- Unix

Executable facts on Unix work by dropping an executable file into the standard
external fact path above.

An example external fact written in Python:

~~~ python
    #!/usr/bin/env python
    data = {"key1" : "value1", "key2" : "value2" }

    for k in data:
            print "%s=%s" % (k,data[k])
~~~


You must ensure that the script has its execute bit set:

    chmod +x /etc/facter/facts.d/my_fact_script.py

For Facter to parse the output, the script must return key/value pairs on
STDOUT in the format:

    key1=value1
    key2=value2
    key3=value3

Using this format, a single script can return multiple facts.

### Executable facts --- Windows

> **Note:** Executable facts on Windows are supported in Facter 1.7.3 and later; if you are using 1.7.0 through 1.7.2, you must upgrade in order to use them.

Executable facts on Windows work by dropping an executable file into the external fact path for your version of Windows. Unlike with Unix, the external facts interface expects Windows scripts to end with a known extension. Line endings can be either `LF` or `CRLF`. At the moment the following extensions are supported:

-   `.com` and `.exe`: binary executables
-   `.bat` and `.cmd`: batch scripts
-   `.ps1`: PowerShell scripts

As with Unix facts, each script must return key/value pairs on STDOUT in the format:

    key1=value1
    key2=value2
    key3=value3

Using this format, a single script can return multiple facts in one return.

#### Batch Scripts

The file encoding for `.bat/.cmd` files must be `ANSI` or `UTF8 without BOM` (Byte Order Mark), otherwise you may get strange output.

Here is a sample batch script which outputs facts using the required format:

    @echo off
    echo key1=val1
    echo key2=val2
    echo key3=val3
    REM Invalid - echo 'key4=val4'
    REM Invalid - echo "key5=val5"

#### PowerShell Scripts

The encoding that should be used with `.ps1` files is pretty open. PowerShell will determine the encoding of the file at run time.

Here is a sample PowerShell script which outputs facts using the required format:

    Write-Host "key1=val1"
    Write-Host 'key2=val2'
    Write-Host key3=val3

You should be able to save and execute this PowerShell script on the command line.

### Structured Data Facts

Facter can parse structured data files stored in the external facts directory and set facts based on their contents.

Structured data files must use one of the supported data types and must have the correct file extension. At the moment, Facter supports the following extensions and data types:

* `.yaml`: YAML data, in the following format:

~~~ yaml
        ---
        key1: val1
        key2: val2
        key3: val3
~~~

* `.json`: JSON data, in the following format:

~~~ javascript
        {
            "key1": "val1",
            "key2": "val2",
            "key3": "val3"
        }
~~~

* `.txt`: Key value pairs, in the following format:

        key1=value1
        key2=value2
        key3=value3

As with executable facts, structured data files can set multiple facts at once.

#### Structured Data Facts on Windows

All of the above types are supported on Windows with the following caveats:

* The line endings can be either `LF` or `CRLF`.
* The file encoding must be either `ANSI` or `UTF8 without BOM` (Byte Order Mark).

### Troubleshooting

If your external fact is not appearing in Facter's output, running
Facter in debug mode should give you a meaningful reason and tell you which file is causing the problem:

    # facter --debug

An example would be in cases where a fact returns invalid characters.
Let say you used a hyphen instead of an equals sign in your script `test.sh`:

    #!/bin/bash

    echo "key1-value1"

Running `facter --debug` should yield a useful error message:

    ...
    Fact file /etc/facter/facts.d/sample.txt was parsed but returned an empty data set
    ...

If you are interested in finding out where any bottlenecks are, you can run
Facter in timing mode and it will reflect how long it takes to parse your
external facts:

    facter --timing

The output should look similar to the timing for ruby facts, but will name external facts with their full paths. For example:

    $ facter --timing
    kernel: 14.81ms
    /usr/lib/facter/ext/abc.sh: 48.72ms
    /usr/lib/facter/ext/foo.sh: 32.69ms
    /usr/lib/facter/ext/full.json: 104.71ms
    /usr/lib/facter/ext/sample.txt: 0.65ms
    ....

#### External Facts and stdlib

If you find that an external fact does not match what you have configured in your `facts.d`
directory, make sure you have not defined the same fact using the external facts capabilities
found in the stdlib module.

### Drawbacks

While external facts provide a mostly-equal way to create variables for Puppet, they have a few drawbacks:

* An external fact cannot internally reference another fact. However, due to parse order, you can reference an external fact from a ruby fact.
* External executable facts are forked instead of executed within the same process.
* Although we plan to allow distribution of external facts through Puppet's pluginsync capability, this is not yet supported. See [ticket #9546](https://projects.puppetlabs.com/issues/9546)
