---
title: "PE 3.8 » Release Notes >> Known Issues"
layout: default
subtitle: "Known Issues"
canonical: "/pe/latest/release_notes_known_issues.html"
---

As we discover them, this page will be updated with known issues in Puppet Enterprise 3.8.x releases. Fixed issues will be removed from this page and noted in the Bug Fixes section of the release notes. If you find new problems yourself, please file bugs in [our issue tracker](https://tickets.puppetlabs.com).

To find out which of these issues may affect you, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `3.8.5 (Puppet Enterprise 3.8.0)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](install_upgrading.html).

[peissues]: https://tickets.puppetlabs.com/browse/ENTERPRISE/
[puppetissues]: https://tickets.puppetlabs.com/browse/PUP/

The following issues affect the currently shipped version of PE and all prior releases through the 3.x.x series, unless otherwise stated.

## Installation/Upgrade Known Issues

### Upgrading Requires You to Manually Add Nodes to the PE Node Groups

For fresh installations of PE 3.8.0, node groups in the classifier are created and configured during the installation process. For upgrades, if these groups do not exist, or do not contain any classes, they will be created and configured but **no nodes will be pinned to them**. This helps prevent errors during the upgrade process, but you must manually pin the correct nodes to each group after you complete the upgrade process. For a more detailed explanation refer to [Adding Nodes to the PE Groups](./install_upgrading_notes.html#adding-nodes-to-the-pe-groups) in [Upgrading Puppet Enterprise: Notes and Warnings](./install_upgrading_notes.html).

### Incorrect Credentials for Console Databases will Cause Split Upgrade to Fail

If, during a split upgrade, you supply incorrect database credentials (specifically, incorrect database names, user names, or passwords for the databases associated with the PE console), the upgrade process will fail with a confusing error message. In most cases, ensure you have the correct database credentials and rerun the upgrader. The credentials can be found on the PuppetDB node at `/etc/puppetlabs/installer/database_info.install`.

### Web-based Installer Fails to Acknowledge Failed Installs due to Low RAM

When a PE installation fails because a system is not provisioned with adequate RAM, the web-based installer stops responding when verifying that PE is functioning on the server, but the installation appears to have succeeded, as the **Start using Puppet Enterprise** button is available. Note that in such cases, the command line shows an "out of memory: Kill process" error.

We recommend provisioning the system with adequate RAM and re-running the installation. Refer to the [hardware requirements](./install_system_requirements.html#hardware-requirements).

###  New PE 3.7.x MCO Server is Not Connecting with Older MCollective agents (posted December 17, 2014)

This issue has been fixed in PE 3.8.0.

### Review Modified `auth.conf` Files before Upgrading to 3.8

There have been several changes to `auth.conf` leading up to PE 3.8. If you have a modified `auth.conf` file, you will be prompted by the upgrader to review it and make changes before continuing with your upgrade. For details, please review [Upgrading to 3.8 with a Modified `auth.conf` File](./install_upgrading_notes.html#upgrading-to-38-with-a-modified-authconf-file).

### Incorrect Umask Value Can Cause Upgrade/Installation to Fail

To prevent potential failures, you should set an umask value of 0022 on your Puppet master.

### New PostgreSQL Databases Needed on Upgrade/Install (for External PostgreSQL Users)

If you are using an external PostgreSQL instance that is not managed by PE, please note that you will need to make a few changes for the new databases included in PE 3.8. See [A Note about RBAC, Node Classifier, and External PostgreSQL](./install_upgrading_notes.html#a-note-about-rbac-node-classifier-and-external-postgresql).

### Additional Puppet Masters in Large Environment Installations Cannot Be Upgraded

If you've installed additional Puppet masters (i.e., secondary or compile masters) in a version of PE before 3.7.2, you cannot upgrade these Puppet masters. To re-install and enable compile masters in 3.8, refer to the [Additional Puppet Master Installation documentation](./install_multimaster.html).

### stdlib No Longer Installed with Puppet Enterprise

If necessary, you can install the stdlib module after installing/upgrading by running `puppet module install puppetlabs-stdlib`.

### PuppetDB Behind a Load Balancer Causes Puppet Server Errors

Puppet Server handles outgoing HTTPS connections differently from the older MRI Ruby Puppet master, and has a new restriction on the server certificates it will accept. This affects all Puppet Enterprise versions in the 3.8 series.

If Puppet Server makes client connections to another HTTPS service, that service must use only one certificate. If that service is behind a load balancer, and the back-end servers use individual certificates, Puppet Server will frequently abort its client connections. For more details, see [this note from the Puppet Server docs.](/puppetserver/1.0/ssl_server_certificate_change_and_virtual_ips.html)

Therefore, if you are running multiple PuppetDB servers behind a load balancer, you must configure all of them to use the same certificate. You can do this by following the instructions below.

> **Warning**: This is a non-standard configuration that may or may not be supported, depending on what your organization has negotiated with Puppet Labs.
>
> Also note that if you use this workaround, you will not be able to use `/opt/puppet/sbin/puppetdb ssl-setup` to repair certificate issues with PuppetDB.

1. On the Puppet master that serves as the CA, generate a certificate for your PuppetDB nodes with the load balancer hostname as one of the DNS alt names. In this example, we use `pe-internal-puppetdb`.

   `puppet cert generate <pe-internal-puppetdb> --dns_alt_names=<LOAD BALANCER HOSTNAME>`

2. Move the new cert from the Puppet master SSL cert directory (`/etc/puppetlabs/puppet/ssl/certs/pe-internal-puppetdb.pem`) to the same path on each PuppetDB node (`/etc/puppetlabs/puppet/ssl/certs/pe-internal-puppetdb.pem`).
3. Move the new private key from the Puppet master SSL private key directory (`/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-puppetdb.pem`) to the same path on each PuppetDB node (`/etc/puppetlabs/puppet/ssl/private_keys/pe-internal-puppetdb.pem`).
4. Move the new public key from Puppet master SSL public key directory (`/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-puppetdb.pem`) to the same path on each PuppetDB node (`/etc/puppetlabs/puppet/ssl/public_keys/pe-internal-puppetdb.pem`).
5. In the PE console, configure the `puppet_enterprise::profile::puppetdb` class to use the new `pe-internal-puppetdb` certname.

   a. Click **Classification** in the top navigation bar.

   b. From the **Classification** page, select the **PE PuppetDB** group.

   c. Click the **Classes** tab, and find the `puppet_enterprise::profile::puppetdb` class.

   d. From the **Parameter** drop-down list, select **`certname`**.

   e. In the **Value** field, enter `pe-internal-puppetdb`.

   f. Click **Add parameter** and the **Commit change** button.

6. Add the hostname of the load balancer to the **PE Infrastructure** class.

   a. Navigate to the **PE Infrastructure** group.

   b. Click the **Classes** tab, and find the `puppet_enterprise` class.

   c. For the **`puppetdb_host`** entry, edit the value to reflect the hostname of your load balancer.

   d. Click the **Commit change** button.

7. On each PuppetDB node and the Puppet master, kick off a Puppet run.

### Before Upgrading to PE 3.8, Correct Invalid Entries in `autosign.conf`

Any entries in `/etc/puppetlabs/puppet/autosign.conf` that don't conform to the [autosign requirements](/puppet/3.8/reference/ssl_autosign.html#the-autosignconf-file) will cause the upgrade to fail to configure the PE console. Please correct any invalid entries before upgrading.

### Install Agents With Different OS When Puppet Master is Behind A Proxy

If your Puppet master uses a proxy server to access the internet, you may not be able to download the `pe_repo` packages for the agent. In the case that you're using a proxy, follow this workaround:

**Tip**: The following steps should be performed on your Puppet master (and, if you have a large environment installation, on all your compile masters as well).

1. From your Puppet master, navigate to `/etc/sysconfig/`, and create a file called `pe-puppet`.
2. In `pe-puppet` add the following lines:

       export http_proxy ...
       export https_proxy ...

3. Save and exit the file.
4. Restart the pe-puppet service with the following commands:

	puppet resource service pe-puppet ensure=stopped
	puppet resource service pe-puppet ensure=running


### `q_database_host` Cannot be an Alt Name For Upgrades or Installs of 3.8.0

PostgreSQL does not support alt names when set to `verify_full`. If you are upgrading to or installing 3.8 with an answer file, make sure `q_database_host` is set as the Puppet agent certname for the database node and not set as an alt name.

### You Might Need to Upgrade puppetlabs-inifile to Version 1.1.0 or Later

PE automatically updates your version of puppetlabs-inifile as part of the upgrade process. However, if you encounter the following error message on your PuppetDB node, then you need to manually upgrade the puppetlabs-inifile module to version 1.1.0 or higher.

	Error: Could not retrieve catalog from remote server: Error 400 on SERVER: Invalid parameter quote_char on Ini_subsetting['-Xmx'] on node master
	Warning: Not using cache on failed catalog
	Error: Could not retrieve catalog; skipping run

### Notes about Symlinks and Installation/Upgrade

The answer file no longer gives the option of whether to install symlinks.

Review [Puppet Enterprise Binaries and Symlinks](./install_basic.html#puppet-enterprise-binaries-and-symlinks) for more information about the binaries and symlinks installed during normal installations and upgrades.

### Answer File Required for Some SMTP Servers

Any SMTP server that requires authentication, TLS, or runs over any port other than 25 needs to be explicitly added to an answers file. See the [advanced configuration page](./console_config.html#allowing-anonymous-console-access) for details.

### Installing Agents in a PE Infrastructure with No Internet Access

Refer to [Installing Agents in a Puppet Enterprise Infrastructure without Internet Access](./install_agents.html#installing-agents-in-a-puppet-enterprise-infrastructure-without-internet-access).

## Puppet Server Known Issues

> **Tip**: More information about Puppet Server can be found in the [Puppet Server docs](/puppetserver/1.0/services_master_puppetserver.html). Differences between PE and open source versions of Puppet Server are typically called out.

### Puppet Server Developments Impact Custom Certificate Extensions

A certificate generated with custom extensions in PE 3.8 might not be properly decodable if used in a prior PE release.

### Updating Puppet Master Gems

If you've installed any additional Ruby gems beyond those installed by PE, they will not be migrated to the Puppet master during the upgrade to PE 3.8. If you have modules that depend on additional gems, you will need to install them on the Puppet master after you complete the upgrade process.

You can update the gems used by your Puppet master with `/opt/puppet/bin/puppetserver gem install <GEM NAME>`.

After updating the gems, you need to restart the Puppet master with `service pe-puppetserver restart`. You should do this **before** doing any Puppet agent runs.

>**Note**: Installing `puppetserver` gems fails when run unprivileged. You might get a "no such file or directory" error. Instead, install as root.

### Installing Gems when Puppet Server is Behind a Proxy Requires Manual Download of Gems

If you run Puppet Server behind a proxy, the `puppetserver gem install` command will fail. Instead you can install the gems as follows:

1. Use [rubygems.org](https://rubygems.org/pages/download#formats) to search for and download the gem you want to install, and then transfer that gem to your Puppet master.
2. Run `/opt/puppet/bin/puppetserver gem install --local <PATH to GEM>`.

### A Note About Gems with Native (C) Extensions for JRuby on the Puppet Server

Please see the Puppet Server documentation for a description of this issue, [Gems with Native (C) Extensions](/puppetserver/1.0/gems.html#gems-with-native-c-extensions).

### Puppet Server Run Issue when `/tmp/` Directory Mounted `noexec`

In some cases (especially for RHEL 7 installations) if the `/tmp` directory is mounted as `noexec`, Puppet Server might fail to run correctly, and you might see an error in the Puppet Server logs similar to the following:

    Nov 12 17:46:12 fqdn.com java[56495]: Failed to load feature test for posix: can't find user for 0
    Nov 12 17:46:12 fqdn.com java[56495]: Cannot run on Microsoft Windows without the win32-process, win32-dir and win32-service gems: Win32API only supported on win32
    Nov 12 17:46:12 fqdn.com java[56495]: Puppet::Error: Cannot determine basic system flavour

To work around this issue, you can either mount the `/tmp` directory without `noexec`, or you can choose a different directory to use as the temporary directory for the Puppet Server process.

If you want to use a directory other than `/tmp`, you can add an extra argument to the `$java_args` parameter of the `puppet_enterprise::profile::master` class using the PE console. Add `{"Djava.io.tmpdir=/var/tmp":""}` as the value for the `$java_args` parameter. Refer to [Editing Parameters](./console_classes_groups_making_changes.html#editing-parameters) for instructions on editing parameters in the console.

Note that whether you use `/tmp` or a different directory, you’ll need to set the permissions of the directory to `1777`. This allows the Puppet Server JRuby process to write a file to `/tmp` and then execute it.

### No Config Reload Requests

The Puppet Server service doesn't have a non-disruptive way to request a reload of its configuration files. In order to reload its config, you must restart the service.

Refer to [SERVER-15](https://tickets.puppetlabs.com/browse/SERVER-15).

### HTTPS Client Issues with Newer Apache `mod_ssl` Servers

When configuring the Puppet server to use a report processor that involves HTTPS requests (e.g., to Foreman), there can be compatibility issues between the JVM HTTPS client and certain server HTTPS implementations (e.g., very recent versions of Apache `mod_ssl`). This is usually indicated by a `Could not generate DH keypair` error in Puppet Server's logs. See [SERVER-17](https://tickets.puppetlabs.com/browse/SERVER-17) for known workarounds.


## PuppetDB/PostgreSQL Known Issues

### Incorrect Password for Database User(s) Causes Install/Upgrade to Fail

If, during installation or upgrade, you supply an incorrect password for one of the PE databases users (RBAC, console, PuppetDB), the install/upgrade will fail. However, in some cases it might appear that the install/upgrade was successful. For example, if the incorrect password is supplied for the console database user, the install/upgrade continues---and appears to succeed---but the console will not be functional.

### PostgreSQL Buffer Memory Issue Can Cause PE Install to Fail on Machines with Large Amounts of RAM

In some cases, when installing PE on machines with large amounts of RAM, the PostgreSQL database uses more shared buffer memory than is available and will not be able to start. This prevents PE from installing correctly. For more information and a suggested workaround, refer to [Troubleshooting the Console and Database](./trouble_console-db.html#postgresql-memory-buffer-causes-pe-install-to-fail).

### Errors Related to Stopping `pe-postgresql` Service

If for any reason the `pe-postgresql` service is stopped, agents receive several different error messages, for example:

    Warning: Unable to fetch my node definition, but the agent run will continue:
    Warning: Error 400 on SERVER: (<unknown>): mapping values are not allowed in this context at line 7 column 28

or, when attempting to request a catalog:

    Error: Could not retrieve catalog from remote server: Error 400 on SERVER: (<unknown>): mapping values are not allowed in this context at line 7 column 28
    Warning: Not using cache on failed catalog
    Error: Could not retrieve catalog; skipping run

If you encounter these errors, simply re-start the `pe-postgresql` service.


### `db:raw:optimize` Rake Task does not Work in PE 3.8

The `db:raw:optimize` Rake task does not work in PE 3.8 because the ownership of the database was changed from `console` to `pe-postgres`.

To re-index and vacuum the console database, you can use the following PostgreSQL commands:

`su - pe-postgres -s /bin/bash -c "reindexdb console"; su - pe-postgres -s /bin/bash -c "vacuumdb --full --verbose console"`

## PE console/pe-console-services

###  Incorrect Error Message When Agent Has Significant Time Skew

If a PE agent attempts to perform a checkin with the master but the agent has significant time skew, an incorrect error message is returned. This message masks the real cause of the problem, which is the time skew. The error message says: `400 Error: "Attempt to assign to a reserved variable name: 'trusted' on node"`.

### PE Console Doesn't Display Parent Group Rules

In the console, parent group rules don't show, which makes it easier to create a rule that contradicts an inherited rule. If you create a contradictory rule, then you might find that no nodes match the rule you've created. The **Matching nodes** tab is accurate. If you don't see the nodes you're expecting on this tab, then you need to look up the ancestor rules to identify the contradictory rule.

Matching nodes aren’t showing up.

### The "Accept all" Option Doesn't Work with Hundreds of New Certs

When you install hundreds of agents and attempt to use the **Accept all** option in the console, only some of the certs will be signed before there's an error. This is likely due to timing out.

### `pe_console_prune` Class Not Added to PE Console Group During Upgrade to 3.8

The `pe_console_prune` class is a class in the PE Console group. However, when upgrading to PE 3.8, this class may be incorrectly added to the singleton group created for the node assigned the PE console component.

### Important Factors in Connecting to an External Directory Service

The following requirement affects how you connect your existing LDAP to PE:

   * Use of multiple user RDNs or group RDNs is not supported.

### Custom Console Certs May Break on Upgrade

Upgrades to this version of PE can affect deployments that use a custom console certificate, as certificate functionality has changed between versions. Refer to [Configuring the Puppet Enterprise Console to Use a Custom SSL Certificate](./custom_console_cert.html) for instructions on re-configuring your custom console certificate.

### Nodes Can Be Pinned an Infinite Number of Times

When pinning a node to a node group in the PE console, if you pin the node multiple times, the console does not resolve this to a single entry. For example, if you pin the same node to a node group ten times and commit it, the console will show that you have ten nodes all with the same node name.

### Error When a PE User and User Group Have the Same Name

If you have both a PE user and a user group with the exact same name, PE will throw an error when you perform a search that matches both of these entries.

### 400 Error When There Are Over 500 Nodes Pinned to a Node Group and You Click **Load All Nodes**

When there are over 500 nodes pinned to a node group, a **Load All Nodes** button appears in the **Matching nodes** tab for that node group. Clicking the **Load All Nodes** button results in a 400 error.

### Querying the Nodes Endpoint of the Classifier Service Can Exhaust Memory

If a large number of nodes is returned when querying the `v1/nodes` endpoint of the classifier service API, the pe-console-services process may exhaust the memory and return a 500 error. This can be resolved by pruning the node check-in data as documented in [Configuring & Tuning Node Classifier](./config_nc.html).

### Not All Environments Are Listed in the PE Console

When the classifier service encounters an environment that has code that will not compile, it marks the environment as deleted. If you later correct the code in the environment, the classifier service does not remove the deleted flag.

To manually remove the deleted flag for an environment named "test" for example, in the command line, type:

    sudo su - pe-postgres -s /bin/bash -c "/opt/puppet/bin/psql -d 'pe-classifier' -c \"UPDATE environments SET deleted = 'f' WHERE name = 'test';\""

### User Login is Invalid When Less Than Three Characters

The PE RBAC service will not allow you to add a user login that is less than three characters long.

### Passenger `permission denied` Log entry

At application startup for Dashboard, Passenger logs a "permission denied" message to the Apache error log concerning the passenger-config executable. This log message only appears once, at application startup, is not repeated, and appears to be cosmetic. The dashboard starts and functions properly.

### Safari Certificate Handling May Prevent Console Access

[client_cert_dialog]: ./images/client_cert_dialog.png

Due to [Apache bug 53193](https://issues.apache.org/bugzilla/show_bug.cgi?id=53193) and the way Safari handles certificates, Puppet Labs recommends that PE 3.8 users avoid using Safari to access the PE console.

If you need to use Safari, you may encounter the following dialog box the first time you attempt to access the console after installing/upgrading PE 3.8:

![Safari Certificate Dialog][client_cert_dialog]

If this happens, click __Cancel__ to access the console. (In some cases, you may need to click __Cancel__ several times.)

This issue will be fixed in a future release.

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

Note that unless your system contains OpenSSL v1.0.1d (the version that correctly supports TLS1.1 1and 1.2), prioritizing RC4 might leave you vulnerable to other types of attacks.

### Inconsistent Counts When Comparing Service Resources in Live Management

In the Browse Resources tab, comparing a service across a mixture of RedHat-based and Debian-based nodes will give different numbers in the list view and the detail view.

### Deleted Nodes Can Reappear in the Console

Due to the fact that the console will create a node listing for any node found via the inventory search function, nodes deleted from the console can sometimes reappear. See the [console bug report describing the issue](https://projects.puppetlabs.com/issues/11210).

The nodes will reappear after deletion if PuppetDB data for that node has not yet expired, and you perform an inventory search in the console that returns information for that node.

You can avoid the reappearance of nodes by removing them with the following procedure:

1. `puppet node clean <node_certname>`
2. `puppet node deactivate <node_certname>`
3.  `sudo /opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production node:del[<node_certname>]`

These steps will remove the node's certificate, purge information about the node from PuppetDB, and delete the node from the console. The last command is equivalent to logging into the console and deleting the node via the UI.

For instructions on completely deactivating an agent node, refer to [Deactivating a PE Agent Node](./node_deactivation.html).

### Problems with Marking Failed Tasks as Read in the Console

Marking failed tasks as read in the console can instead open a security warning, followed by an "unable to connect" message.

### `site.pp` Must Be Duplicated for Each Environment

You can no longer have a universal or global `site.pp`. The default main filebucket is configured as a resource default in `site.pp`. This means that `site.pp` must be duplicated for each environment. See the [Puppet environments documentation for more information](/puppet/latest/reference/environments.html).


## PE Services/Puppet Core Known Issues

### `/opt/staging/` is No Longer Used

In PE 3.8, the `/opt/staging/` directory is no longer used. Because users may have used either the `puppetlabs-pe_staging` or `nanliu-staging` modules, we did not delete the directory. If you are not using the directory, it is safe to delete it.

### PE 3.7.x Agent Can't Compile Against PE 3.8.0 Master If Future Parser is Installed

If you upgrade or install a PE 3.8.0 master, sign the certificate, and run Puppet on a 3.7.x agent node, that should succeed. However, if you enable future parser, restart pe-puppetserver, and then run Puppet on the agent again, you'll get a server error. This error doesn't happen if you enable future parser with a PE 3.8.0 master and agent, only a 3.8.0 master with a 3.7.x agent. To avoid this problem, update your agents to match the version of your masters.


### Change to `lsbmajdistrelease` Fact Affects Some Manifests

In Facter 2.2.0, the `lsbmajdistrelease` fact changed its value from the first two numbers to the full two-number.two-number version on Ubuntu systems. This might break manifests that were based on the previous behavior. For example, this fact changed from: `12` to `12.04`.

This change affects Ubuntu and Amazon Linux. See the [Facter documentation for more information](./facter/2.3/release_notes.html#significant-changes-to-existing-facts)

### Enabling NIO and Stomp for ActiveMQ Performance Improvements will Introduce Security Issues

Enabling ActiveMQ's use of the NIO protocol in PE can improve the speed at which orchestration messages are sent across your deployment. However, when this is enabled, any parameters that you define for which SSL protocols to use will be ignored, and SSL version 3 will be enabled. Apache has fixed this bug, but they have not yet released a version of ActiveMQ that contains the fix. For more information, refer to their [public ticket](https://issues.apache.org/jira/browse/AMQ-5407).

Considering security over performance, PE 3.8 ships with NIO disabled. You can enable it with the following procedure:

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


### `puppet module list --tree` Shows Incorrect Dependencies After Uninstalling Modules

If you uninstall a module with `puppet module uninstall <module name>` and then run `puppet module list --tree`, you will get a tree that does not accurately reflect module dependencies.

### Dynamic Man Pages Are Incorrectly Formatted

Man pages generated with the `puppet man` subcommand are not formatted as proper man pages and are instead displayed as Markdown source text. This is a purely cosmetic issue, and the pages are still fully readable.

To improve the display of Puppet man pages, you can use your system `gem` command to install the `ronn` gem:

    $ sudo gem install ronn

### The Puppet Module Tool (PMT) Does Not Support Solaris 10

When attempting to use the PMT on Solaris 10, you'll get an error like the following:

		Error: Could not connect via HTTPS to https://forgeapi.puppetlabs.com
  		Unable to verify the SSL certificate
    	The certificate may not be signed by a valid CA
    	The CA bundle included with OpenSSL may not be valid or up to date

This error occurs because there is no CA-cert bundle on Solaris 10 to trust the Puppet Labs Forge certificate. To work around this issue, we recommend that you download directly from the Forge website and then use the Puppet module tool to [install from a local tarball](./puppet/latest/reference/modules_installing.html#installing-from-a-release-tarball).

## PE on Windows Known Issues

### Puppet Expands Variables in Windows Systems Path

Puppet will automatically expand variables in a system path.

For example, this path:

	PATH=%SystemRoot%\System32

Will be expanded, as follows:

	PATH=C:\Windows\System32

This should not cause any problems.

### Errors Not Issued for Unprivileged Non-root Agent Actions on Windows

- If you run a PE agent on Windows with non-root privileges and attempt to create a file without the correct access, PE will fail the file creation but will not issue any warnings.

- If you run a PE agent on Windows with non-root privileges and attempt to create a registry key, PE will fail the registry key creation but will indicate they were created.

These issues will be fixed in a future release.

### Live Management Cannot Uninstall Packages on Windows Nodes

An issue with MCollective prevents correct uninstallation of packages on nodes running Windows. You can uninstall packages on Windows nodes using Puppet, for example:
        `package
            { 'Google Chrome': ensure => absent, }`

The issue is being tracked on [this support ticket](https://tickets.puppetlabs.com/browse/MCOP-14).

## Supported Platforms Known Issues

### Ubuntu Conflict When You're Running on Fusion VM and Amazon EC2

We've discovered an issue in which customers running the Ubuntu 14.04 amd64 platform on a Fusion VM or in Amazon EC2 cannot properly install or upgrade to PE 3.8, or they've installed and upgraded but Puppet Server will not properly start. For such cases, the following workaround is available:

**If you cannot properly install or upgrade**:

1. Navigate to your Hiera defaults file. 

   The default location for the Hiera defaults is `/var/lib/hiera/defaults.yaml`. If you’ve customized your `hierarchy` or `datadir`, you’ll need to access and edit the default `.yaml` file accordingly.
   
2. Add the following:

        puppet_enterprise::profile::master::java_args:
           Djava.library.path: '=/lib/x86_64-linux-gnu'
           
**If you've installed/upgraded but Puppet Server will not start**:

1. Follow the two steps in the previous section. 
2. Edit `/etc/default/pe-puppetserver` and include the following:

    `JAVA_ARGS="-Xms2048m -Xmx2048m -XX:MaxPermSize=256m -Djava.library.path=/lib/x86_64-linux-gnu"`
    
3. Run `service pe-puppetserver restart`. 

### Readline Version Issues on AIX Agents

- AIX 5.3 Puppet agents depend on readline-4-3.2 being installed. You can check the installed version of readline by running `rpm -q readline`. If you need to install it, you can [download it from IBM](ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/readline/readline-4.3-2.aix5.1.ppc.rpm). Install it *before* installing the Puppet agent.

- On AIX 6.1 and 7.1, the default version of readline, 4-3.2, is insufficient. You need to replace it *before* upgrading or installing by running

        rpm -e --nodeps readline
        rpm -Uvh readline-6.1-1.aix6.1.ppc.rpm

If you see an error message after running this, you can disregard it. Readline-6 should be successfully installed, and you can proceed with the installation or upgrade (you can verify the installation with  `rpm -q readline`).

### Solaris Updates Might Break Puppet Install

We've seen an issue in which Puppet agents on Solaris platforms have quit responding after the core Solaris OS was updated. Essential Puppet configuration files were erased from the `/etc/` directory (which includes SSL certs needed to communicate with the Puppet master), and the `/etc/hosts` file was reverted.

If you encounter this issue, log in to the Puppet master and clear the agent cert from the Solaris machine (`puppet cert clean <HOSTNAME>`), and then re-install [the Puppet agent](.//install_agents.html).

### Solaris 10 and 11 Have No Default `symplink` Directory

Solaris 10 and 11 will not by default have the `symlink` directory in their path. Therefore, if you use one of these two platforms,  add `/usr/local/bin` to your default path.

### Debian/Ubuntu Local Hostname Issue

On some versions of Debian/Ubuntu, the default `/etc/hosts` file contains an entry for the machine's hostname with a local IP address of 127.0.1.1. This can cause issues for PuppetDB and PostgreSQL, because binding a service to the hostname causes it to resolve to the local-only IP address rather than its public IP. As a result, nodes (including the console) will fail to connect to PuppetDB and PostgreSQL.

To fix this, add an entry to `/etc/hosts` that resolves the machine's FQDN to its *public* IP address. This should be done prior to installing PE. However, if PE has already been installed, restarting the `pe-puppetdb` and `pe-postgresql` services after adding the entry to the hosts file should fix things.

### Puppet Enterprise Cannot Locate Samba init Script for Ubuntu 14.04

If you attempt to install and start Samba using PE resource management, you might encounter the following errors:

    Error: /Service[smb]: Could not evaluate: Could not find init script or upstart conf file for 'smb'`
    Error: Could not run: Could not find init script or upstart conf file for 'smb'`

To work around this issue, install and start Samba with the following commands:

    puppet resource service smbd provider=init enable=true ensure=running
    puppet resource service nmbd provider=init enable=true ensure=running

Or, add the following to a Puppet manifest:

	service { 'smbd':
  		ensure   => running,
  		enable   => true,
  		provider => 'init',
	}

	service { 'nmbd':
  		ensure   => running,
  		enable   => true,
  		provider => 'init',
	}


### Augeas File Access Issue

On AIX agents, the Augeas lens is unable to access or modify `etc/services`. There is no known workaround.

## Razor Known Issues

### Razor Installation Requires an Internet Connection
The pe_razor module assumes internet connectivity to download the PE installation tarball from pm.puppetlabs.com. The module also assumes it can download the microkernel from pm.puppetlabs.com as well.

### Razor has Trouble Provisioning a Node with Debian Wheezy

We've had errors when trying to provision a node with Debian Wheezy. In such cases, the image hasn't loaded.

###Razor doesn't handle local time jumps

The Razor server is sensitive to large jumps in the local time, like the one that is experienced by a VM after it has been suspended for some time and then resumed. In that case, the server will stop processing background tasks, such as the creation of repos. To remediate that, restart the server with `service pe-razor-server restart`.

###Razor hangs in VirtualBox 4.3.6

We're finding that VirtualBox 4.3.6 gets to the point of downloading the microkernel from the Razor server and hangs at 0% indefinitely. We don't have this problem with VirtualBox 4.2.22.

###Temp Files aren't Removed in a Timely Manner

This is due to Ruby code working as designed, and while it takes longer to remove temporary files than you might expect, the files are eventually removed when the object is finalized.

###Updates might be required for VMware ESXi 5.5 igb files

You might have to update your VMware ESXi 5.5 ISO with updated igb drivers before you can install ESXi with Razor. See this [driver package download page on the VMware site](https://my.vmware.com/web/vmware/details?downloadGroup=DT-ESXI55-INTEL-IGB-42168&productId=353) for the updated igb drivers you need.

###JSON warning

When you run Razor commands, you might get this warning: "MultiJson is using the default adapter (ok_json). We recommend loading a different JSON library to improve performance."

You can disregard the warning since this situation is completely harmless. However, if you're using Ruby 1.8.7, you can install a separate JSON library, such as json_pure, to prevent the warning from appearing.

### `pe-razor` Doesn't Allow `java_args` Configuration

Most PE services enable you to configure `java_args` in the console, but Razor requires you to hard code them in the `init` script.


Puppet Terminology
-----

For help with Puppet-specific terms and language, visit [the glossary](/references/glossary.html)

For a complete guide to the Puppet language, visit [the reference manual](/puppet/3.6/reference/)

* * *

- [Next: Getting Support](./overview_getting_support.html)





























