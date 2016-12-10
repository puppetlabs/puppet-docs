---
layout: default
title: "Installing Puppet: OS X"
---

[peinstall]: {{pe}}/install_basic.html
[install-latest]: /puppet/latest/reference/install_pre.html

> #### **Note:** This document covers *open source* releases of Puppet version 3.8 and lower. For current versions, you should see instructions for [installing the latest version of Puppet][install-latest] or [installing Puppet Enterprise][peinstall].

First
-----

Before installing Puppet, review the [pre-install tasks.](./pre_install.html)

Supported Versions
-----

Puppet builds packages for OS X, but we don't run automated testing on them.

{% include pup38_platforms_osx.markdown %}

We recommend using Puppet on the newest version of OS X available, because we might not address bugs related to older versions. Our Puppet 3.8 packages are intended for OS X 10.9 (Mavericks) and later, and newer versions of Puppet are built and tested against newer versions of OS X.

To install on other operating systems, see the product navigation.

Step 1: Download Packages
-----

Download Puppet's OS X installers from [downloads.puppetlabs.com/mac](http://downloads.puppetlabs.com/mac/). You need these three packages:

-   The most recent Facter package (`facter-<VERSION>.dmg`)
-   The most recent Hiera package (`hiera-<VERSION>.dmg`)
-   The most recent Puppet package (`puppet-<VERSION>.dmg`)

The list of OS X packages includes release candidates, whose filenames have something like `-rc1` after the version number. Only use these if you want to test upcoming Puppet versions.

Step 2: Install Facter
-----

Mount the Facter disk image, and run the installer package it contains.

Step 3: Install Hiera
-----

Mount the Hiera disk image, and run the installer package it contains.

Step 4: Install Puppet
-----

Mount the Puppet disk image, and run the installer package it contains.

Although OS X systems can act as puppet master servers, we don't ship separate packages for that. This is mostly because the OS X package is very minimal compared to the Linux packages, and it doesn't include the relevant init scripts.

### Upgrading

> **Note:** Be sure to read our [tips on upgrading](./upgrading.html) before upgrading your whole Puppet deployment.

To upgrade to the latest versions of Puppet, Facter, and Hiera, download new packages and run the installers again.

You'll need to restart the `com.puppetlabs.puppet` service and/or the puppet master web server after upgrading. To restart a launchd service, run something like `sudo launchctl stop com.puppetlabs.puppet`; the service will be restarted as soon as it stops.

Step 5: Pre-Configure Puppet
-----

The OS X packages don't have some of the conveniences that the Linux and Windows packages have. To prepare for the post-install tasks, you should now do the following:

### Create Users

The puppet master service needs a `puppet` user and group. If this node might ever act as a puppet master server, do the following now:

1. Manually create a `puppet` group, by running `sudo puppet resource group puppet ensure=present`.
2. Manually create a `puppet` user, by running `sudo puppet resource user puppet ensure=present gid=puppet shell='/sbin/nologin'`.

This step is optional on agent nodes.

### Create a Launchd Service for Puppet Agent

[launchd]: http://developer.apple.com/library/mac/#documentation/MacOSX/Conceptual/BPSystemStartup/Chapters/CreatingLaunchdJobs.html
[launchctl]: http://developer.apple.com/library/mac/#documentation/Darwin/Reference/ManPages/man1/launchctl.1.html

OS X services are managed by [launchd][] (which is controlled with the [`launchctl`][launchctl] command). To run puppet agent as a service, you'll need to create a job configuration plist and put it where launchd expects to find it. (This service will be named `com.puppetlabs.puppet`.)

Make the service by creating a plist file at `/Library/LaunchDaemons/com.puppetlabs.puppet.plist`. The contents of the file should be something like this:

~~~ markup
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
        <key>Label</key>
        <string>com.puppetlabs.puppet</string>
        <key>OnDemand</key>
        <false/>
        <key>ProgramArguments</key>
        <array>
                <string>/usr/bin/puppet</string>
                <string>agent</string>
                <string>--no-daemonize</string>
                <string>--logdest</string>
                <string>syslog</string>
                <string>--color</string>
                <string>false</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>ServiceDescription</key>
        <string>Puppet agent service</string>
        <key>ServiceIPC</key>
        <false/>
</dict>
</plist>
~~~

Once you've created the plist, make sure it can only be modified by the root user:

    $ sudo chown root:wheel /Library/LaunchDaemons/com.puppetlabs.puppet.plist
    $ sudo chmod 644 /Library/LaunchDaemons/com.puppetlabs.puppet.plist

Do not start the `com.puppetlabs.puppet` service yet. If this node will also be a puppet master, do not start the puppet master's web server yet.

#### Customize the Launchd Config

You can customize this configuration if you want to.

By default, all of Puppet's messages will go to the main system log; you can view them in Console.app under "All Messages," and they will appear in `/var/log/system.log`. You can keep Puppet's messages out of the system log by changing `syslog` to `console` in the `ProgramArguments` array. You can also redirect Puppet's messages and errors to their own files by adding the following lines to the main `<dict>` object:

~~~ markup
<key>StandardErrorPath</key>
<string>/var/log/puppet/puppet.err</string>
<key>StandardOutPath</key>
<string>/var/log/puppet/puppet.out</string>
~~~

(Note that the `/var/log/puppet` directory doesn't exist by default, so you'll have to manually create it before launchd can use these files.)

You can also set any command line options you want for puppet agent by adding them to the `ProgramArguments` array. For example, you could increase the detail in your logs by adding:

~~~ markup
<string>--debug</string>
~~~

See [the puppet agent man page](/puppet/latest/reference/man/agent.html) for details about available options; note that [any of Puppet's settings can also be set on the command line.](/puppet/latest/reference/config_about_settings.html)

### Don't Worry About Loading the Launchd Service

As long as a service plist is in the `/Library/LaunchDaemons` directory, `puppet resource service` can manage it by name. You do not need to use `launchctl load` to enable the service.

Next
----

At this point, Puppet is installed, but it isn't configured or running. You should now [do the post-install tasks](./post_install.html).
