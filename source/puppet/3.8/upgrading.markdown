---
layout: default
title: "Upgrading Puppet"
---

[release_notes]: /release_notes/
[repos]: ./puppet_repositories.html
[puppet_3_release_notes]: /puppet/3/reference/release_notes.html
[mailing_list]: https://groups.google.com/group/puppet-users/
[tarball]: http://downloads.puppetlabs.com/puppet/
[mcollective]: /mcollective
[mco_puppetd]: /mcollective/reference/basic/basic_cli_usage.html#discovering-available-agents

Since Puppet is likely managing your entire infrastructure, it should be **upgraded with care.** This page describes our recommendations for upgrading Puppet.

Upgrade Intentionally
-----

If you are using `ensure => latest` on the Puppet package or running large-scale package upgrade commands, you might receive a Puppet upgrade you were not expecting, especially if you subscribe to the [Puppet package repos][repos], which always contain the most recent version of Puppet. **We highly recommend avoiding unintentional upgrades.** Although we try our best not to break things, especially between minor releases, Puppet has a lot of surface area, and bugs can and do slip in.

We recommend doing one of the following:

* Maintain your own package repositories, test new Puppet releases in a dev environment, and only introduce known-good versions into your production repo. Many sysadmins consider this to be best practice for **any** mission-critical packages.
* Use Apt's pinning feature or Yum's versionlock plugin to lock Puppet to a specific version, and only upgrade when you have a roll-out plan in place.

### Apt Pinning Example

You can pin package versions by adding special .pref files to your system's `/etc/apt/preferences.d/` directory:

    # /etc/apt/preferences.d/00-puppet.pref
    Package: puppet puppet-common
    Pin: version 2.7*
    Pin-Priority: 501

This pref file will lock puppet and puppet-common to the latest 2.7 release --- they will be upgraded when new 2.7.x releases are added, but will not jump a major version. It will also downgrade a Puppet 3 to Puppet 2.7 if the pin-priority of the Puppet 3 is less than 501 (the default is 500). A separate file could be used to pin puppetmaster and puppetmaster-common, or they could be added to the package list.

### Yum Versionlock Example

Unfortunately, Yum versionlock is less flexible than Apt pinning: it can't allow bugfix upgrades, and can only lock specific versions. For this reason, maintaining your own repo is a more attractive option for RPM systems.

    $ sudo yum install yum-versionlock
    $ sudo yum install puppet-2.7.19
    $ sudo yum versionlock puppet

These commands will install the versionlock plugin and lock Puppet to version 2.7.19. When you want to upgrade, edit `/etc/yum/pluginconf.d/versionlock.list` and remove the Puppet lock, then run:

    $ sudo yum install puppet-<desired version>
    $ sudo yum versionlock puppet

Always Upgrade the Puppet Master First
-----

Older agent nodes can get catalogs from a newer puppet master. The inverse is not always true.

Use More Care With Major Releases
-----

Upgrading to a new major release presents more possibility for things to go wrong, and we recommend extra caution.

### Additional Precautions

When upgrading to a new major release, we recommend the following:

* Avoid jumping over a whole major release. If you are on Puppet 2.6, you should upgrade to Puppet 2.7 before going to 3.x, unless you are prepared to spend a lot of time fixing your manifests without a net.
* **Read the release notes,** in particular any sections that refer to "backwards-incompatible changes." Follow any specific recommendations for the new version. (See the "BREAK" notes in the table of contents of [the Puppet 3.x release notes][puppet_3_release_notes] for backwards-incompatible changes in Puppet 3.0.)
* If you tend to just upgrade everything for bug fix releases, use a more conservative roll-out plan for major ones.

The definition of a "major release" has occasionally changed:

### Versioning in Puppet 3 and Later

Starting with Puppet 3, there are three kinds of Puppet release:

* **Bug fix** releases increment the last segment of the version number. (E.g. 3.0.**1**.) They are intended to fix bugs without introducing new features or breaking backwards compatibility. These releases **should** be safe to upgrade to, but you should test them anyway.
* **Minor** releases increment the middle segment of the version number. (E.g. 3.**1**.0.) They may introduce new features, but shouldn't break backwards compatibility.
* **Major** releases increment the first segment of the version number. (E.g. **3**.0.0.) They **may intentionally break backwards compatibility** with previous versions, in addition to adding features and fixing bugs.

### Versioning in Puppet 2.x

In the 2.x series:

* **Minor** releases are not distinguished from bug fix releases. A release that increments the last segment of the version number (e.g. 2.7.**18**) may or may not add new features or break small areas of backwards compatibility, and you must check the [release notes][release_notes] to find out.
* **Major** releases increment the second segment of the version number. (E.g. 2.**7**.0.) They **may intentionally break backwards compatibility** with previous versions, in addition to adding features and fixing bugs.


Roll Out In Stages
-----

When upgrading, especially between major versions, we recommend rolling out the upgrade in stages. Use one of the following three options:

### Option 1: Spin Up Temporary Puppet Master, or Cull a Master From Your Load Balancer Pool

The best approach is to spin up a temporary puppet master, then point a few test nodes at it.

