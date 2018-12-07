---
layout: default
title: "Custom facts walkthrough"
---

[Facter 3.0.2 release notes]: ../3.0/release_notes.html#facter--p-restored
[Plugins in Modules]: /docs/puppet/latest/plugins_in_modules.html
[Adding plug-ins to a module]: /docs/puppet/latest/plugins_in_modules.html#adding-plug-ins-to-a-module

You can add custom facts by writing snippets of Ruby code on the Puppet master. Puppet then uses [Plugins in Modules][] to distribute the facts to the client.

For information on how to add custom facts to modules, see [Adding plug-ins to a module][].

## Adding custom facts to Facter

Sometimes you need to be able to write conditional expressions based on site-specific data that just isn't available via Facter, or perhaps you'd like to include it in a template.

Because you can't include arbitrary Ruby code in your manifests, the best solution is to add a new fact to Facter. These additional facts can then be distributed to Puppet clients and are available for use in manifests and templates, just like any other fact is.

> **Note:** Facter 3.0 removed the Ruby implementations of some features and replaced them with a [custom facts API](https://github.com/puppetlabs/facter/blob/master/Extensibility.md#custom-facts-compatibility). Any custom fact that requires one of the Ruby files previously stored in `lib/facter/util` fails with an error. For more information, see the [Facter 3.0 release notes](../3.0/release_notes.html).

### Structured and flat facts

A typical fact extracts a piece of information about a system and returns it as either as a simple value ("flat" fact) or data organized as a hash or array ("structured" fact). There are several types of facts classified by how they collect information, including:

-   [Core facts](./core_facts.html), which are built into Facter and are common to almost all systems
-   [Custom facts](#loading-custom-facts), which run Ruby code to produce a value
-   [External facts](#external-facts), which return values from pre-defined static data, or the result of an executable script or program

All fact types can produce flat or structured values.

## Loading custom facts

Facter offers multiple methods of loading facts:

-   `$LOAD\_PATH`, or the Ruby library load path
-   The `--custom-dir` command line option
-   The environment variable 'FACTERLIB'

You can use these methods to do things like test files locally before distributing them, or you can arrange to have a specific set of facts available on certain machines.

### Using the Ruby load path

Facter searches all directories in the Ruby `$LOAD_PATH` variable for
subdirectories named `facter`, and loads all Ruby files in those directories.
If you had a directory in your `$LOAD_PATH` like `~/lib/ruby`, set up like
this:

    #~/lib/ruby
    └── facter
        ├── rackspace.rb
        ├── system_load.rb
        └── users.rb

Facter loads `facter/system_load.rb`, `facter/users.rb`, and
`facter/rackspace.rb`.

### Using the `--custom-dir` command line option

Facter can take multiple `--custom-dir` options on the command line that specifies a single directory
to search for custom facts. Facter attempts to load all Ruby files in the specified directories.
This allows you to do something like this:

    $ ls my_facts
    system_load.rb
    $ ls my_other_facts
    users.rb
    $ facter --custom-dir=./my_facts --custom-dir=./my_other_facts system_load users
    system_load => 0.25
    users => thomas,pat

### Using the `FACTERLIB` environment variable

Facter also checks the environment variable `FACTERLIB` for a delimited (semicolon for Windows and colon for all
other platforms) set of directories, and tries to load all Ruby files in those directories.
This allows you to do something like this:

    $ ls my_facts
    system_load.rb
    $ ls my_other_facts
    users.rb
    $ export FACTERLIB="./my_facts:./my_other_facts"
    $ facter system_load users
    system_load => 0.25
    users => thomas,pat

> ### Note: Changes in built-in pluginsync support in Facter 3
>
> Facter 2.4 **deprecated** Facter's support for loading facts via Puppet's pluginsync
> (the `-p` option), and Facter 3.0.0 **removed** the `-p` option. However, we reversed
> this decision in Facter 3.0.2 and re-enabled the `-p` option. For details about current
> and future support for this option, see the [Facter 3.0.2 release notes][].

## Two parts of every fact

Most facts have at least two elements:

1.  A call to `Facter.add('fact_name')`, which determines the name of the fact.
2.  A `setcode` statement for simple resolutions, which is evaluated to determine the fact's value.

Facts *can* get a lot more complicated than that, but those two together are the most common implementation of a custom fact.

## Executing shell commands in facts

Puppet gets information about a system from Facter, and the most common way for Facter to
get that information is by executing shell commands. You can then parse and manipulate the
output from those commands using standard Ruby code. The Facter API gives you a few ways to
execute shell commands:

-   To run a command and use the output verbatim, as your fact's value, you can pass the command into `setcode` directly. For example: `setcode 'uname --hardware-platform'`
-   If your fact is more complicated than that, you can call `Facter::Core::Execution.execute('uname --hardware-platform')` from within the `setcode do`...`end` block. Whatever the `setcode` statement returns is used as the fact's value.
-   Your shell command is also a Ruby string, so you need to escape special characters if you want to pass them through.

> **Note:** Not everything that works in the terminal works in a fact. You can use the pipe (`|`) and similar operators as you normally would, but Bash-specific syntax like `if` statements do not work. The best way to handle this limitation is to write your conditional logic in Ruby.

### Example

To get the output of `uname --hardware-platform` to single out a specific type of workstation, you create a new custom fact.

1.  Start by giving the fact a name, in this case, `hardware_platform`.

2.  Create your new fact in a file, `hardware_platform.rb` on the Puppet master server:

    ``` ruby
    # hardware_platform.rb

    Facter.add('hardware_platform') do
      setcode do
        Facter::Core::Execution.execute('/bin/uname --hardware-platform')
      end
    end
    ```

3.  Use the instructions in the [Plugins in Modules][] page to copy the new fact to a module and distribute it. During your next Puppet run, the value of the new fact is available to use in your manifests and templates.

## Using other facts

You can write a fact that uses other facts by accessing `Facter.value(:somefact)`.
If the fact fails to resolve or is not present, Facter returns `nil`.

For example:

``` ruby
Facter.add(:osfamily) do
  setcode do
    distid = Facter.value(:lsbdistid)
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
```

## Configuring facts

Facts have a few properties that you can use to customize how they are evaluated.

### Confining facts

One of the more commonly used properties is the `confine` statement, which
restricts the fact to only run on systems that matches another given fact.

An example of the confine statement would be something like the following:

``` ruby
Facter.add(:powerstates) do
  confine :kernel => 'Linux'
  setcode do
    Facter::Core::Execution.execute('cat /sys/power/states')
  end
end
```

This fact uses sysfs on linux to get a list of the power states that are
available on the given system. Since this is only available on Linux systems,
we use the confine statement to ensure that this fact isn't needlessly run on
systems that don't support this type of enumeration.

To confine structured facts like `['os']['family']`, you can use `Facter.value`:

``` ruby
confine Facter.value(:os)['family'] => 'RedHat'
```

You can also use a Ruby block:

``` ruby
confine :os do |os|
  os['family'] == 'RedHat'
end
```

### Fact precedence

A single fact can have multiple **resolutions**, each of which is a different way
of ascertaining what the value of the fact should be. It's very common to have
different resolutions for different operating systems, for example. It's easy to
confuse facts and resolutions because they are superficially identical --- to add
a new resolution to a fact, you simply add the fact again, only with a different
`setcode` statement.

When a fact has more than one resolution, the first resolution that returns a value other
than `nil` sets the fact's value. The way that Facter decides the issue of resolution precedence is the
weight property. Once Facter rules out any resolutions that are excluded because of `confine` statements,
the resolution with the highest weight is evaluated first. If that resolution returns `nil`,
Facter moves on to the next resolution (by descending weight) until it gets a value for the fact.

By default, the weight of a fact is the number of confines for that resolution, so
that more specific resolutions take priority over less specific resolutions. Note that external facts have a weight of 1000 — to override these set a weight above 1000.

``` ruby
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
```

### Execution timeouts

Although this version of Facter does not support overall timeouts on resolutions, you can pass a timeout
to `Facter::Core::Execution#execute`:

``` ruby
Facter.add(:sleep) do
  setcode do
    begin
      Facter::Core::Execution.execute('sleep 10', options = {:timeout => 5})
      'did not timeout!'
    rescue Facter::Core::Execution::ExecutionFailure
      'timeout!'
    end
  end
end
```

## Structured facts

Structured facts take the form of either a hash or an array. To create a structured fact, return a hash or an array from the `setcode` statement.

You can see some relevant examples in the [writing structured facts](./fact_overview.html#writing-structured-facts) section of the [Fact Overview](./fact_overview.html).

## Aggregate resolutions

If your fact combines the output of multiple commands, it may make sense to use aggregate resolutions. An aggregate resolution is split into "chunks", each one responsible for resolving one piece of the fact. After all of the chunks have been resolved separately, they're combined into a single flat or structured fact and returned.

Aggregate resolutions have several key differences compared to simple resolutions, beginning with the fact declaration. To introduce an aggregate resolution, add the `:type => :aggregate` parameter:

``` ruby
Facter.add(:fact_name, :type => :aggregate) do
    #chunks go here
    #aggregate block goes here
end
```

Each step in the resolution then gets its own named `chunk` statement:

``` ruby
chunk(:one) do
    'Chunk one returns this. '
end

chunk(:two) do
    'Chunk two returns this.'
end
```

Aggregate resolutions *never* have a `setcode` statement. Instead, they have an optional `aggregate` block that combines the chunks. Whatever value the `aggregate` block returns is the fact's value. Here's an example that just combines the strings from the two chunks above:

``` ruby
aggregate do |chunks|
  result = ''

  chunks.each_value do |str|
    result += str
  end

  # Result: "Chunk one returns this. Chunk two returns this."
  result
end
```

If the `chunk` blocks all return arrays or hashes, you can omit the `aggregate` block. If you do, Facter automatically merges all of your data into one array or hash and uses that as the fact's value.

For more examples of aggregate resolutions, see the [aggregate resolutions](./fact_overview.html#writing-facts-with-aggregate-resolutions) section of the [Fact Overview](./fact_overview.html) page.

## Viewing fact values

[puppetdb]: /puppetdb/latest

If your Puppet masters are configured to use [PuppetDB][puppetdb], you can view and search all of the facts for any node, including custom facts. See [the PuppetDB docs][puppetdb] for more info.

## External facts

External facts provide a way to use arbitrary executables or scripts as facts, or set facts statically with structured data. If you've ever wanted to write a custom fact in Perl, C, or a one-line text file, this is how.

### Fact locations

The best way to distribute external facts is with pluginsync, which added support for them in [Puppet 3.4](/puppet/3/reference/release_notes.html#preparations-for-syncing-external-facts)/[Facter 2.0.1](../2.0/release_notes.html#pluginsync-for-external-facts). To add external facts to your Puppet modules, just place them in `<MODULEPATH>/<MODULE>/facts.d/`.

If you're not using pluginsync, then external facts must go in a standard directory. The location of this directory varies depending on your operating system, whether your deployment uses Puppet Enterprise or open source releases, and whether you are running as root/Administrator. When calling facter from the command line, you can specify the external facts directory with the `--external-dir` option.

> **Note:** These directories don't necessarily exist by default; you may need to create them. If you create the directory, make sure to restrict access so that only Administrators can write to the directory.

In a module (recommended):

    <MODULEPATH>/<MODULE>/facts.d/

On Unix/Linux/OS X, there are three directories:

    /opt/puppetlabs/facter/facts.d/
    /etc/puppetlabs/facter/facts.d/
    /etc/facter/facts.d/

On Windows:

    C:\ProgramData\PuppetLabs\facter\facts.d\

When running as a non-root / non-Administrator user:

    <HOME DIRECTORY>/.facter/facts.d/

> **Note:** You can only use custom facts as a non-root user if you have first [configured non-root user access]({{pe}}/deploy_nonroot-agent.html) and previously run Puppet agent as that same user.

### Executable facts --- Unix

Executable facts on Unix work by dropping an executable file into the standard
external fact path. A shebang (`#!`) is always required for executable facts on Unix. If the shebang is missing, the execution of the fact fails.

An example external fact written in Python:

``` python
#!/usr/bin/env python
data = {"key1" : "value1", "key2" : "value2" }

for k in data:
    print "%s=%s" % (k,data[k])
```

You must ensure that the script has its execute bit set:

    chmod +x /etc/facter/facts.d/my_fact_script.py

For Facter to parse the output, the script must return key/value pairs on
STDOUT in the format:

    key1=value1
    key2=value2
    key3=value3

Using this format, a single script can return multiple facts.

### Executable facts --- Windows

Executable facts on Windows work by dropping an executable file into the external fact path. Unlike with Unix, the external facts interface expects Windows scripts to end with a known extension. Line endings can be either `LF` or `CRLF`. The following extensions are currently supported:

-   `.com` and `.exe`: binary executables
-   `.bat` and `.cmd`: batch scripts
-   `.ps1`: PowerShell scripts

As with Unix facts, each script must return key/value pairs on STDOUT in the format:

    key1=value1
    key2=value2
    key3=value3

Using this format, a single script can return multiple facts in one return.

#### Batch scripts

The file encoding for `.bat/.cmd` files must be `ANSI` or `UTF8 without BOM` (Byte Order Mark), otherwise you may get strange output.

Here is a sample batch script which outputs facts using the required format:

    @echo off
    echo key1=val1
    echo key2=val2
    echo key3=val3
    REM Invalid - echo 'key4=val4'
    REM Invalid - echo "key5=val5"

#### PowerShell scripts

The encoding that should be used with `.ps1` files is pretty open. PowerShell determines the encoding of the file at run time.

Here is a sample PowerShell script which outputs facts using the required format:

    Write-Host "key1=val1"
    Write-Host 'key2=val2'
    Write-Host key3=val3

You should be able to save and execute this PowerShell script on the command line.

### Structured data facts

Facter can parse structured data files stored in the external facts directory and set facts based on their contents.

Structured data files must use one of the supported data types and must have the correct file extension. Facter supports the following extensions and data types:

`.yaml`: YAML data, in the following format:

``` yaml
---
key1: val1
key2: val2
key3: val3
```

`.json`: JSON data, in the following format:

``` javascript
{
    "key1": "val1",
    "key2": "val2",
    "key3": "val3"
}
```

`.txt`: Key value pairs, of the `String` data type, in the following format:

```
key1=value1
key2=value2
key3=value3
```

As with executable facts, structured data files can set multiple facts at once.

``` javascript
{
  "datacenter":
  {
    "location": "bfs",
    "workload": "Web Development Pipeline",
    "contact": "Blackbird"
  },
  "provision":
  {
    "birth": "2017-01-01 14:23:34",
    "user": "alex"
  }
}
```

#### Structured data facts on Windows

All of the above types are supported on Windows with the following caveats:

-   The line endings can be either `LF` or `CRLF`.
-   The file encoding must be either `ANSI` or `UTF8 without BOM` (Byte Order Mark).

### Troubleshooting

If your external fact is not appearing in Facter's output, running
Facter in debug mode should give you a meaningful reason and tell you which file is causing the problem:

    # puppet facts --debug

One example of when this can happen is in cases where a fact returns invalid characters.
For example if you used a hyphen instead of an equals sign in your script `test.sh`:

    #!/bin/bash

    echo "key1-value1"

Running `puppet facts --debug` yields a useful message:

    ...
    Debug: Facter: resolving facts from executable file "/tmp/test.sh".
    Debug: Facter: executing command: /tmp/test.sh
    Debug: Facter: key1-value1
    Debug: Facter: ignoring line in output: key1-value1
    Debug: Facter: process exited with status code 0.
    Debug: Facter: completed resolving facts from executable file "/tmp/test.sh".
    ...

#### External facts and `stdlib`

If you find that an external fact does not match what you have configured in your `facts.d`
directory, make sure you have not defined the same fact using the external facts capabilities
found in the `stdlib` module.

### Drawbacks

While external facts provide a mostly-equal way to create variables for Puppet, they have a few drawbacks:

-   An external fact cannot internally reference another fact. However, due to parse order, you can reference an external fact from a Ruby fact.
-   External executable facts are forked instead of executed within the same process.
