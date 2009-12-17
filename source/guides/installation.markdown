Installation Guide
==================

Puppet supports a wide range of platforms and installation options.
Read this guide for in-depth installation instructions.

* * *

Before you start
----------------

First, make sure to read the [Downloading Puppet](http://reductivelabs.com/trac/puppet/wiki/DownloadingPuppet)
guide for how to get packages or source for your platform.

You will need to install Puppet on all machines that will use it,
including both clients and servers.

There are packages available for most platforms (use your normal
package sources for them), but for the rest you will have to
install using the
[tarball](http://www.reductivelabs.com/downloads/puppet/) or
[RubyGems](http://www.reductivelabs.com/downloads/gems/).

INFO: Install instructions do not cover installing packages, since it is assumed
you know how to retrieve and install packages for your specific
platform.

Ruby Prerequisites
-------------------

The only prerequisite for Puppet that doesn't come as part of the
Ruby standard library is
[facter](http://www.reductivelabs.com/projects/facter/index.html),
which is also developed by Reductive Labs.

All other prerequisites for Puppet are Ruby libraries, and they
should all come with any standard Ruby 1.8.2+ install. The other
prerequisites, should your OS not come with the complete standard
library, are:

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

NOTE: I recommend using whatever Ruby comes with your system,
since that's what I've tested against in most cases and it's most
likely to work correctly. If you feel the particular need to build
it manually, you can get the source from
[the Ruby site](http://ruby-lang.org/).

Platform Prerequisites
----------------------

### Fedora

Fedora 11 hosts require these packages:

* `selinux-policy-3.6.12-57.fc11.noarch`
* `selinux-policy-targeted-3.6.12-57.fc11.noarch`

Or later, to avoid an issue with ifconfig AVC denials in SELinux
enforcing mode on both the puppetmaster and puppet client.

### Red Hat

Puppet and Facter are available in Fedora; thanks to David
Lutterkort at Red Hat. Fedora users can retrieve them via yum from
their Fedora repositories. Users of Enterprise Linux (RHEL, CentOS,
OEL, Scientific, Start.com, etc) can get the package from
[Extra Packages for Enterprise Linux (EPEL)](https://fedoraproject.org/wiki/EPEL)-
a Fedora add-on for EL.

Please let the puppet-users mailing list know if you have built
RPM's for RHEL2.1 or RHEL3 (or the equivalent CentOS builds)

If you are building ruby on Red Hat (at least on version 3), you
apparently must build it with CPPFLAGS=-I/usr/kerberos/include/,
else you will have all kinds of unreasonable problems (thanks to
Mario Martelli for tracking that one down).

### Solaris

There is a repository of Facter and Puppet packages for Solaris
[here](http://garylaw.net/packages/). The packages require Ruby
and some other dependencies from the
[opencsw](http://opencsw.org/) or
[blastwave](http://blastwave.org) projects. The tools pkg-get and
pkgutil can handle installing these dependencies for you (in much
the same way as apt-get or yum on Linux). Unlike the RPMs for RHEL,
the Solaris packages will auto-start the puppetd client immediately
post installation.

If you get segfaults, core dumps, or 'library missing ciphers'
errors, that is almost definitely a problem with that specific ruby
package, not Puppet or Ruby itself. The current opencsw and
blastwave Ruby seem OK.

You might also find the
[Solaris Puppet Client Installation Guide](http://reductivelabs.comhttp://reductivelabs.com/trac/puppet/wiki/SolarisPuppetClientInstallationGuide/)
to be useful.

Some very old packages can be found in the
[downloads](http://reductivelabs.com/downloads/packages/SunOS).

### Debian and Ubuntu

You can download packages for Puppet from any Debian mirror.

The package maintainer for Ruby on these platforms has decided to
split the Ruby standard library into many packages. According to
Eric Hollensbe, this is the package dependency list for Puppet on
Debian:

* ruby
* irb
* ri
* rdoc
* libxmlrpc-ruby
* libopenssl-ruby
* libstrscan-ruby
* libsyslog-ruby
* libwebrick-ruby

Debian Stable tends to lag behind a bit with packages. You might
want to
[install the puppet packages from Unstable](http://reductivelabs.com/trac/puppet/wiki/PuppetDebian).

Ubuntu Dapper Server (LTS): You need to enable the *universe*
repository to install the above package list.

### SuSE

Martin Vuk has set up the SuSE build service to create Puppet and
Facter packages, so you can get them
[there](http://software.opensuse.org/download/system:/management/).
Older versions of Puppet can still be retrieved from his old
[yum repository](http://lmmri.fri.uni-lj.si/suse/).

More about
[puppet on SuSE and opensuse](http://reductivelabs.com/trac/puppet/wiki/PuppetSuSE).

### Gentoo

Thanks to José González Gómez, there are
[now](http://packages.gentoo.org/package/app-admin/puppet) ebuilds
available for Puppet in the official Portage repository.

Also, as of September 2006 there is a problem with the PPC Ruby
package that causes rdoc/usage to fail. The bug has been reported
to the Gentoo folks.

Install Facter
--------------

First install facter. Like Puppet, there are
[packages](http://www.reductivelabs.com/downloads/packages/)
available for some platforms, but you might have to use the
tarball:

Get the latest tarball:
    
    $ wget http://reductivelabs.com/downloads/facter/facter-latest.tgz
{:shell}

Untar and install it:

    $ gzip -d -c facter-latest.tgz | tar xf -
    $ cd facter-*
    $ sudo ruby install.rb # or become root and run install.rb
{:shell}

There are also gems available in the
[download](http://www.reductivelabs.com/downloads/) directory.

Install Puppet
--------------

Using the same mechanism, install the puppet libraries and
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

Or you can also override the installation location:

    $ sudo ruby install.rb --bindir=/usr/bin --sbindir=/usr/sbin
{:shell}

### Alternative: Using Ruby Gems

You can also install Facter and Puppet via gems:

      $ wget http://reductivelabs.com/downloads/gems/facter-1.5.7.gem
      $ sudo gem install facter-1.5.7.gem
      $ wget http://reductivelabs.com/downloads/gems/puppet-0.25.1.gem
      $ sudo gem install puppet-0.25.1.gem
{:shell}

The Reductive Labs gem server is broken. Find the latest gems
[here](http://reductivelabs.com/downloads/gems/)

For more information on Ruby Gems, see the
[Gems User Guide](http://docs.rubygems.org/read/book/1)

WARNING: If you get the error, in `require: no such file to load`, you need
to define the RUBYOPT environment variable as advised in the
[post-install instructions](http://docs.rubygems.org/read/chapter/3#page70)
of the RubyGems User Guide.

Building the Server
-------------------

### Create Your Site Manifest

Because the Puppet language is declarative, it does not make as
much sense to speak of "executing" Puppet programs, or to describe
them as "scripts". We choose to use the word manifest to describe
Puppet programs, and we speak of *applying* those manifests to the
local system. Thus, a *manifest* is a text document written in the
Puppet language and meant to result in a desired configuration.

Puppet is written with the assumption that you will have one
central manifest capable of configuring your entire network, which
we call the *site manifest*. You could have multiple, separate site
manifests if you wanted, but at this point each of them would need
their own servers.

Puppet will start with /etc/puppet/manifests/site.pp as the primary
manifest, so create /etc/puppet/manifests and add your manifest,
along with any files it includes, to that directory. It is highly
recommended that you use some kind of
[version control](http://svnbook.red-bean.com/) on your
manifests.

### Example Manifest

The site manifest can be as simple or as complicated as you want. A
good starting point is to make sure that your sudoers file has the
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

You may need to open port 8140, both tcp and udp, on the server and
client machines.

Configure DNS
-------------

The puppet client looks for a server named 'puppet'. If you have
local DNS zone files, you may want to add a CNAME record pointing
to the server machine in the appropriate zone file.

    puppet.   IN   CNAME  crabcake.picnic.edu.

See the book "DNS and Bind" by Cricket Liu et al if you need help
with CNAME records. After adding the CNAME record, restart your
name server. You can also add a host entry in the /etc/hosts file
on both the server and client machines.

    127.0.0.1 localhost.localdomain localhost puppet
    
or
    
    192.168.1.67 crabcake.picnic.edu crabcake puppet

Use the appropriate entry. 

WARNING: If you can ping the server by
the name 'puppet' but /var/log/messages on the clients still have
entries stating the puppet client cannot connect to the server, you
may have forgotten to open port 8140 on the server.

Start the Central Daemon
------------------------

Most sites should only need a single central server. Reductive Labs
will soon publish a document describing how to build puppet
architectures with failover capabilities and architectures that are
capable of handling large loads, but for now only a single server
is supported.

Decide which machine you want to be your central server; this is
where you will be starting puppetmasterd.

The best way to start any daemon is using your local server's
service management system, often in the form of init scripts.
Eventually Puppet will ship with an appropriate script for each
platform (it already has appropriate scripts for Red Hat, Debian,
and Solaris), but in the meantime you can either create your own,
using an existing script as an example, or simply run without one
(not recommended for production environments).

Other than the system manifest at /etc/puppet/manifests/site.pp,
the last thing you'll need is to create the puppet user and group
that the daemon runs as. You can create these manually, or you can
just start the daemon with the --mkusers flag, and it should create
both of them for you (of course, this flag is only necessary the
first time the daemon is run):

    # /usr/sbin/puppetmasterd --mkusers
{:shell}

On OSX, after installing Puppet via gem, puppetmasterd may be at a
different path

    # /opt/local/bin/puppetmasterd --mkusers
{:shell}

Even without the `--mkusers` flag, it will automatically create all
necessary certificates, directories, and files.

NOTE: If you want the
daemon to also function as a file server, so your clients can copy
files from it, you will need to create a
[fileserver configuration file](http://reductivelabs.com/trac/puppet/wiki/FileServingConfiguration);
the daemon checks for the existence of this file at startup and
automatically enables or disables file serving functionality.

Verifying Installation
----------------------

To verify that your daemon is working as expected, pick a single
client to use as a testbed. Once Puppet is installed on that
machine, run a single client against the central server to verify
that everything is working appropriately. You should start the
first client in verbose mode, with the --waitforcert flag enabled:

    # puppetd --server myserver.domain.com --waitforcert 60 --test
{:shell}

The default server for puppetd is puppet, so you could just create
a CNAME of that to whatever server is running puppetmasterd.

Adding the `--test` flag causes puppetd to stay in the foreground,
print extra output, only run once and then exit, and to just exit
if the remote configuration fails to compile (by default, puppetd
will use a cached configuration if there is a problem with the
remote manifests).

In running the client, you should see the message

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
the value to 0 to disable it entirely.

Finishing Installation
----------------------

There are already init scripts available for some platforms
(notably, Red Hat versions, thanks to David Lutterkort's work on
the [RPMs](http://www.reductivelabs.com/downloads/rpm/)), but for
not-yet-supported platforms, you will need to create an init script
that can start and stop puppetd. The process creates a PID file in
its run directory (/var/puppet/run, by default), so you can use
that to stop it.

NOTE: The process will log to syslog by default in the daemon facility.

Scaling your Installation
-------------------------

The default Puppet server uses an internal webrick web server. The
webrick web server does not scale very well and is not recommended
for production use beyond 10 to 20 nodes. It is recommend that you
move your Puppet server to Mongrel or Passenger. You can find
instructions at [Using Mongrel](http://reductivelabs.com/trac/puppet/wiki/UsingMongrel) and
[Using Passenger](http://reductivelabs.com/trac/puppet/wiki/UsingPassenger) respectively.



