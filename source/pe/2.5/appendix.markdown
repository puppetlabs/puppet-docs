---
nav: pe25.html
layout: pe2experimental
title: "PE 2.5 » Appendix"
subtitle: "User's Guide Appendix"
---


This document contains additional miscellaneous information about Puppet Enterprise 2.5.


Release Notes
-----

Changes to Puppet's core are documented in the [Puppet Release notes](http://projects.puppetlabs.com/projects/puppet/wiki/Release_Notes#2.7.10). The changes for Puppet versions 2.7.10, 2.7.11, and 2.7.12 cover the difference between Puppet Enterprise 2.0.3 and Puppet Enterprise 2.5.0.

### Puppet Enterprise 2.5.0

* Added support for console user access roles and authentication
* Added basic support for Windows agents
* Improved integration with the Forge and module support


Known Issues
-----

As we discover them, this page will be updated with known issues in each maintenance release of Puppet Enterprise 2.5. If you find new problems yourself, please file bugs in Puppet [here][puppetissues] and bugs specific to Puppet Enterprise [here][peissues]. 

To find out which of these issues you are affected by, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `2.7.12 (Puppet Enterprise 2.5.0)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](./install_upgrading.html).

[peissues]: http://projects.puppetlabs.com/projects/puppet-enterprise/issues
[puppetissues]: http://projects.puppetlabs.com/projects/puppet/issues


The following issues affect the currently shipped version of PE and all prior releases in the 2.x.x series, unless otherwise stated. 

### Upgrading the Console Server Requires an Increased MySQL Buffer Pool Size

An inadequate default MySQL server setting can interfere with upgrades to Puppet Enterprise console servers.

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

    # sudo /etc/init.d/pe-httpd restart
    
    ### Internet Explorer 8 Can't Access Live Management Features

The console's [live management](./console_live.html) page doesn't load in Internet Explorer 8. Although we are working on supporting IE8, you should currently use another browser (such as Internet Explorer 9 or Google Chrome) to access PE's live management features. 

### Dynamic Man Pages are Incorrectly Formatted

Man pages generated with the `puppet man` subcommand are not formatted as proper man pages, and are instead displayed as Markdown source text. This is a purely cosmetic issue, and the pages are still fully readable. 

To improve the display of Puppet man pages, you can use your system `gem` command to install the `ronn` gem:

    # sudo gem install ronn



