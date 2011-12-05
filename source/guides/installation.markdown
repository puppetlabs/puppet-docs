---
layout: default
title: Installation Guide
---

Installation Guide
==================

This guide covers in-depth installation instructions and options for Puppet on
a wide-range of operating systems.

* * *

Before Starting
---------------

You will need to install Puppet on both [managed nodes](./tools.html#puppet-agent-or-puppetd)
and the central [Puppet master server(s)](./tools.html#puppet-master-or-puppetmasterd)
in order to run puppet in client server mode.
If you will just be running [Puppet standalone](./tools.html#puppet-apply-or-puppet)
you don't need a Puppet master server and installation on just one machine will suffice.

For most platforms, you can install 'puppet' via your package
manager of choice.  For a few platforms, you will need to install
using the [tarball](http://www.puppetlabs.com/downloads/puppet/) or
[RubyGems](http://www.puppetlabs.com/downloads/gems/).

INFO: For instructions on installing puppet using a distribution-specific package manager, consult your operating system documentation.  Volunteer contributed operating system packages can also be found on the [downloads page](http://projects.puppetlabs.com/projects/puppet/wiki/Downloading_Puppet)

Ruby Prerequisites
------------------

The only prerequisite for Puppet that doesn't come as part of the
Ruby standard library is
[facter](http://www.puppetlabs.com/projects/facter/index.html),
which is also developed by Puppet Labs.

All other prerequisites Ruby libraries should come with any standard Ruby 1.8.2+ install.  Should your OS not come with the complete standard
library (or you are using a custom Ruby build), these include:

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

If installing from a distribution maintained package, such as those listed on the [Downloading Puppet Wiki Page](http://projects.puppetlabs.com/projects/puppet/wiki/Downloading_Puppet) all OS prerequisites should be handled by your package manager.  See the Wiki for information on how to enable repositories for your particular OS.  Usually the latest stable version is available as a package.  If you would like to do puppet-development or see the latest versions, however, you will want to install from source.


Installing Facter From Source
-----------------------------

The facter library is a prerequisite for Puppet. Like Puppet, there are
[packages](http://projects.puppetlabs.com/projects/puppet/wiki/Downloading_Puppet)
available for most platforms, though you may want to use the
tarball if you would like to try a newer version or are using
a platform without an OS package:

Get the latest tarball:

    $ wget http://puppetlabs.com/downloads/facter/facter-latest.tgz
{:shell}

Untar and install facter:

    $ gzip -d -c facter-latest.tgz | tar xf -
    $ cd facter-*
    $ sudo ruby install.rb # or become root and run install.rb
{:shell}

There are also gems available in the
[download](http://www.puppetlabs.com/downloads/) directory.

Installing Puppet From Source
-----------------------------

Using the same mechanism as Facter, install the puppet libraries and
executables:

    # get the latest tarball
    $ wget http://puppetlabs.com/downloads/puppet/puppet-latest.tgz
    # untar and install it
    $ gzip -d -c puppet-latest.tgz | tar xf -
    $ cd puppet-*
    $ sudo ruby install.rb # or become root and run install.rb
{:shell}

You can also check the source out from the git repo:

    $ mkdir -p ~/git && cd ~/git
    $ git clone git://github.com/puppetlabs/puppet
    $ cd puppet
    $ sudo ruby ./install.rb
{:shell}

To install into a different location you can use:

    $ sudo ruby install.rb --bindir=/usr/bin --sbindir=/usr/sbin
{:shell}

### Alternative Install Method: Using Ruby Gems

You can also install Facter and Puppet via gems:

      $ wget http://puppetlabs.com/downloads/gems/facter-1.5.7.gem
      $ sudo gem install facter-1.5.7.gem
      $ wget http://puppetlabs.com/downloads/gems/puppet-0.25.1.gem
      $ sudo gem install puppet-0.25.1.gem
{:shell}

Find the latest gems
[here](http://puppetlabs.com/downloads/gems/)

For more information on Ruby Gems, see the
[Gems User Guide](http://docs.rubygems.org/read/book/1)

WARNING: If you get the error, in `require: no such file to load`, define the RUBYOPT environment variable as advised in the
[post-install instructions](http://docs.rubygems.org/read/chapter/3#page70)
of the RubyGems User Guide.

Learning and Configuring Puppet
------------------

Now that the packages are installed, start [Learning Puppet](../learning/) or see [Configuring Puppet](./configuring.html) for setup instructions.
