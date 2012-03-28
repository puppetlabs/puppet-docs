---
nav: pe25.html
layout: pe2experimental
title: "PE 2.5 » Appendix"
subtitle: 
---

Puppet Enterprise 2.5
-----
*Release Notes
*Known Issues
*Glossary


### Release Notes

Changes to Puppet (FOSS) are documented in the [Puppet Release notes](http://projects.puppetlabs.com/projects/puppet/wiki/Release_Notes#2.7.9). Relevant changes start with Puppet version 2.7.9.

####Puppet Enterprise 2.5.0
* Added support for console user access roles and authentication
* Added basic support for Windows agents
* Improved integration with the Forge and module support


### Known Issues
As we discover them, this page will be updated with known issues in each maintenance release of Puppet Enterprise 2.5. If you find new problems yourself, please file bugs in Puppet [here][puppetissues] and bugs specific to Puppet Enterprise [here][peissues]. 

To find out which of these issues you are affected by, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `2.7.12 (Puppet Enterprise 2.5.0)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](./install_upgrading.html).

[peissues]: http://projects.puppetlabs.com/projects/puppet-enterprise/issues
[puppetissues]: http://projects.puppetlabs.com/projects/puppet/issues


Issues Still Outstanding
-----

The following issues affect the currently shipped version of PE and all prior releases in the 2.x.x series, unless otherwise stated. 

### Upgrades May Fail With MySQL Errors

Some users may experience failure when upgrading to PE 2.5, and there have been reports of similar failures when running previous upgrades. These failures:

* Are limited to the console server
* Usually affect sites with a very large console database
* Are triggered by a MySQL error when running database migrations

The upgrader's output in these cases resembles the following:

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

The cause of these failures is still under investigation, but it appears to involve a too-small lock table, which is governed by the `innodb_buffer_pool_size` setting in the MySQL server configuration. 

#### Workaround

Until the upgrader can handle these cases by itself, we recommend the following:

**If you haven't yet upgraded PE on your console server:**

* Edit the MySQL config file on your database server (usually located at `/etc/my.cnf`, but your system may differ) and set the value of `innodb_buffer_pool_size` to at least `80M`. (Its default value is 8 MB, or 8388608 bytes.)

    **Example diff:**

{% highlight diff %}
 [mysqld]
 datadir=/var/lib/mysql
 socket=/var/lib/mysql/mysql.sock
 user=mysql
 # Default to using old password format for compatibility with mysql 3.x
 # clients (those using the mysqlclient10 compatibility package).
 old_passwords=1
+innodb_buffer_pool_size = 80M
 
 # Disabling symbolic-links is recommended to prevent assorted security risks;
 # to do so, uncomment this line:
 # symbolic-links=0
 
 [mysqld_safe]
 log-error=/var/log/mysqld.log
 pid-file=/var/run/mysqld/mysqld.pid
{% endhighlight %}

* Restart the MySQL server:

        # sudo /etc/init.d/mysqld restart
* Perform a normal upgrade of Puppet Enterprise on the console server.

**If you have already suffered a failed upgrade:** 

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
* Edit the MySQL config file and restart the MySQL server, as described above.
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

### Glossary
For help with vocabulary, check out the [glossary of common Puppet terms and concepts](http://projects.puppetlabs.com/projects/1/wiki/Glossary_Of_Terms) <!-- to do -->.




* * *

