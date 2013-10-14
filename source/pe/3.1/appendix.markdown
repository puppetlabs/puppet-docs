---
layout: default
title: "PE 3.1 » Appendix"
subtitle: "User's Guide Appendix"
canonical: "/pe/latest/appendix.html"
---


This page contains additional miscellaneous information about Puppet Enterprise (PE) 3.1.

Puppet Terminology
-----

For help with Puppet-specific terms and language, visit [the glossary](/references/glossary.html)

For a complete guide to the Puppet language, visit [the reference manual](/puppet/3/reference/)

Release Notes
-----

### PE 3.1.0 (10/15/2013)

#### Event Inspector

Puppet Enterprise (PE) event inspector is a new reporting tool that provides multiple, dynamic ways to view the state of your infrastructure, providing both broad and specific insight into how Puppet is managing configurations. By providing information about events from the perspective of classes and resources, event inspector lets you quickly and easily find the source of configuration failures. For more information, see the [event inspector page](console_event-inspector.html).

#### Discoverable Classes & Parameters

New UI and functionality in PE's console now allows you to easily add classes and parameters in the production environment by selecting them from an auto-generated list. The list also displays available documentation for the class, making it easier to know what a class does and why. For more information, see the [console documentation on classification](console_classes_groups.html#viewing-the-known-classes).

#### Red Hat Enterprise Linux 4 Support

The puppet agent can now be installed on nodes running RHEL 4. Support is only for agents. For more information, see the [system requirements](install_system_requirements.html).

#### License Availability

The console UI now displays how many licenses you are currently using and how many are available, so you'll know exactly how much capacity you have to expand your deployment.  The [console navigation page](console_navigating.html) has more information. 

#### Support for Google Compute Engine

PE's cloud provisioner now supports Google Compute Engine virtual infrastructure. For more information, see the [GCE cloud provisioner page](cloudprovisioner_gce.html).

#### Geppetto Integration

Geppetto is an integrated development environment (IDE) for Puppet. It is integrated with PE and provides a toolset for developing puppet modules and manifests that includes syntax highlighting, error tracing/debugging, and code completion features. For more information, visit the [puppet modules and manifests page](puppet_modules_manifests.html) or the [Geppetto Documentation](./geppetto/4.0/index.html).

#### Windows Reboot Capabilities

