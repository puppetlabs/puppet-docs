---
layout: default
title: Custom Facts
---

Custom Facts
============

Extend facter by writing your own custom facts to provide information to Puppet.

* * *

[executionpolicy]: http://technet.microsoft.com/en-us/library/ee176949.aspx

Ruby Facts
----------

### Adding Custom Facts to Facter

Sometimes you need to be able to write conditional expressions
based on site-specific data that just isn't available via Facter (or use
a variable in a template that isn't there).
A solution can be achieved by adding a new fact to Facter. These additional facts
can then be distributed to Puppet clients and are available for use
in manifests.

### The Concept

You can add new facts by writing a snippet of Ruby code on the
Puppet master. We then use [Plugins In Modules](./plugins_in_modules.html) to distribute our
facts to the client.

### An Example

Let's say we need to get the output of uname -i to single out a
specific type of workstation. To do these we create a fact. We
start by giving the fact a name, in this case, `hardware_platform`,
and create our new fact in a file, `hardware_platform.rb`, on the
Puppet master server:

    # hardware_platform.rb

    Facter.add("hardware_platform") do
            setcode do
                    %x{/bin/uname -i}.chomp
            end
    end

Note that the `chomp` is required to provide clean data.

We then use the instructions in [Plugins In Modules](./plugins_in_modules.html) page to copy
our new fact to a module and distribute it. During your next Puppet
run the value of our new fact will be available to use in your
manifests.

The best place to get ideas about how to write your own custom facts is to look at the existing Facter fact code. You will find lots of examples of how to interpret different types of system data and return useful facts.

### Using other facts

You can write a fact which uses other facts by accessing
Facter.value("somefact") or simply Facter.somefact. The former will
return nil for unknown facts, the latter will raise an exception.
An example:

    Facter.add("osfamily") do
        setcode do
            begin
                Facter.lsbdistid
            rescue
                Facter.loadfacts()
            end
            distid = Facter.value('lsbdistid')
            if distid.match(/RedHatEnterprise|CentOS|Fedora/)
                family = "redhat"
            elsif distid == "ubuntu"
                family = "debian"
            else
                family = distid
            end
            family
        end
    end

Here it is important to note that running facter myfact on the
command line will not load other facts, hence the above code calls
Facter.loadfacts to work in this mode, too. loadfacts will only
load the default facts.

To still test your custom puppet facts, which are usually only
loaded by puppetd, there is a small hack:

          mkdir rubylib
          cd rubylib
          ln -s /path/to/puppet/facts facter
          RUBYLIB=. facter

### Loading Custom Facts

Facter offers a few methods of loading facts, so you can do things like
testng facts locally before distributing them or having a specific copy of
facts available to a single user.

Facter will search all directories in the ruby $LOAD\_PATH variable for
subdirectories named facter, and will load all ruby files in those directories.
If you had some directory in your $LOAD\_PATH like ~/lib/ruby, set up like
this:

    {~/lib/ruby}
    └── facter
        ├── rackspace.rb
        ├── system_load.rb
        └── users.rb

Facter would try to load system\_load.rb, users.rb, and rackspace.rb.

Facter also will check the environment variable FACTERLIB for a colon delimited
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

It is important to note that to use the facts on your clients you
will still need to distribute them using the [Plugins In Modules](./plugins_in_modules.html)
method.

### Viewing Fact Values

You can also determine what facts (and their values) your clients
return by checking the contents of the client's yaml output. To do
this we check the `$yamldir` (by default `$vardir/yaml/`) on the Puppet
master:

    # grep kernel /var/lib/puppet/yaml/node/puppetslave.example.org.yaml
      kernel: Linux
      kernelrelease: 2.6.18-92.el5
      kernelversion: 2.6.18

### Caching Ruby Facts

Starting with Facter 1.7.0, you can now specify that the contents of a fact's "setcode"
block should be cached for faster retrieval.

The mechanism for doing this is trivial --- simply supply a "`:ttl`" option during
fact creation. The value is specified in seconds:

    Facter.add("mylongoperation", :ttl => 600) do
        setcode do
            ... an operation that takes a long time ...
        end
    end

The ttl value can also be one of:

* `0` --- never cache. This is the default behaviour.
* `-1` --- cache forever. Useful for one-off operations that should never need to run again.

### Legacy Fact Distribution

For Puppet versions prior to 0.24.0:

