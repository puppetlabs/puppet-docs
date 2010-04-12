Frequently Asked Questions
==========================

* * *

This document covers frequently asked questions not well covered elsewhere in the
documentation or on the main website. 

You may also wish to see [Troubleshooting](./troubleshooting.html) or [Techniques](/guides/techniques)
for additional assorted information about specific technical items.

General
-------

## What license is Puppet released under?

Puppet is open source and is released under the
[GNU Public License](http://www.gnu.org/copyleft/gpl.html), version 2 or
greater.

## Why does Puppet have its own language?

People often ask why Puppet does not use something like XML or YAML as the
configuration format; otherwise people ask why I didn't just choose
to just use Ruby as the input language.

The input format for Puppet is not XML or YAML because these are
data formats developed to be easy for computers to handle. They do
not do conditionals (although, yes, they support data structures
that could be considered conditionals), but mostly, they're just
horrible human interfaces. While some people are comfortable
reading and writing them, there's a reason why we use web browsers
instead of just reading the HTML directly. Also, using XML or YAML
would limit the ability to make sure the interface is declarative
-- one process might treat an XML configuration differently from
another.

As to just using Ruby as the input format, that unnecessarily ties
Puppet to Ruby, which is undesirable, and Ruby provides a bit too
much functionality.  We believe systems administrators should be 
able to model their datacenters in a higher level system, and
for those that need the power of Ruby, writing custom functions,
types, and providers is still possible.

## Can Puppet manage workstations?

Yes, Puppet can manage any type of machine.  Puppet is used
to manage many organizations that have a mix of laptops and
desktops.

## Does Puppet run on Windows?

The short answer is 'not yet'.   Windows support is slated
to be available in 2010.

## What size organizations should use Puppet?

There is no minimum or maximum organization size that can benefit
from Puppet, but there are sizes that are more likely to benefit.
Organizations with only a handful of servers are unlikely to
consider maintaining those servers to be a real problem, while
those that have more need to consider carefully how they eliminate
manual management tasks.   

## My servers are all unique; can Puppet still help?

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

## When is the Next Release?

There are regular feature and release updates on the
[Mailing List](http://groups.google.com/group/puppet-dev), and you
can always find the latest release on the
[downloads page](http://puppetlabs.com/downloads).

## I have found a security issue in Puppet. Who do I tell?

Reductive Labs and the Puppet project take security very seriously.
We handle all security problems brought to our attention and ensure
that they are corrected within a reasonable time frame.

If you have identified an issue then please send an email to the
Security mailbox
\<[security@reductivelabs.net](mailto:security@reductivelabs.net)>
with the details.

### Recent Notifications

Experience has shown that "security through obscurity" does not
work. Public disclosure allows for more rapid and better solutions
to security problems. In that vein, this page addresses Puppet's
status with respect to various known security holes, which could
potentially affect Puppet.

CVE
Status
[CVE-2009-3564](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2009-3564)
Resolved in 0.25.2
[CVE-2010-0156](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2010-0156)
Resolved in 0.25.2

Installation
------------

## What's The Minimum Version of Ruby?

Puppet is supported on all versions of Ruby from 1.8.2 on up. It
will sometimes work on 1.8.1, but it's not supported on that
release.


Upgrading
---------

## Should I upgrade the client or server first?

When upgrading to a new version of Puppet, always upgrade the
server first. Old clients can point at a new server but you may
have problems when pointing a new client at an old server.
[[[Frequently\_Asked\_Questions#table-of-contents|Frequently Asked
Questions]] ]

## How should I upgrade Puppet & Facter?

The best way to install and to upgrade Puppet and Facter is via
your operating system's package management system. This is easier
than installing them from source. If you do install them from
source make sure you remove old versions including all application
and library files (excepting configuration in /etc/puppet
obviously) entirely before upgrading.
[[[Frequently\_Asked\_Questions#table-of-contents|Frequently Asked
Questions]] ]

## How do I know what's changed when I upgrade?

The best way to find out what's changed in Puppet is to read the
release notes which are posted to the puppet-announce mailing list. 
They will tell you about new features, functions, deprecations and other changes to Puppet.

* * * * *

# Configuration

## What characters are permitted in a class name?

Alphanumeric and hyphens '-' only.  Qualified variables also
can't use the hyphen.

## How Do I Test/Run Manifests?

Once you have Puppet installed according the the [[Installation
Guide]] , just can run the puppet executable against your example:

    puppet -v example.pp

## How do I manage passwords on Red Hat Enterprise Linux & Fedora Core?

As described in the Type reference you need the Shadow Password
Library, this is provided by the ruby-shadow package. The
ruby-shadow library is available natively for fc6 (and higher) and
should build on the RHEL and CentOS variants.

## How do I use Puppet's graphing support?

Puppet has graphing support capable of creating graph files of the
relationships between your Puppet client configurations. 

The graphs are created by and on the
client, so you must enable `graph=true` in your Puppet.conf and
set `graphdir` to the directory where graphs should be output.  The
resultant files will be created in `dot` format which is readable by 
[OmniGraffle](http://www.omnigroup.com/applications/omnigraffle/) (OS X)
or [graphviz](http://www.graphviz.org/).   To generate a visual from
the dot file in graphviz, run the following:

    dot -Tpng /var/puppet/state/graphs/resources.dot -o /tmp/configuration.png

## How do all of these variables, like $operatingsystem, get set?

The variables are all set by
[Facter](http://puppetlabs.com/projects/facter). You can get a
full listing of the available variables and their values by running
facter by itself in a shell.:

    # facter

## Are there variables available other than those provided by Facter?

Puppet also provides a few in-built variables you can use in your
manifests.  The first is provided by the Puppet client and returns the current
environment, appropriately it is called $environment.

Also available are the $server, $serverip and $serverversion
variables. These contain the fully-qualified domain, IP address,
and Puppet version of the server respectively.

## Can I access environmental variables with Facter?

Not directly no but Facter has a special types of facts that can be
set from environment variables. Any environment variable with a
prefix of [FACTER](http://puppetlabs.com/projects/facter) will
be taken by Facter and converted into a fact, for example:

    $ FACTER_FOO="bar"
    $ export FACTER_FOO
    $ facter | grep 'foo'
      foo => bar

The value of the FACTER\_FOO environmental variable would now be
available in your Puppet manifests as $foo with a value of 'bar'.

## Why shouldn't I use autosign for all my clients?

It is very tempting to enable autosign for all nodes, as it cuts
down on the manual steps required to bootstrap a new node (or
indeed to move it to a new puppetmaster).

Typically this would be done with a \*.mydomain.com or even \* in
the autosign.conf file.

This however can be very dangerous as it can enable a node to
masquerade as another node, and get the configuration intended for
that node. The reason for this is that the node chooses the
certificate common name ('CN' - usually its fqdn, but this is fully
configurable), and the puppetmaster then uses this CN to look up
the node definition to serve. The certificate itself is stored, so
two nodes could not connect with the same CN (eg
alice.mydomain.com), but this is not the problem.

The problem lies in the fact that the puppetmaster does not make a
1-1 mapping between a node and the first certificate it saw for it,
and hence multiple certificates can map to the same node, for
example:

-   alice.mydomain.com connects, gets node alice { } definition.
-   bob.mydomain.com connects with CN alice.bob.mydomain.com, and
    also matches node alice { } definition.

Without autosigning, it would be apparent that bob was trying to
get alice's configuration - as the puppetca process lists the full
fqdn/CN presented. With autosign turned on, bob silently retrieves
alices config.

Depending on your environment, this may not present a significant
risk. It essentially boils down to the question 'Do I trust
everything that can connect to my Puppetmaster?'.

If you do still choose to have a permanent, or semi-permanent,
permissive autosign.conf, please consider doing the following:

-   Firewall your puppetmaster - restrict port tcp/8140 to only
    networks that you trust.
-   Create puppetmasters for each 'trust zone', and only include
    the trusted nodes in that Puppet masters manifest.
-   Never use a full wildcard such as \*

