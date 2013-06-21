---
layout: default
title: "PE 3.0 » Appendix"
subtitle: "User's Guide Appendix"
---


This page contains additional miscellaneous information about Puppet Enterprise (PE) 3.0.

Puppet Terminology
-----

For help with Puppet-specific terms and language, visit [the glossary](/references/glossary.html)

For a complete guide to the Puppet language, visit [the reference manual](/puppet/3/reference/)

Release Notes
-----

### PE 3.0.0

#### Package and Component Upgrades

Many of the constituent components of Puppet Enterprise have been upgraded. Namely:

* Ruby 1.9.3
* Augeas 1.0.0
* Puppet 3.2.1
* Facter 1.7.1
* Hiera 1.2.1
* MCollective 2.2.4
* Passenger 4.0
* Dashboard 2.0
* Java 1.7
* PostgreSQL 9.2.4

#### Removal of Cloning

The Live Management cloning tool is deprecated and has been removed in PE 3.0. We are continuing to improve resource inspection and interactive MCollective commands in the console. In the meantime, you can use your manifests and MCollective's `puppetral` plug-in provider to achieve similar functionality to the cloning tool. 

##### Alternate Workflow in Brief
Use `puppet resource` to learn the details of resources on individual host. Then, use the MCollective `puppetral` plug-in provider to query for resources across multiple nodes. Use that info to write or append to a manifest. 


#### Removal of Compliance

The compliance workflow tools, including File Search, are deprecated, and have been removed in Puppet Enterprise 3.0. We are continuing to invest in flexible ways to help you predict, detect, and control change, and our next-generation tools will not use manually maintained baselines as a foundation.

If you are using the compliance workflow tools today, you can achieve a similar workflow by using Puppet's **noop** features to detect changes.

##### Alternate Workflow In Brief

 - _Instead of writing audit manifests:_ Write manifests that describe the desired baseline state(s). This is identical to writing Puppet manifests to _manage_ systems: you use the resource declaration syntax to describe the desired state of each significant resource.
 - _Instead of running puppet agent in its default mode:_ Make it sync the significant resources in **noop mode,** which can be done for the entire Puppet run, or per-resource. (See below.) This causes Puppet to detect changes and _simulate_ changes, without automatically enforcing the desired state.
 - _In the console:_ Look for "pending" events and node status. "Pending" is how the console represents detected differences and simulated changes.

##### Controlling Your Manifests

 As part of a solid change control process, you should be maintaining your Puppet manifests in a version control system like Git. This allows changes to your manifests to be tracked, controlled, and audited.