* If you run a multi-master site and can pull a puppet master out of the load balancer pool for temporary test duty, do that. Upgrade Puppet on it, and follow steps 5-10 below.
* If you run a multi-master site and use Puppet to configure new puppet masters, you can also spin up a new node and use Puppet to configure it. Upgrade Puppet on it, and follow steps 5-10 below.
* Otherwise, follow steps 1-10 below.

1. Provision a new node and install Puppet on it.
2. Set its `server` setting to the existing puppet master, and use `puppet agent --test` to request a certificate; sign the cert.
3. Provision the new puppet master by checking out your latest modules, manifests, and data from version control. If you use an ENC and/or PuppetDB or storeconfigs, configure the master to talk to those services.
4. In a terminal window, run `puppet master --no-daemonize --verbose`. This will run a puppet master in the foreground so you can easily see log messages and warnings. Use care to limit concurrent checkins on your test nodes; this WEBrick puppet master cannot handle sustained load.
5. Choose a subset of your nodes to test with the new master, or spin up new nodes. Upgrade Puppet to the new version on them, and change their `server` setting to point to the temporary puppet master.
6. Trigger a `puppet agent --test` run on every test node, so you can see log messages in the foreground. **Look for changes to their resources;** if you see anything you didn't expect, investigate it. If something seems dangerous and you can't figure it out, you may want to post to the [Puppet users list][mailing_list] or ask other users in #puppet on Freenode.
7. Check the log messages in the terminal window or log file on your puppet master. Look for warnings and deprecation notices.
8. Check the actual configurations of your test nodes. Make sure everything is still working as expected.
9. Repeat steps 5-8 with more test nodes if you're still not sure.
10. Revert the `server` setting on all test nodes. Decommission the temporary puppet master. Upgrade your production puppet master(s) by stopping their web server, upgrading the puppet package, and restarting their web server. Upgrade all your production nodes. (Most packaging systems allow you to use Puppet to upgrade Puppet.)

### Option 2: Run Two Instances of Puppet Master at Once

You can also run a second instance of puppet master on your production puppet master server, using the same modules, manifests, data, ENC, and SSL configuration.

> **Note:** This is generally reliable, but has a small chance of yielding inaccurate results. (This problem would require a major version to remove a given code path but not fail hard when attempting to access the code path; we are not currently aware of a situation that would cause that.)

1. [Download a tarball of the Puppet source code for the new version.][tarball] Unzip it somewhere **other than your normal Ruby library directory.** (`tar -xf puppet-<version>`)
2. Open a root shell, which should stay open for the duration of this test. (`sudo -i`)
3. Change directory into the source tarball. (`cd puppet-<version>`)
4. Add the lib directory to your shell's RUBYLIB. (`export RUBYLIB=$(pwd)/lib:$RUBYLIB`)
5. Run `./bin/puppet master --no-daemonize --verbose --masterport 8141`. This will run a puppet master **on a different port** in the foreground so you can easily see log messages and warnings. Use care to limit concurrent checkins on your test nodes; this WEBrick puppet master cannot handle sustained load.
6. Choose a subset of your nodes to test with the new master, or spin up new nodes. Upgrade Puppet to the new version on them, and change their `masterport` setting to point to 8141.
7. Trigger a `puppet agent --test` run on every test node, so you can see log messages in the foreground. **Look for changes to their resources;** if you see anything you didn't expect, investigate it. If something seems dangerous and you can't figure it out, you may want to post to the [Puppet users list][mailing_list] or ask other users in #puppet on Freenode.
8. Check the log messages in the terminal window on your puppet master. Look for warnings and deprecation notices.
9. Check the actual configurations of your test nodes. Make sure everything is still working as expected.
10. Repeat steps 6-9 with more test nodes if you're still not sure.
11. Revert the `masterport` setting on all test nodes. Kill the temporary puppet master process, delete the temporary copy of the puppet source. Upgrade your production puppet master(s) by stopping their web server, upgrading the puppet package, and restarting their web server. Upgrade all of your production nodes. (Most packaging systems allow you to use Puppet to upgrade Puppet.)



### Option 3: Upgrade Master and Roll Back if Needed

For **minor and bug fix releases,** you can often take a simpler path. This is not universally recommended, but many users do it and survive.

1. Disable puppet agent on all of your production nodes. This is best done with [MCollective][] and the [puppetd plugin][mco_puppetd], which can stop the agent on all nodes in a matter of seconds.
2. Upgrade your puppet master(s) to the new version of Puppet by stopping their web server, upgrading the puppet package, and restarting their web server.
3. Choose a subset of your nodes to test with the new master, or spin up new nodes. Upgrade Puppet to the new version on them.
4. Trigger a `puppet agent --test` run on every test node, so you can see log messages in the foreground. **Look for changes to their resources;** if you see anything you didn't expect, investigate it. If something seems dangerous and you can't figure it out, you may want to post to the [Puppet users list][mailing_list] or ask other users in #puppet on Freenode.
5. Check your puppet master's log files. Look for warnings and deprecation notices.
6. Check the actual configurations of your test nodes. Make sure everything is still working as expected.
7. Repeat steps 3-6 with more test nodes if you're still not sure.
8. Do one of the following:
    * Upgrade Puppet and reactivate puppet agent on all of your production nodes.
    * Downgrade Puppet to a known-good version on your Puppet master and any test nodes.

