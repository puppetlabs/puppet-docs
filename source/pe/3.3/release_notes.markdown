---
layout: default
title: "PE 3.3 » Release Notes"
subtitle: "Puppet Enterprise 3.3.0 Release Notes"
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

This page contains information about the Puppet Enterprise (PE) 3.3.0 release, including new features, known issues, bug fixes and more.

## New Features

Puppet Enterprise 3.3 introduces the following new features and improvements.

### Puppet Enterprise Installer Improvements

This release introduces a web-based interface meant to simplify—and provide better clarity into—the PE installation experience. You now have a few paths to choose from when installing PE.

- Perform a guided installation using the web-based interface. Think of this as an installation interview in which we ask you exactly how you want to install PE. If you're able to provide a few SSH credentials, this method will get you up and running fairly quickly. Refer to the [installation overview](./install_basic.html) for more information.

- Use the web-based interface to create an answer file that you can then add as an argument to the installer script to perform an installation (e.g., `sudo ./puppet-enterprise-installer -a ~/my_answers.txt`). Refer to [Automated Installation with an Answer File](./install_automated.html), which provides an overview on installing PE with an answer file.

- Write your own answer file or use the answer file(s) provided in the PE installation tarball. Check the [Answer File Reference Overview](./install_answer_file_reference.html) to get started.


### Manifest Ordering

Puppet Enterprise is now using a new `ordering` setting in the Puppet core that allows you to configure how unrelated resources should be ordered when applying a catalog. By default, `ordering` will be set to `manifest` in PE.

The following values are allowed for the `ordering` setting:

* `manifest`: (default) uses the order in which the resources were declared in their manifest files.
* `title-hash`: orders resources randomly, but will use the same order across runs and across nodes; this is the default in previous versions of Puppet.
* `random`: orders resources randomly and change their order with each run. This can work like a fuzzer for shaking out undeclared dependencies.

Regardless of this setting's value, Puppet will always obey explicit dependencies set with the `before`/`require`/`notify`/`subscribe` metaparameters and the `->`/`~>` chaining arrows; this setting only affects the relative ordering of *unrelated* resources.

