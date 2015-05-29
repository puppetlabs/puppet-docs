---
layout: default
title: "Facter 1.6: Custom Facts"
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

> **Note:** Prior to Facter 1.5.8, values returned by `Facter::Util::Resolution.exec` often had trailing newlines. If your custom fact will also be used by older versions of Facter, you may need to call `chomp` on these values. (In the example above, this would look like `Facter::Util::Resolution.exec('/bin/uname --hardware-platform').chomp`.)

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
