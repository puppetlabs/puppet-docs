---
layout: default
title: "PE 2.0 » Welcome » New Features and Release Notes"
canonical: "/pe/latest/release_notes.html"
---

* * *

&larr; [Welcome: Components and Roles](./welcome_roles.html) --- [Index](./) --- [Welcome: Known Issues](./welcome_known_issues.html) &rarr;

* * *


New Features and Release Notes
========

Puppet Enterprise 2.0
-----

2.0 was a major new release of Puppet Enterprise, which introduced the following new features:

### Live Management

PE's web console now lets you edit and command your infrastructure in real time. Visit the console's live management tab to:

* Browse resources on your nodes in real-time
* Clone resources to make a group of nodes resemble a known good node
* Trigger puppet runs on an arbitrary set of nodes
* Run advanced MCollective tasks from your browser

Live management works out of the box, without writing any Puppet code.

### Cloud Provisioning

PE 2 ships with new command-line tools for building new nodes. From the comfort of your terminal, you can create new machine instances, install PE on any node, and assign new nodes to your existing console groups.

### More Secure Console

PE's web console is now served over SSL, and requires a login for access. This lets you control access to the console without having to restrict access by host.

### Puppet 2.7

Puppet Enterprise is now built around Puppet 2.7, which made several significant improvements and changes to the Puppet core:

* Puppet can now manage network devices with the vlan, interface, and router resource types. 
* There's a new API for creating subcommands called faces, and Puppet ships with prebuilt subcommands that expose core subsystems at the command line.
* Error messages have been generally improved, including the infamous OpenSSL "Hostname was not match" error.
* Service init scripts are now assumed to have status commands; use `hasstatus => false` to emulate the behavior from 2.6 and earlier.
* Dynamically scoped variable lookup now causes warnings to be logged. If you're getting these warnings, you should begin [switching to fully qualified variable names and parameterized classes](/guides/scope_and_puppet.html) to eliminate dynamic scoping in your manifests.

See the [Puppet release notes][releasenotes] for more details.

[releasenotes]: http://projects.puppetlabs.com/projects/puppet/wiki/Release_Notes


### Other Changes

#### Dashboard is Now Console

What was Puppet Dashboard is now just "the console."

#### Changes to Orchestration Features

* Orchestration is enabled by default for all PE nodes. 
* Orchestration tasks can now be invoked directly from the console, with the "advanced tasks" section of the live management page. PE's orchestration framework also powers the other live management features.
* The `mco` user account on the puppet master is gone, in favor of a new `peadmin` user. This user can still invoke orchestration tasks across your nodes, but it will also gain more general purpose capabilities in future versions.
* PE now includes the `puppetral` plugin, which lets you use Puppet's Resource Abstraction Layer (RAL) in orchestration tasks.
* For performance reasons, the default message security scheme has changed from AES to PSK.
* The network connection over which messages are sent is now encrypted using SSL.

#### Improved and Simplified Install Experience

The installer asks fewer and smarter questions. 

#### Built-in Puppet Modules Have Been Renamed

The `mcollectivepe`, `accounts`, and `baselines` modules from PE 1.2 were renamed (to `pe_mcollective, pe_accounts,` and `pe_compliance`, respectively) to avoid namespace conflicts and make their origin more clear. The PE upgrader can install wrapper modules to preserve functionality if you used any of these modules by their previous names.


Puppet Enterprise 2.0.1
----

This is a maintenance release in the Puppet Enterprise 2.0 series.

### Fixed Breakage on Enterprise Linux 6.1 and 6.2

PE 2.0 would often fail during installation on enterprise Linux 6.1 and 6.2 systems (RHEL, CentOS, Oracle Linux, and Scientific Linux). This was due to memory corruption issues with our version of Apache and OpenSSL. The problem has been fixed, and EL > 6.0 systems can now be used as puppet masters and console servers. 

### Fixed Security Issue: XSS Vulnerability in Console (CVE-2012-0891)

The upstream Puppet Dashboard code used in PE's web console was found to be vulnerable to cross-site scripting attacks due to insufficient sanitization of user input. [See here][dashboard_xss] for more details, including hotfixes for previous versions of PE.

This vulnerability has a CVE identifier of [CVE-2012-0891][dashxss_cve]. 

[dashboard_xss]: http://puppetlabs.com/security/cve/cve-2012-0891/
[dashxss_cve]: http://cve.mitre.org/cgi-bin/cvename.cgi?name=cve-2012-0891

### Install and Upgrade Improvements

We've fixed a lot of glitches in PE's installer and upgrader, and done some things to make the experience more user-friendly. Highlights include: 

* PE now ships with an uninstaller script.
* The installer will now warn you if you attempt to install a puppet master or console server with less than the required 1GB of memory.
* More secure console and MySQL passwords can be chosen, as the installer will accept a wider array of non-alphanumeric characters. You can also use non-alphanumeric characters in database names.
* We've eliminated a possible source of file permission errors by explicitly setting the umask used by the installer. (This would occasionally cause mysterious installation failures.)
* Upgrading from PE 1.x no longer requires manual edits to `passenger-extra.conf`.
* Answer files created during installation are handled more securely, and are no longer saved as world- or group-readable. 
* Handling of remote MySQL databases for the console has been greatly improved. The installer now aborts safely if it isn't able to verify the database credentials, and fixes an issue where the inventory service couldn't use a remote DB.

### Support Script

PE now includes an information-gathering script, which can help Puppet Labs support to resolve issues faster. The script is simply called "`support`," and is in the root of the installation tarball, alongside the installer, uninstaller, and upgrader scripts. 

