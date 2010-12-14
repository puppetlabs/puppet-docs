---
layout: default
title: Custom Facts
---

Custom Facts
============

Extend facter by writing your own custom facts to provide information to Puppet.

* * *

Adding Custom Facts to Facter
-----------------------------

Sometimes you need to be able to write conditional expressions
based on site-specific data that just isn't available via Facter (or use
a variable in a template that isn't there).
A solution can be achieved by adding a new fact to Facter. These additional facts
can then be distributed to Puppet clients and are available for use
in manifests.

The Concept
-----------

You can add new facts by writing a snippet of Ruby code on the
Puppet master. We then use [Plugins In Modules](./plugins_in_modules.html) to distribute our
facts to the client.

An Example
----------

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

You may not be able to view your custom fact when running
facter on the client node. If you are unable to view the custom
fact, try adding the "factpath" to the FACTERLIB environmental
variable:

    export FACTERLIB=/var/lib/puppet/lib/facter

Using other facts
-----------------

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

Testing
-------

Of course, we can test that our code works before adding it to
Puppet.

Create a directory called facter/ somewhere (we often use
`~/lib/ruby/facter`), and set the environment variable `$RUBYLIB` to
its parent directory. You can then run facter, and it will import
your code:

    $ mkdir -p ~/lib/ruby/facter ; export RUBYLIB=~/lib/ruby
    $ cp /path/to/hardware_platform.rb $RUBYLIB/facter
    $ facter hardware_platform
    SUNW,Sun-Blade-1500

Adding this path to your `$RUBYLIB` also means you can see this fact
when you run Puppet. Hence, you should now see the following when
running puppetd:

    # puppetd -vt --factsync
    info: Retrieving facts
    info: Loading fact hardware_platform
    ...

Alternatively, you can set `$FACTERLIB` to a directory with your new
facts in, and they will be recognised on the Puppet master.

It is important to note that to use the facts on your clients you
will still need to distribute them using the [Plugins In Modules](./plugins_in_modules.html)
method.

Viewing Fact Values
-------------------

You can also determine what facts (and their values) your clients
return by checking the contents of the client's yaml output. To do
this we check the `$yamldir` (by default `$vardir/yaml/`) on the Puppet
master:

    # grep kernel /var/lib/puppet/yaml/node/puppetslave.example.org.yaml
      kernel: Linux
      kernelrelease: 2.6.18-92.el5
      kernelversion: 2.6.18

Legacy Fact Distribution
------------------------

For Puppet versions prior to 0.24.0:

On older versions of Puppet, prior to 0.24.0, a different method
called factsync was used for custom fact distribution. Puppet would
look for custom facts on
[puppet://$server/facts](puppet://%24server/facts) by default and
you needed to run puppetd with --factsync option (or add factsync =
true to puppetd.conf). This would enable the syncing of these files
to the local file system and loading them within puppetd.

Facts were synced to a local directory ($vardir/facts, by default)
before facter was run, so they would be available the first time.
If $factsource was unset, the --factsync option is equivalent to:

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



