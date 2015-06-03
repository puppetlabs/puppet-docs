---
layout: default
title: "PE 2.0 » Welcome » Known Issues"
canonical: "/pe/latest/release_notes.html"
---

{% capture security_info %}Detailed info about security issues lives at <http://puppetlabs.com/security>, and security hotfixes for supported versions of PE are always available at <http://puppetlabs.com/security/hotfixes>. For security notifications by email, make sure you're on the [PE-Users](http://groups.google.com/group/puppet-users) mailing list.{% endcapture %}

* * *

&larr; [Welcome: New Features and Release Notes](./welcome_whats_new.html) --- [Index](./) --- [Welcome: Getting Support](./welcome_getting_support.html) &rarr;

* * *

Known Issues in Puppet Enterprise 2.0
=====

As we discover them, this page will be updated with known issues in each maintenance release of Puppet Enterprise 2.0. If you find new problems yourself, please file bugs in Puppet [here][puppetissues] and bugs specific to Puppet Enterprise [here][peissues]. 

To find out which of these issues you are affected by, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `2.7.9 (Puppet Enterprise 2.0.1)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](./install_upgrading.html).

[peissues]: https://tickets.puppetlabs.com/secure/CreateIssue!default.jspa
[puppetissues]: https://tickets.puppetlabs.com/secure/CreateIssue!default.jspa


Issues Still Outstanding
-----

The following issues affect the currently shipped version of PE and all prior releases in the 2.0.x series, unless otherwise stated. 

### Upgrades May Fail With MySQL Errors

Several users have encountered failures when upgrading to PE 2.0.3, and there have been reports of similar failures when running previous upgrades. These failures:

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

~~~ diff
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
~~~

* Restart the MySQL server:

        $ sudo /etc/init.d/mysqld restart
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

### On Linode/Xen Instances, Facter Always Prints Error Messages

([Issue #12813](https://projects.puppetlabs.com/issues/12813))

This issue was introduced in PE 2.0.3. 

On Linode instances, and possibly other Xen platforms, Facter prints the following harmless but annoying messages to STDERR every time Puppet runs:

    pcilib: Cannot open /proc/bus/pci
    lspci: Cannot find any working access method.

This will be fixed in the next patch release of PE 2.0. For now, the noise can be suppressed by directly patching the `/opt/puppet/lib/ruby/site_ruby/1.8/facter/virtual.rb` file, as shown below:

~~~ diff
diff --git lib/facter/virtual.rb lib/facter/virtual.rb
index e617359..94b10c5 100644
--- /opt/puppet/lib/ruby/site_ruby/1.8/facter/virtual.rb
+++ /opt/puppet/lib/ruby/site_ruby/1.8/facter/virtual.rb
@@ -89,7 +89,7 @@ Facter.add("virtual") do
     end
 
     if result == "physical"
-      output = Facter::Util::Resolution.exec('lspci')
+      output = Facter::Util::Resolution.exec('lspci 2>/dev/null')
       if not output.nil?
         output.each_line do |p|
           # --- look for the vmware video card to determine if it is virtual => vmware.
~~~

### `pe-httpd` Must Be Restarted After Revoking Certificates

([Issue #8421](http://projects.puppetlabs.com/issues/8421))

Due to [an upstream bug in Apache](https://issues.apache.org/bugzilla/show_bug.cgi?id=14104), the `pe-httpd` service on the puppet master must be restarted after revoking any node's certificate.

After using `puppet cert revoke` or `puppet cert clean` to revoke a certificate, restart the service by running:

    $ sudo /etc/init.d/pe-httpd restart

### Installer Cannot Prevent or Recover From DNS Errors

The installer in PE 2.0 does not currently check for DNS misconfiguration. Such problems can cause the installer to fail, leaving the PE software in an undefined state. To work around this, you should:

* Be sure to read this guide's [Preparing to Install chapter](./install_preparing.html) before installing, and make sure DNS at your site is configured appropriately.
* If the installer has failed, follow [the instructions in the troubleshooting section of this guide][failed_install].

[failed_install]: ./maint_common_config_errors.html#how-do-i-recover-from-a-failed-install

### Internet Explorer 8 Can't Access Live Management Features

The console's [live management](./console_live.html) page doesn't load in Internet Explorer 8. Although we are working on supporting IE8, you should currently use another browser (such as Internet Explorer 9 or Google Chrome) to access PE's live management features. 

### Dynamic Man Pages are Incorrectly Formatted

Man pages generated with the `puppet man` subcommand are not formatted as proper man pages, and are instead displayed as Markdown source text. This is a purely cosmetic issue, and the pages are still fully readable. 

Issues Affecting PE 2.0.2
-----

### Incorrect Hardware Facts

This issue was fixed in PE 2.0.3.

On Linux systems where the pciutils, pmtools, or dmidecode packages are not installed, the `virtual`, `is_virtual`, `manufacturer`, `productname`, and `serialnumber` facts are frequently inaccurate. In PE 2.0.3 and later, these facts are kept accurate by requiring the necessary packages from the OS's repository. 

### Security Issue: Group IDs Leak to Forked Processes (CVE-2012-1053)

This issue was fixed in PE 2.0.3. It affected PE versions between 1.0 and 2.0.2.

When executing commands as a different user, Puppet leaves the forked process with Puppet's own group permissions. Specifically: 

* Puppet's primary group (usually root) is always present in a process's supplementary groups.
* When an `exec` resource has a specified `user` attribute but not a `group` attribute, Puppet will set its effective GID to Puppet's own GID (usually root).
* Permanently changing a process's UID and GID won't clear the supplementary groups, leaving the process with Puppet's own supplementary groups (usually including root).

This causes any untrusted code executed by a Puppet exec resource to be given unexpectedly high permissions. [See here][gid_release] for more details, including hotfixes for previous versions of PE.

This vulnerability has a CVE identifier of [CVE-2012-1053][gid_cve]. 

[gid_release]: http://puppetlabs.com/security/cve/cve-2012-1053/
[gid_cve]: http://cve.mitre.org/cgi-bin/cvename.cgi?name=cve-2012-1053

### Security Issue: k5login Type Writes Through Symlinks (CVE-2012-1054)

This issue was fixed in PE 2.0.3. It affected PE versions between 1.0 and 2.0.2.

If a user's `.k5login` file is a symlink, Puppet will overwrite the link's target when managing that user's login file with the k5login resource type. This allows local privilege escalation by linking a user's `.k5login` file to root's `.k5login` file. 

[See here][k5login_release] for more details, including hotfixes for previous versions of PE.

This vulnerability has a CVE identifier of [CVE-2012-1054][k5login_cve]. 

[k5login_release]: http://puppetlabs.com/security/cve/cve-2012-1054/
[k5login_cve]: http://cve.mitre.org/cgi-bin/cvename.cgi?name=cve-2012-1054

### Security Issue: Puppet.conf on Puppet Master is World-Readable

This issue was fixed in PE 2.0.3.

The `/etc/puppetlabs/puppet/puppet.conf` file on the puppet master is world-readable by default (permissions mode `0644`), which can expose the console's database password to unauthorized users.

### Security Issue: X-Forwarded-For Headers Are Respected for Unauthenticated Requests

This issue was fixed in PE 2.0.3. It affected PE versions between 1.0 and 2.0.2.

By default, Puppet's unauthenticated services (certificate requests, fetching the CA certificate...) are not restricted by hostname, but `auth.conf` makes it possible to open extra services to unauthenticated connections and restrict those connections by hostname. If the puppet master were configured like this, it would be possible for nodes to impersonate other nodes simply by modifying the X-Forwarded-For header in their request.

This rare possibility was removed in PE 2.0.3 by changing the Apache configuration to discard any X-Forwarded-For headers from requests before passing them to Puppet.

### Uninstaller Cannot Remove Databases if MySQL's Root Password Has Special Characters

This issue was fixed in PE 2.0.3.

If your database server's root password contains certain non-alphanumeric characters, the uninstaller may not be able to log in and delete PE's databases, and you will have to remove them manually. This issue was present when the uninstaller was introduced in PE 2.0.1.

Issues Affecting PE 2.0.1
-----

### EL 4 Agent Nodes Cannot Upgrade from 2.0.0 to 2.0.1

This issue was fixed in PE 2.0.2.

Due to a packaging error, Enterprise Linux 4 agent nodes running PE 2.0.0 cannot be upgraded to PE 2.0.1.

### Puppet Help Broken on Debian/Ubuntu Systems

This issue was fixed in PE 2.0.2.

Due to a packaging error, the puppet help subcommand malfunctions on Debian and Ubuntu systems, resulting in errors like the following:

    puppet help cert list
    err: RubyGem version error: excon(0.6.5 not ~> 0.7.3)
    
    err: Try 'puppet help help help' for usage


Issues Affecting PE 2.0.0
-----

### Puppet Master and Console Roles Break Under EL 6.1 and 6.2

This issue was fixed in PE 2.0.1.

The versions of Apache and OpenSSL used in PE 2.0.0 suffer from memory corruption under any enterprise Linux 6 system (RHEL, CentOS, Oracle Linux, and Scientific Linux) later than version 6.0. This would cause dramatic failures during installation on these OS versions. 

### Ruby 1.8.7 Patchlevel 302 is Vulnerable to a Denial of Service Attack

This issue was fixed in PE 2.0.1 by upgrading Ruby and Rack.

The version of Ruby used by PE 2.0.0 is vulnerable to a denial of service attack via a predictable hashbucket algorithm. See [here](http://www.ocert.org/advisories/ocert-2011-003.html) and [here](http://www.ruby-lang.org/en/news/2011/12/28/denial-of-service-attack-was-found-for-rubys-hash-algorithm-cve-2011-4815/) for more details.

### Apache Contains Several Security Vulnerabilities

Apache was upgraded to address these issues in PE 2.0.1.

The version of Apache used by PE 2.0.0 is vulnerable to the following CVE issues:

* [CVE-2011-3192](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3192)
* [CVE-2011-3348](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3348)
* [CVE-2011-3368](http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-3368)

### Security Issue: XSS Vulnerability in Puppet Dashboard (CVE-2012-0891)

This issue was fixed in PE 2.0.1.

The upstream Puppet Dashboard code used in PE's web console was found to be vulnerable to cross-site scripting attacks due to insufficient sanitization of user input. [See here][dashboard_xss] for more details, including hotfixes for previous versions of PE.

This vulnerability has a CVE identifier of [CVE-2012-0891][dashxss_cve]. 

[dashboard_xss]: http://puppetlabs.com/security/cve/cve-2012-0891/
[dashxss_cve]: http://cve.mitre.org/cgi-bin/cvename.cgi?name=cve-2012-0891

### Installer Cannot Detect or Recover From a Misconfigured Firewall

This issue was fixed in PE 2.0.1, which will detect and warn of firewall misconfigurations. 

The installer in PE 2.0.0 may fail and leave the PE software in an undefined state if your firewall doesn't allow access to the [required ports](./install_preparing.html#firewall-configuration). If your installation fails due to firewall issues, you should follow [the instructions in the troubleshooting section of this guide][failed_install].

### Console's `reports:prune` Task Leaves Orphaned Data

This issue was fixed in PE 2.0.1, and the upgrade process will delete any orphaned data that remains in your console database without requiring any additional user action.

The console's historical node reports can be deleted periodically to control disk usage; this is usually done by [creating a cron job for the `reports:prune` rake task](./maint_maintaining_console.html#cleaning-old-reports). However, in PE 2.0.0, this task [leaves behind orphaned records in the database][resource_statuses]. 

If you aren't at risk of running out of disk space, simply upgrade to Puppet Enterprise 2.0.1 or later at your leisure. 

If you _are_ about to run out of disk, and cannot immediately upgrade PE on your console server, you can:

* Download [this updated rake fragment][updated_task].
* Put it in `/opt/puppet/share/puppet-dashboard/lib/tasks/` on your console server, replacing the existing `prune_reports.rake` file.
* Run the following command on your console server:

        $ sudo /opt/puppet/bin/rake \
        -f /opt/puppet/share/puppet-dashboard/Rakefile \
        RAILS_ENV=production \
        reports:prune:orphaned

    This task will have to be run after every time you run the `reports:prune` task, until you are able to upgrade to an unaffected version of Puppet Enterprise. 

[updated_task]: https://raw.github.com/puppetlabs/puppet-dashboard/3652aca542671059cdb88e1408efff64cc3cb878/lib/tasks/prune_reports.rake
[resource_statuses]: http://projects.puppetlabs.com/issues/6717

### Answer Files Created During Installation are Saved as World-Readable

This issue was fixed in PE 2.0.1.

Answer files created when installing PE 2.0.0 are saved as world- and group-readable. These files may contain sensitive information, and should be either deleted or given more restrictive permissions.

### The Uninstaller Script is Not Shipped With PE

This issue was fixed in PE 2.0.1, which includes the uninstaller. 

[uninstaller]: ./files/puppet-enterprise-uninstaller

The Puppet Enterprise uninstaller script was not included with PE 2.0. Although it is included in subsequent PE releases, you can [download it here][uninstaller]. 

Before you can use it, you must move the uninstaller script into the directory which contains the installer script. The uninstaller and the installer _must_ be in the same directory. Once it is in place, you can make the uninstaller executable and run it:

    $ sudo chmod +x puppet-enterprise-uninstaller
    $ sudo ./puppet-enterprise-uninstaller

### When Upgrading, `passenger-extra.conf` Requires Manual Edits

This issue was fixed in PE 2.0.1, and the upgrader script now automatically tunes the `passenger-extra.conf` file.

Upgrading to PE 2.0.0 requires you to edit the `/etc/puppetlabs/httpd/conf.d/passenger-extra.conf` file, **on both the puppet master and the console server,** so that it looks like this:

    # /etc/puppetlabs/httpd/conf.d/passenger-extra.conf
    PassengerHighPerformance on
    PassengerUseGlobalQueue on
    PassengerMaxRequests 40
    PassengerPoolIdleTime 15
    PassengerMaxPoolSize 8
    PassengerMaxInstancesPerApp 4

Some of these settings can be tuned:

* `PassengerMaxPoolSize` should be four times the number of CPU cores in the server.
* `PassengerMaxInstancesPerApp` should be one half the `PassengerMaxPoolSize`.

### Compliance Features Don't Work with Solaris Agents

This issue was fixed in PE 2.0.1.

A quirk in Solaris's cron implementation prevents the compliance reporting job from running on PE 2.0.0. This means resources cannot be audited on Solaris agents without manually repairing the cron job or upgrading to PE 2.0.1.

### Libraries Provided by PE Aren't Namespaced on RPM-based Systems

This issue was fixed in PE 2.0.1. 

On RPM-based systems, some of the libraries provided by PE 2.0.0's packages are not namespaced. This can block proper dependency resolution when installing software that expects the system-provided versions of those libraries. 

* * *

&larr; [Welcome: New Features and Release Notes](./welcome_whats_new.html) --- [Index](./) --- [Welcome: Getting Support](./welcome_getting_support.html) &rarr;

* * *