On older versions of Puppet, prior to 0.24.0, a different method
called factsync was used for custom fact distribution. Puppet would
look for custom facts on
[puppet://$server/facts](puppet://%24server/facts) by default and
you needed to run puppetd with `--factsync` option (or add `factsync =
true` to puppetd.conf). This would enable the syncing of these files
to the local file system and loading them within puppetd.

Facts were synced to a local directory ($vardir/facts, by default)
before facter was run, so they would be available the first time.
If $factsource was unset, the `--factsync` option is equivalent to:

    file { $factdir: source => "puppet://puppet/facts", recurse => true }

After the facts were downloaded, they were loaded (or reloaded)
into memory.

Some additional options were avaialble to configure this legacy
method:

The following command line or config file options are available
(default options shown):

-   factpath ($vardir/facts): Where Puppet should look for facts.
    Multiple directories should be colon-separated, like normal PATH
    variables. By default, this is set to the same value as factdest,
    but you can have multiple fact locations (e.g., you could have one
    or more on NFS).
-   factdest ($vardir/facts): Where Puppet should store facts that
    it pulls down from the central server.
-   factsource
    ([puppet://$server/facts](puppet://%24server/facts)): From where to
    retrieve facts. The standard Puppet file type is used for
    retrieval, so anything that is a valid file source can be used
    here.
-   factsync (false): Whether facts should be synced with the
    central server.
-   factsignore (.svn CVS): What files to ignore when pulling down
    facts.

Remember the approach described above for `factsync` is now deprecated and replaced by the plugin approach described in the [Plugins In Modules](./plugins_in_modules.html) page.

External Facts
--------------

**External facts are available only in Facter 1.7.0 and later.**

### What are external facts?

External facts provide a way to use arbitrary executables or scripts as facts, or set facts statically with structured data. If you've ever wanted to write a custom fact in Perl, C, or a one-line text file, this is how.

### Fact Locations

On Unix/Linux:

    /usr/lib/facter/ext

On Windows 2003:

    C:\Documents and Settings\All Users\Application Data\Puppetlabs\facter\ext

On Windows 2008:

    C:\ProgramData\Puppetlabs\facter\ext

### Executable facts --- Unix

Executable facts on Unix work by dropping an executable file into the standard 
external fact path above.

You must ensure that the script has its execute bit set:

    chmod +x /usr/lib/facter/ext/myscript

For Facter to parse the output, the script must return key/value pairs on 
STDOUT in the format:

    key1=value1
    key2=value2
    key3=value3

Using this format, a single script can return multiple facts in one return.

### Executable facts --- Windows

Executable facts on Windows work by dropping an executable file into the external fact path for your version of Windows. Unlike with Unix, the external facts
interface expects Windows scripts to end with a known extension. At the moment the 
following extensions are supported:

-   `.com` and `exe`: binary executables
-   `.bat`: batch scripts
-   `.ps1`: PowerShell scripts

As with Unix facts, each script must return key/value pairs on STDOUT in the format:

    key1=value1
    key2=value2
    key3=value3

Using this format, a single script can return multiple facts in one return.

#### Enabling PowerShell Scripts

For PowerShell scripts (scripts with a ps1 extension) to work, you need to make
sure you have the correct execution policy set.

[See this Microsoft TechNet article][executionpolicy] for more detail about
the impact of changing execution policy. We recommend understanding any security
implications before making a global change to execution policy.

The simplest and safest mechanism we have found is to change the execution 
policy so that only remotely downloaded scripts need to be signed. You can
set this policy with:

    Set-ExecutionPolicy RemoteSigned -Scope LocalMachine

Here is a sample PowerShell script which outputs facts using the required format:

    Write-Host "key1=val1"
    Write-Host "key2=val2"
    Write-Host "key3=val3"

You should be able to save and execute this PowerShell script on the command line after changing the execution policy.

### Structured Data Facts

Facter can parse structured data files stored in the external facts directory and set facts based on their contents.

Structured data files must use one of the supported data types and must have the correct file extension. At the moment, Facter supports the following extensions and data types:

* `.yaml`: YAML data, in the following format:

        ---
        key1: val1
        key2: val2
        key3: val3
* `.json`: JSON data, in the following format:

        {
            "key1": "val1",
            "key2": "val2",
            "key3": "val3",
        }
* `.txt`: Key value pairs, in the following format: 

        key1=value1
        key2=value2
        key3=value3

As with executable facts, structured data files can set multiple facts at once.

### Caching External facts

Just like with Ruby facts, you can cache external facts for better performance. This is done by creating a text file in the facts directory with the same file name as the fact (including extension) and the `.ttl` extension. For example, if your script is:

    /usr/lib/facter/ext/myfacts.sh

The `.ttl` file should be:

    /usr/lib/facter/ext/myfacts.sh.ttl

TTL files should contain the number of seconds for which to cache the results. You can also provide the following special TTL values:

* `0` --- never cache. This is the default behaviour.
* `-1` --- cache forever. Useful for one-off operations that should never need to run again.

The TTL value will apply to all of the facts set by the script. 

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
    Fact file /usr/lib/facter/ext/test.sh was parsed but returned an empty data set
    ...

If you are interested in finding out where any bottlenecks are, you can run 
Facter in timing mode and it will reflect how long it takes to parse your 
external facts:

    facter --timing

The output should look similar to the timing for Ruby facts, but will name external facts with their full paths. For example:

    $ facter --timing
    kernel: 14.81ms
    /usr/lib/facter/ext/abc.sh: 48.72ms
    /usr/lib/facter/ext/foo.sh: 32.69ms
    /usr/lib/facter/ext/full.json: 104.71ms
    /usr/lib/facter/ext/sample.txt: 0.65ms
    ....

### Drawbacks

While external facts provide a mostly-equal way to create variables for Puppet, they have a few drawbacks:

* An external fact cannot internally reference another fact. However, due to parse order, you can reference an external fact from a Ruby fact.
* External executable facts are forked instead of executed within the same process.
* Although we plan to allow distribution of external facts through Puppet's pluginsync capability, this is not yet supported. <!-- TODO: supply ticket number -->

