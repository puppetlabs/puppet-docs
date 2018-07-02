---
layout: default
title: "Installing Puppet: From Source Tarballs"
---

[peinstall]: {{pe}}/install_basic.html
[confdir]: /puppet/latest/reference/dirs_confdir.html
[puppet.conf]: /puppet/latest/reference/config_file_main.html
[auth.conf]: /puppet/latest/reference/config_file_auth.html
[main manifest]: /puppet/latest/reference/dirs_manifest.html
[module directory]: /puppet/latest/reference/dirs_modulepath.html
[directory environments]: /puppet/latest/reference/environments.html
[install-latest]: /puppet/latest/reference/install_pre.html

> #### **Note:** This document covers *open source* releases of Puppet version 3.8 and lower. For current versions, you should see instructions for [installing the latest version of Puppet][install-latest] or [installing Puppet Enterprise][peinstall].

On \*nix platforms without native packages available, you can install Puppet with a tarball of source code. This is even more unwieldy than using RubyGems and is almost never recommended, but it might be necessary in some cases.

First
-----

Before installing Puppet, make sure you've looked at the [pre-install tasks.](./pre_install.html)

Step 1: Ensure Prerequisites are Installed
-----

1.  Use your OS's package tools to install Ruby. In some cases, you might need to compile and install it yourself.
2.  On Linux platforms, ensure that the LSB tools are installed. We recommend installing at least `lsb_release`. See your OS's documentation for details about its LSB tools.
3.  If you use Ruby 1.8.7, you must also install the JSON library. If you have RubyGems installed, you can use `sudo gem install json_pure`, but if not, you'll need to [download the source from the project's site](http://flori.github.io/json/) and install it manually.

Step 2: Download Puppet and its Dependencies
-----

Download the latest `.tar.gz` files containing the Puppet, Facter, and Hiera sources.

-   [Puppet downloads](https://downloads.puppetlabs.com/puppet/)
-   [Facter downloads](http://downloads.puppetlabs.com/facter/)
-   [Hiera downloads](https://downloads.puppetlabs.com/hiera/)

Optionally, you can also download the corresponding `.asc` files and [verify the signature](/puppet/latest/reference/puppet_collections.html#verifying-puppet-packages) of each tarball.

Step 3: Install Facter, Hiera, and Puppet
-----

Unarchive the Facter, Hiera, and Puppet tarballs, then navigate to each resulting directory and run:

    sudo ruby install.rb

### Upgrading

> **Note:** Read our [tips on upgrading](./upgrading.html) before upgrading your Puppet deployment.

To upgrade to the latest versions of Puppet, Facter, and Hiera, download new tarballs and run the install scripts again.

After upgrading, restart the `puppet` service and, if applicable, the Puppet master web server.

Step 6: Pre-Configure Puppet
-----

Source tarballs lack some of the conveniences that native packages have. To prepare for the post-install tasks, do the following:

### Create Users

The Puppet master service needs a `puppet` user and group. If this node might ever act as a Puppet master server, do the following:

1.  Create a `puppet` group:

        sudo puppet resource group puppet ensure=present

2.  Create a `puppet` user:

        sudo puppet resource user puppet ensure=present gid=puppet shell='/sbin/nologin'

This step is optional on agents.

### Create an Init Script for Puppet Agent

To run Puppet agent as a service, you need an init script (or whatever your OS's equivalent is).

Because each platform handles init scripts differently, you must find one specific to your operating system or build one yourself based on what you know about your chosen operating system. The `ext` directory in the Puppet source includes several example init scripts or service configurations for various operating systems:

-   [Red Hat](https://github.com/puppetlabs/puppet/blob/master/ext/redhat)
-   [Debian](https://github.com/puppetlabs/puppet/blob/master/ext/debian)
-   [SUSE](https://github.com/puppetlabs/puppet/blob/master/ext/suse)
-   [systemd](https://github.com/puppetlabs/puppet/blob/master/ext/systemd)
-   [FreeBSD](https://github.com/puppetlabs/puppet/blob/master/ext/freebsd)
-   [Gentoo](https://github.com/puppetlabs/puppet/blob/master/ext/gentoo)
-   [Solaris](https://github.com/puppetlabs/puppet/blob/master/ext/solaris)

Do not start the `puppet` or Puppet master services yet.

### Create a Confdir and Config Files

When you install with tarballs, your [confdir][] might be empty or missing. Populate it with these required files:

1.  Make sure the [confdir][] exists. This directory is usually at `/etc/puppet/`.
2.  Create a [puppet.conf][] file in the confdir. You can leave it empty until the post-install tasks.
3.  If this node will ever act as a Puppet master, it needs an [auth.conf][] file. Use [the default auth.conf file](https://raw.githubusercontent.com/puppetlabs/puppet/3.8.5/conf/auth.conf) from the Puppet source, and put it in the confdir.
4.  Create a [main manifest][] and a [module directory][]. Alternately, [enable directory environments][directory environments] in puppet.conf and create a `production` environment, as described in the [directory environments][] page.

### Make Sure Puppet Can be Loaded

Run `puppet --version`. This should output the version of Puppet you now have installed.

Next
----

At this point, Puppet is installed, but it isn't configured or running. You should now [do the post-install tasks](./post_install.html).
