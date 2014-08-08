---
layout: default
title: "PE 2.8 » Appendix"
subtitle: "User's Guide Appendix"
canonical: "/pe/latest/release_notes.html"
---


This page contains additional miscellaneous information about Puppet Enterprise 2.8.

Puppet Terminology
-----

For help with Puppet-specific terms and language, visit [the glossary](/references/glossary.html)

For a complete guide to the Puppet language, visit [the reference manual](/puppet/2.7/reference/)

Release Notes
-----

### PE 2.8.7 (6/10/2014)

#### Security Fixes

*[CVE-2014-3248 Arbitrary Code Execution with Required Social Engineering](http://puppetlabs.com/security/cve/cve-2014-3248)*

Assessed Risk Level: Medium. On platforms with Ruby 1.9.1 and earlier, an attacker could have Puppet execute malicious code by convincing a privileged user to change directories to one containing the malicious code and then run Puppet.

CVSS v2 score: 5.2 Vector (AV:L/AC:M/Au:S/C:C/I:C/A:C/E:POC/RL:OF/RC:C)

*[CVE-2014-3249 Information leakage](http://puppetlabs.com/security/cve/cve-2014-3249)*

Assessed Risk Level: Low. Unauthenticated users could hide and unhide nodes in the console and get a list of facts for a node. 

CVSS v2 score: 3.9 Vector (AV:N/AC:L/Au:N/C:P/I:N/A:N/E:POC/RL:OF/RC:C)

### PE 2.8.6 (4/15/2014)

#### Security Fixes

*[CVE-2014-0098 Apache vulnerability in config module could allow denial of service attacks via cookies](http://puppetlabs.com/security/cve/cve-2014-0098)*

Assessed Risk Level: medium. For Apache versions earlier than 2.4.8, the `log_cookie` function in `mod_log_config.c` in the `mod_log_config` module could allow remote attackers to cause a denial of service attack via a crafted cookie that is not properly handled during truncation.

For RHEL, SLES, CentOS, and Scientific Linux systems CVSS v2 score: 5.3 v2 Vector (AV:N/AC:M/Au:N/C:N/I:N/A:C/E:U/RL:OF/RC:C)

For Debian and Ubuntu systems CVSS v2 score: 4.0 v2 Vector (AV:N/AC:H/Au:N/C:N/I:N/A:C/E:U/RL:OF/RC:C)

The variation in score is because `mod_log_config` is enabled by default on RHEL, CentOS, SLES, and Scientific Linux systems. The module is not enabled by default on Debian and Ubuntu.

*[CVE-2013-6438 Apache vulnerability in `mod_dav` module could allow denial of service attacks via DAV WRITE requests](http://puppetlabs.com/security/cve/cve-2013-6438)*

Assessed Risk Level: medium. For Apache versions earlier than 2.4.8, the `dav_xml_get_cdata` function in `main/util.c` in the `mod_dav` module does not properly remove leading spaces could allow remote attackers to cause a denial of service attack via a crafted DAV WRITE request. 

CVSS v2 score: 4.0 with v2 Vector (AV:N/AC:H/Au:N/C:N/I:N/A:C/E:U/RL:OF/RC:C)

#### A Note about the Heartbleed Bug

We want to emphasize that Puppet Enterprise does not need to be patched for Heartbleed.  

No version of Puppet Enterprise has been shipped with a vulnerable version of OpenSSL, so Puppet Enterprise is not itself vulnerable to the security bug known as Heartbleed, and does not require a patch from Puppet Labs.

However, some of your Puppet Enterprise-managed nodes could be running operating systems that include OpenSSL versions 1.0.1 or 1.0.2, and both of these are vulnerable to the Heartbleed bug. Since tools included in Puppet Enterprise, such as PuppetDB and the Console, make use of SSL certificates we believe the safest, most secure method for assuring the security of your Puppet-managed infrastructure is to regenerate your certificate authority and all OpenSSL certificates. 

We have outlined the remediation procedure to help make it an easy and fail-safe process. You’ll find the details here: Remediation for [Recovering from the Heartbleed Bug](/trouble_remediate_heartbleed_overview.html).

We’re here to help. If you have any issues with remediating the Heartbleed vulnerability, one of your authorized Puppet Enterprise support users can always log into the [customer support portal](https://support.puppetlabs.com/access/unauthenticated). We’ll continue to update the email list with any new information.

Links:

* [Heartbleed and Puppet-Supported Operating Systems](https://puppetlabs.com/blog/heartbleed-and-puppet-supported-operating-systems)

* [Heartbleed Update: Regeneration Still the Safest Path](https://puppetlabs.com/blog/heartbleed-update-regeneration-still-safest-path)

### PE 2.8.5 (1/30/2014)

#### Security Fixes

*[CVE-2013-6450 OpenSSL DTLS retransmission vulnerability](http://puppetlabs.com/security/cve/cve-2013-6450/)*

Assessed Risk Level: medium. The DTLS retransmission implementation in OpenSSL through 0.9.8y and 1.x through 1.0.1e does not properly maintain data structures for digest and encryption contexts, which might allow man-in-the-middle attackers to trigger the use of a different context by interfering with packet delivery, related to ssl/d1_both.c and ssl/t1_enc.c. This has been fixed in PE 2.8.5 by updating OpenSSL to 1.0.0.l

#### Bug Fixes

Several minor bugs in puppet core have been fixed in this release.

### PE 2.8.4 (12/19/2013)

#### Security Fixes

*[CVE-2013-6414 Action View vulnerability in Ruby on Rails](http://puppetlabs.com/security/cve/cve-2013-6414)*

Assessed Risk Level: medium. Ruby on Rails is vulnerable to headers containing an invalid MIME type that allows attackers to issue  denial of service through memory consumption, which leads to excessive caching. This has been fixed in PE 2.8.4.

*[CVE-2013-4491 XSS vulnerability in Ruby on Rails](http://puppetlabs.com/security/cve/cve-2013-4491)* 

Assed Risk Level: medium. An XXS vulnerability in the translation helper allows remote attackers to add web script or HTML that triggers generation of a fallback string in the i18n gem. This has been fixed in PE 2.8.4.

*[CVE-2013-4363 Algorithmic Complexity Vulnerability in RubyGems](http://puppetlabs.com/security/cve/cve-2013-4363)*

Assessed Risk Level: low. RubyGems validates versions with a regular expression that is vulnerable to attackers causing denial of service through CPU consumption. This is resolved in PE 2.8.4. 
**Note:** This vulnerability was due to an incomplete fix for CVE-2013-4287.

*[CVE-2013-4164 Heap overflow in floating point parsing in RubyGems](http://puppetlabs.com/security/cve/cve-2013-4164)*

Assessed Risk Level: Medium. Converting strings of unknown origin to floating point values can cause heap overflow and allow attackers to create denial of service attacks. This has been fixed in PE 2.8.4.

*[CVE-2013-4969 Unsafe use of temp files in `file_type`](http://puppetlabs.com/security/cve/cve-2013-4969)*

Assessed Risk Level: medium. Previous code used temp files unsafely by looking for a name it could use in a directory, and then later writing to that file, creating a vulnerability in which an attacker could make the name a symlink to another file and thereby cause puppet agent to overwrite something that it did not intend to. This has been fixed in PE 2.8.4.
### PE 2.8.3 (8/15/2013)

#### Security Fixes

*[CVE-2013-4761 `resource_type` Remote Code Execution Vulnerability](http://puppetlabs.com/security/cve/cve-2013-4761/).*

The `resource_type` service could be used to load arbitrary Ruby files if auth_conf was edited to allow the behavior.

*[CVE-2013-4073 Ruby SSL Vulnerability](http://puppetlabs.com/security/cve/cve-2013-4073/).*

A vulnerability in Ruby's SSL client could allow an attacker to spoof SSL servers via a valid, trusted certificate.

*[CVE-2013-4956 Puppet Module Permissions Vulnerability](http://puppetlabs.com/security/cve/cve-2013-4956/).*

The Puppet Module Tool (PMT) incorrectly transferred a module's original permissions.


### PE 2.8.2 (6/18/2013)

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

[peissues]: https://tickets.puppetlabs.com/secure/CreateIssue!default.jspa
[puppetissues]: https://tickets.puppetlabs.com/secure/CreateIssue!default.jspa


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

Any SMTP server that requires authentication, TLS, or runs over any port other than 25 needs to be explicitly added to an answers file. See the [advanced configuration page](/pe/2.8/config_advanced.html#allowing-anonymous-console-access) for details.

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

### Installing or Upgrading to PE 2.8.3 on Ubuntu Results in an Inaccessible Console

Due to a bug with the console packages for PE 2.8.3, several lines of necessary configuration are missing
when PE is installed on Ubuntu.

The following errors will appear in `/var/log/pe-puppet-dashboard/production.log` when this issue occurs:

    ActionView::TemplateError (`per_page` setting cannot be less than 1 (0 given)) on line #2 of app/views/nodes/_nodes.html.haml:
    1: - node_count = local_assigns[:nodes].count
    2: - nodes = paginate_scope(local_assigns[:nodes])
    3: - container = local_assigns[:container]
    4: - selected_status = local_assigns[:selected_status]
    5: - more_link = local_assigns[:more_link]

The issue can be resolved by appending these four configuration lines to the file `/etc/puppetlabs/puppet-dashboard/settings.yml`:

    nodes_per_page: 20
    classes_per_page: 50
    groups_per_page: 50
    reports_per_page: 20

