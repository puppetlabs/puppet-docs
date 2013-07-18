---
layout: default
title: "PE 3.0 » Appendix"
subtitle: "User's Guide Appendix"
canonical: "/pe/latest/appendix.html"
---


This page contains additional miscellaneous information about Puppet Enterprise (PE) 3.0.

Puppet Terminology
-----

For help with Puppet-specific terms and language, visit [the glossary](/references/glossary.html)

For a complete guide to the Puppet language, visit [the reference manual](/puppet/3/reference/)

Release Notes
-----

### PE 3.0.0

#### Delayed Support for Complete Upgrades and SLES

* Full functionality for upgrades is not yet complete in 3.0. Upgrading is not yet supported for master, console and database roles, but is fully supported for agents. Visit the [upgrading page](./install_upgrading) for complete instructions on how to migrate a 2.8 deployment to PE 3.0 now. Full upgrade support will be included in the next release of PE 3.0, no later than August 15, 2013.
* Support for nodes running the SLES operating system is not yet completed. It will be included in the next release of PE 3.0, no later than August 15, 2013.


#### Package and Component Upgrades

Many of the constituent components of Puppet Enterprise have been upgraded. Namely:

* Ruby 1.9.3
* Augeas 1.0.0
* Puppet 3.2.2
* Facter 1.7.1
* Hiera 1.2.1
* MCollective 2.2.4
* Passenger 4.0
* Dashboard 2.0
* Java 1.7
* PostgreSQL 9.2.4

#### Removal of Cloning

The live management cloning tool is deprecated and has been removed in PE 3.0. We are continuing to improve resource inspection and interactive orchestration commands in the console. In general, we recommend managing resources with Puppet manifests instead of one-off commands.

