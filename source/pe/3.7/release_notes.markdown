---
layout: default
title: "PE 3.7 » Release Notes"
subtitle: "Puppet Enterprise 3.7.0 Release Notes"
canonical: "/pe/latest/release_notes.html"
---

This page contains information about the Puppet Enterprise (PE) 3.7.0 release, including new features, known issues, bug fixes and more.

## New Features

### Next-Generation Puppet Server

PE 3.7.0 introduces the Puppet server, built on a JVM stack, which functions as a seamless drop-in replacement for the former Apache/Passenger Puppet master stack.

For users upgrading from an earlier version of PE, there are a few things you'll notice after upgrading due to changes in the underlying architecture of the Puppet server.

[About the Puppet Server](./install_upgrading_puppet_server_notes.html) details some items that are intentionally different between the Puppet server and the Apache/Passenger stack; you may also be interested in the PE [Known Issues related to Puppet Server](#issues-related-to-puppet-server), where we've listed a handful of issues that we expect to fix in future releases.

[Graphing Puppet Server Metrics](./puppet_server_metrics.html) provides instructions on setting up a Graphite server running Grafana to track Puppet server performance metrics.

### Adding Puppet Masters to a PE Deployment

This release supports the ability to add additional Puppet masters to large PE deployments managing more than 1500 agent nodes. Using additional Puppet masters in such scenarios will provide quicker, more efficient compilation times as multiple masters can share the load of requests when agent nodes run.

For instructions on adding additional Puppet masters, refer to [Additional Puppet Master Installation](./install_multimaster.html).

### Node Manager

PE 3.7.0 introduces the rules-based node classifier, which is the first part of the Node Manager app that was announced in September. The node classifier provides a powerful and flexible new way to organize and configure your nodes. We’ve built a robust, API-driven backend service and an intuitive new GUI that encourages a modern, cattle-not-pets approach to managing your infrastructure. Classes are now assigned at the group level, and nodes are dynamically matched to groups based on user-defined rules.

For a detailed overview of the new node classifier, refer to the [PE user's guide](./console_classes_groups_getting_started.html).

### Role-Based Access Control

With RBAC, PE nodes can now be segmented so that tasks can be safely delegated to the right people. For example, RBAC allows segmenting of infrastructure across application teams so that they can manage their own servers without affecting other applications. Plus, to ease the administration of users and authentication, RBAC connects directly with standard directory services including Microsoft Active Directory and OpenLDAP.

For detailed information to get started with RBAC, see the [PE user's guide](./rbac_intro.html).

### Adding MCollective Hub and Spokes

PE 3.7.0 provides the ability to add additional ActiveMQ hubs and spokes to large PE deployments managing more than 1500 agent nodes. Building out your ActiveMQ brokers will provide efficient load balancing of network connections for relaying MCollective messages through your PE infrastructure.

For instructions on adding additional ActiveMQ Hubs and Spokes, refer to [Additional ActiveMQ Hub and Spoke Installation](./install_add_activemq.html).

### Upgrades to Directory Environments

PE 3.7.0 introduces full support for directory environments, which will be enabled by default.

Environments are isolated groups of puppet agent nodes. This frees you to use different versions of the same modules for different populations of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines. Directory environments let you add a new environment by simply adding a new directory of config data.

For your reference, we've provided some notes on what you may experience during upgrades from a previous version of PE. See [Important Information about Upgrades to PE 3.7 and Directory Environments](./install_upgrading_dir_env_notes.html).

Before getting started, visit the Puppet docs to read up on the [Structure of an  Environment](puppet/3.7/reference/environments_creating.html#structure-of-an-environment), [Global Settings for Configuring Environments](puppet/3.7/latest/reference/environments_configuring.html#global-settings-for-configuring-environments), and [creating directory environments](/puppet/3.7/reference/environments_creating.html).

#### A Note about `environment_timeout` in PE 3.7.0

The [environment_timeout](puppet/3.7/reference/environments_configuring.html#environmenttimeout) defaults to 3 minutes. This means that code changes you make might not appear until after that timeout has been reached. In addition it's possible that back to back runs of Puppet could flip between the new code and the old code until the `environment_timeout` is reached.

### Support Script Improvements

PE 3.7.0 includes several improvements to the support script, which is bundle in the PE tarball. Check out the [Getting Support page](./overview_getting_support.html#the-pe-support-script) for more information about the support script.

### SLES 10 Support (agent only)

This release provides support for SLES 10 for agent only installation.

For more information, see the [system requirements](./install_system_requirements.html).


## Security Fixes

### OpenSSL Security Vulnerabilities

On October 15th, the OpenSSL project announced several security vulnerabilities in OpenSSL. Puppet Enterprise versions prior to 3.7.0 contained vulnerable versions of OpenSSL. Puppet Enterprise 3.7 contains updated versions of OpenSSL that have patched the vulnerabilities.

For more information about the OpenSSL vulnerabilities, refer to the OpenSSL [security announcement](https://www.openssl.org/news/secadv_20141015.txt).

Affected Software Versions:
* Puppet Enterprise 2.x
* Puppet Enterprise 3.x

Resolved in:
Puppet Enterprise 3.7.0

### Oracle Java Security Vulnerabilities

Assessed Risk Level: Medium

On October 14th, Oracle announced several security vulnerabilities in Java. Puppet Enterprise versions prior to 3.7.0 contained a vulnerable version of Java. Puppet Enterprise 3.7.0 contains an updated version of Java that has patched the vulnerabilities.

For more information about the Java vulnerabilities, refer to the Oracle [security announcement](http://www.oracle.com/technetwork/topics/security/cpuoct2014-1972960.html).

Affected Software Versions:
Puppet Enterprise 3.x

Resolved in:
Puppet Enterprise 3.7.0

### CVE-2014-3566 - POODLE SSLv3 Vulnerability

Assessed Risk Level: Medium

On October 14th, the OpenSSL project announced CVE-2014-3566, the POODLE attack vulnerability in the SSLv3 protocol. Fixes for this vulnerability disable SSLv3 protocol negotiation to prevent fallback to the insecure protocol.

Resolved in:
Puppet Enterprise 3.7.0
Manual remediation provided for Puppet Enterprise 3.3
Puppet 3.7.2, Puppet-Server 0.3.0, PuppetDB 2.2, MCollective 2.6.1

Users of Puppet Enterprise 3.3 who cannot upgrade can follow the remediation instructions in our [impact assessment](http://puppetlabs.com/blog/impact-assessment-sslv3-vulnerability-poodle-attack).

## Known Issues

As we discover them, this page will be updated with known issues in Puppet Enterprise 3.7 and earlier. Fixed issues will be removed from this list and noted above in the release notes. If you find new problems yourself, please file bugs in Puppet [here][puppetissues] and bugs specific to Puppet Enterprise [here][peissues].

To find out which of these issues may affect you, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `3.6.2 (Puppet Enterprise 3.7.0)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](install_upgrading.html).

[peissues]: http://projects.puppetlabs.com/projects/puppet-enterprise/issues
[puppetissues]: http://projects.puppetlabs.com/projects/puppet/issues

The following issues affect the currently shipped version of PE and all prior releases through the 3.x.x series, unless otherwise stated.

### Important Factors in Connecting to an External Directory Service

The following requirements affect how you connect your existing LDAP to PE:

   * User and group RDNs are currently required as part of the directory service settings. A simple query from the provided base DN is not supported.
   * Use of multiple user RDNs or group RDNs is not supported.
   * Cyclical group relationships in Active Directory will prevent a user from logging in.


### Upgrade Warning for Users of Directory Environments in PE 3.3.x

If the `basemodulepath` is set in the `[master]` section of `puppet.conf`, the upgrader will fail due to not being able to find PE-specific modules. To prevent this, ensure that `basemodulepath` is set in the `[main]` section of `puppet.conf` before upgrading.

### Issues Related to Puppet Server

#### SSL Termination Configuration Not Currently Supported

Previous to PE 3.7.0, it was possible to configure your environment to handle SSL termination on a hardware load balancer. This situation was handled by supporting some custom HTTP headers where the client certificate information could be stored when the SSL was terminated, thus making it possible for Puppet to continue to perform authorization checks based on the client certificate data, even when communicating via HTTP instead of HTTPS. This configuration is not yet supported, but we intend to support it in a future release.

See [SERVER-18](https://tickets.puppetlabs.com/browse/SERVER-18).

#### No Config Reload Handling Requests

In the Puppet server servie, there is no signal handling mechanism that allows you to request a config reload and service refresh. In order to clear out the Ruby environments and reload the config, you must restart the service.

Refer to [SERVER-15](https://tickets.puppetlabs.com/browse/SERVER-15).

#### Diffie-Helman HTTPS Client Issues

When configuring the Puppet server to use a report processor that involves HTTPS requests (e.g. to Foreman), there can be compatibility issues between the JVM HTTPS client and certain server HTTPS implementations (e.g. very recent versions of Apache `mod_ssl`). See [SERVER-17](https://tickets.puppetlabs.com/browse/SERVER-17) for known workarounds.

### Console Session Timeout Issue

The default session timeout for the PE console is 30 minutes. However, due to an issue that has not yet been resolved, console users will be logged out after thirty minutes even if they are currently active.

### SLES 12 `pe::repo` Class Available in PE Console but SLES 12 not Supported in PE 3.7.0

Due to a known issue in PE 3.7.0, you can select the SLES 12 `pe::repo` class from the PE console, but this class will not work. SLES 12 is not supported in PE 3.7.0, and no tarballs for SLES 12 are shipped in this version.

Support for SLES 12 will be added in a future release.

### Change to `lsbmajdistrelease` Fact Affects Some Manifests

In Facter 2.2.0, the `lsbmajdistrelease` fact changed its value from the first two numbers to the full two-number.two-number version on Ubuntu systems. This might break manifests that were based on the previous behavior.

For example, this fact changed from: `12` to `12.04`

This change affects Ubuntu and Amazon Linux. See the [Facter documentation for more information](./facter/2.2/release_notes.html#significant-changes-to-existing-facts)

### Puppet Expands Variables in Windows Systems Path

Puppet will automatically expand variables in a system path.

For example, this path:

	PATH=%SystemRoot%\System32

Will be expanded, as follows:

	PATH=C:\Windows\System32

This should not cause any problems.

### Enabling NIO and Stomp for ActiveMQ Performance Improvements will Introduce Security Issues

Enabling ActiveMQ's use of the NIO protocol in PE can improve the speed at which orchestration messages are sent across your deployment. However, when this is enabled, any parameters that you define for which SSL protocols to use will be ignored, and SSL version 3 will be enabled. Apache has fixed this bug, but they have not yet released a version of ActiveMQ that contains the fix. For more information, refer to their [public ticket](https://issues.apache.org/jira/browse/AMQ-5407).

Considering security over performance, PE 3.7.0 ships with NIO disabled. You can enable it with the following procedure:

1. From the console, click __Classification__ in the navigation bar.
2. From the __Classification page__, click the __PE ActiveMQ Broker__ group.
3. Click the __Classes__ tab, and find `puppet_enterprise::profile::amq::broker` in the list of classes.
4. From the __parameter__ drop-down menu, choose `openwire_protocol`, and in the __value__ field add __nio+ssl__.
6. Click __Add parameter__.
7. From the __parameter__ drop-down menu, choose `stomp_protocol`, and in the __value__ field add __stomp+nio+ssl__.
8. Click __Add parameter__.
9. Click __Commit 2 changes__.
10. Navigate to the Live Management page, and select the __Control Puppet__ tab.
11. Click __runonce__  and then __Run__ to trigger a Puppet run to have Puppet Enterprise create the new configuration.

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

### Safari Certificate Handling May Prevent Console Access

Due to [Apache bug 53193](https://issues.apache.org/bugzilla/show_bug.cgi?id=53193) and the way Safari handles certificates, Puppet Labs recommends that PE 3.7 users avoid using Safari to access the PE console.

If you need to use Safari, you may encounter the following dialog box the first time you attempt to access the console after installing/upgrading PE 3.7:

![Safari Certificate Dialog][client_cert_dialog]

If this happens, click __Cancel__ to access the console. (In some cases, you may need to click __Cancel__ several times.)

This issue will be fixed in a future release.

### `puppet module list --tree` Shows Incorrect Dependencies After Uninstalling Modules

If you uninstall a module with `puppet module uninstall <module name>` and then run `puppet module list --tree`, you will get a tree that does not accurately reflect module dependencies.

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

- AIX 5.3 puppet agents depend on readline-4-3.2 being installed. You can check the installed version of readline by running `rpm -q readline`. If you need to install it, you can [download it from IBM](ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/readline/readline-4.3-2.aix5.1.ppc.rpm). Install it *before* installing the puppet agent.

- On AIX 6.1 and 7.1, the default version of readline, 4-3.2, is insufficient. You need to replace it *before* upgrading or installing by running

        rpm -e --nodeps readline
        rpm -Uvh readline-6.1-1.aix6.1.ppc.rpm

If you see an error message after running this, you can disregard it. Readline-6 should be successfully installed, and you can proceed with the installation or upgrade (you can verify the installation with  `rpm -q readline`).

### Debian/Ubuntu Local Hostname Issue

On some versions of Debian/Ubuntu, the default `/etc/hosts` file contains an entry for the machine's hostname with a local IP address of 127.0.1.1. This can cause issues for PuppetDB and PostgreSQL, because binding a service to the hostname will cause it to resolve to the local-only IP address rather than its public IP. As a result, nodes (including the console) will fail to connect to PuppetDB and PostgreSQL.

To fix this, add an entry to `/etc/hosts` that resolves the machine's FQDN to its *public* IP address. This should be done prior to installing PE. However, if PE has already been installed, restarting the `pe-puppetdb` and `pe-postgresql` services after adding the entry to the hosts file should fix things.

### Inconsistent Counts When Comparing Service Resources in Live Management

In the Browse Resources tab, comparing a service across a mixture of RedHat-based and Debian-based nodes will give different numbers in the list view and the detail view.

### Augeas File Access Issue

On AIX agents, the Augeas lens is unable to access or modify `etc/services`. There is no known workaround.

### Answer File Required for Some SMTP Servers

Any SMTP server that requires authentication, TLS, or runs over any port other than 25 needs to be explicitly added to an answers file. See the [advanced configuration page](./console_config.html#allowing-anonymous-console-access) for details.

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

### The Puppet Module Tool (PMT) Does Not Support Solaris 10

When attempting to use the PMT on Solaris 10, you'll get an error like the following:

		Error: Could not connect via HTTPS to https://forgeapi.puppetlabs.com
  		Unable to verify the SSL certificate
    	The certificate may not be signed by a valid CA
    	The CA bundle included with OpenSSL may not be valid or up to date

This error occurs because there is no CA-cert bundle on Solaris 10 to trust the Puppet Labs Forge certificate. To work around this issue, we recommend that you download directly from the Forge website and then use the puppet module tool to [install from a local tarball](./puppet/latest/reference/modules_installing.html#installing-from-a-release-tarball).


### Razor Known Issues

Please see the page [Razor Setup Recommendations and Known Issues](./razor_knownissues.html).

Puppet Terminology
-----

For help with Puppet-specific terms and language, visit [the glossary](/references/glossary.html)

For a complete guide to the Puppet language, visit [the reference manual](/puppet/3.6/reference/)

* * *

- [Next: Getting Support](./overview_getting_support.html)
