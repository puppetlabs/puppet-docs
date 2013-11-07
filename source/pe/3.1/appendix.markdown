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

New UI and functionality in PE's console now allow you to easily add classes and parameters in the production environment by selecting them from an auto-generated list. The list also displays available documentation for the class, making it easier to know what a class does and why. For more information, see the [console documentation on classification](console_classes_groups.html#viewing-the-known-classes).

#### Red Hat Enterprise Linux 4 Support

The puppet agent can now be installed on nodes running RHEL 4. Support is only for agents. For more information, see the [system requirements](install_system_requirements.html).

#### License Availability

The console UI now displays how many licenses you are currently using and how many are available, so you'll know exactly how much capacity you have to expand your deployment.  The [console navigation page](console_navigating.html) has more information. 

#### Support for Google Compute Engine

PE's cloud provisioner now supports Google Compute Engine virtual infrastructure. For more information, see the [GCE cloud provisioner page](cloudprovisioner_gce.html).

#### Geppetto Integration

Geppetto is an integrated development environment (IDE) for Puppet. It is integrated with PE and provides a toolset for developing puppet modules and manifests that includes syntax highlighting, error tracing/debugging, and code completion features. For more information, visit the [Geppetto Documentation](./geppetto/4.0/index.html) or the [puppet modules and manifests page](puppet_modules_manifests.html).

#### Windows Reboot Capabilities

PE now includes a module that adds a type and provider for managing reboots on Windows nodes. You can now create manifests that can restart windows nodes after package updates or whenever any other resource is applied. For more information, see the [module documentation](https://forge.puppetlabs.com/puppetlabs/reboot).

#### Component Updates

Several of the constituent components of Puppet Enterprise have been upgraded. Namely:

* Ruby 1.9.3 (patch level 448)
* Augeas 1.1.0
* Puppet 3.3.1
* Facter 1.7.3.1
* Hiera 1.2.21
* Passenger 4.0.18
* Dashboard 2.0.12
* Java 1.7.0.19

#### Account Lockout

Security against brute force attacks has been improved by adding an account lockout mechanism. User accounts will be locked after ten failed login attempts. Accounts can only be unlocked by an admin user.

#### Removal of Upgrade Database Staging Directory

The upgrade process has been simplified by removing the need to provide a staging directory for transferring data between the old MySQL databases used by 2.8.x and new PostgreSQL databases used in 3.x. Data is now piped directly between the old and new databases.

#### Support for SELinux
PE 3.1 includes new SELinux bindings for pe-ruby on EL5 and EL6. These bindings allow you to manage SELinux attributes of files and the `seboolean` and `semodule` types. These bindings are available on a preview basis and are not installed by default. They are included in the installation tarball in a package named `pe-ruby-selinux`.

#### Security Fixes

*[CVE-2013-4287 Algorithmic Complexity Vulnerability In RubyGems 2.0.7 And Older](http://puppetlabs.com/security/cve/cve-2013-4287/)*

Assessed Risk Level: low. 
RubyGems validates versions with a regular expression that is vulnerable to attackers causing denial of service through CPU consumption. This is resolved in PE 3.1.

*[CVE-2013-4957 YAML vulnerability in Puppet dashboard's report handling](http://puppetlabs.com/security/cve/cve-2013-4957/)*

Assessed Risk Level: medium. 
Systems that rely on YAML to create report-specific types were found to be at risk of arbitrary code execution vulnerabilities. This vulnerability has been fixed in PE 3.1.

*[CVE-2013-4965 User account not locked after numerous invalid login attempts](http://puppetlabs.com/security/cve/cve-2013-4965/)*

Assessed Risk Level: low. 
A user's account was not locked out after the user submitted a large number of invalid login attempts, leaving the account vulnerable to brute force attack. This has been fixed in PE 3.1;  now the account is locked after 10 failed attempts.

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

### Answer File Required for Some SMTP servers.

Any SMTP server that requires authentication, TLS, or runs over any port other than 25 needs to be explicitly added to an answers file. See the [advanced configuration page](./console_config.html#allowing-anonymous-console-access) for details.

### `pe-httpd` Must Be Restarted After Revoking Certificates

([Issue #8421](http://projects.puppetlabs.com/issues/8421))

Due to [an upstream bug in Apache](https://issues.apache.org/bugzilla/show_bug.cgi?id=14104), the `pe-httpd` service on the puppet master must be restarted after revoking any node's certificate.

After using `puppet cert revoke` or `puppet cert clean` to revoke a certificate, restart the service by running:

    $ sudo /etc/init.d/pe-httpd restart

### Dynamic Man Pages Are Incorrectly Formatted

Man pages generated with the `puppet man` subcommand are not formatted as proper man pages, and are instead displayed as Markdown source text. This is a purely cosmetic issue, and the pages are still fully readable.

To improve the display of Puppet man pages, you can use your system `gem` command to install the `ronn` gem:

    $ sudo gem install ronn

### Deleted Nodes Can Reappear in the Console.

Due to the fact that the console will create a node listing for any node found via the inventory search function, nodes deleted from the console can sometimes reappear. See the [console bug report describing the issue](https://projects.puppetlabs.com/issues/11210).

The nodes will reappear after deletion if PuppetDB data for that node has not yet expired, and you perform an inventory search in the console that returns information for that node.

You can avoid the reappearance of nodes by removing them with the following procedure:

1. `puppet node clean <node_certname>`
1. `puppet node deactivate <node_certname>`
1. `sudo /opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production node:del[<node_certname>]`

These steps will remove the node's certificate, purge information about the node from PuppetDB, and delete the node from the console. The last command is equivalent to logging into the console and deleting the node via the UI.



* * *

- [Next: Compliance: Alternate Workflow](./compliance_alt.html)
