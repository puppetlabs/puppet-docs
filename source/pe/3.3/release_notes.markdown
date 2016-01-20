---
layout: default
title: "PE 3.3 » Release Notes"
subtitle: "Puppet Enterprise 3.3.2 Release Notes"
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

This page contains information about the Puppet Enterprise (PE) 3.3.2 release as well as known issues for all versions of PE 3.3. For information on previous 3.x releases, including new features, bug fixes, security fixes, and more, see the [archived PE 3.x release notes](/pe/latest/release_notes_archive.html).

## Security Fixes (9/9/14)

#### [CVE-2014-0226 - Apache vulnerabilty in mod_status module could allow arbitrary code execution](http://puppetlabs.com/security/cve/cve-2014-0226/)

**Assessed risk level**: medium

**Affected platforms**: Puppet Enterprise 2.x and 3.x

**Resolved in**: Puppet Enterprise 2.8.8, 3.3.2

A race condition in the mod_status module in the Apache HTTP Server before 2.4.10 allows remote attackers to cause a denial of service (due to heap-based buffer overflow), or possibly obtain sensitive credential information or execute arbitrary code.

Upstream CVSS v2 Score: 4.4 with Vector:  AV:L/AC:M/Au:N/C:P/I:P/A:P/E:ND/RL:U/RC:C

#### [CVE-2014-0118 - Apache vulnerability in mod_deflate module could allow denial of service attacks](http://puppetlabs.com/security/cve/cve-2014-0118)

**Assessed risk level**: medium

**Affected platforms**: Puppet Enterprise 2.x and 3.x on Debian-based platforms only

**Resolved in**: Puppet Enterprise 2.8.8, 3.3.2

The `deflate_in_filter` function in the mod_deflate module in the Apache HTTP Server before 2.4.10 allows remote attackers to cause a denial of service (due to resource consumption) via crafted request data that decompresses to a much larger size.

Upstream CVSS v2 Score: 5.0 with Vector: AV:N/AC:L/Au:N/C:N/I:N/A:P/E:ND/RL:U/RC:C

#### [CVE-2014-0231 - Apache vulnerability in mod_cgid module could allow denial of service attacks](http://puppetlabs.com/security/cve/cve-2014-0231)

**Assessed risk level**: low

**Affected platforms**: Puppet Enterprise 2.x and 3.x on Debian-based platforms only

**Resolved in**: Puppet Enterprise 2.8.8, 3.3.2

The mod_cgid module in the Apache HTTP Server before 2.4.10 does not have a timeout mechanism, which allows remote attackers to cause a denial of service (due to process hang) via a request to a CGI script that does not read from its stdin file descriptor.

Upstream CVSS v2 Score: 2.6 with Vector: AV:N/AC:H/Au:N/C:N/I:N/A:P/E:ND/RL:U/RC:C)

#### Additional Security Information for this Release: OpenSSL Security Fixes

On August 6, the OpenSSL project announced several security vulnerabilities in OpenSSL. Puppet Enterprise 2.x and 3.x contained vulnerable versions of OpenSSL. Puppet Enterprise 2.8.8 and 3.3.2 contain updated versions of OpenSSL that have patched the vulnerabilities.