##### Noop Features

 Puppet resources or catalogs can be marked as "noop" before they are applied by the agent nodes. This means that the user describes a desired state for the resource, and Puppet will detect and report any divergence from this desired state. Puppet will report what _should_ change to bring the resource into the desired state, but it will not _make_ those changes automatically.

 * To set an individual resource as noop, set [the `noop` metaparameter](/references/latest/metaparameter.html#noop) to `true`.

         file {'/etc/sudoers':
           owner => root,
           group => root,
           mode  => 0600,
           noop  => true,
         }

     This allows you to mix enforced resources and noop resources in the same Puppet run.
 * To do an entire Puppet run in noop, set [the `noop` setting](/references/latest/configuration.html#noop) to `true`. This can be done in the `[agent]` block of puppet.conf, or as a `--noop` command-line flag. If you are running puppet agent in the default daemon mode, you would set noop in puppet.conf.

##### In the Console

 In the console, you can locate the changes Puppet has detected by looking for "pending" nodes, reports, and events. A "pending" status means Puppet has detected a change and simulated a fix, but has not automatically managed the resource.

 You can find a pending status in the following places:

 * The node summary, which lists the number of nodes that have had changes detected:

 ![The node summary with one node in pending status](./images/baseline/pending_node_summary.png)

 * The list of recent reports, which uses an orange asterisk to show reports with changes detected:

 ![The recent reports, with a few reports containing pending events](./images/baseline/pending_recent_reports.png)

 * The _log_ and _events_ tabs of any report containing pending events; these tabs will show you what changes were detected, and how they differ from the desired system state described in your manifests:

 ![The events tab of a report with pending events](./images/baseline/pending_events.png)

 ![The log tab of a report with pending events](./images/baseline/pending_log.png)

##### After Detection

 When a Puppet node reports noop events, this means someone has made changes to a noop resource that has a desired state desribed. Generally, this either means an unauthorized change has been made, or an authorized change was made but the manifests have not yet been updated to contain the change. You will need to either:

 * Revert the system to the desired state (possibly by running puppet agent with `--no-noop`).
 * Edit your manifests to contain the new desired state, and check the changed manifests into version control.

##### Before Detection

 However, your admins should generally be changing the manifests before making authorized changes. This serves as documentation of the change's approval.

##### Summary

 In this alternate workflow, you are essentially still maintaining baselines of your systems' desired states. However, instead of maintaining an _abstract_ baseline by approving changes in the console, you are maintaining _concrete_ baselines in readable Puppet code, which can be audited via version control records.

#### Puppet Agent Service Rename
Previously, the puppet agent service was known by several names, depending on platform (e.g. `puppetagent` on Solaris, `pe-puppet-agent` on Debian/Ubuntu, etc.). As of PE 3, it is called `'pe-puppet` on all platforms.


Known Issues
-----

As we discover them, this page will be updated with known issues in Puppet Enterprise 3.0 and earlier. Fixed issues will be removed from this list and noted above in the release notes. If you find new problems yourself, please file bugs in Puppet [here][puppetissues] and bugs specific to Puppet Enterprise [here][peissues].

To find out which of these issues may affect you, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `3.2.2 (Puppet Enterprise 3.0)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](./install_upgrading.html).

[peissues]: http://projects.puppetlabs.com/projects/puppet-enterprise/issues
[puppetissues]: http://projects.puppetlabs.com/projects/puppet/issues


The following issues affect the currently shipped version of PE and all prior releases in the 2.x.x series, unless otherwise stated.

### Debian/Ubuntu Local Hostname Issue
On some versions of Debian/Ubuntu, the default `/etc/hosts` file contains an entry for the machine's hostname with a local IP address of 127.0.1.1. This can cause issues for PuppetDB and PostgreSQL, because binding a service to the hostname will cause it to resolve to the local, rather public, IP of 127.0.1.1. As a result, nodes (including the console) will fail to connect to PuppetDB and PostgreSQL.

To fix this, add an entry to `/etc/hosts` that resolves the machine's FQDN to its *public* IP address. This should be done prior to installing PE. But if PE has already been installed, restarting the `pe-puppetdb` and `pe-postgresql` services after adding the entry to the hosts file should fix things.

### Console_auth Fails After PostgreSQL Restart
RubyCAS server, the component which provides console log-in services will not automatically reconnect if it loses connection to its database, which can result in a `500 Internal Server Error` when attempting to log in or out. The issue can be resolved by restarting Apache on the console's node with `service pe-httpd restart`. 

### Bad Data in Facter's `architecture` Fact

On AIX agents, a bug causes facter to return the system's model number (e.g., IBM 3271) instead of the processor's architecture (e.g. Power6). There is no known workaround.

### Augeas File Access Issue

On AIX agents, the Augeas lens is unable to access or modify `etc/services`. There is no known workaround.

### After Upgrading, Nodes Report a "Not a PE Agent" Error

When doing the first puppet run after upgrading using the "upgrader" script included in PE tarballs, agents are reporting an error: "&lt;node.name&gt; is not a Puppet Enterprise agent." This was caused by a bug in the upgrader that has since been fixed. If you downloaded a tarball prior to November 28, 2012, simply download the tarball again to get the fixed upgrader. If you prefer, you can download the [latest upgrader module](http://forge.puppetlabs.com/adrien/pe_upgrade/0.4.0-rc1) from the Forge. Alternatively, you can fix it by changing `/etc/puppetlabs/facter/facts.d/is_pe.txt`  to contain: `is_pe=true`.

### EC2/Dual-homed Systems Report Incorrect URIs for the Console.

During installation, the PE installer attempts to automatically determine the URI where the console can be reached. On EC2 (and likely all other dual-homed systems), the installer incorrectly selects the internal, non-routable URI. Instead, you should manually enter the correct, external facing URI of the system hosting the console.

### Answer file required for some SMTP servers.d

Any SMTP server that requires authentication, TLS, or runs over any port other than 25 needs to be explicitly added to an answers file. See the [advanced configuration page](./config_advanced.html#allowing-anonymous-console-access) for details.

### `pe-httpd` Must Be Restarted After Revoking Certificates

([Issue #8421](http://projects.puppetlabs.com/issues/8421))

Due to [an upstream bug in Apache](https://issues.apache.org/bugzilla/show_bug.cgi?id=14104), the `pe-httpd` service on the puppet master must be restarted after revoking any node's certificate.

After using `puppet cert revoke` or `puppet cert clean` to revoke a certificate, restart the service by running:

    $ sudo /etc/init.d/pe-httpd restart

### Dynamic Man Pages are Incorrectly Formatted

Man pages generated with the `puppet man` subcommand are not formatted as proper man pages, and are instead displayed as Markdown source text. This is a purely cosmetic issue, and the pages are still fully readable.

To improve the display of Puppet man pages, you can use your system `gem` command to install the `ronn` gem:

    $ sudo gem install ronn



