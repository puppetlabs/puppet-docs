---
layout: legacy
title: Running Puppet From Source
---

[install]: /guides/installation.html
[sysreqs]: /guides/platforms.html
[config]: /guides/configuring.html
[authconf]: /guides/rest_auth_conf.html
[gitpuppet]: https://github.com/puppetlabs/puppet
[gitfacter]: https://github.com/puppetlabs/facter

Running Puppet From Source
=====

Puppet should usually be installed from reliable packages, such as those provided by Puppet Labs or your operating system vendor. If you plan to run Puppet in anything resembling a normal fashion, you should leave this page and see [Installing Puppet][install].

However, if you are developing Puppet, helping to resolve a bug, or testing a new feature, you may need to run pre-release versions of Puppet. The most flexible way to do this, if you are not being provided with pre-release packages, is to run Puppet directly from source.

> ![windows logo](/images/windows-logo-small.jpg) To run Puppet from source on Windows, [see the equivalent page in the Puppet for Windows documentation](/windows/from_source.html).

> Note: When running Puppet from source, you should never use the `install.rb` script included in the source. The point of running from source is to be able to switch versions of Puppet with a single command, and the `install.rb` script removes that capability by copying the source to several directories across your system.

Prerequisites
-----

* Puppet requires Ruby.
    * Ruby 1.8.5 may work, but you should make an effort to use Ruby 1.8.7 or 1.9.2. See the open source Puppet [system requirements][sysreqs] for more details.
* Puppet requires Facter, a Ruby library. This guide will also describe how to install Facter from source, but you can skip those steps and instead install Facter from your operating system's packages or with `sudo gem install facter`.
* To access every version of the Puppet source code, including the current pre-release status of every development branch, you will need [Git][].
* If you want to run Puppet's tests, you will need [rake][], [rspec][], and [mocha][].
* If you wish to use Puppet ≥ 3.2 [with `parser = future` enabled](/puppet/latest/reference/lang_future.html), you should also install the `rgen` gem.

[mocha]: http://mocha.rubyforge.org/
[rspec]: http://rspec.info/
[rake]: http://rubygems.org/gems/rake
[git]: http://git-scm.com/


Get and Install the Source
-----

Use Git to clone the public code repositories for [Puppet][gitpuppet] and [Facter][gitfacter]. The examples below assume a base directory of `/usr/src`; if you are installing the source elsewhere, substitute the correct locations when running commands.

    $ sudo mkdir -p /usr/src
    $ cd /usr/src
    $ sudo git clone git://github.com/puppetlabs/facter
    $ sudo git clone git://github.com/puppetlabs/puppet

Select a Branch or Release
-----

By default, the instructions above will leave you running the `master` branch, which contains code for the next unreleased major version of Puppet. This may or may not be what you want.

Most development on existing series of releases happens on branches with names like `2.7.x`. [Explore the repository on GitHub][gitpuppet] to find the branch you want, then run:

    $ cd /usr/src/puppet
    $ sudo git checkout origin/<BRANCH NAME>

...to switch to it. You can also check out:

* Released versions, by version number:

        $ sudo git checkout 2.7.12
* Specific commits anywhere on any branch:

        $ sudo git checkout 2d51b64

Teaching the complete use of Git is beyond the scope of this guide.


Tell Ruby How to Find Puppet and Facter
-----

For Puppet to be functional, Ruby needs to have Puppet and Facter in its load path. Add the following to your `/etc/profile` file:

    export RUBYLIB=/usr/src/puppet/lib:/usr/src/facter/lib:$RUBYLIB

This will make Puppet and Facter available when run from login shells; if you plan to run Puppet as a daemon from source, you must set `RUBYLIB` appropriately in your init scripts.

Add the Binaries to the Path
-----

Add the following to your `/etc/profile` file:

    export PATH=/usr/src/puppet/bin:/usr/src/puppet/sbin:/usr/src/facter/bin:$PATH

This will make the Puppet and Facter binaries runnable from login shells.

At this point, you can run `source /etc/profile` or log out and back in again; after doing so, you will be able to run Puppet commands.

Configure Puppet
-----

On systems that have never had Puppet installed, you should do the following:

### Copy auth.conf Into Place

Puppet master uses the [`auth.conf`][authconf] file to control which systems can access which resources. The source includes an example file that exposes the default rules; starting with this file makes it easier to tweak the rules if necessary.

    $ sudo cp /usr/src/puppet/conf/auth.conf /etc/puppet/auth.conf

### Create a puppet.conf File

    $ sudo touch /etc/puppet/puppet.conf

The `puppet.conf` file contains Puppet's settings. See [Configuring Puppet][config] for more details.

You will likely want to set the following settings:

* In the `[agent]` block:
    * [`certname`](/references/latest/configuration.html#certname)
    * [`server`](/references/latest/configuration.html#server)
    * [`pluginsync`](/references/latest/configuration.html#pluginsync)
    * [`report`](/references/latest/configuration.html#report)
    * [`environment`](/references/latest/configuration.html#environment)
* In the `[master]` block:
    * [`certname`](/references/latest/configuration.html#certname)
    * [`dns_alt_names`](/references/latest/configuration.html#dns_alt_names)
    * [`reports`](/references/latest/configuration.html#reports)
    * [`node_terminus`](/references/latest/configuration.html#node_terminus)
    * [`external_nodes`](/references/latest/configuration.html#external_nodes)

### Create the Puppet User and Group

Puppet requires a user and group. By default, these are `puppet` and `puppet`, but they can be changed in [`puppet.conf`][config] with the [`user`](/references/latest/configuration.html#user) and [`group`](/references/latest/configuration.html#group) settings.

Create this user and group using your operating system's normal tools, or run the following:

    $ sudo puppet resource user puppet ensure=present
    $ sudo puppet resource group puppet ensure=present

If you skip this step, puppet master may not start correctly, and Puppet may have problems when creating some of its run data directories.

Run Puppet
-----

You can now interactively run the main puppet agent, puppet master, and puppet apply commands, as well as any of the additional commands used to manage Puppet.

For testing purposes, you will usually want to run puppet master with the `--verbose` and `--no-daemonize` options and run puppet agent with the `--test` option. For day-to-day use, you should create an init script for puppet agent (see the examples in the source's `conf/` directory) and use a Rack server like Passenger or Unicorn to run puppet master.

> Note: You should never attempt to run Puppet or Facter binaries while your current working directory is in `/usr/src`. This is because Ruby automatically adds the current directory to the load path, which can cause the projects' spec tests to accidentally be loaded as libraries. Facter in particular will usually fail when this is done.

Periodically Update the Source or Switch Versions
-----

If you are running from source, it is likely because you need to stay up to date with activity on a specific development branch. To update your installation to the current point on your chosen branch, you should periodically run:

    $ cd /usr/src/puppet
    $ sudo git fetch origin
    $ sudo git checkout origin/<BRANCH NAME>

Be sure to stop any Puppet processes before doing this.

You can also switch versions or branches of Puppet at any time by running `sudo git checkout <VERSION OR BRANCH>`.

