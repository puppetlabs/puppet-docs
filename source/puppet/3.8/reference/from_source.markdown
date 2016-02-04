---
layout: default
title: Running Puppet From Source
---

[install]: ./pre_install.html
[sysreqs]: /puppet/latest/reference/system_requirements.html
[authconf]: /guides/rest_auth_conf.html
[gitpuppet]: https://github.com/puppetlabs/puppet
[puppet.conf]: /puppet/latest/reference/config_file_main.html
[confdir]: /puppet/latest/reference/dirs_confdir.html
[about_settings]: /puppet/latest/reference/config_about_settings.html
[short_settings]: /puppet/latest/reference/config_important_settings.html

Running Puppet From Source
=====

Puppet should usually be installed from reliable packages, such as those provided by Puppet Labs or your operating system vendor. **If you plan to run Puppet in production, you should leave this page and see [Installing Puppet][install].**

However, if you are developing Puppet, helping to resolve a bug, or testing a new feature, you may need to run pre-release versions of Puppet. The most flexible way to do this, if you are not being provided with pre-release packages, is to run Puppet directly from source.

> Note: When running Puppet from source, you should never use the `install.rb` script included in the source. The point of running from source is to be able to switch versions of Puppet with a single command, and the `install.rb` script removes that capability by copying the source to several directories across your system.

Prerequisites
-----