For more information, and instructions on changing the `ordering` setting, refer to the [Puppet Modules and Manifest Page](./puppet_modules_manifests.html#about-manifest-ordering).

### Directory Environments and Deprecation Warnings

[dir_environments]: http://docs.puppetlabs.com/puppet/latest/reference/environments.html
[config_envir]: http://docs.puppetlabs.com/puppet/latest/reference/environments_classic.html

The latest version of the Puppet core (Puppet 3.6) deprecates the classic [config-file environments][config_envir] in favor of the new and improved [directory environments][dir_environments]. Over time, both Puppet open source and Puppet Enterprise will make more extensive use of this pattern.

Environments are isolated groups of puppet agent nodes. This frees you to use different versions of the same modules for different populations of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines. (You could also do this by running a separate puppet master for testing, but using environments is often easier.)

In this release of PE, please note that if you define environment blocks or use any of the `modulepath`, `manifest`, and `config_version` settings in `puppet.conf`, you will see deprecation warnings intended to prepare you for these changes. Configuring PE to use *no* environments will also produce deprecation warnings.

Once PE has fully moved to directory environments, the default `production` environment will take the place of the global `manifest`/`modulepath`/`config_version` settings.

**PE 3.3 User Impact**

If you use an environment config section in `puppet.conf`, you will see a deprecation warning similar to

     # puppet.conf
     [legacy]
     # puppet config print confdir
     Warning: Sections other than main, master, agent, user are deprecated in puppet.conf. Please use the directory environments feature to specify  environments. (See http://docs.puppetlabs.com/puppet/latest/reference/environments.html)
        (at /usr/lib/ruby/site_ruby/1.8/puppet/settings/config_file.rb:77:in `collect')
    /etc/puppet

Using the `modulepath`, `manifest`, or `config_version` settings will raise a deprecation warning similar to

     # puppet.conf
     [main]
     modulepath = /tmp/foo
     manifest = /tmp/foodir
     config_version = /usr/bin/false

    # puppet config print confdir
    Warning: Setting manifest is deprecated in puppet.conf. See http://links.puppetlabs.com/env-settings-deprecations
        (at /usr/lib/ruby/site_ruby/1.8/puppet/settings.rb:1065:in `each')
    Warning: Setting modulepath is deprecated in puppet.conf. See http://links.puppetlabs.com/env-settings-deprecations
        (at /usr/lib/ruby/site_ruby/1.8/puppet/settings.rb:1065:in `each')
    Warning: Setting config_version is deprecated in puppet.conf. See http://links.puppetlabs.com/env-settings-deprecations
        (at /usr/lib/ruby/site_ruby/1.8/puppet/settings.rb:1065:in `each')

> **Note**: Executing puppet commands will raise the `modulepath` deprecation warning.

> **About Disabling Deprecation Warnings**
>
> You can disable deprecation warnings by adding `disable_warnings = deprecations` to the `[main]` section of `puppet.conf`. However, please note that this will disable **ALL** deprecation warnings. We recommend that you re-enable deprecation warnings when upgrading so that you don't potentially miss new warnings.

The Puppet 3.6 documentation has a comprehensive overview on working with [directory environments][dir_environments].

### New Puppet Enterprise Supported Modules

This release adds new modules to the list of Puppet Enterprise supported modules: ACL (for Windows), vcsrepo, and Windows PowerShell. Visit the [supported modules](https://forge.puppetlabs.com/supported) page to learn more, or check out the ReadMes for [ACL](https://forge.puppetlabs.com/puppetlabs/acl/1.0.1), [vcsrepo](https://forge.puppetlabs.com/puppetlabs/vcsrepo/1.0.2), and [PowerShell](https://forge.puppetlabs.com/puppetlabs/powershell/1.0.1).

### Puppet Module Tool (PMT) Improvements

The PMT has been updated to deprecate the Modulefile in favor of metadata.json. To help ease the transition, when you run `puppet module generate` the module tool will kick off an interview and generate metadata.json based on your responses.

If you have already built a module and are still using a Modulefile, you will receive a deprecation warning when you build your module with `puppet module build`. You will need to perform [migration steps](http://docs.puppetlabs.com/puppet/latest/reference/modules_publishing.html#build-your-module) before you publish your module. For complete instructions on working with metadata.json, see [Publishing Modules](http://docs.puppetlabs.com/puppet/latest/reference/modules_publishing.html)

Please see [Known Issues](#known-issues) for information about a bug impacting modules that were built with the new PMT but did not perform the migration steps.

### Console Data Export

Every node list view in the console now includes a link to export the table data in CSV format, so that you can include the data in a spreadsheet or other tool.

### Support for Red Hat Enterprise Linux 7

This release provides full support for RHEL 7 for all applicable PE features and capabilities. For more information, see the [system requirements](./install_system_requirements.html).

### Support for Ubuntu 14.04 LTS

This release provides full support for Ubuntu 14.04 LTS for all applicable PE features and capabilities. For more information, see the [system requirements](./install_system_requirements.html).

### Support for Mac OS X (Agent Only)

The puppet agent can now be installed on nodes running Mac OS X Mavericks (10.9). Other components (e.g., master) are not supported. For more information, see the [system requirements](./install_system_requirements.html) and the [Mac OS X installation instructions](./install_osx.html).

### Support for Windows 2012 R2 (Agent Only)

This release provides agent only support for nodes running Windows 2012 R2. For more information, see the [system requirements](./install_system_requirements.html) and [Installing Windows Agents](./install_windows.html).

### Additional OS Support for Agent Install via Package Management Tools

This release increases the number of PE supported operating systems than can install agents via package management tools, making the agent installation process faster and simpler. For details, visit [Installing Puppet Enterprise Agents](./install_agents.html).

### Support for stdlib 4

This version of PE is fully compatible with version 4.x of stdlib.

### Razor Provisioning Tech Preview Usability Enhancements and Bug Fixes

Razor is included in PE 3.3 as a [tech preview](http://puppetlabs.com/services/tech-preview). This version of Razor includes usability enhancements and bug fixes. For more information, refer to the [Razor documentation](./razor_intro.html).

>**Note**: Razor is included in Puppet Enterprise 3.3 as a tech preview. Puppet Labs tech previews provide early access to new technology still under development. As such, you should only use them for evaluation purposes and not in production environments. You can find more information on tech previews on the [tech preview](http://puppetlabs.com/services/tech-preview) support scope page.

## Security Fixes

[CVE-2014-0224 OpenSSL vulnerability in secure communications](http://puppetlabs.com/security/cve/cve-2014-0224/)

**Assessed Risk Level**: medium

**Affected Platforms**:

* Puppet Enterprise 2.8 (Solaris, Windows)

* Puppet Enterprise 3.2 (Solaris, Windows, AIX)

Due to a vulnerability in OpenSSL versions 1.0.1 and later, an attacker could intercept and decrypt secure communications. This vulnerability requires that both the client and server be running an unpatched version of OpenSSL. Unlike heartbleed, this attack vector occurs after the initial handshake, which means encryption keys are not compromised. However, Puppet Enterprise encrypts catalogs for transmission to agents, so PE manifests containing sensitive information could have been intercepted. We advise all users to avoid including sensitive information in catalogs.

Puppet Enterprise 3.3.0 includes a patched version of OpenSSL.

CVSS v2 score: 2.4 with Vector: AV:N/AC:H/Au:M/C:P/I:P/A:N/E:U/RL:OF/RC:C

[CVE-2014-0198 OpenSSL vulnerability could allow denial of service attack](http://puppetlabs.com/security/cve/cve-2014-0198/)

**Assessed Risk Level**: low

**Affected Platforms**: Puppet Enterprise 3.2 (Solaris, Windows, AIX)

Due to a vulnerability in OpenSSL versions 1.0.0 and 1.0.1, if SSL\_MODE_\RELEASE\_BUFFERS is enabled, an attacker could cause a denial of service.

CVSS v2 score: 1.9 with Vector: AV:N/AC:H/Au:N/C:N/I:N/A:P/E:U/RL:OF/RC:C

[CVE-2014-3251 MCollective `aes_security` plugin did not correctly validated new server certs](http://puppetlabs.com/security/cve/cve-2014-3251/)

**Assessed Risk Level**: low

**Affected Platforms**:

* Mcollective (all)

* Puppet Enterprise 3.2

The MCollective `aes_security` public key plugin did not correctly validate new server certs against the CA certificate. By exploiting this vulnerability within a specific race condition window, an attacker with local access could initiate an unauthorized Mcollective client connection with a server. Note that this vulnerability requires that a collective be configured to use the `aes_security` plugin. Puppet Enterprise and open source Mcollective are not configured to use the plugin and are not vulnerable by default.

CVSS v2 score: 3.4 with Vector: AV:L/AC:H/Au:M/C:P/I:N/A:C/E:POC/RL:OF/RC:C

## Bug Fixes

The following is a basic overview of some of the bug fixes in this release:

* Installation - fixes improve installation so that the installer checks for config files and not just /etc/puppetlabs/, stops pe-puppet-dashboard-workers during upgrade, warns the user if there is not enough PostgreSQL disk space, and more.
* UI updates - fixes make the appearance and behavior more consistent across all areas of the console.

## Known Issues

As we discover them, this page will be updated with known issues in Puppet Enterprise 3.3 and earlier. Fixed issues will be removed from this list and noted above in the release notes. If you find new problems yourself, please file bugs in Puppet [here][puppetissues] and bugs specific to Puppet Enterprise [here][peissues].

To find out which of these issues may affect you, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `3.6.2 (Puppet Enterprise 3.3.0)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](install_upgrading.html).

[peissues]: http://projects.puppetlabs.com/projects/puppet-enterprise/issues
[puppetissues]: http://projects.puppetlabs.com/projects/puppet/issues


The following issues affect the currently shipped version of PE and all prior releases through the 3.x.x series, unless otherwise stated.

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

In an effort to make `puppet apply` work with PuppetDB in masterless puppet scenarios, users may edit puppet.conf to make storeconfigs point to PuppetDB. This breaks `puppet resource`, causing it to fail with a Ruby error. For more information, see the [console & database troubleshooting page](./trouble_console-db.html), and for a workaround see the [PuppetDB documentation on connecting `puppet apply`](http://docs.puppetlabs.com/puppetdb/1.5/connect_puppet_apply.html).

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

The PMT has a known issue wherein modules that were published to the Puppet Forge using the new PMT and that had not performed the [migration steps](http://docs.puppetlabs.com/puppet/latest/reference/modules_publishing.html#build-your-module) before publishing will have erroneous checksum information in their metadata.json. These checksums will cause errors that prevent you from upgrading or uninstalling the module.

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

For a complete guide to the Puppet language, visit [the reference manual](/puppet/3/reference/)

* * *

- [Next: Compliance: Alternate Workflow](./compliance_alt.html)
