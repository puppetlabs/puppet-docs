---
layout: default
title: "Installing Puppet: From Source Tarballs"
---

[peinstall]: /pe/latest/install_basic.html
[confdir]: /puppet/latest/reference/dirs_confdir.html
[puppet.conf]: /puppet/latest/reference/config_file_main.html
[auth.conf]: /puppet/latest/reference/config_file_auth.html
[main manifest]: /puppet/latest/reference/dirs_manifest.html
[module directory]: /puppet/latest/reference/dirs_modulepath.html
[directory environments]: /puppet/latest/reference/environments.html
[install-latest]: /puppet/latest/reference/install_pre.html

> **Note:** This document covers open source releases of Puppet version 3.8 and lower. You might also want instructions for [installing Puppet Enterprise][peinstall] or [installing Puppet 4.0 or newer.][install-latest]

On \*nix platforms without native packages available, you can install Puppet with a tarball of source code. This is even more unwieldy than using RubyGems and is almost never recommended, but it may be necessary in some cases.

First
-----

Before installing Puppet, make sure you've looked at the [pre-install tasks.](./pre_install.html)

Step 1: Ensure Prerequisites are Installed
-----

* Use your OS's package tools to install Ruby. In some cases, you may need to compile and install it yourself.
* On Linux platforms, you should also ensure that the LSB tools are installed; at a minimum, we recommend installing `lsb_release`. See your OS's documentation for details about its LSB tools.
* If you are running Ruby 1.8.7, you must also install the JSON library. If you have RubyGems installed, you can use `sudo gem install json_pure`, but if not, you'll need to [download the source from the project's site](http://flori.github.io/json/) and install it manually.


Step 2: Download Puppet and its Dependencies
-----

You will need the latest `.tar.gz` files for the Puppet source, the Facter source, and the Hiera source.

* [Puppet downloads](https://downloads.puppetlabs.com/puppet/)
* [Facter downloads](http://downloads.puppetlabs.com/facter/)
* [Hiera downloads](https://downloads.puppetlabs.com/hiera/)

Optionally, you can also download the corresponding `.asc` files and [verify the signature](/guides/puppetlabs_package_verification.html) of each tarball.

Step 3: Install Facter
-----

Unarchive the Facter tarball, navigate to the resulting directory, and run:

    $ sudo ruby install.rb

Step 4: Install Hiera
-----

Unarchive the Hiera tarball, navigate to the resulting directory, and run:

    $ sudo ruby install.rb

Step 5: Install Puppet
-----

Unarchive the Puppet tarball, navigate to the resulting directory, and run:

    $ sudo ruby install.rb

### Upgrading

**Note:** Be sure to read our [tips on upgrading](./upgrading.html) before upgrading your whole Puppet deployment.

To upgrade to the latest versions of Puppet, Facter, and Hiera, download new tarballs and run the install scripts again.

You'll need to restart the `puppet` service and/or the puppet master web server after upgrading.

Step 6: Pre-Configure Puppet
-----

Source tarballs lack some of the conveniences that native packages have. To prepare for the post-install tasks, you should now do the following:

### Create Users

The puppet master service needs a `puppet` user and group. If this node might ever act as a puppet master server, do the following now:

1. Manually create a `puppet` group, by running `sudo puppet resource group puppet ensure=present`.
2. Manually create a `puppet` user, by running `sudo puppet resource user puppet ensure=present gid=puppet shell='/sbin/nologin'`.

This step is optional on agent nodes.

### Create an Init Script for Puppet Agent

To run puppet agent as a service, you'll want an init script, or whatever your OS's equivalent is.

Each platform handles init scripts a little differently, so you'll need to either find an OS-specific one or build one yourself based on what you know about your OS of choice. If you browse the `ext` directory in the Puppet source on GitHub, you can find several example init scripts or service configurations for various OSes:

* [Red Hat](https://github.com/puppetlabs/puppet/blob/master/ext/redhat)
* [Debian](https://github.com/puppetlabs/puppet/blob/master/ext/debian)
* [SUSE](https://github.com/puppetlabs/puppet/blob/master/ext/suse)
* [systemd](https://github.com/puppetlabs/puppet/blob/master/ext/systemd)
* [FreeBSD](https://github.com/puppetlabs/puppet/blob/master/ext/freebsd)
* [Gentoo](https://github.com/puppetlabs/puppet/blob/master/ext/gentoo)
* [Solaris](https://github.com/puppetlabs/puppet/blob/master/ext/solaris)

Do not start the `puppet` or puppet master services yet.

### Create a Confdir and Config Files

When you install with tarballs, your [confdir][] may be empty or missing. You will need to populate it with the required files

* Make sure the [confdir][] exists. This directory is usually at `/etc/puppet/`.
* Create a [puppet.conf][] file in the confdir. You can leave it empty until the post-install tasks.
* If this node will ever act as a puppet master, it will need an [auth.conf][] file. Download [the default auth.conf file](https://raw.githubusercontent.com/puppetlabs/puppet/master/conf/auth.conf) from the Puppet source on GitHub, and put it in the confdir.
* Create a [main manifest][] and a [module directory][]. Alternately, [enable directory environments][directory environments] in puppet.conf and create a `production` environment, as described in the [directory environments][] page.


Next
----

At this point, Puppet is installed, but it isn't configured or running. You should now [do the post-install tasks](./post_install.html).

