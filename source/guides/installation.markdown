Installation Guide
==================

This guide covers in-depth installation instructions and options for Puppet on
a wide-range of operating systems.

* * *

Before you start
----------------

Start by reading the [Downloading Puppet](http://reductivelabs.com/trac/puppet/wiki/DownloadingPuppet)
guide, which explains how to download packages or source code for your operating system.

You will need to install Puppet on all machines on both clients
and the central Puppet master server(s).

For most platforms, you can install 'puppet' via your package
manager of choice.  For other platforms, you will need to install
using the [tarball](http://www.reductivelabs.com/downloads/puppet/) or
[RubyGems](http://www.reductivelabs.com/downloads/gems/).

INFO: For instructions on installing puppet using a distribution-specific package manager, consult your operating system documentation.  Volunteer contributed operating system packages can also be found on the [downloads page](http://reductivelabs.com/trac/puppet/wiki/DownloadingPuppet)

Ruby Prerequisites
------------------

The only prerequisite for Puppet that doesn't come as part of the
Ruby standard library is
[facter](http://www.reductivelabs.com/projects/facter/index.html),
which is also developed by Reductive Labs.

All other prerequisites for Puppet are Ruby libraries, and they
should all come with any standard Ruby 1.8.2+ install. The other
prerequisites, should your OS not come with the complete standard
library (or you are using a custom Ruby build), include:

* base64
* cgi
* digest/md5
* etc
* fileutils
* ipaddr
* openssl
* strscan
* syslog
* uri
* webrick
* webrick/https
* xmlrpc

NOTE: We strongly recommend using the version of Ruby that comes with your system, since that will have a higher degree of testing coverage.
If you feel the particular need to build Ruby manually, you can get the source from [ruby-lang.org](http://ruby-lang.org/).

OS Packages
-----------

If installing from a distribution maintained package, such as those listed on [Downloading Puppet Wiki Page](http://reductivelabs.com/trac/puppet/wiki/DownloadingPuppet) all OS prerequisites should be handled by your package manager.  See the Wiki for information on how to enable repositories for your particular OS.  Usually the latest stable version is available as a package.  If you would like to do puppet-development or see the latest versions, however, you will want to install from source.


Installing Facter From Source
-----------------------------

The facter library is a prerequisite for Puppet. Like Puppet, there are
[packages](http://www.reductivelabs.com/downloads/packages/)
available for most platforms, though you may want to use the
tarball if you would like to try a newer version or are using
a platform without an OS package:

Get the latest tarball:
    
    $ wget http://reductivelabs.com/downloads/facter/facter-latest.tgz
{:shell}

Untar and install facter:

    $ gzip -d -c facter-latest.tgz | tar xf -
    $ cd facter-*
    $ sudo ruby install.rb # or become root and run install.rb
{:shell}

There are also gems available in the
[download](http://www.reductivelabs.com/downloads/) directory.

Installing Puppet From Source
-----------------------------

Using the same mechanism as Facter, install the puppet libraries and
executables:

    # get the latest tarball
    $ wget http://reductivelabs.com/downloads/puppet/puppet-latest.tgz
    # untar and install it
    $ gzip -d -c puppet-latest.tgz | tar xf -
    $ cd puppet-*
    $ sudo ruby install.rb # or become root and run install.rb
{:shell}

You can also check the source out from the git repo:

    $ mkdir -p ~/git && cd ~/git
    $ git clone git://github.com/reductivelabs/puppet
    $ cd puppet
    $ sudo ruby ./install.rb
{:shell}

To install into a different location you can use:

    $ sudo ruby install.rb --bindir=/usr/bin --sbindir=/usr/sbin
{:shell}

### Alternative Install Method: Using Ruby Gems

You can also install Facter and Puppet via gems:

      $ wget http://reductivelabs.com/downloads/gems/facter-1.5.7.gem
      $ sudo gem install facter-1.5.7.gem
      $ wget http://reductivelabs.com/downloads/gems/puppet-0.25.1.gem
      $ sudo gem install puppet-0.25.1.gem
{:shell}

Find the latest gems
[here](http://reductivelabs.com/downloads/gems/)

For more information on Ruby Gems, see the
[Gems User Guide](http://docs.rubygems.org/read/book/1)

WARNING: If you get the error, in `require: no such file to load`, define the RUBYOPT environment variable as advised in the
[post-install instructions](http://docs.rubygems.org/read/chapter/3#page70)
of the RubyGems User Guide.

Building the Server
-------------------

### Create Your Site Manifest

Because the Puppet language is declarative, it does not make as
much sense to speak of "executing" Puppet manifests, or to describe
them as "scripts". We choose to use the word manifest to describe
Puppet programs, and we speak of *applying* those manifests to the
local system. Thus, a *manifest* is a text document written in the
Puppet language and meant to describe and result in a desired configuration.

Puppet is written with the assumption that you will have one
central manifest capable of configuring an entire site, which
we call the *site manifest*. You could have multiple, separate site
manifests if you wanted, though if doing this each of them would need
their own puppet servers.

Puppet will start with /etc/puppet/manifests/site.pp as the primary
manifest, so create /etc/puppet/manifests and add your manifest,
along with any files it includes, to that directory. It is highly
recommended that you use
[version control](http://svnbook.red-bean.com/) to keep track of
changes to manifests.

### Example Manifest

The site manifest can be as simple or as complicated as you want. A
good starting example is to make sure that your sudoers file has the
appropriate permissions:

    # site.pp
    file { "/etc/sudoers":
        owner => root, group => root, mode => 440
    }
{:puppet}

For more information on how to create the site manifest, see the
tutorials listed on the
[Getting Started](http://reductivelabs.com/trac/puppet/wiki/GettingStarted) page.

Open Firewall Ports On Server and Client
----------------------------------------

In order for the puppet server to centrally manage clients, you may need to open port 8140, both tcp and udp, on the server and client machines.

Configure DNS
-------------

The puppet client looks for a server named 'puppet'. If you have
local DNS zone files, you may want to add a CNAME record pointing
to the server machine in the appropriate zone file.

    puppet.   IN   CNAME  crabcake.picnic.edu.

By setting up the CNAME you will avoid having to specify the
server name in the configuration of each client.

See the book "DNS and Bind" by Cricket Liu et al if you need help
with CNAME records. After adding the CNAME record, restart your
name server. You can also add a host entry in the /etc/hosts file
on both the server and client machines.

For the server:

    127.0.0.1 localhost.localdomain localhost puppet
    
For the clients:
    
    192.168.1.67 crabcake.picnic.edu crabcake puppet

WARNING: If you can ping the server by
the name 'puppet' but /var/log/messages on the clients still has
entries stating the puppet client cannot connect to the server, 
verify port 8140 is open on the server.

Start the Central Daemon
------------------------

Most sites should only need one central puppet server. Reductive Labs
will be publishing a document describing best practices for scale-out
and failover, though there are various ways to address handling
in larger infrastructures.  For now, we'll explain how to
work with the one server, and others can be added as needed.

First, decide which machine will be the central server; this is
where puppetmasterd will be run.

The best way to start any daemon is using the local server's
service management system, often in the form of init scripts.

If you're running on Red Hat, CentOS, Fedora, Debian, Ubuntu, or 
Solaris, the OS package already contains a suitable init script.
If you don't have one, you can either create your own using an existing
init script as an example, or simply run without one (though this
is not advisable for production environments).

It is also neccessary to create the puppet user and group
that the daemon will use.   Either create these manually, or start
the daemon with the --mkusers flag to create them.

    # /usr/sbin/puppetmasterd --mkusers
{:shell}

Starting the puppet daemon will automatically create all necessary certificates, directories, and files.

NOTE:  To enable the daemon to also function as a file server, so that clients can copy files from it, create a
[fileserver configuration file](http://reductivelabs.com/trac/puppet/wiki/FileServingConfiguration) and restart pupetmasterd.

Verifying Installation
----------------------

To verify that your daemon is working as expected, pick a single
client to use as a testbed. Once Puppet is installed on that
machine, run a single client against the central server to verify
that everything is working appropriately. You should start the
first client in verbose mode, with the --waitforcert flag enabled:

    # puppetd --server myserver.domain.com --waitforcert 60 --test
{:shell}

Adding the `--test` flag causes puppetd to stay in the foreground,
print extra output, only run once and then exit, and to just exit
if the remote configuration fails to compile (by default, puppetd
will use a cached configuration if there is a problem with the
remote manifests).

In running the client, you should see the message:

    info: Requesting certificate
    warning: peer certificate won't be verified in this SSL session
    notice: Did not receive certificate

INFO: This message will repeat every 60 seconds with the above
command.

This is normal, since your server is not auto-signing certificates
as a security precaution. 

On your server, list the waiting certificates:

    # puppetca --list
{:shell}

You should see the name of the test client. Now go ahead and sign
the certificate:

    # puppetca --sign mytestclient.domain.com
{:shell}

Within 60 seconds, your test client should receive its certificate
from the server, receive its configuration, apply it locally, and
exit normally.

NOTE: By default, puppetd runs with a waitforcert of five minutes; set
the value to 0 to disable this wait-polling period entirely.

Scaling your Installation
-------------------------

The default Puppet server uses the internal "WEBrick" ruby web server.   As this reference server does not scale very well, if you have more 
than a few dozen nodes, it is recommended to use Mongrel or Passenger as the web server.  You can find detailed instructions at [Using Mongrel](http://reductivelabs.com/trac/puppet/wiki/UsingMongrel) and [Using Passenger](http://reductivelabs.com/trac/puppet/wiki/UsingPassenger) respectively.  There are various other tips to improve scaling capabilities that will be added here in the future.