When it finishes running, the support script will print the location of its results, which can be sent to Puppet Labs for inspection. This may include sensitive information about your site, so we advise you to examine the collected data before sending it. 

### Updated Software Versions

We've updated the following software in the PE distribution:

* Puppet has been updated to 2.7.9 (from 2.7.6). See the [Puppet release notes][releasenotes] for more details. The major improvements include:
    * Faster recursive directory traversal
    * Types and providers can be used during the run in which they are first delivered
* Facter has been updated to 1.6.4, which fixes several Solaris issues.
* PE's web console is now built atop Puppet Dashboard 1.2.4, which fixes an issue with orphaned database records and improves navigation and accessibility. 
* Ruby has been updated to 1.8.7 patch level 357. This is due to a security vulnerability found in Ruby. (See [here](http://www.ocert.org/advisories/ocert-2011-003.html) and [here](http://www.ruby-lang.org/en/news/2011/12/28/denial-of-service-attack-was-found-for-rubys-hash-algorithm-cve-2011-4815/).)
* The Rack middleware has been updated to 1.1.3 to respond to the same security vulnerability.
* Apache has been updated to address the following security vulnerabilities: 
    * [CVE-2011-3192](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3192)
    * [CVE-2011-3348](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3348)
    * [CVE-2011-3368](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3368)
* Augeas has been updated to the latest upstream version (0.10.0) and modified to handle the correct locations of PE's config files.


### All PE Libraries Are Now Namespaced

On RPM-based systems, some of the libraries provided by PE's packages weren't being namespaced, and would cause problems when other software tried to reference system packages that provide those libraries. This has been fixed. 

### Other Changes

#### Compliance Features Now Work with Solaris Agents

A quirk in Solaris's cron implementation was preventing the compliance reporting job from running. This has been fixed. 

#### The ActiveMQ Heap Size is Now Tunable

This is an advanced feature, and should be ignored by most users. 

Use the `activemq_heap_mb` parameter to configure this, and see the internal documentation of the `pe_mcollective` module for more details. 


Puppet Enterprise 2.0.2
----

This is a regression-fix release that fixes two issues introduced in PE 2.0.1. Only Debian/Ubuntu and Enterprise Linux 4 systems are affected by this release; in all other respects, it is identical to PE 2.0.1.

### Fix Puppet Help Breakage on Debian/Ubuntu Systems

The puppet help subcommand was malfunctioning on Debian and Ubuntu systems. This problem has been fixed.

### Fix Upgrade Failures on Enterprise Linux 4 Systems

Agent nodes running RHEL 4 and CentOS 4 were unable to upgrade to PE 2.0.1 due to a packaging error. These nodes can instead upgrade to PE 2.0.2.


Puppet Enterprise 2.0.3
-----

This is a security and bug-fix release in the PE 2.0 series. It patches two security vulnerabilities and fixes a handful of inaccurate hardware facts on Linux.

### Security Fix: Group IDs Leak to Forked Processes (CVE-2012-1053)

When executing commands as a different user, Puppet was leaving the forked process with Puppet's own group permissions. Specifically: 

* Puppet's primary group (usually root) was always present in a process's supplementary groups.
* When an `exec` resource had a specified `user` attribute but not a `group` attribute, Puppet would set its effective GID to Puppet's own GID (usually root).
* Permanently changing a process's UID and GID wouldn't clear the supplementary groups, leaving the process with Puppet's own supplementary groups (usually including root).

This caused any untrusted code executed by a Puppet exec resource to be given unexpectedly high permissions. [See here][gid_release] for more details, including hotfixes for previous versions of PE.

This vulnerability has a CVE identifier of [CVE-2012-1053][gid_cve]. 

[gid_release]: http://puppetlabs.com/security/cve/cve-2012-1053/
[gid_cve]: http://cve.mitre.org/cgi-bin/cvename.cgi?name=cve-2012-1053

### Security Fix: k5login Type Writes Through Symlinks (CVE-2012-1054)

If a user's `.k5login` file was a symlink, Puppet would overwrite the link's target when managing that user's login file with the k5login resource type. This allowed local privilege escalation by linking a user's `.k5login` file to root's `.k5login` file. 

[See here][k5login_release] for more details, including hotfixes for previous versions of PE.

This vulnerability has a CVE identifier of [CVE-2012-1054][k5login_cve]. 

[k5login_release]: http://puppetlabs.com/security/cve/cve-2012-1054/
[k5login_cve]: http://cve.mitre.org/cgi-bin/cvename.cgi?name=cve-2012-1054

### Bug Fix: Inaccurate Hardware Facts

In previous versions of PE, the following facts were often inaccurate on Linux systems that lacked the pciutils/pmtools and dmidecode packages:

* `virtual`
* `is_virtual`
* `manufacturer`
* `productname`
* `serialnumber`

PE now lists the necessary packages as prerequisites for Facter, which makes these facts more reliable.

### Upgrader Improvements

The upgrader now skips unnecessary steps for upgrades from 2.0.x versions. 

### Puppet.conf is No Longer World-Readable By Default

The `/etc/puppetlabs/puppet/puppet.conf` file on the puppet master is now created with default permissions of `0600`, to improve security in cases where the puppet master is a multi-purpose server with untrusted user accounts.

### Apache Now Discards X-Forwarded-For Headers

Puppet Enterprise's Apache configuration now discards any X-Forwarded-For header from requests before passing them to Puppet. In rare configurations, Ruby and Rack's handling of this header could allow agents to impersonate each other when making unauthenticated requests. 

* * *

&larr; [Welcome: Components and Roles](./welcome_roles.html) --- [Index](./) --- [Welcome: Known Issues](./welcome_known_issues.html) &rarr;

* * *