* Puppet requires Ruby, and some older versions won't work. See the Puppet [system requirements][sysreqs] for more details about supported versions.
    * On Windows, you can use the Ruby installer from [rubyinstaller.org](http://rubyinstaller.org/downloads).
* To automatically manage Puppet's dependencies, you will also need to install [Bundler](http://bundler.io/). You can usually do this by running `gem install bundler`, or your operating system may have packages available.
* To access the Puppet source code, you will need [Git][].
    * On Windows, you should use [the "msysgit" packages](http://msysgit.github.io/). You should also run `git config core.filemode false` to prevent unnecessary mode bit changes.
* On Windows, the default `cmd.exe` terminal will work fine for running Puppet commands; Puppet doesn't require Cygwin or Powershell.

[git]: http://git-scm.com/

Install Puppet
-----

### Step 1: Get the Puppet Source Code

Use Git to clone [Puppet's GitHub repository][gitpuppet]. The example below assumes a base directory of `~/src`; if you are installing the source elsewhere, substitute the correct locations when running commands.

    $ mkdir ~/src
    $ cd ~/src
    $ git clone git://github.com/puppetlabs/puppet
    $ cd puppet

Roughly equivalent commands on Windows:

    C:>mkdir src
    C:>cd src
    C:\src>git clone git://github.com/puppetlabs/puppet.git
    C:\src>cd puppet

### Step 2: Select a Branch or Release

By default, the instructions above will leave you running the `master` branch, which contains code for the next unreleased version of Puppet. This may or may not be what you want.

Most development happens on either the `master` (for the next major or minor version) or `stable` (for patch releases for the current minor version) branches. Released versions are tagged with their version number; release candidates are tagged with their version number and a suffix like `-rc1`. [Explore the repository on GitHub][gitpuppet] to find the branch or tag you want, then run:

    $ git checkout origin/<BRANCH NAME>

...to switch to it. You can also check out:

* Released versions, by version number:

        $ git checkout 2.7.12
* Specific commits anywhere on any branch:

        $ git checkout 2d51b64

Teaching the complete use of Git is beyond the scope of this guide.


### Step 3: Install (or Update) Dependencies with Bundler

To install Puppet's dependencies, run:

    $ bundle install --path .bundle/gems/

If you change commits, Puppet's dependencies may also change; for example, a major new version of Puppet may require a new version of Facter. To update any changed dependencies, run:

    $ sudo bundle update

Configure Puppet
-----

On systems that have never had Puppet installed, you should do the following:

### Create a puppet.conf File

Create a [puppet.conf][] file in the confdir. (The location of the confdir depends on your OS and user account; see [the reference page on the confdir][confdir] for details.)

The puppet.conf file contains Puppet's settings. For more details, see [About Puppet's Settings][about_settings], [Short List of Important Settings][short_settings], and [the puppet.conf reference page][puppet.conf].

You will likely want to set the following settings:

* In the `[agent]` section:
    * [`certname`](/puppet/latest/reference/configuration.html#certname)
    * [`server`](/puppet/latest/reference/configuration.html#server)
    * [`environment`](/puppet/latest/reference/configuration.html#environment)
* In the `[master]` section:
    * [`certname`](/puppet/latest/reference/configuration.html#certname)
    * [`dns_alt_names`](/puppet/latest/reference/configuration.html#dnsaltnames)
    * [`reports`](/puppet/latest/reference/configuration.html#reports)
    * [`node_terminus`](/puppet/latest/reference/configuration.html#nodeterminus)
    * [`external_nodes`](/puppet/latest/reference/configuration.html#externalnodes)

### Copy auth.conf Into Place (Puppet Master Servers Only)

Puppet master uses the [`auth.conf`][authconf] file to control which systems can access which resources. The source includes an example file that exposes the default rules; starting with this file makes it easier to tweak the rules if necessary.

Copy the file from `~/src/puppet/conf/auth.conf` (or wherever you checked out the source) into the confdir. (The location of the confdir depends on your OS and user account; see [the reference page on the confdir][confdir] for details.)

### Create the Puppet User and Group (Puppet Master Servers Only)

To run a puppet master server, Puppet requires a user and group. By default, these are both named `puppet`, but they can be changed in [puppet.conf][] with the [`user`](/puppet/latest/reference/configuration.html#user) and [`group`](/puppet/latest/reference/configuration.html#group) settings.

Create this user and group using your operating system's normal tools, or run the following:

    $ sudo puppet resource user puppet ensure=present
    $ sudo puppet resource group puppet ensure=present

If you skip this step, puppet master may not start correctly, and Puppet may have problems when creating some of its run data directories.

This is never necessary on Windows, as Windows nodes can't serve as puppet masters.

Run Puppet
-----

To run Puppet from source, you must first `cd` into its source directory and prefix your command with `bundle exec`. For example:

    $ cd ~/src/puppet
    $ bundle exec puppet resource host localhost
    $ bundle exec puppet agent --test --server puppet.example.com

The `bundle exec` prefix will let you interactively run the puppet agent, puppet master, and puppet apply commands, as well as any of the additional commands used to manage Puppet.

For testing purposes, you will usually want to run `puppet master --verbose --no-daemonize --autosign true` to start a temporary puppet master and `puppet agent --test --server <SERVER>` to run agents against it. For day-to-day use, you should create an init script for puppet agent (see the examples in the source's `conf/` directory) and use a Rack server like Passenger or Unicorn to run puppet master.

### Windows Note: User Account Control

In general, Puppet must be running in an account that is a member of the local Administrators group in order to make changes to the system (e.g., change file ownership, modify `/etc/hosts`, etc.).

On systems where User Account Control (UAC) is enabled, such as Windows 7 and 2008, Puppet must be running with explicitly elevated privileges. **It will not ask for elevation automatically; you must specifically start your `cmd.exe` terminal window with elevated privileges before running Puppet commands.** See [this blog post (unaffiliated with Puppet Labs)](http://blog.didierstevens.com/2008/05/26/quickpost-restricted-tokens-and-uac/) for more information about UAC.

### Running Spec Tests

To run Puppet's spec tests, you can run:

    $ bundle exec rspec spec


Periodically Update the Source or Switch Versions
-----

If you are running from source, it is likely because you need to stay up to date with activity on a specific development branch. To update your installation to the current point on your chosen branch, you should periodically run:

    $ cd /usr/src/puppet
    $ sudo git fetch origin
    $ sudo git checkout origin/<BRANCH NAME>
    $ sudo bundle update

Be sure to stop any Puppet processes before doing this.

You can also switch versions or branches of Puppet at any time by running `sudo git checkout <VERSION OR BRANCH>`.

