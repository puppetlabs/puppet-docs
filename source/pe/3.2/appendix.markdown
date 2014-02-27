---
layout: default
title: "PE 3.2 » Appendix"
subtitle: "User's Guide Appendix"
canonical: "/pe/latest/appendix.html"
---


This page contains additional miscellaneous information about Puppet Enterprise (PE) 3.2.

Puppet Terminology
-----

For help with Puppet-specific terms and language, visit [the glossary](/references/glossary.html)

For a complete guide to the Puppet language, visit [the reference manual](/puppet/3/reference/)

Release Notes
-----

### PE 3.2.0 (3/4/13)

#### Simplified Agent Install

On platforms that support remote package repos, installing PE agents can now be done via package manager, making the installation process faster and simpler. For details, visit the [PE installation page](install_basic.html).

#### Puppet Enterprise Supported Modules

PE 3.2 introduces PE supported modules. Supported modules will allow you to manage core services quickly and easily, with very little need for you to write any code. Supported modules are

* rigorously tested with PE
* supported by PL via the usual [support channels](http://puppetlabs.com/services/customer-support)
* maintained for a long-term lifecycle
* compatible with multiple platforms and architectures.

Visit the [Supported Modules page](TODO: link) to learn more. You can also check out the Read Me for each supported module being released with PE 3.2: [Apache][pe-apache], [NTP][pe-ntp], [MySQL][pe-mysql], [Windows Registry][windows-registry], [PostgreSQL][pe-postgresql], [stdlib][pe-stdlib], [reboot][pe-reboot], [firewall][pe-firewall], [apt][pe-apt], [INI-file][pe-inifile], [java_ks][pe-javaks], [Concat][pe-concat].

[pe-apache]: http://forge.puppetlabs.com/puppetlabs/apache
[pe-ntp]: http://forge.puppetlabs.com/puppetlabs/ntp
[pe-mysql]: http://forge.puppetlabs.com/puppetlabs/ntp
[windows-registry]: http://forge.puppetlabs.com/puppetlabs/registry
[pe-postgresql]: http://forge.puppetlabs.com/puppetlabs/postgresql
[pe-stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[pe-reboot]: http://forge.puppetlabs.com/puppetlabs/reboot
[pe-firewall]: http://forge.puppetlabs.com/puppetlabs/firewall
[pe-apt]: http://forge.puppetlabs.com/puppetlabs/apt
[pe-inifile]: http://forge.puppetlabs.com/puppetlabs/inifile
[pe-javaks]: http://forge.puppetlabs.com/puppetlabs/java_ks
[pe-concat]: http://forge.puppetlabs.com/puppetlabs/concat

#### Razor Provisioning Tech Preview

PE 3.2 offers a preview of new, bare-metal provisioning capabilities using Razor technology. 

Razor is an advanced provisioning application that can deploy both bare metal and virtual systems. It's aimed at solving the problem of how to bring new metal into a state that your existing configuration management systems, PE for example, can then take over.

*Note*: This is a Tech Preview release of Razor. For more information, see the see the [Puppet Labs Tech Previews Info Page](TODO: link).

#### Puppet Agent with Non-Root Privileges 

In some situations, it may be desirable for a development team to manage their infrastructure on nodes in which they do not have root access. PE 3.2 lets users take advantage of PE's capabilities with puppet agents that can run without root privileges. Details can be found in the new [guide to non-root agents](./guides/nonroot_agent.html).

#### Disable/Enable Live Management

In some cases, it may be desirable to disable PE's orchestration capabilities. This can now be done easily by disabling live management, either by changing a config setting or during installation with an answer file entry. For more information, see [navigating live management](console_navigating_live_mgmt.html#disabling_enabling-live-management).

#### Support for Solaris 11

The puppet agent can now be installed on nodes running Solaris 11. Support is only for agents. For more information, see the [system requirements](install_system_requirements.html).

#### Component Package Upgrades

Several of the “under the hood” constituent parts of Puppet Enterprise have been updated in version 3.2. Most notably these include:

* Puppet 3.4.2
* PuppetDB 1.5.2
* Facter 1.7.4.
* MCollective 2.2.4
* Hiera 1.3.0.
* Dashboard 2.1.0

#### Security Fixes

[*CVE-2014-0082 ActionView vulnerability in Ruby on Rails*](http://puppetlabs.com/security/cve/cve-2014-0082)

Assessed Risk Level: medium. The text rendering component of ActionView is vulnerable to denial of service attacks. Strings in specially crafted headers are converted to symbols, but since the symbols are not removed by ruby's garbage collector, they can outgrow the heap and bring down the rails process. For more information, please visit the [ruby security Google group](https://groups.google.com/forum/#!topic/ruby-security-ann/ZaQ0-g1gUpc).

[*CVE-2014-0060 PostgreSQL security bypass vulnerability*](http://puppetlabs.com/security/cve/cve-2014-0060)

Assessed Risk Level: medium. PostgreSQL did not properly enforce the `WITH ADMIN OPTION` permission for role management, which allowed any member of a role the ability to grant others access to the same role regardless if the member was given the `WITH ADMIN OPTION` permission. For complete details, please see the ["SET ROLE bypasses lack of ADMIN OPTION" entry on the PostgreSQL wiki](http://wiki.postgresql.org/wiki/20140220securityrelease)

[*CVE-2013-4966 Master external node classification script vulnerable to console impersonation*](http://puppetlabs.com/security/cve/cve-2013-4966)

Assessed Risk Level: medium. The script that the PE master used to contact the PE console for node classification did not verify the identity of the console. This introduced a vulnerability in which an attacker could impersonate the console and submit malicious classification to the master.

[*CVE-2013-4971 Unathenticated read access to node endpoints could cause information leakage*](http://puppetlabs.com/security/cve/cve-2013-4971)

Assessed Risk Level: medium. Unauthenticated read access to the node endpoint in the console could result in information leakage in PE versions earlier than 3.2.

               
Known Issues
-----

As we discover them, this page will be updated with known issues in Puppet Enterprise 3.2 and earlier. Fixed issues will be removed from this list and noted above in the release notes. If you find new problems yourself, please file bugs in Puppet [here][puppetissues] and bugs specific to Puppet Enterprise [here][peissues].

To find out which of these issues may affect you, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `3.2.0 (Puppet Enterprise 3.2)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](./install_upgrading.html).

[peissues]: http://projects.puppetlabs.com/projects/puppet-enterprise/issues
[puppetissues]: http://projects.puppetlabs.com/projects/puppet/issues


The following issues affect the currently shipped version of PE and all prior releases through the 2.x.x series, unless otherwise stated.

### Safari Certificate Handling May Prevent Console Access for PE 3.2

Due to [Apache bug 53193](https://issues.apache.org/bugzilla/show_bug.cgi?id=53193) and the way Safari handles certificates, Puppet Labs recommends that PE 3.2 users avoid using Safari to access the PE console. 

If you need to use Safari, you may encounter the following dialog box the first time you attempt to access the console after installing/upgrading PE 3.2: 

![Safari Certificate Dialog][client_cert_dialog]

If you are presented with this dialog box, click "Cancel" to access the console. (In some cases, you may need to click "Cancel" several times.)

This issue will be fixed in a future release.

### Passenger Global Queue Error on Upgrade

When upgrading a PE 2.8.3 master to PE 3.2.0, restarting `pe-httpd` produces a warning: `The 'PassengerUseGlobalQueue' option is obsolete: global queueing is now always turned on. Please remove this option from your configuration file.` This error will not affect anything in PE, but if you wish you can turn it off by removing the line in question from `/etc/puppetlabs/httpd/conf.d/passenger-extra.conf`.

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

For instructions on completely deactivating an agent node, refer to [Deactivating a PE Agent Node](./node_deactivation.html).

### Errors Related to Stopping `pe-postresql` Service

If for any reason the `pe-postresql` service is stopped, agents will receive several different error messages, for example:

    Warning: Unable to fetch my node definition, but the agent run will continue:
    Warning: Error 400 on SERVER: (<unknown>): mapping values are not allowed in this context at line 7 column 28
    
or, when attempting to request a catalog:

    Error: Could not retrieve catalog from remote server: Error 400 on SERVER: (<unknown>): mapping values are not allowed in this context at line 7 column 28
    Warning: Not using cache on failed catalog
    Error: Could not retrieve catalog; skipping run
    
If you encounter these errors, simply re-start the `pe-postgresql` service.

[client_cert_dialog]: ./images/client_cert_dialog.png

* * *

- [Next: Compliance: Alternate Workflow](./compliance_alt.html)
