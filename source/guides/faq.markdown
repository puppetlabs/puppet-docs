---
layout: default
title: Frequently Asked Questions
---

Frequently Asked Questions
==========================

* * *

This document covers frequently asked questions not well covered elsewhere in the
documentation or on the main website.

You may also wish to see [Troubleshooting](./troubleshooting.html) or [Techniques](/guides/techniques)
for additional assorted information about specific technical items.

General
-------

### What is Puppet?

Puppet is an open-source next-generation server automation tool. It
is composed of a declarative language for expressing system
configuration, a client and server for distributing it, and a
library for realizing the configuration.

The primary design goal of Puppet is to have an expressive
enough language backed by a powerful enough library that you can
write your own server automation applications in just a few lines
of code. Puppet's deep extensibility and open source license lets you 
add functionality as needed and share your innovations with others. 

To learn more about the capabilities of Puppet, start at the [main Puppet documentation](../).

### What license is Puppet released under?

Puppet is open source and is released under the
[GNU Public License](http://www.gnu.org/copyleft/gpl.html) version 2.

### What's special about Puppet's model-driven design?

Traditionally, managing the configurations of a large group of computers has
meant a series of imperative steps; in its rawest state, SSH and
a _for_ loop. This general approach grew more sophisticated over time, but it
retained the more profound limitations at its root.

Puppet takes a different approach, which is to model everything -- the current
state of the node, the desired configuration state, the actions taken during
configuration enforcement -- as data: each node receives a catalog of
resources and relationships, compares it to the current system state, and makes
changes as needed to bring the system into compliance.

The benefits go far beyond just healing the headaches of configuration drift
and unknown system state: modeling systems as data lets Puppet simulate
configuration changes, track the history of a system over its lifecycle, and
prove that refactored manifest code still produces the same system state. 
It also drastically lowers the barrier to entry for hacking and extending
Puppet: instead of analyzing code and reverse-engineering the effects of each
step, a user can just parse data, and sysadmins have been able to add
significant value to their Puppet deployments with an afternoon's worth of perl
scripting.

### Why does Puppet have its own language?

Why not use XML or YAML as the configuration format? Why not use Ruby as the
input language?

The language used for manifests is ultimately Puppet's human interface, and XML
and YAML, being data formats developed around the processing capabilities of
computers, are
horrible human interfaces. While some people are comfortable
reading and writing them, there's a reason why we use web browsers
instead of just reading the HTML directly. Also, using XML or YAML
would limit any assurance that the interface was declarative
-- one process might treat an XML configuration differently from
another.

As for just using Ruby as the input format, Puppet 2.6.0 actually added
this functionality, and manifests can now be written in pure Ruby. However,
this capability should be used carefully and avoided where possible:
the full grammar of Ruby is often _too_ much functionality,
and we believe systems administrators should be
able to model their datacenters in a higher-level system. Writing manifests in
the Puppet DSL and separating needed Ruby extensions out into redistributable
custom functions, facts, types, and providers is usually the best balance of 
power and maintainability. 

### Why is Puppet written in Ruby?

From Luke Kanies, Puppet's author: 

> I was a sysadmin by trade and
> had mostly developed in perl, but when I tried to write the
> prototype I had in mind, I couldn't get the class relationships I
> wanted in perl. I tried Python, because this was around 2003 and
> Python was the next new thing and everyone was saying how great it
> is, but I just can't seem to write in Python at all. A friend had
> said he'd heard Ruby was cool, so I gave it a try, and in four
> hours I went from never having seen a line of it to having a
> working prototype. I haven't looked back since then, and haven't
> regretted the choice.

### Who would find Puppet useful?

Any organization that would like to reduce the cost of maintaining
its computers could benefit from using Puppet. However, because the
return on investment is linked to multiple factors, like current
administrative overhead, diversity among existing computers, and
cost of downtime, it can be difficult for organizations to
determine whether they should invest in any configuration
management tools, much less Puppet. Puppet Labs can always be
contacted directly at <info@puppetlabs.com> to help answer this
question.

Generally, however, an organization should be using server
automation if any of the following are true:

-   It has high server administration costs
-   It pays a high price for downtime, either because of contracts
    or opportunity cost
-   It has many servers that are essentially either identical or
    nearly identical
-   It requires flexibility and agility in server configuration


### Can Puppet manage workstations?

Yes: Puppet can manage any type of machine, and is used
to manage many organizations that have a mix of laptops and
desktops.

### Does Puppet run on Windows?

The short answer is "not yet." 

Experimental Windows support was added in Puppet 2.6. Although
it's not yet ready for deployment, this support will be improved and 
extended during 2011.

### What size organizations should use Puppet?

There is no minimum or maximum organization size that can benefit
from Puppet, but there are sizes that are more likely to benefit.
Organizations with only a handful of servers are unlikely to
consider maintaining those servers to be a real problem, while
those that have more need to consider carefully how they eliminate
manual management tasks.

### My servers are all unique; can Puppet still help?

Yes.

All servers are at least somewhat unique -- with different host
names and different IP addresses -- but very few servers are
entirely unique, since nearly every one runs a relatively standard
operating system. Servers are also often very similar to other
servers within a single organization -- all Solaris servers might
have similar security settings, or all web servers might have
roughly equivalent configurations -- even if they're very different
from servers in other organizations. Finally, servers are often
needlessly unique, in that they have been built and managed
manually with no attempt at retaining appropriate consistency.

Puppet can help both on the side of consistency and uniqueness.
Puppet can be used to express the consistency that should exist,
even if that consistency spans arbitrary sets of servers based on
any type of data like operating system, data centre, or physical
location. Puppet can also be used to handle uniqueness, either by
allowing special provision of what makes a given host unique or
through specifying exceptions to otherwise standard classes.

### When is the next release?

There are regular feature and release updates on the
[Mailing List](http://groups.google.com/group/puppet-dev), and you
can always find the latest release on the
[downloads page](http://puppetlabs.com/downloads).

### I have found a security issue in Puppet. Who do I tell?

Puppet Labs and the Puppet project take security very seriously.
We handle all security problems brought to our attention and ensure
that they are corrected within a reasonable time frame.

If you have identified an issue then please send an email to the
Security mailbox (<security@puppetlabs.net>) with the details.

#### Recent Notifications

Experience has shown that "security through obscurity" does not
work. Public disclosure allows for more rapid and better solutions
to security problems. In that vein, this page addresses Puppet's
status with respect to various known security holes, which could
potentially affect Puppet.

- [CVE-2009-3564](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-3564) -- Resolved in 0.25.2
- [CVE-2010-0156](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2010-0156) -- Resolved in 0.25.2

### Who is Puppet Labs?

Puppet Labs (formerly Reductive Labs) is a small, private company focused on re-framing
the server automation problem. More information about Puppet Labs is available
[on our website](http://www.puppetlabs.com/company/overview/).

### How do I contribute?

First, join one or both of the mailing lists. There is currently
a [development list](http://groups.google.com/group/puppet-dev/),
and a [user discussion list](http://groups.google.com/group/puppet-users/). 
You can also join the IRC channel \#puppet on
irc.freenode.net, where Puppet's developers will be hanging out
most days (and nights).

If you are interested in helping with Puppet's development, you can
read about how it is developed and how to submit patches and fixes
on the [Development Lifecycle](http://projects.puppetlabs.com/projects/puppet/wiki/Development_Development_Lifecycle) wiki page.

The most valuable contribution you can make, though, is to use
Puppet and submit your feedback, either directly on IRC or through
the mailing list, or by reporting to the
[bug database](http://projects.puppetlabs.com/projects/show/puppet).
We're always looking for great ideas to incorporate into Puppet.

Installation
------------

### Where can I get Puppet?

Many operating system vendors offer Puppet in their package repositories, 
which is the most convenient way to install Puppet. Puppet Labs
also maintains its own public package repositories at <http://yum.puppetlabs.com> and 
<http://apt.puppetlabs.com>. 

In addition, source tarballs and packages for the latest release of Puppet are available
in the [downloads](http://puppetlabs.com/resources/downloads) area 
of the site, and you can view the current state of development (or start contributing code!)
at [Puppet Labs' Github page](https://github.com/puppetlabs/puppet).

### What's the minimum version of Ruby?

Puppet is supported on all versions of Ruby from 1.8.2 on up. It
will sometimes work on 1.8.1, but it's not supported on that
release.


Upgrading
---------

### Should I upgrade the client or server first?

When upgrading to a new version of Puppet, always upgrade the
server first. Old clients can point at a new server but you may
have problems when pointing a new client at an old server.

### How should I upgrade Puppet and Facter?

The best way to install and upgrade Puppet and Facter is via
your operating system's package management system, using either your
vendor's repository or one of Puppet Labs' public repositories.

If you have installed Puppet from
source, make sure you remove old versions entirely (including all application
and library files) before upgrading. Configuration data (usually located
in `/etc/puppet` or `/var/lib/puppet`, although the location can vary) can
be left in place between installs.

### How do I know what's changed when I upgrade?

The best way to find out what's changed in Puppet is to read the release notes,
which are posted to the 
[puppet-announce mailing list](http://groups.google.com/group/puppet-announce) and 
[archived on the Puppet wiki](http://projects.puppetlabs.com/projects/puppet/wiki/Release_Notes).


Configuration
-------------

### What is a manifest?

"Manifest" is the word we chose to describe a declarative Puppet program. 
Since Puppet configurations are idempotent, words like "script" (which implies
a procedural step-by-step model of execution) seemed misleading.

### What characters are permitted in a class name? In a module name? In other identifiers?

Class names can contain lowercase letters, numbers, and underscores, and should begin with a lowercase letter. "`::`" can be used as a namespace separator.

The same rules should be used when naming defined resource types, modules, and parameters, although modules and parameters cannot use the namespace separator.

Variable names can include alphanumeric characters and underscores, and are case-sensitive.

### How do I apply and test manifests?

Once you have Puppet installed according the the [Installation
Guide](./installation.html), just run `puppet apply` against your example:

    puppet apply -v example.pp

### How do I document my manifests?

The puppet language includes a simple documentation syntax, which is currently 
documented on the
[Puppet Manifest Documentation wiki page](http://projects.puppetlabs.com/projects/puppet/wiki/Puppet_Manifest_Documentation). 
The puppetdoc command uses this inline documentation to automatically generate 
RDoc or HTML documents for your manifests and modules.

### How do I manage passwords on Red Hat Enterprise Linux, CentOS, and Fedora Core?

As described in the [Type reference](../references/latest/type.html), you need the Shadow Password
Library, which is provided by the ruby-shadow package. The
ruby-shadow library is available natively for fc6 (and higher), and
should build on the corresponding RHEL and CentOS variants.

### How do I use Puppet's graphing support?

Puppet has graphing support capable of creating graph files of your
aagent node configurations.

These graphs are created by and on the
agent nodes, so you must enable `graph=true` in the `[agent]` section of your nodes' Puppet.conf and
set `graphdir` to the directory where graphs should be written.  The
resulting files will be created in `.dot` format, which is readable by
[OmniGraffle](http://www.omnigroup.com/applications/omnigraffle/) (OS X)
or [graphviz](http://www.graphviz.org/).   To generate an image from
a dot file using the `dot` utility included with graphviz, run the following:

    dot -Tpng /var/puppet/state/graphs/resources.dot -o /tmp/configuration.png

### How do all of these variables, like $operatingsystem, get set?

The variables are all set by
[Facter](http://puppetlabs.com/projects/facter). You can get a
full listing of the available variables and their values by running
facter by itself in a shell.:

    # facter

### Are there variables available other than those provided by Facter?

Puppet provides a few in-built variables you can use in your
manifests:

* `$environment` -- Provided by the puppet agent; returns the agent node's current
environment.
* `$servername` -- Provided by the puppet master; returns the master server's
fully-qualified domain name. (Note that this information is gathered from the
master server by Facter, rather than read from the config files; even if the
master's certname is set to something other than its fully-qualified domain
name, this variable will still contain the server's fqdn.)
* `$serverip` -- Provided by the puppet master; returns the master server's IP address.
* `$serverversion` -- Provided by the puppet master; returns puppet master's current version. 

### Can I access environment variables with Facter?

Not directly. However, Facter reads in custom facts from a special subset of
environment variables. Any environment variable with a
prefix of `FACTER_` will be converted into a fact when Facter runs. For example:

    $ FACTER_FOO="bar"
    $ export FACTER_FOO
    $ facter | grep 'foo'
      foo => bar

The value of the `FACTER_FOO` environment variable would now be
available in your Puppet manifests as $foo, and would have a value of 'bar'.
Using shell scripting to export an arbitrary subset of environment variables as
facts is left as as exercise for the reader.

### Why shouldn't I use autosign for all my clients?

It is very tempting to enable autosign for all nodes, as it cuts
down on the manual steps required to bootstrap a new node (or
indeed to move it to a new puppet master).

Typically this would be done with a \*.mydomain.com or even \* in
the autosign.conf file.

This however can be very dangerous as it can enable a node to
masquerade as another node, and get the configuration intended for
that node. The reason for this is that the node chooses the
certificate common name ('CN' - usually its fqdn, but this is fully
configurable), and the puppet master then uses this CN to look up
the node definition to serve. The certificate itself is stored, so
two nodes could not connect with the same CN (eg
alice.mydomain.com), but this is not the problem.

The problem lies in the fact that the puppet master does not make a
1-1 mapping between a node and the first certificate it saw for it,
and hence multiple certificates can map to the same node, for
example:

-   alice.mydomain.com connects, gets node alice { } definition.
-   bob.mydomain.com connects with CN alice.bob.mydomain.com, and
    also matches node alice { } definition.

Without autosigning, it would be apparent that bob was trying to
get alice's configuration - as the puppet cert process lists the full
fqdn/CN presented. With autosign turned on, bob silently retrieves
alice's configuration.

Depending on your environment, this may not present a significant
risk. It essentially boils down to the question 'Do I trust
everything that can connect to my puppet master?'.

If you do still choose to have a permanent, or semi-permanent,
permissive autosign.conf, please consider doing the following:

-   Firewall your puppet master - restrict port tcp/8140 to only
    networks that you trust.
-   Create puppet masters for each 'trust zone', and only include
    the trusted nodes in that Puppet masters manifest.
-   Never use a full wildcard such as \*.