If you are using cloning, you can achieve a similar workflow by using `puppet resource` or [the puppetral plugin's `find` action](./orchestration_actions.html#find) to learn the details of resources on individual host. Then, you can use that info to write or append to a manifest. <!-- We've created an example page that shows this [alternate workflow in greater detail](./cloning_alt.html). -->


#### Removal of Compliance

The compliance workflow tools, including File Search, are deprecated, and have been removed in Puppet Enterprise 3.0. We are continuing to invest in flexible ways to help you predict, detect, and control change, and our next-generation tools will not use manually maintained baselines as a foundation.

If you are using the compliance workflow tools today, you can achieve a similar workflow by using Puppet's **noop** features to detect changes. We've created an example page that shows this [alternate workflow in greater detail](./compliance_alt.html).

#### Removal of "File Search"

Related to the removal of compliance, the File Search section of the console has been removed. This section was able to display file contents when given an MD5 checksum, but was no longer relevant once compliance was removed.

#### Puppet Agent Service Rename
Previously, the puppet agent service was known by several names, depending on platform (e.g. `puppetagent` on Solaris, `pe-puppet-agent` on Debian/Ubuntu, etc.). As of PE 3, it is called `'pe-puppet` on all platforms.

#### Change to Orchestration Engine's Authentication Backend

In previous versions, the orchestration engine (MCollective) used either the `psk` or `aespe` security plugin. As of PE 3, it uses the more secure and reliable `ssl` security plugin. **If you have integrated external applications with the orchestration engine,** you will need to [re-configure their security credentials](./orchestration_config.html#adding-new-orchestration-users-and-integrating-applications).

#### Change to Built-in Orchestration Actions

The output format and available actions of the `puppetral` orchestration plugin have changed --- the `create` action has been removed, and the output format is now an array of hashes. If you have built applications that integrate with the `puppetral` plugin, you'll need to update them.

Known Issues
-----

As we discover them, this page will be updated with known issues in Puppet Enterprise 3.0 and earlier. Fixed issues will be removed from this list and noted above in the release notes. If you find new problems yourself, please file bugs in Puppet [here][puppetissues] and bugs specific to Puppet Enterprise [here][peissues].

To find out which of these issues may affect you, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `3.2.2 (Puppet Enterprise 3.0)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](./install_upgrading.html).

[peissues]: http://projects.puppetlabs.com/projects/puppet-enterprise/issues
[puppetissues]: http://projects.puppetlabs.com/projects/puppet/issues


The following issues affect the currently shipped version of PE and all prior releases in the 2.x.x series, unless otherwise stated.

### Puppet Code Issues with UTF-8 Encoding
PE 3 uses an updated version of Ruby, 1.9 that is much stricter about character encodings than the version of Ruby used in PE 2.8. As a result, puppet code that contains UTF-8 characters such as accents or other non-ASCII characters can fail or act unpredictably. There are a number of ways UTF-8 characters can make it into puppet code, including, but not limited to, downloading a Forge module where some piece of metadata (e.g., author's name) contains UTF-8 characters. With apologies to our international customers, the current solution is to strictly limit puppet code to the ASCII character set only, including any code comments or metadata. Puppet Labs is working on cleaning up character encoding issues in Puppet and the various libraries it interfaces with.


### Readline Version Issues on AIX Agents
- As wtith PE 2.8.2,  on AIX 5.3, puppet agents depend on readline-4-3.2 being installed. You can check the installed version of readline by running `rpm -q readline`. If you need to install it, you can [download it from IBM](ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/readline/readline-4.3-2.aix5.1.ppc.rpm). Install it *before* installing the puppet agent.

- On AIX 6.1 and 7.1, the default version of readline, 4-3.2, is insufficient. You need to replace it *before* upgrading or installing by running

         rpm -e --nodeps readline
        rpm -Uvh readline-6.1-1.aix6.1.ppc.rpm

If you see an error message after running this, you can disregard it. Readline-6 should be successfully installed and you can proceed with the installation or upgrade (you can verify the installation with  `rpm -q readline`).

### Debian/Ubuntu Local Hostname Issue
On some versions of Debian/Ubuntu, the default `/etc/hosts` file contains an entry for the machine's hostname with a local IP address of 127.0.1.1. This can cause issues for PuppetDB and PostgreSQL, because binding a service to the hostname will cause it to resolve to the local-only IP address rather than its public IP. As a result, nodes (including the console) will fail to connect to PuppetDB and PostgreSQL.

To fix this, add an entry to `/etc/hosts` that resolves the machine's FQDN to its *public* IP address. This should be done prior to installing PE. However, if PE has already been installed, restarting the `pe-puppetdb` and `pe-postgresql` services after adding the entry to the hosts file should fix things.

### Console_auth Fails After PostgreSQL Restart
RubyCAS server, the component which provides console log-in services will not automatically reconnect if it loses connection to its database, which can result in a `500 Internal Server Error` when attempting to log in or out. The issue can be resolved by restarting Apache on the console's node with `service pe-httpd restart`.

### Inconsistent Counts When Comparing Service Resources in Live Management

In the Browse Resources tab, comparing a service across a mixture of RedHat-based and Debian-based nodes will give different numbers in the list view and the detail view.

### Bad Data in Facter's `architecture` Fact

On AIX agents, a bug causes facter to return the system's model number (e.g., IBM 3271) instead of the processor's architecture (e.g. Power6). There is no known workaround.

### Augeas File Access Issue

On AIX agents, the Augeas lens is unable to access or modify `etc/services`. There is no known workaround.

### After Upgrading, Nodes Report a "Not a PE Agent" Error

When doing the first puppet run after upgrading using the "upgrader" script included in PE tarballs, agents are reporting an error: "&lt;node.name&gt; is not a Puppet Enterprise agent." This was caused by a bug in the upgrader that has since been fixed. If you downloaded a tarball prior to November 28, 2012, simply download the tarball again to get the fixed upgrader. If you prefer, you can download the [latest upgrader module](http://forge.puppetlabs.com/adrien/pe_upgrade/0.4.0-rc1) from the Forge. Alternatively, you can fix it by changing `/etc/puppetlabs/facter/facts.d/is_pe.txt`  to contain: `is_pe=true`.

### EC2/Dual-homed Systems Report Incorrect URIs for the Console.

During installation, the PE installer attempts to automatically determine the URI where the console can be reached. On EC2 (and likely all other dual-homed systems), the installer incorrectly selects the internal, non-routable URI. Instead, you should manually enter the correct, external facing URI of the system hosting the console.

### Answer file required for some SMTP servers.d

Any SMTP server that requires authentication, TLS, or runs over any port other than 25 needs to be explicitly added to an answers file. See the [advanced configuration page](./console_config.html#allowing-anonymous-console-access) for details.

### `pe-httpd` Must Be Restarted After Revoking Certificates

([Issue #8421](http://projects.puppetlabs.com/issues/8421))

Due to [an upstream bug in Apache](https://issues.apache.org/bugzilla/show_bug.cgi?id=14104), the `pe-httpd` service on the puppet master must be restarted after revoking any node's certificate.

After using `puppet cert revoke` or `puppet cert clean` to revoke a certificate, restart the service by running:

    $ sudo /etc/init.d/pe-httpd restart

### Dynamic Man Pages are Incorrectly Formatted

Man pages generated with the `puppet man` subcommand are not formatted as proper man pages, and are instead displayed as Markdown source text. This is a purely cosmetic issue, and the pages are still fully readable.

To improve the display of Puppet man pages, you can use your system `gem` command to install the `ronn` gem:

    $ sudo gem install ronn


* * *

- [Next: Compliance: Alternate Workflow](./compliance_alt.html)
