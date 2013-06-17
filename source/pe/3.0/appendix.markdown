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


Known Issues
-----

As we discover them, this page will be updated with known issues in Puppet Enterprise 2.8.x. Fixed issues will be removed from this list and noted above in the release notes. If you find new problems yourself, please file bugs in Puppet [here][puppetissues] and bugs specific to Puppet Enterprise [here][peissues].

To find out which of these issues may affect you, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `3.2.2 (Puppet Enterprise 3.0)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](./install_upgrading.html).

[peissues]: http://projects.puppetlabs.com/projects/puppet-enterprise/issues
[puppetissues]: http://projects.puppetlabs.com/projects/puppet/issues


The following issues affect the currently shipped version of PE and all prior releases in the 2.x.x series, unless otherwise stated.

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

### Upgrading the Console Server Requires an Increased MySQL Buffer Pool Size

An inadequate default MySQL buffer pool size setting can interfere with upgrades to Puppet Enterprise console servers.

**The PE 2.8 upgrader will check for this bad setting.** If you are affected, it will warn you and give you a chance to abort the upgrade.

TODO this shouldn't be around anymore.

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



