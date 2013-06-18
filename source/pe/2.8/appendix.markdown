---
layout: default
title: "PE 2.8 » Appendix"
subtitle: "User's Guide Appendix"
---


This page contains additional miscellaneous information about Puppet Enterprise 2.8.

Puppet Terminology
-----

For help with Puppet-specific terms and language, visit [the glossary](/references/glossary.html)

For a complete guide to the Puppet language, visit [the reference manual](/puppet/2.8/reference/)

Release Notes
-----

### Puppet 2.8.2 (6/18/2013)

#### Security Fix

*[CVE-2013-3567 Unauthenticated Remote Code Execution Vulnerability](http://puppetlabs.com/security/cve/cve-2013-3567/).*

A critical vulnerability was found in puppet wherein it was possible for the puppet master to take YAML from an untrusted client via the REST API. This YAML could be deserialized to construct an object containing arbitrary code.

### PE 2.8.1 (4/17/2013)

#### Open-Source Agents Bug Fix
A bug in 2.8.0 prevented the pe_mcollective module from working correctly when running open-source agents with a PE master. This has been fixed. For more information, see [issue 19230](http://projects.puppetlabs.com/issues/19230).

#### Stomp/MCollective Bug Fix
A bug in 2.8.0 related to the Stomp component upgrade prevented Live Management and MCollective filters from functioning. A [hotfix](https://puppetlabs.com/puppet-enterprise-hotfixes-2-8-0/) was released and the issue has been fixed in PE 2.8.1.

#### Spaces Now Allowed in Passwords
Previously, spaces could not be used in console passwords. This has been changed and spaces are now accepted.

#### Red Hat Installation on Amazon AMI Bug Fix
A bug in 2.8.0 caused the installer to reject Amazon Linux AMIs when the `redhat-lsb` package is installed. This issue has been fixed in 2.8.1. For details see [issue 19963](https://projects.puppetlabs.com/issues/19963).


### PE 2.8.0 (3/26/2013)

#### AIX Support
2.8.0 adds support for the AIX operating system. Only puppet agents are supported; you cannot run a master, console, or other component on an AIX node. Support for three AIX package providers, NIM, RPM and BFF, is also added. Note that while AIX supports two modes for package installation, "install" (for test runs) and "committed" (for actual installation), the PE AIX implementation only supports "committed" mode.

#### Updated Modules
The following modules have been updated to newer versions as indicated:

* Puppet 2.7.19 updated to 2.7.21. Provides performance improvements and bug fixes.
* Facter 1.6.10 updated to 1.6.17. Provides bug fixes.
* Hiera 0.3.0 updated to 1.1.2. Provides support for merging arrays and hashes across back-ends, bug fixes.
* Hiera-Puppet 0.3.0 updated to 1.0.0. Provides bug fixes.
* Stomp 1.1.9 updated to 1.2.3. Provides performance improvements and bug fixes.

#### Security Fix

*[CVE-2013-2716 CAS Client Config Vulnerability](http://puppetlabs.com/security/cve/cve-2013-2716/).*
A vulnerability can be introduced when upgrading PE versions 2.5.0 through 2.7.2 from PE versions 1.2.x or 2.0.x. In such cases, the CAS client config file, `/etc/puppetlabs/console-auth/cas_client_config.yml`, is installed without a randomized secret.  Consequently, an attacker could craft a cookie that would be inappropriately authorized by the console.

This issue has been resolved in PE 2.8.0. Users running older affected versions can resolve the issue by running `/opt/puppet/bin/rake -f /opt/puppet/share/console-auth/Rakefile console:auth:generate_secret`

Known Issues
-----

As we discover them, this page will be updated with known issues in Puppet Enterprise 2.8.x. Fixed issues will be removed from this list and noted above in the release notes. If you find new problems yourself, please file bugs in Puppet [here][puppetissues] and bugs specific to Puppet Enterprise [here][peissues].

To find out which of these issues may affect you, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `2.7.21 (Puppet Enterprise 2.8.1)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](./install_upgrading.html).

[peissues]: http://projects.puppetlabs.com/projects/puppet-enterprise/issues
[puppetissues]: http://projects.puppetlabs.com/projects/puppet/issues


The following issues affect the currently shipped version of PE and all prior releases in the 2.x.x series, unless otherwise stated.

### PE 2.8.0 Only: Broken Live Management and MCollective

A packaging bug in the initial PE 2.8.0 release prevented the console’s live management feature from functioning. This issue also prevents MCollective from using filters.

This issue was fixed in PE 2.8.1. Anyone running 2.8.0 is strongly encouraged to upgrade.

### Bad Data in Facter's `architecture` Fact

On AIX agents, a bug causes facter to return the system's model number (e.g., IBM 3271) instead of the processor's architecture (e.g. Power6). There is no known workaround.

### Augeas File Access Issue

On AIX agents, the Augeas lens is unable to access or modify `etc/services`. There is no known workaround.

### After Upgrading, Nodes Report a "Not a PE Agent" Error

When doing the first puppet run after upgrading using the "upgrader" script included in PE tarballs, agents are reporting an error: "&lt;node.name&gt; is not a Puppet Enterprise agent." This was caused by a bug in the upgrader that has since been fixed. If you downloaded a tarball prior to November 28, 2012, simply download the tarball again to get the fixed upgrader. If you prefer, you can download the [latest upgrader module](http://forge.puppetlabs.com/adrien/pe_upgrade/0.4.0-rc1) from the Forge. Alternatively, you can fix it by changing `/etc/puppetlabs/facter/facts.d/is_pe.txt`  to contain: `is_pe=true`.

### Issues with Compliance UI

There are two issues related to incorrect Compliance UI behavior:

*     Rejecting a difference by clicking (-) results in an erroneous display (Google Chrome only).
*     The user account pull-down menu in the top level compliance tab ceases to function after a host report has been selected.

### EC2/Dual-homed Systems Report Incorrect URIs for the Console.

During installation, the PE installer attempts to automatically determine the URI where the console can be reached. On EC2 (and likely all other dual-homed systems), the installer incorrectly selects the internal, non-routable URI. Instead, you should manually enter the correct, external facing URI of the system hosting the console.

### Answer file required for some SMTP servers.

Any SMTP server that requires authentication, TLS, or runs over any port other than 25 needs to be explicitly added to an answers file. See the [advanced configuration page](http://docs.puppetlabs.com/pe/2.8/config_advanced.html#allowing-anonymous-console-access) for details.

### Upgrading the Console Server Requires an Increased MySQL Buffer Pool Size

An inadequate default MySQL buffer pool size setting can interfere with upgrades to Puppet Enterprise console servers.

**The PE 2.8 upgrader will check for this bad setting.** If you are affected, it will warn you and give you a chance to abort the upgrade.

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



