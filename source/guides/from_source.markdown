---
layout: default
title: Running Puppet From Source
---

[install]: /guides/installation.html
[sysreqs]: /puppet/latest/reference/system_requirements.html
[config]: /guides/configuring.html
[authconf]: /guides/rest_auth_conf.html
[gitpuppet]: https://github.com/puppetlabs/puppet
[gitfacter]: https://github.com/puppetlabs/facter

Running Puppet From Source
=====

Puppet should usually be installed from reliable packages, such as those provided by Puppet Labs or your operating system vendor. **If you plan to run Puppet in production, you should leave this page and see [Installing Puppet][install].**

However, if you are developing Puppet, helping to resolve a bug, or testing a new feature, you may need to run pre-release versions of Puppet. The most flexible way to do this, if you are not being provided with pre-release packages, is to run Puppet directly from source.

> ![windows logo](/images/windows-logo-small.jpg) To run Puppet from source on Windows, [see the equivalent page in the Puppet for Windows documentation](/windows/from_source.html).

> Note: When running Puppet from source, you should never use the `install.rb` script included in the source. The point of running from source is to be able to switch versions of Puppet with a single command, and the `install.rb` script removes that capability by copying the source to several directories across your system.

Prerequisites
-----

* Puppet requires Ruby 1.8.7, 1.9.3, or 2.0.0. See the open source Puppet [system requirements][sysreqs] for more details about supported versions.
* To automatically manage Puppet's dependencies, you will also need to install [Bundler](http://bundler.io/). You can usually do this by running `gem install bundler`, or your operating system may have packages available.
* To access the Puppet source code, you will need [Git][].

[git]: http://git-scm.com/


Get the Puppet Source Code
-----

Use Git to clone [Puppet's GitHub repository][gitpuppet]. The example below assumes a base directory of `/usr/src`; if you are installing the source elsewhere, substitute the correct locations when running commands.

    $ sudo mkdir -p /usr/src
    $ cd /usr/src
    $ sudo git clone git://github.com/puppetlabs/puppet

Select a Branch or Release
-----

By default, the instructions above will leave you running the `master` branch, which contains code for the next unreleased version of Puppet. This may or may not be what you want.

Most development happens on either the `master` (for the next major or minor version) or `stable` (for patch releases for the current minor version) branches. Released versions are tagged with their version number; release candidates are tagged with their version number and a suffix like `-rc1`. [Explore the repository on GitHub][gitpuppet] to find the branch or tag you want, then run:

    $ cd /usr/src/puppet
    $ sudo git checkout origin/<BRANCH NAME>

...to switch to it. You can also check out:

* Released versions, by version number:

        $ sudo git checkout 2.7.12
* Specific commits anywhere on any branch:

        $ sudo git checkout 2d51b64

Teaching the complete use of Git is beyond the scope of this guide.


Install (or Update) Dependencies with Bundler
-----

To install Puppet's dependencies, run:

    $ sudo bundle install --path .bundle/gems/

This will install everything Puppet needs to run, do spec tests, etc. To run Puppet, you'll be running something like this:

    $ bundle exec puppet apply testmanifest.pp

See [the "Run Puppet" section below](#run-puppet) for more details. To run the tests, you can run:

    $ bundle exec rspec spec

If you change commits, Puppet's dependencies may also change; for example, a major new version of Puppet may require a new version of Facter. To update any changed dependencies, run:

    $ sudo bundle update

Configure Puppet
-----

On systems that have never had Puppet installed, you should do the following:

### Copy auth.conf Into Place

Puppet master uses the [`auth.conf`][authconf] file to control which systems can access which resources. The source includes an example file that exposes the default rules; starting with this file makes it easier to tweak the rules if necessary.

If you'll be running Puppet as root or as the `puppet` user, put it at `/etc/puppet/auth.conf`; otherwise, put it at `~/.puppet/auth.conf`.

    $ sudo cp /usr/src/puppet/conf/auth.conf /etc/puppet/auth.conf

### Create a puppet.conf File

If you'll be running Puppet as root or as the `puppet` user, the `puppet.conf` file is at `/etc/puppet/puppet.conf`; otherwise, put it at `~/.puppet/puppet.conf`.

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
    * [`dns_alt_names`](/references/latest/configuration.html#dnsaltnames)
    * [`reports`](/references/latest/configuration.html#reports)
    * [`node_terminus`](/references/latest/configuration.html#nodeterminus)
    * [`external_nodes`](/references/latest/configuration.html#externalnodes)

### Create the Puppet User and Group

Puppet requires a user and group. By default, these are `puppet` and `puppet`, but they can be changed in [`puppet.conf`][config] with the [`user`](/references/latest/configuration.html#user) and [`group`](/references/latest/configuration.html#group) settings.

Create this user and group using your operating system's normal tools, or run the following:

    $ sudo puppet resource user puppet ensure=present
    $ sudo puppet resource group puppet ensure=present

If you skip this step, puppet master may not start correctly, and Puppet may have problems when creating some of its run data directories.

Run Puppet
-----

To run Puppet from source, you must first `cd` into its source directory and prefix your command with `bundle exec`. For example:

    $ cd /usr/src/puppet
    $ bundle exec puppet resource host localhost

As long as you do that, you can interactively run the main puppet agent, puppet master, and puppet apply commands, as well as any of the additional commands used to manage Puppet.

For testing purposes, you will usually want to run `puppet master --verbose --no-daemonize --autosign true` to start a temporary puppet master and `puppet agent --test --server <SERVER>` to run agents against it. For day-to-day use, you should create an init script for puppet agent (see the examples in the source's `conf/` directory) and use a Rack server like Passenger or Unicorn to run puppet master.


Periodically Update the Source or Switch Versions
-----

If you are running from source, it is likely because you need to stay up to date with activity on a specific development branch. To update your installation to the current point on your chosen branch, you should periodically run:

    $ cd /usr/src/puppet
    $ sudo git fetch origin
    $ sudo git checkout origin/<BRANCH NAME>
    $ sudo bundle update

Be sure to stop any Puppet processes before doing this.

You can also switch versions or branches of Puppet at any time by running `sudo git checkout <VERSION OR BRANCH>`.

