---
layout: default
title: "PE 3.2 » Appendix"
subtitle: "User's Guide Appendix"
canonical: "/pe/latest/release_notes.html"
---

[client_cert_dialog]: ./images/client_cert_dialog.png

[pe-apache]: http://forge.puppetlabs.com/puppetlabs/apache
[pe-ntp]: http://forge.puppetlabs.com/puppetlabs/ntp
[pe-mysql]: http://forge.puppetlabs.com/puppetlabs/mysql
[windows-registry]: http://forge.puppetlabs.com/puppetlabs/registry
[pe-postgresql]: http://forge.puppetlabs.com/puppetlabs/postgresql
[pe-stdlib]: http://forge.puppetlabs.com/puppetlabs/stdlib
[pe-reboot]: http://forge.puppetlabs.com/puppetlabs/reboot
[pe-firewall]: http://forge.puppetlabs.com/puppetlabs/firewall
[pe-apt]: http://forge.puppetlabs.com/puppetlabs/apt
[pe-inifile]: http://forge.puppetlabs.com/puppetlabs/inifile
[pe-javaks]: http://forge.puppetlabs.com/puppetlabs/java_ks
[pe-concat]: http://forge.puppetlabs.com/puppetlabs/concat

This page contains additional miscellaneous information about Puppet Enterprise (PE) 3.2.

Puppet Terminology
-----

For help with Puppet-specific terms and language, visit [the glossary](/references/glossary.html)

For a complete guide to the Puppet language, visit [the reference manual](/puppet/3/reference/)

Release Notes
-----

### PE 3.2.3 (5/1/2014)

#### Security Fixes

