---
layout: default
title: "PE 2.5 » Appendix"
subtitle: "User's Guide Appendix"
canonical: "/pe/latest/release_notes.html"
---


This document contains additional miscellaneous information about Puppet Enterprise 2.5.

Glossary
-----

For help with Puppet specific terms and language, visit [the glossary](/references/glossary.html)

Release Notes
-----

Changes to Puppet's core are documented in the [Puppet Release notes](/puppet/2.7/reference/release_notes.html#puppet-2710). The changes for Puppet versions 2.7.10, 2.7.11, and 2.7.12 cover the difference between Puppet Enterprise 2.0.3 and Puppet Enterprise 2.5.0.


### Puppet Enterprise 2.5.3

2.5.3 is a maintenance release, which fixes several outstanding bugs.

#### Bug Fix: Incomplete Upstart Support on Ubuntu

([Issue 15553](https://projects.puppetlabs.com/issues/15553))

This issue, introduced in PE 2.5.2, could cause failures on Ubuntu due to a patch error in our packages, which caused the Upstart service provider to break.

#### Bug Fix: Solaris Uninstaller

On Solaris, the uninstaller would print a bash error regarding integer comparison. This has been fixed.

#### Bug Fix: MCollective Upgrade Failures on Debian-based Systems

Upgrades on Debian-based systems were failing due to the MCollective service not being properly stopped.

#### Update: PE Cloud Provisioner Module to Version 1.0.5

This update includes changes to apt repos, in response to the removal of some redirects on apt.puppetlabs.com.

### Puppet Enterprise 2.5.2

2.5.2 is a maintenance and update release. It adds support for new platforms and browsers as well as fixing some bugs and updating some components.

#### Update: ActiveMQ Can Now Use a Thread Pool

By default, ActiveMQ uses a dedicated thread for each destination. If there are a large number of destinations, this can cause issues with memory usage. A thread pool makes memory usage more efficient. ActiveMQ can be configured to use a thread pool through the use of the system property: `-Dorg.apache.activemq.UseDedicatedTaskRunner=false.` The property is specified in the activemq start script via ACTIVEMQ_OPTS.

#### Update: New Installer Behavior for Database Setup

The Puppet Enterprise installer will now check for an installation of MySQL. If found, the installer will prompt for information about contacting the MySQL server (whether it is remote or local). If no instance of MySQL is found, the installer will offer to install and configure MySQL and a new a database. See the [Installing Puppet Enterprise](/pe/2.5/install_basic.html) page for complete information.

#### Update: Support Added for New Platforms and Browsers.

Puppet Enterprise now supports Ubuntu Precise and SLES 11 SP2. In addition, the console now works correctly in IE8. 

#### Update: New Version of ActiveMQ

ActiveMQ has been updated from 5.5.0 to 5.6.0.

#### Patches to Puppet

Several patches from upstream Puppet releases have been backported to 2.7.12 for this release:

* A fix for a rebooting issue with SLES and the "puppet resource service" command
* A patch that improves performance for large numbers of modules
* A patch adding upstart support for Ubuntu 12.04 Precise

#### Security Fixes

This release includes fixes for the following security issues, which were discovered in internal and external audits initiated by Puppet Labs:

* [CVE-2012-3864 – Arbitrary File Read](http://puppetlabs.com/security/cve/cve-2012-3864/)
* [CVE-2012-3865 – Arbitrary file delete/D.O.S on Puppet Master](http://puppetlabs.com/security/cve/cve-2012-3865/)
* [CVE-2012-3866 – `last_run_report.yaml` is World-Readable](http://puppetlabs.com/security/cve/cve-2012-3866/)
* [CVE-2012-3867 – Insufficient Input Validation](http://puppetlabs.com/security/cve/cve-2012-3867/)
* [CVE-2012-3408 – Agent Impersonation](http://puppetlabs.com/security/cve/cve-2012-3408/)



### Puppet Enterprise 2.5.1

2.5.1 was a security fix release. It also fixes a handful of minor bugs.

#### Bug Fix: Upgrading from 2.0 on Debian/Ubuntu Systems  Set external_node Permissions Incorrectly

Users upgrading from 2.0.x to 2.5.0  experienced "Permission Denied" errors when attempting catalog runs that execute the external\_node script. The problem was that the external\_node file permissions were being set incorrectly to 640. Consequently, users had to manually set the permissions to 755. This has been fixed and permissions should now be set correctly during upgrade.

#### Bug Fix: Hiera does not get uninstalled on Solaris nodes

Running a normal uninstall on PE 2.5.0 systems running Solaris failed to remove Hiera. Users needed to delete Hiera manually. This has been fixed and Hiera should now be removed as expected.

#### Bug Fix: Allowing Anonymous Console Access

Setting up anonymous access to the console now works as documented, by editing config.yml so as to set `global_unauthenticated_access: true`. See the [advanced configuration page](/pe/2.5/config_advanced.html#allowing-anonymous-console-access) for details.

#### Bug Fix: Custom modules can cause upgrade failures

Custom modules erroneously placed in `/opt/puppet/share/puppet/modules` will no longer cause an upgrade to fail. However, for a number of reasons, custom modules should still be placed in the documented directory: `/etc/puppetlabs/puppet/modules`.

#### Security Fix: Arbitrary File Read Access

([CVE-2012-1986][])

When issuing a REST request for a file from a remote filebucket, it was possible to override the puppet master’s defined location for filebucket storage. A user with an authorized SSL key and the ability to construct directories and symlinks on the puppet master could thus read any file that the puppet master’s user account had access to.

#### Security Fix: Arbitrary Code Execution (OS X)

([CVE-2012-1906][])

> Note: This issue is not relevant on PE-supported systems, but will affect users who have connected OS X systems to a PE puppet master. If your deployment includes OS X agent nodes running an open-source release of Puppet, you must update them to Puppet 2.7.13 to patch this vulnerability.

When installing Mac OS X packages from a remote source, Puppet used a predictable filename in /tmp to store the package. Using a symlink at that filename, it was possible to either overwrite arbitrary files on the system or to install an arbitrary package. (Note that OS X package installers can also execute arbitrary code.)

#### Security Fix: Denial of Service

([CVE-2012-1987][])

This vulnerability could present itself in two ways:

* Using the symlink vulnerability described in CVE-2012-1986, the puppet master could be caused to read from a stream (e.g. /dev/random) when trying to read or write a file. Due to the way Puppet sends files via REST requests, the thread handling the request would block forever, reading from the stream and continually consuming more memory. This could lead to the puppet master system running out of memory, causing a denial of service. In order to do this, the attacker needed access to agent SSL keys and the ability to create directories and symlinks on the puppet master system.
* By constructing a marshaled form of a Puppet::FileBucket::File object, a user could craft a REST request that would cause it it to be written to any place on the puppet master’s filesystem. This could cause a denial of service on the puppet master if an attacker filled a filesystem. In order to do this, the attacker only needed access to agent SSL keys, and did not require access to the puppet master system.

#### Security Fix: Arbitrary Code Execution

([CVE-2012-1988][])

If a file whose full path contained an executable command string was created on the puppet master system, it was possible to cause Puppet to execute the embedded command by crafting a malicious file bucket request. This required access to agent SSL keys and the ability to create directories and files on the puppet master system.

#### Security Fix: Arbitrary File Write Access

([CVE-2012-1989][])

The telnet connection type for managing network devices opened a NET::Telnet connection whose output log was written to a predictable location (/tmp/out.log). That log could be replaced by a symlink to an arbitrary location, potentially overwriting files.

[cve-2012-1986]: http://puppetlabs.com/security/cve/cve-2012-1986/
[cve-2012-1906]: http://puppetlabs.com/security/cve/cve-2012-1906/
[cve-2012-1987]: http://puppetlabs.com/security/cve/cve-2012-1987/
[cve-2012-1988]: http://puppetlabs.com/security/cve/cve-2012-1988/
[cve-2012-1989]: http://puppetlabs.com/security/cve/cve-2012-1989/


### Puppet Enterprise 2.5.0

2.5.0 was a major feature release.

* Added support for console user access roles and authentication
* Added basic support for Windows agents
* Improved integration with the Forge and module support


Known Issues
-----

As we discover them, this page will be updated with known issues in Puppet Enterprise 2.5.x. Fixed issues will be removed from this list and noted above in the release notes. If you find new problems yourself, please file bugs in Puppet [here][puppetissues] and bugs specific to Puppet Enterprise [here][peissues]. 

To find out which of these issues you are affected by, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `2.7.12 (Puppet Enterprise 2.5.0)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](./install_upgrading.html).

[peissues]: https://tickets.puppetlabs.com/secure/CreateIssue!default.jspa
[puppetissues]: https://tickets.puppetlabs.com/secure/CreateIssue!default.jspa


The following issues affect the currently shipped version of PE and all prior releases in the 2.x.x series, unless otherwise stated. 

### Issues with Compliance UI

There are two issues related to incorrect Compliance UI behavior: 

*     Rejecting a difference by clicking (-) results in an erroneous display. (Google Chrome only; fix is tentatively targeted for PE 2.6.)
*     The user account pull-down menu in the top level compliance tab ceases to function after a host report has been selected.

### EC2/Dual-homed Systems Report Incorrect URIs for the Console.

During installation, the PE installer attempts to automatically determine the URI where the console can be reached. On EC2 (and likely all other dual-homed systems), the installer incorrectly selects the internal, non-routable URI. Instead, you should manually enter the correct, external facing URI of the system hosting the console.

### Answer file required for some SMTP servers.

Any SMTP server that requires authentication, TLS, or runs over any port other than 25 needs to be explicitly added to an answers file. See the [advanced configuration page](/pe/2.5/config_advanced.html#allowing-anonymous-console-access) for details.

### Logging for Parts of the Console Non-Functional

The Rack::Cas::Client class does not log any data. (Note that the RubyCAS-client tool does log correctly.) There is no known workaround. The issue is under investigation.

### Upgrading the Console Server Requires an Increased MySQL Buffer Pool Size

An inadequate default MySQL buffer pool size setting can interfere with upgrades to Puppet Enterprise console servers.

**The PE 2.5 upgrader will check for this bad setting.** If you are affected, it will warn you and give you a chance to abort the upgrade. 

If you see this warning, you should:

* Abort the upgrade.
* [Follow these instructions](./config_advanced.html#increasing-the-mysql-buffer-pool-size) to increase the value of the `innodb_buffer_pool_size` setting.
* Re-run the upgrade.

If you have attempted to upgrade your console server without following these instructions, it is possible for the upgrade to fail. The upgrader's output in these cases resembles the following:

    (in /opt/puppet/share/puppet-dashboard) 
    == AddReportForeignKeyConstraints: migrating ================================= 
    Going to delete orphaned records from metrics, report_logs, resource_statuses, resource_events 
    Preparing to delete from metrics 
    2012-01-27 17:51:31: Deleting 0 orphaned records from metrics 
    Deleting 100% |###################################################################| Time: 00:00:00
    Preparing to delete from report_logs 
    2012-01-27 17:51:31: Deleting 0 orphaned records from report_logs 
    Deleting 100% |###################################################################| Time: 00:00:00
    Preparing to delete from resource_statuses 
    2012-01-27 17:51:31: Deleting 0 orphaned records from resource_statuses 
    Deleting 100% |###################################################################| Time: 00:00:00
    Preparing to delete from resource_events 
    2012-01-27 17:51:31: Deleting 0 orphaned records from resource_events 
    Deleting 100% |###################################################################| Time: 00:00:00
    -- execute("ALTER TABLE reports ADD CONSTRAINT fk_reports_node_id FOREIGN KEY (node_id) REFERENCES nodes(id) ON DELETE CASCADE;") 
    rake aborted! 
    An error has occurred, all later migrations canceled:
    Mysql::Error: Can't create table 'console.#sql-328_ff6' (errno: 121): ALTER TABLE reports ADD CONSTRAINT fk_reports_node_id FOREIGN KEY (node_id) REFERENCES nodes(id) ON DELETE CASCADE;
    (See full trace by running task with --trace)
    ===================================================================================
    !! ERROR: Cancelling installation
    ===================================================================================

If you have suffered a failed upgrade, you can fix it by doing the following:

* On your database server, log into the MySQL client as either the root user or the console user:

        # mysql -u console -p
        Enter password: <password>
* Execute the following SQL statements:

        USE console 
        ALTER TABLE reports DROP FOREIGN KEY fk_reports_node_id; 
        ALTER TABLE resource_events DROP FOREIGN KEY fk_resource_events_resource_status_id; 
        ALTER TABLE resource_statuses DROP FOREIGN KEY fk_resource_statuses_report_id; 
        ALTER TABLE report_logs DROP FOREIGN KEY fk_report_logs_report_id; 
        ALTER TABLE metrics DROP FOREIGN KEY fk_metrics_report_id;
* [Follow the instructions for increasing the `innodb_buffer_pool_size`](./config_advanced.html#increasing-the-mysql-buffer-pool-size) and restart the MySQL server.
* Re-run the upgrader, which should now finish successfully. 

For more information about the lock table size, [see this MySQL bug report](http://bugs.mysql.com/bug.php?id=15667).

### `pe-httpd` Must Be Restarted After Revoking Certificates

([Issue #8421](http://projects.puppetlabs.com/issues/8421))

Due to [an upstream bug in Apache](https://issues.apache.org/bugzilla/show_bug.cgi?id=14104), the `pe-httpd` service on the puppet master must be restarted after revoking any node's certificate.

After using `puppet cert revoke` or `puppet cert clean` to revoke a certificate, restart the service by running:

    $ sudo /etc/init.d/pe-httpd restart
    
    ### Internet Explorer 8 Can't Access Live Management Features

The console's [live management](./console_live.html) page doesn't load in Internet Explorer 8. Although we are working on supporting IE8, you should currently use another browser (such as Internet Explorer 9 or Google Chrome) to access PE's live management features. 

### Dynamic Man Pages are Incorrectly Formatted

Man pages generated with the `puppet man` subcommand are not formatted as proper man pages, and are instead displayed as Markdown source text. This is a purely cosmetic issue, and the pages are still fully readable. 

To improve the display of Puppet man pages, you can use your system `gem` command to install the `ronn` gem:

    $ sudo gem install ronn