PE now includes a module that adds a type and provider for managing reboots on Windows nodes. You can now create manifests that can restart windows nodes after package updates or whenever any other resource is applied. For more information, see the [module documentation](https://forge.puppetlabs.com/puppetlabs/reboot).

#### Component Updates

Several of the constituent components of Puppet Enterprise have been upgraded. Namely:

* Ruby 1.9.3 (patch level 448)
* Augeas 1.1.0
* Puppet 3.3.1
* Facter 1.7.1
* Hiera 1.2.21
* Passenger 4.0.18
* Dashboard 2.0.12
* Java 1.7.0.19

#### Account Lockout

Security against brute force attacks has been improved by adding an account lockout mechanism. User accounts will be locked after ten failed login attempts. Accounts can only be unlocked by an admin user.

#### Removal of Upgrade Database Staging Directory

The upgrade process has been simplified by the removing the need to provide a staging directory for transferring data between the old MySQL databases used by 2.8.x and new PostgreSQL databases used in 3.x. Data is now piped directly between the old and new databases.

#### Support for SELinux
PE 3.1 includes new SELinux bindings for pe-ruby on EL5 and EL6. These bindings allow you to manage SELinux attributes of files and the `seboolean` and `semodule` types. These binding are available on preview basis and are not installed by default. They are included in the installation tarball in a package named `pe-ruby-selinux`.

#### Security Fixes

*[CVE-2013-4287 Algorithmic Complexity Vulnerability In RubyGems 2.0.7 And Older](http://puppetlabs.com/security/cve/cve-2013-4287/)*

RubyGems validates versions with a regular expression that is vulnerable to attackers causing denial of service through CPU consumption. In PE 3.1, this vulnerability was adddressed by rebuilding Ruby with a fixed version. 

*[CVE-2013-4957 YAML vulnerability in Puppet dashboard's report handling](http://puppetlabs.com/security/cve/cve-2013-4957/)*

Systems that rely on YAML to create report-specific types were found to be at risk of code injection vulnerabilities. This vulnerability has been fixed in PE 3.1.

*[CVE-2013-4965 User account not locked after numerous invalid login attempts](http://puppetlabs.com/security/cve/cve-2013-4965/)*

A user's account was not locked out after the user submitted a large number of invalid login attempts, leaving the account vulnerable to brute force attack. This has been fixed in PE 3.1;  now the account is locked after 10 failed attempts.


### PE 3.0.1 (8/15/2013)

#### Complete Upgrade Support

The PE Installer/Upgrader script is now fully functional and can upgrade all PE roles: agent, master, console, cloud provisioner, and database support.

#### SLES Support

PE 3.0.1 now fully supports all PE roles on nodes running SLES 11 SP1 or higher.

#### Improvements to Cloud Provisioner

Integration with PE has been improved and installation of the cloud provisioner role now properly includes all dependencies. In addition, issues with `puppet node_vmware list` have been addressed and the command should now correctly list directory structures.

#### Security Fixes

*[CVE-2013-4761 `resource_type` Remote Code Execution Vulnerability](http://puppetlabs.com/security/cve/cve-2013-4761/).*

The `resource_type` service could be used to load arbitrary Ruby files if auth_conf was edited to allow the behavior.

*[CVE-2013-4073 Ruby SSL Vulnerability](http://puppetlabs.com/security/cve/cve-2013-4073/).*

A vulnerability in Ruby's SSL client could allow an attacker to spoof SSL servers via a valid, trusted certificate.

*[CVE-2013-4762 Logout Link Did Not Destroy Server Session](http://puppetlabs.com/security/cve/cve-2013-4762/).*

The "logout" link in Puppet Enterprise did not invalidate the old session, potentially allowing an attacker to hijack a user's session and gain access to sensitive data.

*[CVE-2013-4955 Phishing Through URL Redirection Vulnerability](http://puppetlabs.com/security/cve/cve-2013-4955/).*

The PE login page could be manipulated into redirecting to a third-party website, allowing an attacker to redirect to a phishing site under their control.

*[CVE-2013-4956 Puppet Module Permissions Vulnerability](http://puppetlabs.com/security/cve/cve-2013-4956/).*

The Puppet Module Tool (PMT) incorrectly transferred a module's original permissions.

*[CVE-2013-4958 Lack of Session Timeout](http://puppetlabs.com/security/cve/cve-2013-4958/).*

A lack of session timeout in Puppet Enterprise meant that an attacker could seize a machine and perform any actions the user was authorized to perform.

*[CVE-2013-4959 Sensitive Data Browser Caching](http://puppetlabs.com/security/cve/cve-2013-4959/).*

Pages in PE's console that display sensitive data were caching that data incorrectly. This meant an attacker with access to the user's machine could access the data in Temporary Internet Files.

*[CVE-2013-4961 Software Version Numbers Were Revealed](http://puppetlabs.com/security/cve/cve-2013-4961/).*

HTTP response headers generated by the web server revealed software version numbers for Apache and Phusion Passenger. These could be used to craft attacks based on published vulnerabilities. 

*[CVE-2013-4962 Lack of Re-authentication for Sensitive Transactions](http://puppetlabs.com/security/cve/cve-2013-4962/).*

PE's password reset page did not require the user to re-authenticate, allowing an attacker to potentially gain access to sensitive transactions.

*[CVE-2013-4963 Cross-Site Request Forgery Vulnerability](http://puppetlabs.com/security/cve/cve-2013-4963/).*

Several pages in the PE console were vulnerable to CSRF, which could allow an attacker to manipulate a user's browser in a malicious manner.

*[CVE-2013-4964 Session Cookies Not Set With Secure Flag](http://puppetlabs.com/security/cve/cve-2013-4964/).*

The PE console uses a cookie to control access to the application. An incorrectly set security flag could allow an attacker to hijack a user's session and access any functions or services available to the user.

*[CVE-2013-4967 External Node Classifiers Allowed Clear Text Database Password Query](http://puppetlabs.com/security/cve/cve-2013-4967/).*

A vulnerability in the PE console's handling of database password could allow an attacker to access the password in clear text.

*[CVE-2013-4968 Site Lacked Clickjacking Defense](http://puppetlabs.com/security/cve/cve-2013-4968/).*

The PE console was vulnerable to UI redress attack (aka, "clickjacking"), which could allow an attacker to redirect the user to another page or application and possibly trick them into entering sensitive data. Further, live management was vulnerable to cross-site scripting (XSS), allowing an attacker to potentially inject malicious scripts that could be used to access sensitive data.

### PE 3.0.0

#### Delayed Support for Complete Upgrades and SLES

* Full functionality for upgrades is not yet complete in 3.0. Upgrading is not yet supported for master, console and database roles, but is fully supported for agents. Visit the [upgrading page](./install_upgrading) for complete instructions on how to migrate a 2.8 deployment to PE 3.0 now. Full upgrade support will be included in the next release of PE 3.0, no later than August 15, 2013.
* Support for nodes running the SLES operating system is not yet completed. It will be included in the next release of PE 3.0, no later than August 15, 2013.

#### Package and Component Upgrades

Several of the constituent components of Puppet Enterprise have been upgraded. Namely:

* Ruby 1.9.3
* Augeas 1.0.0
* Puppet 3.2.2
* Facter 1.7.1
* Hiera 1.2.1
* MCollective 2.2.4
* Passenger 4.0
* Dashboard 2.0
* Java 1.7
* PostgreSQL 9.2.4

#### Removal of Cloning

The live management cloning tool is deprecated and has been removed in PE 3.0. We are continuing to improve resource inspection and interactive orchestration commands in the console. In general, we recommend managing resources with Puppet manifests instead of one-off commands.

If you are using cloning, you can achieve a similar workflow by using `puppet resource` or [the puppetral plugin's `find` action](./orchestration_actions.html#find) to learn the details of resources on individual host. Then, you can use that info to write or append to a manifest.

#### Removal of Compliance

The compliance workflow tools, including File Search, are deprecated, and have been removed in Puppet Enterprise 3.0. We are continuing to invest in flexible ways to help you predict, detect, and control change, and our next-generation tools will not use manually maintained baselines as a foundation.

If you are using the compliance workflow tools today, you can achieve a similar workflow by using Puppet's **noop** features to detect changes. We've created an example page that shows this [alternate workflow in greater detail](./compliance_alt.html).

While the compliance app has been removed,  none of the associated data will be removed when upgrading the console and master. To remove all database tables used by the compliance app, run the following rake task on the master node: `/opt/puppet/bin/rake -s -f /opt/puppet/share/puppet-dashboard/Rakefile db:drop_compliance_tables RAILS_ENV=production`.

#### Removal of "File Search"

Related to the removal of compliance, the File Search section of the console has been removed. This section was able to display file contents when given an MD5 checksum, but was no longer relevant once compliance was removed.

#### Puppet Agent Service Rename
Previously, the puppet agent service was known by several names, depending on platform (e.g. `puppetagent` on Solaris, `pe-puppet-agent` on Debian/Ubuntu, etc.). As of PE 3, it is called `'pe-puppet` on all platforms.

#### Change to Orchestration Engine's Authentication Backend

In previous versions, the orchestration engine (MCollective) used either the `psk` or `aespe` security plugin. As of PE 3, it uses the more secure and reliable `ssl` security plugin. **If you have integrated external applications with the orchestration engine,** you will need to [re-configure their security credentials](./orchestration_config.html#adding-new-orchestration-users-and-integrating-applications).

#### Change to Built-in Orchestration Actions

The output format and available actions of the `puppetral` orchestration plugin have changed --- the `create` action has been removed, and the output format is now an array of hashes. If you have built applications that integrate with the `puppetral` plugin, you'll need to update them.

Known Issues
-----

As we discover them, this page will be updated with known issues in Puppet Enterprise 3.1 and earlier. Fixed issues will be removed from this list and noted above in the release notes. If you find new problems yourself, please file bugs in Puppet [here][puppetissues] and bugs specific to Puppet Enterprise [here][peissues].

To find out which of these issues may affect you, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `3.2.2 (Puppet Enterprise 3.1)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](./install_upgrading.html).

[peissues]: http://projects.puppetlabs.com/projects/puppet-enterprise/issues
[puppetissues]: http://projects.puppetlabs.com/projects/puppet/issues


The following issues affect the currently shipped version of PE and all prior releases through the 2.x.x series, unless otherwise stated.

### Passenger Global Queue Error on Upgrade

When upgrading a PE 2.8.3 master to PE 3.1.0, restarting `pe-httpd` produces a warning: `The 'PassengerUseGlobalQueue' option is obsolete: global queueing is now always turned on. Please remove this option from your configuration file.` This error will not affect anything in PE, but if you wish you can turn it off by removing the line in question from `/etc/puppetlabs/httpd/conf.d/passenger-extra.conf`.

### `Puppet resource` Fails if `puppet.conf` is Modified to Make `puppet apply` Work with PuppetDB.

In an effort to make `puppet apply` work with PuppetDB in masterless puppet scenarios, users may edit puppet.conf to make storeconfigs point to PuppetDB. This breaks `puppet resource`, causing it to fail with a Ruby error. For more information, see the [console & database troubleshooting page](./trouble_console-db.html), and for a workaround see the [PuppetDB documentation on connecting `puppet apply`](http://docs.puppetlabs.com/puppetdb/1.5/connect_puppet_apply.html).

### BEAST Attack Mitigation

A known weakness in Apache HTTPD leaves it vulnerable to a man-in-the-middle attack known as the BEAST (Browser Exploit Against SSL/TLS) attack. The vulnerability exists because Apache HTTPD uses a FIPS compliant cipher suite that can be cracked via a brute force attack that can discover the decryption key. If FIPS compliance is not required for your infrastructure, we recommend you mitigate vulnerability to the BEAST attack by using a cipher suite that includes stronger ciphers. This can be done as follows:

In `/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf`, edit the `SSLCipherSuite` and `SSLProtocol` options to:

    SSLCipherSuite ALL:!ADH:+RC4+RSA:+HIGH:+AES+256:+CBC3:-LOW:-SSLv2:-EXP
    SSLProtocol ALL -SSLv2
    
This will set the order of ciphers to:

    KRB5-RC4-MD5            SSLv3 Kx=KRB5     Au=KRB5 Enc=RC4(128)  Mac=MD5
    KRB5-RC4-SHA            SSLv3 Kx=KRB5     Au=KRB5 Enc=RC4(128)  Mac=SHA1
    RC4-SHA                 SSLv3 Kx=RSA      Au=RSA  Enc=RC4(128)  Mac=SHA1
    RC4-MD5                 SSLv3 Kx=RSA      Au=RSA  Enc=RC4(128)  Mac=MD5
    DHE-RSA-AES256-SHA      SSLv3 Kx=DH       Au=RSA  Enc=AES(256)  Mac=SHA1
    DHE-DSS-AES256-SHA      SSLv3 Kx=DH       Au=DSS  Enc=AES(256)  Mac=SHA1
    AES256-SHA              SSLv3 Kx=RSA      Au=RSA  Enc=AES(256)  Mac=SHA1
    DHE-RSA-AES128-SHA      SSLv3 Kx=DH       Au=RSA  Enc=AES(128)  Mac=SHA1
    DHE-DSS-AES128-SHA      SSLv3 Kx=DH       Au=DSS  Enc=AES(128)  Mac=SHA1
    AES128-SHA              SSLv3 Kx=RSA      Au=RSA  Enc=AES(128)  Mac=SHA1
    KRB5-DES-CBC3-MD5       SSLv3 Kx=KRB5     Au=KRB5 Enc=3DES(168) Mac=MD5
    KRB5-DES-CBC3-SHA       SSLv3 Kx=KRB5     Au=KRB5 Enc=3DES(168) Mac=SHA1
    EDH-RSA-DES-CBC3-SHA    SSLv3 Kx=DH       Au=RSA  Enc=3DES(168) Mac=SHA1
    EDH-DSS-DES-CBC3-SHA    SSLv3 Kx=DH       Au=DSS  Enc=3DES(168) Mac=SHA1
    DES-CBC3-SHA            SSLv3 Kx=RSA      Au=RSA  Enc=3DES(168) Mac=SHA1
    
Note that unless your system contains OpenSSL v1.0.1d (the version that correctly supports TLS1.1 1and 1.2), prioritizing RC4 may leave you vulnerable to other types of attacks.

### PE Install Fails if Port 8080 or 8081 is in Use
PuppetDB requires access to port 8080 and 8081. The installer will check to make sure these ports are available and if they are not, the install will fail with an error message. To fix this, either disable the service currently using 8080/8081 or install the database role on a different node that has port 8080 available. A slightly more complicated workaround is to temporaily disable the service running on 8080/8081, complete the PE installation and then add a class parameter for puppetDB that makes it use a different, available port. Note that you will still need to temporarily disable the service using the ports even if you implement this class parameter workaround.

### Puppet Code Issues with UTF-8 Encoding
PE 3 uses an updated version of Ruby, 1.9 that is much stricter about character encodings than the version of Ruby used in PE 2.8. As a result, puppet code that contains UTF-8 characters such as accents or other non-ASCII characters can fail or act unpredictably. There are a number of ways UTF-8 characters can make it into puppet code, including, but not limited to, downloading a Forge module where some piece of metadata (e.g., author's name) contains UTF-8 characters. With apologies to our international customers, the current solution is to strictly limit puppet code to the ASCII character set only, including any code comments or metadata. Puppet Labs is working on cleaning up character encoding issues in Puppet and the various libraries it interfaces with.

### PostgreSQL Requires the en_US.UTF8 Locale Prior to Installation

The node selected to run the PostgreSQL instance required by PuppetDB and the console must have the en_US.UTF8 locale present before starting the installation process. The installer will abort with a message about the missing locale if it is not present.

### Readline Version Issues on AIX Agents

- As with PE 2.8.2,  on AIX 5.3, puppet agents depend on readline-4-3.2 being installed. You can check the installed version of readline by running `rpm -q readline`. If you need to install it, you can [download it from IBM](ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/readline/readline-4.3-2.aix5.1.ppc.rpm). Install it *before* installing the puppet agent.

- On AIX 6.1 and 7.1, the default version of readline, 4-3.2, is insufficient. You need to replace it *before* upgrading or installing by running

         rpm -e --nodeps readline
        rpm -Uvh readline-6.1-1.aix6.1.ppc.rpm

If you see an error message after running this, you can disregard it. Readline-6 should be successfully installed and you can proceed with the installation or upgrade (you can verify the installation with  `rpm -q readline`).

### Debian/Ubuntu Local Hostname Issue
On some versions of Debian/Ubuntu, the default `/etc/hosts` file contains an entry for the machine's hostname with a local IP address of 127.0.1.1. This can cause issues for PuppetDB and PostgreSQL, because binding a service to the hostname will cause it to resolve to the local-only IP address rather than its public IP. As a result, nodes (including the console) will fail to connect to PuppetDB and PostgreSQL.

To fix this, add an entry to `/etc/hosts` that resolves the machine's FQDN to its *public* IP address. This should be done prior to installing PE. However, if PE has already been installed, restarting the `pe-puppetdb` and `pe-postgresql` services after adding the entry to the hosts file should fix things.

### Console_auth Fails After PostgreSQL Restart
RubyCAS server, the component which provides console log-in services will not automatically reconnect if it loses connection to its database, which can result in a `500 Internal Server Error` when attempting to log in or out. The issue can be resolved by restarting Apache on the console's node with `service pe-httpd restart`.

### Inconsistent Counts When Comparing Service Resources in Live Management

In the Browse Resources tab, comparing a service across a mixture of RedHat-based and Debian-based nodes will give different numbers in the list view and the detail view.

### Bad Data in Facter's `architecture` Fact

On AIX agents, a bug causes facter to return the system's model number (e.g., IBM 3271) instead of the processor's architecture (e.g. Power6). There is no known workaround.

### Augeas File Access Issue

On AIX agents, the Augeas lens is unable to access or modify `etc/services`. There is no known workaround.

### After Upgrading, Nodes Report a "Not a PE Agent" Error

When doing the first puppet run after upgrading using the "upgrader" script included in PE tarballs, agents are reporting an error: "&lt;node.name&gt; is not a Puppet Enterprise agent." This was caused by a bug in the upgrader that has since been fixed. If you downloaded a tarball prior to November 28, 2012, simply download the tarball again to get the fixed upgrader. If you prefer, you can download the [latest upgrader module](http://forge.puppetlabs.com/adrien/pe_upgrade/0.4.0-rc1) from the Forge. Alternatively, you can fix it by changing `/etc/puppetlabs/facter/facts.d/is_pe.txt`  to contain: `is_pe=true`.

### EC2/Dual-homed Systems Report Incorrect URIs for the Console.

During installation, the PE installer attempts to automatically determine the URI where the console can be reached. On EC2 (and likely all other dual-homed systems), the installer incorrectly selects the internal, non-routable URI. Instead, you should manually enter the correct, external facing URI of the system hosting the console.

### Answer file required for some SMTP servers.

Any SMTP server that requires authentication, TLS, or runs over any port other than 25 needs to be explicitly added to an answers file. See the [advanced configuration page](./console_config.html#allowing-anonymous-console-access) for details.

### `pe-httpd` Must Be Restarted After Revoking Certificates

([Issue #8421](http://projects.puppetlabs.com/issues/8421))

Due to [an upstream bug in Apache](https://issues.apache.org/bugzilla/show_bug.cgi?id=14104), the `pe-httpd` service on the puppet master must be restarted after revoking any node's certificate.

After using `puppet cert revoke` or `puppet cert clean` to revoke a certificate, restart the service by running:

    $ sudo /etc/init.d/pe-httpd restart

### Dynamic Man Pages are Incorrectly Formatted

Man pages generated with the `puppet man` subcommand are not formatted as proper man pages, and are instead displayed as Markdown source text. This is a purely cosmetic issue, and the pages are still fully readable.

To improve the display of Puppet man pages, you can use your system `gem` command to install the `ronn` gem:

    $ sudo gem install ronn


* * *

- [Next: Compliance: Alternate Workflow](./compliance_alt.html)