On April 15th, Oracle announced several security vulnerabilities in Java. Puppet Enterprise versions 3.0.0 through 3.2.2 contain a vulnerable version of Java. [Puppet Enterprise 3.2.3 contains an updated version of Java that has patched the vulnerabilities](https://puppetlabs.com/security/cve/oracle-april-vulnerability-fix).

For more information about the Java vulnerabilities, refer to the [Oracle security site](http://www.oracle.com/technetwork/topics/security/cpuapr2014-1972952.html).

### PE 3.2.2 (4/15/2014)

#### Bug Fixes

This release fixes several minor bugs.

#### Bad Data in Facter’s `architecture` Fact

Previously on AIX agents, a bug caused Facter to return the system’s model number (e.g., IBM 3271) instead of the processor’s architecture (e.g. Power6).

#### `puppet module list --tree` Didn't Work Without `metadata.json`

Previously, if you ran `puppet module generate <module name>` or manually created a module directory on the PE module path (`/etc/puppetlabs/puppet/module`) you would get a module structure that did not include `metadata.json`, which is required to run `puppet module list --tree`.

#### Security Fixes

*[CVE-2014-2525 LibYAML vulnerability could allow arbitrary code execution in a URI in a YAML file](http://puppetlabs.com/security/cve/cve-2014-2525)*

Assessed Risk Level: medium. For LibYAML versions before 0.1.6, heap-based buffer overflow in the `yaml_parser_scan_uri_escapes` could allow attackers to execute arbitrary code via a long sequence of percent-endcoded characters in a URI in a YAML file.

CVSS v2 score: 5.0 with Vector (AV:N/AC:M/Au:N/C:P/I:P/A:P/E:U/RL:OF/RC:C)

*[CVE-2014-0098 Apache vulnerability in config module could allow denial of service attacks via cookies](http://puppetlabs.com/security/cve/cve-2014-0098)*

Assessed Risk Level: medium. For Apache versions earlier than 2.4.8, the `log_cookie` function in `mod_log_config.c` in the `mod_log_config` module could allow remote attackers to cause a denial of service attack via a crafted cookie that is not properly handled during truncation.

* For RHEL, SLES, CentOS, and Scientific Linux systems CVSS v2 score: 5.3 v2 Vector (AV:N/AC:M/Au:N/C:N/I:N/A:C/E:U/RL:OF/RC:C)

* For Debian and Ubuntu systems CVSS v2 score: 4.0 v2 Vector (AV:N/AC:H/Au:N/C:N/I:N/A:C/E:U/RL:OF/RC:C)

The variation in score is because `mod_log_config` is enabled by default on RHEL, CentOS, SLES, and Scientific Linux systems. The module is not enabled by default on Debian and Ubuntu.

*[CVE-2013-6438 Apache vulnerability in `mod_dav` module could allow denial of service attacks via DAV WRITE requests](http://puppetlabs.com/security/cve/cve-2013-6438)*

Assessed Risk Level: medium. For Apache versions earlier than 2.4.8, the `dav_xml_get_cdata` function in `main/util.c` in the `mod_dav` module does not properly remove leading spaces could allow remote attackers to cause a denial of service attack via a crafted DAV WRITE request.

CVSS v2 score: 4.0 with Vector (AV:N/AC:H/Au:N/C:N/I:N/A:C/E:U/RL:OF/RC:C)

#### A Note about the Heartbleed Bug

We want to emphasize that Puppet Enterprise does not need to be patched for Heartbleed.

No version of Puppet Enterprise has been shipped with a vulnerable version of OpenSSL, so Puppet Enterprise is not itself vulnerable to the security bug known as Heartbleed, and does not require a patch from Puppet Labs.

However, some of your Puppet Enterprise-managed nodes could be running operating systems that include OpenSSL versions 1.0.1 or 1.0.2, and both of these are vulnerable to the Heartbleed bug. Since tools included in Puppet Enterprise, such as PuppetDB and the Console, make use of SSL certificates we believe the safest, most secure method for assuring the security of your Puppet-managed infrastructure is to regenerate your certificate authority and all OpenSSL certificates.

We have outlined the remediation procedure to help make it an easy and fail-safe process. You’ll find the details here: Remediation for [Recovering from the Heartbleed Bug](/trouble_remediate_heartbleed_overview.html).

We’re here to help. If you have any issues with remediating the Heartbleed vulnerability, one of your authorized Puppet Enterprise support users can always log into the [customer support portal](https://support.puppetlabs.com/access/unauthenticated). We’ll continue to update the email list with any new information.

Links:

* [Heartbleed and Puppet-Supported Operating Systems](https://puppetlabs.com/blog/heartbleed-and-puppet-supported-operating-systems)

* [Heartbleed Update: Regeneration Still the Safest Path](https://puppetlabs.com/blog/heartbleed-update-regeneration-still-safest-path)

### PE 3.2.1 (3/19/2014)

#### Bug Fixes

This release fixes several minor bugs, including issues with upgrades and installations in environments with separated `/var` and `/opt` directories.

#### OpenSSL Support on AIX

With this release, it is no longer necessary to manually install OpenSSL on AIX nodes. OpenSSL is now automatically added with PE.

### PE 3.2.0 (3/4/2014)

#### Puppet Enterprise Supported Modules

PE 3.2 introduces Puppet Enterprise supported modules. PE supported modules allow you to manage core services quickly and easily, with very little need for you to write any code. PE supported modules are:

* rigorously tested with PE
* supported by Puppet Labs via the usual [support channels](http://puppetlabs.com/services/customer-support) (PE customers only)
* maintained for a long-term lifecycle
* compatible with multiple platforms and architectures.

Visit the [supported modules page](http://forge.puppetlabs.com/supported) to learn more. You can also check out the Read Me for each supported module being released with PE 3.2: [Apache][pe-apache], [NTP][pe-ntp], [MySQL][pe-mysql], [Windows Registry][windows-registry], [PostgreSQL][pe-postgresql], [stdlib][pe-stdlib], [reboot][pe-reboot], [firewall][pe-firewall], [apt][pe-apt], [INI-file][pe-inifile], [java_ks][pe-javaks], [concat][pe-concat].


#### Simplified Agent Install

On platforms that natively support remote package repos, agents can now be installed via package management tools, making the installation process faster and simpler. This will be especially useful for highly dynamic, virtualized infrastructures. For details, visit the [PE installation page](install_basic.html#installing-agents).

#### Razor Provisioning Tech Preview

PE 3.2 offers a [tech preview](http://puppetlabs.com/services/tech-preview) of new, bare-metal provisioning capabilities using Razor technology. Razor aims to solve the problem of how to bring new metal, be it in your machine room or in the cloud, into a state that PE can then take over and manage. It does this by discovering bare metal machines and then installing and configuring operating systems and/or hypervisors on them. For more information, refer to the [Razor documentation](./razor_intro.html).

> *Note*: Razor is included in Puppet Enterprise 3.2 as a tech preview. Puppet Labs tech previews provide early access to new technology still under development. As such, you should only use them for evaluation purposes and not in production environments. You can find more information on tech previews on the [tech preview support scope page](http://puppetlabs.com/services/tech-preview).


#### Symlinks

The answer file no longer gives the option of whether to install symlinks. These are now automatically installed by packages. To allow the creation of symlinks, you need to ensure that /usr/local is writable.

#### Puppet Agent with Non-Root Privileges

In some situations, a development team may wish to manage infrastructure on nodes to which they do not have root access. PE 3.2 lets users take advantage of PE's capabilities with puppet agents that can run without root privileges. You can learn more in the new [guide to non-root agents](deploy_nonroot-agent.html).

#### Agent Support for Solaris 11

The puppet agent can now be installed on nodes running Solaris 11. Other roles (e.g., master, console) are not supported. For more information, see the [system requirements](install_system_requirements.html).

#### Manifest Compilation and Other Puppet Code Issues with UTF-8 encoding

PE 3 uses an updated version of Ruby, 1.9, that is much stricter about character encodings than the version of Ruby used in PE 2.8. As a result, puppet code that contains non-ASCII characters can fail or act unpredictably. There are a number of ways UTF-8 characters can make it into puppet code, including but not limited to downloading a Forge module where some piece of metadata (e.g. author's name) contains UTF-8 characters. With apologies to our international customers, the current solution is to strictly limit puppet code, including metadata, to the ASCII character set. The only exception is puppet manifest comments, which do support non-ASCII characters. Puppet Labs is working on resolving character encoding issues in Puppet and the various libraries it interfaces with.

#### Disable/Enable Live Management

In some cases, you may want to disable PE's orchestration capabilities. This can now be done easily by disabling live management, either by changing a config setting or during installation with an answer file entry. For more information, see [navigating live management](console_navigating_live_mgmt.html) and the [installation instructions](install_basic.html).

#### Hiera Configuration Variables Changed Between PE3.1 and PE3.2

In PE3.2, Hiera variables were updated to include `::pe` in the name. If you set Hiera variables in PE3.1 and then upgrade to PE3.2, Hiera variables will revert back to the default values. You may experience performance issues as a result.

For example, in PE3.1, the `java_args` variable was set using `pe_puppetdb::java_args` but in PE3.2 it is set using `pe_puppetdb::pe::java_args`. In PE3.1, the `database_config_hash` variable was set using `pe_puppetdb::database::database_config_hash` but in PE3.2 it is set using `pe_puppetdb::pe::database::database_config_hash`.

To avoid reverting back to the default values, add `::pe` to the variable name.

#### Component Package Upgrades

Several of the "under the hood" constituent parts of Puppet Enterprise have been updated in version 3.2. Most notably these include:

* Puppet 3.4.3
* PuppetDB 1.5.2
* Facter 1.7.5
* MCollective 2.2.4
* Hiera 1.3.2
* Dashboard 2.1.1

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

As we discover them, this page will be updated with known issues in Puppet Enterprise 3.2 and earlier. Fixed issues will be removed from this list and noted above in the release notes. If you find new problems yourself, please file bugs in [our issue tracker](https://tickets.puppetlabs.com).

To find out which of these issues may affect you, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `3.2.0 (Puppet Enterprise 3.2)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](install_upgrading.html).

The following issues affect the currently shipped version of PE and all prior releases through the 2.x.x series, unless otherwise stated.

### PostgreSQL Buffer Memory Issue Can Cause PE Install to Fail on Machines with Large Amounts of RAM

In some cases, when installing PE on machines with large amounts of RAM, the PostgreSQL database will use more shared buffer memory than is available and will not be able to start. This will prevent PE from installing correctly. For more information and a suggested workaround, refer to [Troubleshooting the Console and Database](./trouble_console-db.html#postgresql-memory-buffer-causes-pe-install-to-fail).

### Upgrades to PE 3.x from 2.8.3 Can Fail if PostgreSQL is Already Installed

There are two scenarios in which your upgrade can fail:

1. If PostgreSQL is already running on port 5432 on the server assigned the database support role, pe-postgresql won't be able to start.

2. Another version of PostgreSQL is not running, but `which psql` resolves to something other than `/opt/puppet/bin/psql`, which is the instance used by PE.

   In this second scenario, you'll see the following failure output:

       ## Performing migration of the console database. This may take a while...
       DEPRECATION WARNING: You have Rails 2.3-style plugins in vendor/plugins! Support for these plugins will be removed in  Rails    4.0. Move them out and bundle them in your Gemfile, or fold them in to your app as lib/myplugin/* and  config/initializers/myplugin.rb. See the release notes for more on this:    http://weblog.rubyonrails.org/2012/1/4/rails-3-2-0-rc2-has-been-released. (called from <top (required)> at   /opt/puppet/share/puppet-dashboard/Rakefile:16)
       psql: could not connect to server: No such file or directory
       Is the server running locally and accepting
       connections on Unix domain socket "/tmp/.s.PGSQL.5432"?
       Database transfer failed.

To work around these issues, ensure the PostgreSQL service is stopped before installing PE. To determine if PostgreSQL is running, run `service status postgresql`. If an equivalent of "stopped" or "no such service" is returned, the service is not running. If the service is running, stop it (e.g., `service postgresql stop`) and disable it (`chkconfig postgresql off`).

To resolve the issue make sure that `which psql` resolves to `/opt/puppet/bin/psql`.

### Upgrades from 3.2.0 Can Cause Issues with Multi-Platform Agent Packages

Users upgrading from PE 3.2.0 to a later version of 3.x (including 3.2.3) will see errors when attempting to download agent packages for platforms other than the master. After adding `pe_repo` classes to the master for desired agent packages, errors will be seen on the subsequent puppet run as PE attempts to access the requisite packages. For a simple workaround to this issue, see the [installer troubleshooting page](/trouble_install.html).

### Nonexistent manifestdir 500 Internal Server Error

If you specify a manifestdir in `puppet.conf` that does not exist, a 500 internal server error will be raised on subsequent puppet runs.

### Live Management Cannot Uninstall Packages on Windows Nodes

An issue with MCollective prevents correct uninstallation of packages on nodes running Windows. Packages on Windows nodes can be uninstalled using Puppet, for example:
        package
            { 'Google Chrome': ensure => absent, }

The issue is being tracked on [this support ticket](https://tickets.puppetlabs.com/browse/MCOP-14).

### Upgrades to PE 3.2.x or Later Removes Commented Authentication Sections from `rubycas-server/config.yml`

If you are upgrading to PE 3.2.x or later, `rubycas-server/config.yml` will not contain the commented sections for the third-party services. We've provided the commented sections on [the console config page](./console_config.html#configuring-rubycas-server-config-yml), which you can copy and paste into `rubycas-server/config.yaml` after you upgrade.

### `pe_mcollective` Module Integer Parameter Issue

The `pe_mcollective` module includes a parameter for the ActiveMQ heap size (`activemq_heap_mb`). A bug prevents this parameter from correctly accepting an integer when one is entered in the console. The problem can be avoided by placing the integer inside quote marks (e.g., `"10"`). This will cause Puppet to correctly validate the value when it is passed from the console.

### Safari Certificate Handling May Prevent Console Access for PE 3.2

Due to [Apache bug 53193](https://issues.apache.org/bugzilla/show_bug.cgi?id=53193) and the way Safari handles certificates, Puppet Labs recommends that PE 3.2 users avoid using Safari to access the PE console.

If you need to use Safari, you may encounter the following dialog box the first time you attempt to access the console after installing/upgrading PE 3.2:

![Safari Certificate Dialog][client_cert_dialog]

If this happens, click __Cancel__ to access the console. (In some cases, you may need to click __Cancel__ several times.)

This issue will be fixed in a future release.

### `puppet module list --tree` Shows Incorrect Dependencies After Uninstalling Modules

If you uninstall a module with `puppet module uninstall <module name>` and then run `puppet module list --tree`, you will get a tree that does not accurately reflect module dependencies.

### Passenger Global Queue Error on Upgrade

When upgrading a PE 2.8.3 master to PE 3.2.0, restarting `pe-httpd` produces a warning: `The 'PassengerUseGlobalQueue' option is obsolete: global queueing is now always turned on. Please remove this option from your configuration file.` This error will not affect anything in PE, but if you wish you can turn it off by removing the line in question from `/etc/puppetlabs/httpd/conf.d/passenger-extra.conf`.

### `puppet resource` Fails if `puppet.conf` is Modified to Make `puppet apply` Work with PuppetDB.

In an effort to make `puppet apply` work with PuppetDB in masterless puppet scenarios, users may edit puppet.conf to make storeconfigs point to PuppetDB. This breaks `puppet resource`, causing it to fail with a Ruby error. For more information, see the [console & database troubleshooting page](./trouble_console-db.html), and for a workaround see the [PuppetDB documentation on connecting `puppet apply`](/puppetdb/1.5/connect_puppet_apply.html).

### Puppet Agent on Windows Requires `--onetime`

On Windows systems, puppet agent runs started locally from the command line require either the `--onetime` or `--test` option to be set. This is due to Puppet bug [PUP-1275](https://tickets.puppetlabs.com/browse/PUP-1275).

### BEAST Attack Mitigation

A known weakness in Apache HTTPD leaves it vulnerable to a man-in-the-middle attack known as the BEAST (Browser Exploit Against SSL/TLS) attack. The vulnerability exists because Apache HTTPD uses a FIPS-compliant cipher suite that can be cracked via a brute force attack that can discover the decryption key. If FIPS compliance is not required for your infrastructure, we recommend you mitigate vulnerability to the BEAST attack by using a cipher suite that includes stronger ciphers. This can be done as follows:

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

### console_auth Fails After PostgreSQL Restart

RubyCAS server, the component which provides console log-in services will not automatically reconnect if it loses connection to its database, which can result in a `500 Internal Server Error` when attempting to log in or out. The issue can be resolved by restarting Apache on the console's node with `sudo /etc/init.d/pe-httpd restart`.

### Inconsistent Counts When Comparing Service Resources in Live Management

In the Browse Resources tab, comparing a service across a mixture of RedHat-based and Debian-based nodes will give different numbers in the list view and the detail view.

### Augeas File Access Issue

On AIX agents, the Augeas lens is unable to access or modify `etc/services`. There is no known workaround.

### After Upgrading, Nodes Report a "Not a PE Agent" Error

When doing the first puppet run after upgrading using the "upgrader" script included in PE tarballs, agents are reporting an error: "&lt;node.name&gt; is not a Puppet Enterprise agent." This was caused by a bug in the upgrader that has since been fixed. If you downloaded a tarball prior to November 28, 2012, simply download the tarball again to get the fixed upgrader. If you prefer, you can download the [latest upgrader module](http://forge.puppetlabs.com/adrien/pe_upgrade/0.4.0-rc1) from the Forge. Alternatively, you can fix it by changing `/etc/puppetlabs/facter/facts.d/is_pe.txt`  to contain: `is_pe=true`.

### Answer File Required for Some SMTP Servers

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

### puppetlabs-apt 1.4.0 uses functions that are not shipped as part of puppetlabs-stdlib 3.2.0

PE 3.2.x ships with puppetlabs-apt 1.4.0 and puppetlabs-stdlib 3.2.0 preinstalled. The puppetlabs-apt module attempts to use a function from stdlib that is not present in puppetlabs-stdlib 3.2.0.

To work around this issue, you may upgrade to puppetlabs-apt 1.4.2, which is the latest supported release, using the puppet module tool:

`puppet module upgrade puppetlabs-apt`

### Razor Known Issues
Please see the page [Razor Setup Recommendations and Known Issues](./razor_knownissues.html).


* * *

- [Next: Compliance: Alternate Workflow](./compliance_alt.html)