For more information about the OpenSSL vulnerabilities, refer to the [OpenSSL security site](https://www.openssl.org/news/vulnerabilities.html).

## Bug Fixes

**Incomplete /etc/inittab entry for pe-puppet service on AIX**

On AIX, the Puppet Enterprise installation created an incomplete /etc/inittab entry for the pe-puppet service. As a result, Puppet would not automatically start on boot unless the /etc/inittab entry was corrected.

This issue is now fixed.

**Ruby using incorrect LIBPATH on AIX**

Under certain conditions on AIX clients, Puppet Enterprise attempted to use an incorrect OpenSSL library, causing Puppet runs to fail with a Ruby "load failed" error.

This issue is fixed in PE 3.3.2.

## Known Issues

As we discover them, this page will be updated with known issues in Puppet Enterprise 3.3 and earlier. Fixed issues will be removed from this list and noted above in the release notes. If you find new problems yourself, please file bugs in [our issue tracker](https://tickets.puppetlabs.com).

To find out which of these issues may affect you, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `3.6.2 (Puppet Enterprise 3.3.0)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](install_upgrading.html).


The following issues affect the currently shipped version of PE and all prior releases through the 3.x.x series, unless otherwise stated.

### Nonexistent manifestdir 500 Internal Server Error

If the Puppet master's `/etc/puppetlabs/puppet/manifests` directory doesn't exist (or if you specify a manifestdir in `puppet.conf` that does not exist), a 500 internal server error will be raised on subsequent Puppet runs.

This can be caused if you move the `manifests` directory into an environment, as we previously recommended in the docs. We've corrected the docs; if you encounter this error, you can fix it by running `sudo mkdir /etc/puppetlabs/puppet/manifests` on your Puppet master(s).

### Puppet Enterprise Cannot Locate Samba init Script for Ubuntu 14.04

If you attempt to install and start Samba using PE resource management, you will may encounter the following errors:

    Error: /Service[smb]: Could not evaluate: Could not find init script or upstart conf file for 'smb'`
    Error: Could not run: Could not find init script or upstart conf file for 'smb'`

To workaround this issue, install and start Samba with the following commands:

    puppet resource package samba ensure=present
    puppet resource service smbd provider=init enable=true ensure=running
    puppet resource service nmbd provider=init enable=true ensure=running

### Errors Not Issued for Unprivileged Non-root Agent Actions on Windows

- If you run a PE agent on Windows with non-root privileges and attempt to create a file without the correct access, PE will fail the file creation but will not issue any warnings.

- If you run a PE agent on Windows with non-root privileges and attempt to create a registry key, PE will fail the registry key creation but will indicate they were created.

These issues will be fixed in a future release.


### PostgreSQL Buffer Memory Issue Can Cause PE Install to Fail on Machines with Large Amounts of RAM

In some cases, when installing PE on machines with large amounts of RAM, the PostgreSQL database will use more shared buffer memory than is available and will not be able to start. This will prevent PE from installing correctly. For more information and a suggested workaround, refer to [Troubleshooting the Console and Database](./trouble_console-db.html#postgresql-memory-buffer-causes-pe-install-to-fail).

### Manifest Compilation and Other Puppet Code Issues with UTF-8 encoding

PE 3 uses an updated version of Ruby, 1.9, that is much stricter about character encodings than the version of Ruby used in PE 2.8. As a result, puppet code that contains non-ASCII characters can fail or act unpredictably. There are a number of ways UTF-8 characters can make it into puppet code, including but not limited to downloading a Forge module where some piece of metadata (e.g. author's name) contains UTF-8 characters. With apologies to our international customers, the current solution is to strictly limit puppet code, including metadata, to the ASCII character set. The only exception is puppet manifest comments, which do support non-ASCII characters. Puppet Labs is working on resolving character encoding issues in Puppet and the various libraries it interfaces with.

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

To resolve the issue, make sure that `which psql` resolves to `/opt/puppet/bin/psql`.

### Upgrades from 3.2.0 Can Cause Issues with Multi-Platform Agent Packages

Users upgrading from PE 3.2.0 to a later version of 3.x (including 3.2.3) will see errors when attempting to download agent packages for platforms other than the master. After adding `pe_repo` classes to the master for desired agent packages, errors will be seen on the subsequent puppet run as PE attempts to access the requisite packages. For a simple workaround to this issue, see the [installer troubleshooting page](./trouble_install.html).

### You Might Need to Upgrade puppetlabs-inifile to Version 1.1.0 or Later
PE will automatically update your version of puppetlabs-inifile as part of the upgrade process. However, if you encounter the following error message on your PuppetDB node, then you need to manually upgrade the puppetlabs-inifile module to version 1.1.0 or higher.

	Error: Could not retrieve catalog from remote server: Error 400 on SERVER: Invalid parameter quote_char on Ini_subsetting['-Xmx'] on node master
	Warning: Not using cache on failed catalog
	Error: Could not retrieve catalog; skipping run

### Live Management Cannot Uninstall Packages on Windows Nodes

An issue with MCollective prevents correct uninstallation of packages on nodes running Windows. You can uninstall packages on Windows nodes using Puppet, for example:
        `package
            { 'Google Chrome': ensure => absent, }`

The issue is being tracked on [this support ticket](https://tickets.puppetlabs.com/browse/MCOP-14).

#### A Note about Symlinks

The answer file no longer gives the option of whether to install symlinks. These are now automatically installed by packages. To allow the creation of symlinks, you need to ensure that `/usr/local` is writable.

### Upgrades to PE 3.2.x or Later Remove Commented Authentication Sections from `rubycas-server/config.yml`

If you are upgrading to PE 3.2.x or later, `rubycas-server/config.yml` will not contain the commented sections for the third-party services. We've provided the commented sections on [the console config page](./console_config.html#configuring-rubycas-server-config-yml), which you can copy and paste into `rubycas-server/config.yaml` after you upgrade.

### `pe_mcollective` Module Integer Parameter Issue

The `pe_mcollective` module includes a parameter for the ActiveMQ heap size (`activemq_heap_mb`). A bug prevents this parameter from correctly accepting an integer when one is entered in the console. The problem can be avoided by placing the integer inside quote marks (e.g., `"10"`). This will cause Puppet to correctly validate the value when it is passed from the console.

### Custom Console Certs May Break on Upgrade

Upgrades from 3.3.0 to 3.3.1 or 3.3.2 may affect deployments that use a custom console certificate, as certificate functionality has changed between versions. Refer to [Configuring the Puppet Enterprise Console to Use a Custom SSL Certificate](./custom_console_cert.html) for instructions on re-configuring your custom console certificate.

### Safari Certificate Handling May Prevent Console Access

Due to [Apache bug 53193](https://issues.apache.org/bugzilla/show_bug.cgi?id=53193) and the way Safari handles certificates, Puppet Labs recommends that PE 3.3 users avoid using Safari to access the PE console.

If you need to use Safari, you may encounter the following dialog box the first time you attempt to access the console after installing/upgrading PE 3.3:

![Safari Certificate Dialog][client_cert_dialog]

If this happens, click __Cancel__ to access the console. (In some cases, you may need to click __Cancel__ several times.)

This issue will be fixed in a future release.

### `puppet module list --tree` Shows Incorrect Dependencies After Uninstalling Modules

If you uninstall a module with `puppet module uninstall <module name>` and then run `puppet module list --tree`, you will get a tree that does not accurately reflect module dependencies.

### Passenger Global Queue Error on Upgrade

When upgrading a PE 2.8.3 master to PE 3.3.0, restarting `pe-httpd` produces a warning: `The 'PassengerUseGlobalQueue' option is obsolete: global queueing is now always turned on. Please remove this option from your configuration file.` This error will not affect anything in PE, but if you wish, you can turn it off by removing the line in question from `/etc/puppetlabs/httpd/conf.d/passenger-extra.conf`.

### `puppet resource` Fails if `puppet.conf` is Modified to Make `puppet apply` Work with PuppetDB.

In an effort to make `puppet apply` work with PuppetDB in masterless puppet scenarios, users may edit puppet.conf to make storeconfigs point to PuppetDB. This breaks `puppet resource`, causing it to fail with a Ruby error. For more information, see the [console & database troubleshooting page](./trouble_console-db.html), and for a workaround see the [PuppetDB documentation on connecting `puppet apply`](/puppetdb/1.6/connect_puppet_apply.html).

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

If you see an error message after running this, you can disregard it. Readline-6 should be successfully installed, and you can proceed with the installation or upgrade (you can verify the installation with  `rpm -q readline`).

### Debian/Ubuntu Local Hostname Issue

On some versions of Debian/Ubuntu, the default `/etc/hosts` file contains an entry for the machine's hostname with a local IP address of 127.0.1.1. This can cause issues for PuppetDB and PostgreSQL, because binding a service to the hostname will cause it to resolve to the local-only IP address rather than its public IP. As a result, nodes (including the console) will fail to connect to PuppetDB and PostgreSQL.

To fix this, add an entry to `/etc/hosts` that resolves the machine's FQDN to its *public* IP address. This should be done prior to installing PE. However, if PE has already been installed, restarting the `pe-puppetdb` and `pe-postgresql` services after adding the entry to the hosts file should fix things.

### console_auth Fails After PostgreSQL Restart

RubyCAS server, the component which provides console log-in services, will not automatically reconnect if it loses connection to its database, which can result in a `500 Internal Server Error` when attempting to log in or out. You can resolve the issue by restarting Apache on the console's node with `sudo /etc/init.d/pe-httpd restart`.

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

Man pages generated with the `puppet man` subcommand are not formatted as proper man pages and are instead displayed as Markdown source text. This is a purely cosmetic issue, and the pages are still fully readable.

To improve the display of Puppet man pages, you can use your system `gem` command to install the `ronn` gem:

    $ sudo gem install ronn

### Deleted Nodes Can Reappear in the Console

Due to the fact that the console will create a node listing for any node found via the inventory search function, nodes deleted from the console can sometimes reappear. See the [console bug report describing the issue](https://projects.puppetlabs.com/issues/11210).

The nodes will reappear after deletion if PuppetDB data for that node has not yet expired, and you perform an inventory search in the console that returns information for that node.

You can avoid the reappearance of nodes by removing them with the following procedure:

1. `puppet node clean <node_certname>`
1. `puppet node deactivate <node_certname>`
1. `sudo /opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production node:del[<node_certname>]`

These steps will remove the node's certificate, purge information about the node from PuppetDB, and delete the node from the console. The last command is equivalent to logging into the console and deleting the node via the UI.

For instructions on completely deactivating an agent node, refer to [Deactivating a PE Agent Node](./node_deactivation.html).

### Errors Related to Stopping `pe-postgresql` Service

If for any reason the `pe-postgresql` service is stopped, agents will receive several different error messages, for example:

    Warning: Unable to fetch my node definition, but the agent run will continue:
    Warning: Error 400 on SERVER: (<unknown>): mapping values are not allowed in this context at line 7 column 28

or, when attempting to request a catalog:

    Error: Could not retrieve catalog from remote server: Error 400 on SERVER: (<unknown>): mapping values are not allowed in this context at line 7 column 28
    Warning: Not using cache on failed catalog
    Error: Could not retrieve catalog; skipping run

If you encounter these errors, simply re-start the `pe-postgresql` service.

### Modules Must Perform Migration Steps Before Being Published with the New Puppet Module Tool

The PMT has a known issue wherein modules that were published to the Puppet Forge using the new PMT and that had not performed the [migration steps](/puppet/3.6/reference/modules_publishing.html#build-your-module) before publishing will have erroneous checksum information in their metadata.json. These checksums will cause errors that prevent you from upgrading or uninstalling the module.

To determine if a module you're using has this issue, run `puppet module changes username-modulename`. If your module has this checksum issue, you will see that the metadata.json has been modified. If you try to upgrade or uninstall a module with this issue, you will receive warnings and your action will fail.

To work around this issue:
1. Navigate to the current version of the module.
2. If the checksums.json file is present, open it in your editor and delete the line: "metadata.json": [some checksum here]
3. If there is no checksums.json, open the metadata.json file in your editor and delete the entire 'checksums' field.

### The Puppet Module Tool (PMT) Does Not Support Solaris 10

When attempting to use the PMT on Solaris 10, you'll get an error like the following:

		Error: Could not connect via HTTPS to https://forgeapi.puppetlabs.com
  		Unable to verify the SSL certificate
    	The certificate may not be signed by a valid CA
    	The CA bundle included with OpenSSL may not be valid or up to date

This error is because there is no CA-cert bundle on Solaris 10 to trust the Puppet Labs Forge certificate.


### Razor Known Issues

Please see the page [Razor Setup Recommendations and Known Issues](./razor_knownissues.html).

Puppet Terminology
-----

For help with Puppet-specific terms and language, visit [the glossary](/references/glossary.html)

For a complete guide to the Puppet language, visit [the reference manual](/puppet/3.6/reference/)

* * *

