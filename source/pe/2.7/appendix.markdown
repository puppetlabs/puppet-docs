---
layout: default
title: "PE 2.7 » Appendix"
subtitle: "User's Guide Appendix"
canonical: "/pe/latest/release_notes.html"
---

This page contains additional miscellaneous information about Puppet Enterprise 2.7.

Puppet Terminology
-----

For help with Puppet-specific terms and language, visit [the glossary](/references/glossary.html)

For a complete guide to the Puppet language, visit [the reference manual](/puppet/2.7/reference/)

Release Notes
-----

### PE 2.7.2 (3/12/2013)

#### Updated Modules
The `java_ks` module has been updated to version 1.0.0 and now supports java 7. The `pe_mcollective` module (which depends on `java_ks`) has been updated to 0.0.60.

#### Security Patches

A number of security patches have been applied in PE 2.7.2. Click the links to the CVE's for detailed information.

*[CVE-2013-0169 "Lucky 13" Open SSL Vulnerability.](http://puppetlabs.com/security/cve/cve-2013-0169/)* 
The Open SSL transport layer was vulnerable to timing side-channel attacks. Because PE provides Open SSL packages for Windows and Solaris, agents on these platforms were vulnerable. These packages have been patched.

*[CVE-2013-0263 Rack Timing Attack Vulnerability.](http://puppetlabs.com/security/cve/cve-2013-0263/)* 
Rack is a middleware component used by PE in the master and console. This vulnerability affects session cookies used by Rack, specifically Rack::Session::Cookie. The component has been patched.

*[CVE-2013-0269 Rails JSON Unsafe Object Creation Vulnerability.](http://puppetlabs.com/security/cve/cve-2013-0269/)* 
The JSON rubygem has a vulnerability that could allow a crafted JSON document to create arbitrary Ruby symbols or internal objects. This could allow an attacker to cause a DoS attack or bypass other protections. Affected components have been patched.

*[CVE-2013-0277 Rails (ActiveRecord) YAML Serialization Vulnerability.](http://puppetlabs.com/security/cve/cve-2013-0277/)* 
Attribute handling code in Ruby on Rails 2.3 and 3.0 can make some applications that directly assign serialized fields susceptible to DoS or remote execution attacks. Affected components have been patched.

*[CVE-2013-1655 Unauthenticated Remote Code Execution Vulnerability.](http://puppetlabs.com/security/cve/cve-2013-1655/)*
A vulnerability found in Puppet could allow unauthenticated clients to send requests to the puppet master which would cause it to load code unsafely. This vulnerability could cause issues like those described in Rails [CVE-2013-0156](http://puppetlabs.com/security/cve/cve-2013-0156/).

*[CVE-2013-1654 SSL Protocol Downgrade Vulnerability.](http://puppetlabs.com/security/cve/cve-2013-1654/)* 
A vulnerability has been found in Puppet that could allow a client negotiating a connection to a master to downgrade the master's SSL protocol to SSLv2. 

*[CVE-2013-1653 Agent Remote Code Execution Vulnerability.](http://puppetlabs.com/security/cve/cve-2013-1653/)* 
A vulnerability has been found in Puppet which could allow authenticated clients to execute arbitrary code on agents that have been configured to accept kick connections. This vulnerability is not present in the default configuration of the puppet agent.

*[CVE-2013-1652 Insufficient Input Validation Vulnerability.](http://puppetlabs.com/security/cve/cve-2013-1652/)* 
A vulnerability found in Puppet could allow an authenticated client to connect to a puppet master and perform unauthorized actions. Specifically, given a valid certificate and private key, an agent could retrieve catalogs from the master that it is not authorized to access or it could poison the puppet master's caches.

*[CVE-2013-1640 Remote Code Execution Vulnerability.](http://puppetlabs.com/security/cve/cve-2013-1640/)* 
A vulnerability found in Puppet could allow an authenticated client to cause the master to execute arbitrary code while responding to a catalog request. Specifically, in order to exploit the vulnerability, the puppet master must be made to invoke the `template` or `inline_template` functions during catalog compilation.

*[CVE-2013-2274 Master/Agent Remote Code Execution Vulnerability--- Puppet 2.6 Only.](http://puppetlabs.com/security/cve/cve-2013-2274/)* 
**NOTE: This vulnerability only affects Puppet 2.6.x.** 
A vulnerability found in Puppet could allow an authenticated client to execute arbitrary code on a puppet master that is running in the default configuration. Specifically, a properly authenticated and connected puppet agent could submit a bogus request for an authorized report that actually causes the execution of arbitrary code on the master.

*[CVE-2013-2275 Incorrect Default Report ACL Vulnerability.](http://puppetlabs.com/security/cve/cve-2013-2274/)* 
This vulnerability affects puppet masters 0.25.0 and above. By default, auth.conf allows any authenticated node to submit a report for any other node. This can cause issues with compliance. The defaults in auth.conf have been changed as follows: 

    Previous setting: 
        # allow all nodes to store their reports
        path /report
        method save
        allow *

    Revised setting: 
        # allow all nodes to store their reports
        path ~ ^/report/([^/]+)$
        method save
        allow $1


### PE 2.7.1 (2/6/2013)

#### Updated Modules

Two modules have been updated in this maintenance release: puppetlabs-request_manager and puppetlabs-auth_conf.

#### Change to auth.conf File Management

Previously, the auth.conf file was fully managed by PE 2.7.0. This meant that manual changes to the file would get over-written on the next puppet run. This is no longer the case. When upgrading to 2.7.1, the upgrader will still convert auth.conf to add the code needed to enable certificate management. However, it will do this if and only if the file has not been manually modified. If the file has been modified, the upgrader will show a warning that it is not going to convert the file and, on subsequent puppet runs, the file will now be left untouched. 
Note that when auth.conf is not modified by the upgrader, you will have to manually add some lines of code to it in order to enable the Console's node request management capabilities. This is explained in the [ node request management configuration details](/pe/2.7/console_cert_mgmt.html#configuration-details).

#### Broken Augeas puppet Lens on Solaris

On Solaris systems, PE's file paths were not compatible with the augeas puppet lenses. The augeas package has been modified to correct this issue.

#### Security Patches

*[CVE-2013-0333 Ruby on Rails JSON Parser Code Injection Vulnerability.](http://puppetlabs.com/security/cve/cve-2013-0333/)* 
This is a Ruby on Rails vulnerability in the JSON parser that could allow an attacker to bypass authentication and inject and execute arbitrary code, or perform a DoS attack. The Puppet Dashboard and Active Record packages have been patched against this vulnerability in PE 2.7.1.

*[CVE-2013-0156 Ruby on Rails SQL Injection Vulnerability.](http://puppetlabs.com/security/cve/cve-2013-0156/)* 
This is a Ruby on Rails vulnerability specific to Active Record that could allow the injection of arbitrary code in SQL. The Puppet Dashboard and Active Record packages have been patched against this vulnerability in PE 2.7.1.

*[CVE-2013-0155 Ruby on Rails SQL Query Generation Vulnerability.](http://puppetlabs.com/security/cve/cve-2013-0155/)* 
This is a Ruby on Rails vulnerability specific to Active Record that could allow the creation of arbitrary queries in SQL. The Puppet Dashboard and Active Record packages have been patched against this vulnerability in PE 2.7.1.

*[CVE-2013-1398 MCO Private Key Leak.](http://puppetlabs.com/security/cve/cve-2013-1398/)* 
Under certain circumstances, a user with root access to a single node in a PE deployment could possibly manipulate that client's local facts in order to force the pe_mcollective module to deliver a catalog containing SSL keys. These keys could be used to access other nodes in the collective and send them arbitrary commands as root. For the vast majority of users, the fix is to apply the 2.7.1 upgrade. 

For PE users who do not use the Console, this can be fixed by making sure that the `pe_mcollective::role::master` class is applied to your master, and
the pe_mcollective::role::console class is applied to your console. This can be as simple as adding the following to your site.pp manifest or other node classifier:


    node console {
        include pe_mcollective::role::console
    }

    node master {
       include pe_mcollective::role::master
    }

*[CVE 2013-1399 CSRF Protection.](http://puppetlabs.com/security/cve/cve-2013-1399/)*  	 
Cross site request forgery (CSRF) protection has been added to the following areas of  the PE console: node request management, live management, and user administration. Now, basically every HTML form submitted to a server running one of these services gets a randomly generated token whose authenticity is compared against a token stored by the session of the currently logged-in user. Requests with tokens that do not authenticate (or are not present) will be answered with a "403 Forbidden" HTML status.

One exception to the CSRF protection model are HTTP requests that use basic HTTP user authorization. These are treated as "API" requests and, since by definition they include a valid (or not) username and password, they are considered secure.
 	 	
Note that the Rails-based  puppet dashboard application is not vulnerable due to Rails' built in CSRF protection.

*[CVE 2012-5664 SQL Injection Vulnerability.](http://puppetlabs.com/security/cve/cve-2012-5664/)* 
This CVE addresses an SQL injection vulnerability in Ruby on Rails and Active Record. The vulnerability is related to the way dynamic finders are processed in Active Record wherein a method parameter could be used as scope. PE 2.7.1 provides patches to Puppet Dashboard and the Active Record packages to eliminate the vulnerabilitly.

### PE 2.7.0 (11/20/2012)

The initial release of PE 2.7. 

#### Puppet Core Patches

Changes to the current version of Puppet's core are documented in the [Puppet Release notes](/puppet/2.7/reference/release_notes.html#puppet-2719). PE 2.7 uses a specially patched version of Puppet 2.7.19. These patches address the following:

* In some cases, an improperly functioning alias between scope and named_scope could cause inventory service to fail. This has been fixed. For details, see [Issue 16376](http://projects.puppetlabs.com/issues/16376).

*  The REST API does not return correct metadata for `GET certificate_request/{certname}` or `GET /certificate_status/{certname}`. This has been corrected. For details, see [Issue 15731](http://projects.puppetlabs.com/issues/15731).

* A bug related to the use of hyphens in variable names caused unpredictable behavior when interpolating variables. This has been fixed. There are numerous tickets associated with this issue. See the related issues listed on [Issue 10146](http://projects.puppetlabs.com/issues/10146).


Known Issues
-----

As we discover them, this page will be updated with known issues in Puppet Enterprise 2.7.x. Fixed issues will be removed from this list and noted above in the release notes. If you find new problems yourself, please file bugs in Puppet [here][puppetissues] and bugs specific to Puppet Enterprise [here][peissues]. 

To find out which of these issues you are affected by, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `2.7.19 (Puppet Enterprise 2.7.0)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](./install_upgrading.html).

[peissues]: https://tickets.puppetlabs.com/secure/CreateIssue!default.jspa
[puppetissues]: https://tickets.puppetlabs.com/secure/CreateIssue!default.jspa


The following issues affect the currently shipped version of PE and all prior releases in the 2.x.x series, unless otherwise stated. 

### After Upgrading, Nodes Report a "Not a PE Agent" Error

When doing the first puppet run after upgrading using the "upgrader" script included in PE tarballs, agents are reporting an error: "&lt;node.name&gt; is not a Puppet Enterprise agent." This was caused by a bug in the upgrader that has since been fixed. If you downloaded a tarball prior to November 28, 2012, simply download the tarball again to get the fixed upgrader. If you prefer, you can download the [latest upgrader module](http://forge.puppetlabs.com/adrien/pe_upgrade/0.4.0-rc1) from the Forge. Alternatively, you can fix it by changing `/etc/puppetlabs/facter/facts.d/is_pe.txt`  to contain: `is_pe=true`. 

### Issues with Compliance UI

There are two issues related to incorrect Compliance UI behavior: 

*     Rejecting a difference by clicking (-) results in an erroneous display (Google Chrome only).
*     The user account pull-down menu in the top level compliance tab ceases to function after a host report has been selected.

### EC2/Dual-homed Systems Report Incorrect URIs for the Console.

During installation, the PE installer attempts to automatically determine the URI where the console can be reached. On EC2 (and likely all other dual-homed systems), the installer incorrectly selects the internal, non-routable URI. Instead, you should manually enter the correct, external facing URI of the system hosting the console.

### Answer file required for some SMTP servers.

Any SMTP server that requires authentication, TLS, or runs over any port other than 25 needs to be explicitly added to an answers file. See the [advanced configuration page](/pe/2.7/config_advanced.html#allowing-anonymous-console-access) for details.

### Upgrading the Console Server Requires an Increased MySQL Buffer Pool Size

An inadequate default MySQL buffer pool size setting can interfere with upgrades to Puppet Enterprise console servers.

**The PE 2.7 upgrader will check for this bad setting.** If you are affected, it will warn you and give you a chance to abort the upgrade. 

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
    
### Dynamic Man Pages are Incorrectly Formatted

Man pages generated with the `puppet man` subcommand are not formatted as proper man pages, and are instead displayed as Markdown source text. This is a purely cosmetic issue, and the pages are still fully readable. 

To improve the display of Puppet man pages, you can use your system `gem` command to install the `ronn` gem:

    $ sudo gem install ronn



