---
title: "PE 3.7 » Release Notes >> Known Issues"
layout: default
subtitle: "Known Issues"
canonical: "/pe/latest/release_notes_known_issues.html"
---

As we discover them, this page will be updated with known issues in Puppet Enterprise 3.7.x releases. Fixed issues will be removed from this page and noted Bug Fixes section of the release notes. If you find new problems yourself, please file bugs in [our issue tracker](https://tickets.puppetlabs.com).

To find out which of these issues may affect you, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `3.6.2 (Puppet Enterprise 3.7.0)`. To upgrade to a newer version of Puppet Enterprise, see the [chapter on upgrading](install_upgrading.html).

The following issues affect the currently shipped version of PE and all prior releases through the 3.x.x series, unless otherwise stated.

## Installation/Upgrade Known Issues

###  New PE 3.7.x MCO Server is Not Connecting With Older MCollective agents (posted 12/17/14)

Customers are experiencing problems connecting PE 3.7 MCO clients, such as Live Management, with older MCO servers (Puppet agents). Specifically, any MCO servers running on PE 3.3.2 agents and older. To fix this problem, we recommend upgrading your PE agents to 3.7.x so you can continue using activemq heartbeats.

However, if you cannot upgrade all of your agents at this time, you can add the following line to your Hiera data. This will affect all Puppet agents of versions older than 3.7.0. After you add this line and complete a puppet run on your agents, ActiveMQ heartbeats will be disabled.

	puppet_enterprise::mcollective::server::activemq_heartbeat_interval: 0

If you're not using Hiera, you need to set it up. See the [Hiera documentation](/hiera/1/) for information.

### A Modified `auth.conf` File Will Cause Upgrade Failure

If your `auth.conf` file has been modified, you may experience a failure when upgrading to the 3.7.x line. To prevent an upgrade failure, before running the upgrade, edit `auth.conf` so that the `resource_type` path contains `pe-internal-classifier`, as shown in the following example:

    ...

    path /resource_type
    method find, search
    auth yes
    allow pe-internal-dashboard, pe-internal-classifier

### Incorrect Umask Value Can Cause Upgrade/Installation to Fail

To prevent potential failures, you should set an umask value of 0022 on your Puppet Master.

### New PostgreSQL Databases Needed on Upgrade/Install (for External PostgreSQL Users)

If you are using an external PostgreSQL instance that is not managed by PE, please note that you will need to make a few changes for the new databases included in PE 3.7.x. See [A Note about RBAC, Node Classifier, and External PostgreSQL](./install_upgrading_notes.html#a-note-about-rbac-node-classifier-and-external-postgresql).

### Additional Puppet Masters in Large Environment Installations Cannot Be Upgraded

If you've installed additional Puppet masters (i.e., secondary or compile masters) in a version of PE before 3.7.x, you cannot upgrade these Puppet masters. To re-install and enable compile masters in 3.7.x, refer to the [Additional Puppet Master Installation documentation](./install_multimaster.html).

### stdlib No Longer Installed with Puppet Enterprise

If necessary, you can install stdlib after installing/upgrading by running `puppet module install puppetlabs-stdlib`.

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

### PuppetDB Behind a Load Balancer Causes Puppet Server Errors

Puppet Server handles outgoing HTTPS connections differently from the older MRI Ruby Puppet master, and has a new restriction on the server certificates it will accept. This affects all Puppet Enterprise versions in the 3.7.x series.

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

### Before Upgrading to PE 3.7.0, Correct Invalid Entries in `autosign.conf`

Any entries in `/etc/puppetlabs/puppet/autosign.conf` that don't conform to the [autosign requirements](/puppet/3.7/reference/ssl_autosign.html#the-autosignconf-file) will cause the upgrade to fail to configure the PE console. Please correct any invalid entries before upgrading.

### `q_database_host` Cannot be an Alt Name For Upgrades or Installs of 3.7.0

PostgreSQL does not support alt names when set to `verify_full`. If you are upgrading to or installing 3.7 with an answer file, make sure `q_database_host` is set as the Puppet agent certname for the database node and not set as an alt name.

### Upgrading Requires You to Manually Configure Default Node Groups

Puppet Enterprise automatically creates a number of special node groups for managing your deployment. In a new install, these node groups come with some default classes. If you’re upgrading, only the MCollective node group comes with classes. For the others, you must manually add the individual classes and configure the parameters, as described on the page, [Preconfigured Node Groups](./console_classes_groups_preconfigured_groups.html#preconfigured-node-groups).

### You Might Need to Upgrade puppetlabs-inifile to Version 1.1.0 or Later
PE will automatically update your version of puppetlabs-inifile as part of the upgrade process. However, if you encounter the following error message on your PuppetDB node, then you need to manually upgrade the puppetlabs-inifile module to version 1.1.0 or higher.

	Error: Could not retrieve catalog from remote server: Error 400 on SERVER: Invalid parameter quote_char on Ini_subsetting['-Xmx'] on node master
	Warning: Not using cache on failed catalog
	Error: Could not retrieve catalog; skipping run

### A Note about Symlinks and Installation/Upgrade

The answer file no longer gives the option of whether to install symlinks. These are now automatically installed by packages. To allow the creation of symlinks, you need to ensure that `/usr/local` is writable.

However, please note that we do not recommend employing symlinks in the place of `/opt` for database storage, as doing so can lead to databases not being seen. In addition, if `/opt/puppet` is symlink, the `-d` flag will not function correctly during an uninstall.

### Answer File Required for Some SMTP Servers

Any SMTP server that requires authentication, TLS, or runs over any port other than 25 needs to be explicitly added to an answers file. See the [advanced configuration page](./console_config.html#allowing-anonymous-console-access) for details.

### Installing Agents in a PE Infrastructure with No Internet Access

Refer to [Installing Agents in a Puppet Enterprise Infrastructure without Internet Access](./install_agents.html#installing-agents-in-a-puppet-enterprise-infrastructure-without-internet-access).

## Puppet Server Known Issues

> **Tip**: More information about Puppet Server can be found in the [Puppet Server docs](/puppetserver/1.0/services_master_puppetserver.html). Differences between PE and open source versions of Puppet Server are typically called out.

### Updating Puppet Master Gems

After upgrading to PE 3.7.2, you need to update the Ruby gems used by your Puppet Master with `/opt/puppet/bin/puppetserver gem install <GEM NAME>`.

For instance, in PE 3.7.2, the deep_merge gem is no longer installed by default. If you previously used this gem, you will need to reinstall it after upgrading.

After updating the gems, you need to restart the Puppet master with `service pe-puppetserver restart`. You should do this **before** doing any Puppet agent runs.

>**Note**: Installing `puppetserver` gems fails when run unprivileged. You might get a "no such file or directory" error. Instead, install as root.

### Installing Gems when Puppet Server is Behind a Proxy Requires Manual Download of Gems

If you run Puppet Server behind a proxy, the `puppetserver gem install` command will fail. Instead you can install the gems as follows:

1. Use [rubygems.org](https://rubygems.org/pages/download#formats) to search for and download the gem you want to install, and transfer that gem to your Puppet master. 
2. Run `/opt/puppet/bin/puppetserver gem install --local <PATH to GEM>`.

### A Note About Gems with Native (C) Extensions for JRuby on the Puppet Server

Please see the Puppet Server documentation for a description of this issue, [Gems with Native (C) Extensions](/puppetserver/1.0/gems.html#gems-with-native-c-extensions).

### Running `pe-puppetserver` on a Server With More Than Four Cores Might Require Tuning

The more JRuby instances you run, the more heap space you'll require.  You have two options:

* Reduce the number of JRuby instances. For more information about configuring settings like these, see [Configuring and Tuning Puppet Server](./config_puppetserver.html).
* Increase the JVM heap size for puppet server. See the PE Puppet Server Service section of [Configuring Java Arguments For PE](./config_java_args.html).

Generally speaking, we recommend starting your tuning with six JRuby instances and then tuning memory from there. If you want more throughput, you need to increase JRuby instances and heap space concurrently after you've found a steady state.


### Puppet Server Run Issue when `/tmp/` Directory Mounted `noexec`

In some cases (especially for RHEL 7 installations) if the `/tmp` directory is mounted as `noexec`, Puppet Server may fail to run correctly, and you may see an error in the Puppet Server logs similar to the following:

    Nov 12 17:46:12 fqdn.com java[56495]: Failed to load feature test for posix: can't find user for 0
    Nov 12 17:46:12 fqdn.com java[56495]: Cannot run on Microsoft Windows without the win32-process, win32-dir and win32-service gems: Win32API only supported on win32
    Nov 12 17:46:12 fqdn.com java[56495]: Puppet::Error: Cannot determine basic system flavour

To work around this issue, you can either mount the `/tmp` directory without `noexec`, or you can choose a different directory to use as the temporary directory for the Puppet Server process. 

If you want to use a directory other than `/tmp`, you can add an extra argument to the `$java_args` parameter of the `puppet_enterprise::profile::master` class using the PE console. Add `{"Djava.io.tmpdir=/var/tmp":""}` as the value for the `$java_args` parameter. Refer to [Editing Parameters](./console_classes_groups_making_changes.html#editing-parameters) for instructions on editing parameters in the console.

Note that whether you use `/tmp` or a different directory, you’ll need to set the permissions of the directory to `1777`. This allows the Puppet Server JRuby process to write a file to `/tmp` and then execute it. 

### No Config Reload Requests

The Puppet Server service doesn't have a non-disruptive way to request a reload of its configuration files. In order to reload its config, you must restart the service.

Refer to [SERVER-15](https://tickets.puppetlabs.com/browse/SERVER-15).

### HTTPS Client Issues With Newer Apache `mod_ssl` Servers

When configuring the Puppet server to use a report processor that involves HTTPS requests (e.g. to Foreman), there can be compatibility issues between the JVM HTTPS client and certain server HTTPS implementations (e.g. very recent versions of Apache `mod_ssl`). This is usually indicated by a `Could not generate DH keypair` error in Puppet Server's logs. See [SERVER-17](https://tickets.puppetlabs.com/browse/SERVER-17) for known workarounds.


## PuppetDB/PostgreSQL Known Issues

### PostgreSQL Buffer Memory Issue Can Cause PE Install to Fail on Machines with Large Amounts of RAM

In some cases, when installing PE on machines with large amounts of RAM, the PostgreSQL database will use more shared buffer memory than is available and will not be able to start. This will prevent PE from installing correctly. For more information and a suggested workaround, refer to [Troubleshooting the Console and Database](./trouble_console-db.html#postgresql-memory-buffer-causes-pe-install-to-fail).

### Errors Related to Stopping `pe-postgresql` Service

If for any reason the `pe-postgresql` service is stopped, agents will receive several different error messages, for example:

    Warning: Unable to fetch my node definition, but the agent run will continue:
    Warning: Error 400 on SERVER: (<unknown>): mapping values are not allowed in this context at line 7 column 28

or, when attempting to request a catalog:

    Error: Could not retrieve catalog from remote server: Error 400 on SERVER: (<unknown>): mapping values are not allowed in this context at line 7 column 28
    Warning: Not using cache on failed catalog
    Error: Could not retrieve catalog; skipping run

If you encounter these errors, simply re-start the `pe-postgresql` service.


### `db:raw:optimize` Rake Task does not Work in PE 3.7.x

The `db:raw:optimize` Rake task does not work in PE 3.7.0 because the ownership of the database was changed from `console` to `pe-postgres`.

To re-index and vacuum the console database, you can use the following PostgreSQL commands:

`su - pe-postgres -s /bin/bash -c "reindexdb console"; su - pe-postgres -s /bin/bash -c "vacuumdb --full --verbose console"`

## PE console/pe-console-services

#### Node Classifier Returns Activity Service Error When Importing a Large Number of Groups

In PE 3.7, an error indicating that the "index row size exceeds maximum" is returned when importing a large number of groups (for example, when upgrading a large environment to PE 3.7). This error is returned even if the import was successful. 

### PE Console Doesn't Display Parent Group Rules

In the console, parent group rules don't show, which makes it easier to create a rule that contradicts an inherited rule. If you create a contradictory rule, then you might find that no nodes match the rule you've created. The **Matching nodes** tab is accurate. If you don't see the nodes you're expecting on this tab, then you need to look up the ancestor rules to identify the contradictory rule.

Matching nodes aren’t showing up.

### Newly Created Node Group Does Not Appear in List of Parents

When you create a new node group in the console, then immediately create another new node group and try to select the first node group as the parent, the first node group does not appear in the list of selectable names in the **Parent name** drop-down list. The first node group will appear if you reload the page. 
 
### Can Only Accept Or Reject One Node at a Time

In PE 3.7.2, if you have multiple node requests pending, you can accept/reject one node, but if you then try to accept/reject subsequent nodes a 403 Forbidden error is returned. This means that if you want to accept/reject node requests one at a time, you have to refresh the page after each time you accept/reject a node request. 

### Node Classifier Ignores Facts That Are False

When creating node matching rules in PE 3.7, the node classifier ignores all facts with a boolean value of `false`. For example, if you create a rule like `is_virtual` `is` `false`, the rule will never match a node. To avoid this problem, rewrite the rule to be `is_virtual` `is not` `true`. 

### Important Factors in Connecting to an External Directory Service

The following requirement affects how you connect your existing LDAP to PE:

   * Use of multiple user RDNs or group RDNs is not supported.

### Custom Console Certs May Break on Upgrade

Upgrades to this version of PE may affect deployments that use a custom console certificate, as certificate functionality has changed between versions.

In addition, the document [Configuring the Puppet Enterprise Console to Use a Custom SSL Certificate](./custom_console_cert.html) does not work for this version of PE. This document, as well as custom console cert functionality, will be fixed in PE 3.8.0.

### Error When a PE User and User Group Have the Same Name

If you have both a PE user and a user group with the exact same name, PE will throw an error when you perform a search that matches both of these entries.

### 400 Error When There Are Over 500 Nodes Pinned to a Node Group and You Click **Load All Nodes**

When there are over 500 nodes pinned to a node group, a **Load All Nodes** button appears in the **Matching nodes** tab for that node group. Clicking the **Load All Nodes** button results in a 400 error.

### Not All Environments Are Listed in the PE Console

When the classifier service encounters an environment that has code that will not compile, it marks the environment as deleted. If you later correct the code in the environment, the classifier service does not remove the deleted flag. 

To manually remove the deleted flag for an environment named "test" for example, in the command line, type:

    su - pe-postgres -s /bin/bash -c "/opt/puppet/bin/psql -d 'pe-classifier' -c \"UPDATE environments SET deleted = 'f' WHERE name = 'test';\""

### Console Session Timeout Issue

The default session timeout for the PE console is 30 minutes. However, due to an issue that has not yet been resolved, console users will be logged out after thirty minutes even if they are currently active.

This issue was resolved in PE 3.7.1.

### SLES 12 `pe::repo` Class Available in PE Console but SLES 12 not Supported in PE 3.7.0

Due to a known issue in PE 3.7.0, you can select the SLES 12 `pe::repo` class from the PE console, but this class will not work. SLES 12 is not supported in PE 3.7.0, and no tarballs for SLES 12 are shipped in this version.

Support for SLES 12 will be added in a future release.

### Nodes Can Be Pinned an Infinite Number of Times

When pinning a node to a node group in the PE console, if you pin the node multiple times, the console does not resolve this to a single entry. For example, if you pin the same node to a node group ten times and commit it, the console will show that you have ten nodes all with the same node name. 

### Safari Certificate Handling May Prevent Console Access

[client_cert_dialog]: ./images/client_cert_dialog.png

Due to [Apache bug 53193](https://issues.apache.org/bugzilla/show_bug.cgi?id=53193) and the way Safari handles certificates, Puppet Labs recommends that PE 3.7 users avoid using Safari to access the PE console.

If you need to use Safari, you may encounter the following dialog box the first time you attempt to access the console after installing/upgrading PE 3.7:

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

Note that unless your system contains OpenSSL v1.0.1d (the version that correctly supports TLS1.1 1and 1.2), prioritizing RC4 may leave you vulnerable to other types of attacks.

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

### Problems with Marking Failed Tasks as Read in the console

Marking failed tasks as read in the console can instead open a security warning, followed by an "unable to connect" message.


## PE services/Puppet Core Known Issues

### PE 3.7.0 Agent Can't Compile Against PE 3.7.1 Master If Future Parser Is installed

If you upgrade or install a PE 3.7.1 master, sign the certificate, and run Puppet on a 3.7.0 agent node, that should succeed. However, if you enable future parser, restart pe-puppetserver, and then run Puppet on the agent again, you'll get a server error. This error doesn't happen if you enable future parser with a PE 3.7.0 master and agent, or a PE 3.7.1 master and agent, only a 3.7.1 master with a 3.7.0 agent. To avoid this problem, update your agents to match the version of your masters.


### Facter 2.2 Known Issues

* PE 3.7.x uses Facter 2.2, which turned off `stringify_facts` and turned on structured facts from the agents. This means that facts that were previously strings are now structured. Perhaps more importantly, facts that were previously strings like "true", "false" are now actual booleans. This causes situations where an `if` statement such as, `if $is_virtual == 'true'`, hits the `else` condition because the boolean value for true is not the same thing as the string "true".
* Change to `lsbmajdistrelease` fact affects some manifests. This is because In Facter 2.2.0, the `lsbmajdistrelease` fact changed its value from the first two numbers to the full two-number.two-number version on Ubuntu systems. This might break manifests that were based on the previous behavior. For example, this fact changed from: `12` to `12.04`
This change affects Ubuntu and Amazon Linux. See the [Facter documentation for more information](/facter/2.2/release_notes.html#significant-changes-to-existing-facts).

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

### Tagmail Isn't Sending Email Notifications

Tagmail doesn't work out of the box in PE 3.7. The [Tagmail module](https://forge.puppetlabs.com/mrpuppet/tagmail), while not a PE supported module, is the recommended workaround.

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

### Readline Version Issues on AIX Agents

- AIX 5.3 Puppet agents depend on readline-4-3.2 being installed. You can check the installed version of readline by running `rpm -q readline`. If you need to install it, you can [download it from IBM](ftp://ftp.software.ibm.com/aix/freeSoftware/aixtoolbox/RPMS/ppc/readline/readline-4.3-2.aix5.1.ppc.rpm). Install it *before* installing the Puppet agent.

- On AIX 6.1 and 7.1, the default version of readline, 4-3.2, is insufficient. You need to replace it *before* upgrading or installing by running

        rpm -e --nodeps readline
        rpm -Uvh readline-6.1-1.aix6.1.ppc.rpm

If you see an error message after running this, you can disregard it. Readline-6 should be successfully installed, and you can proceed with the installation or upgrade (you can verify the installation with  `rpm -q readline`).

### Solaris Updates May Break Puppet Install

We've seen an issue in which Puppet agents on Solaris platforms have quit responding after the core Solaris OS was updated. Essential Puppet configuration files were erased from the `/etc/` directory (which includes SSL certs needed to communicate with the Puppet master), and the `/etc/hosts` file was reverted.

If you encounter this issue, log in to the Puppet master and clear the agent cert from the Solaris machine (`puppet cert clean <HOSTNAME>`), and then re-install [the Puppet agent](.//install_agents.html).

### Debian/Ubuntu Local Hostname Issue

On some versions of Debian/Ubuntu, the default `/etc/hosts` file contains an entry for the machine's hostname with a local IP address of 127.0.1.1. This can cause issues for PuppetDB and PostgreSQL, because binding a service to the hostname will cause it to resolve to the local-only IP address rather than its public IP. As a result, nodes (including the console) will fail to connect to PuppetDB and PostgreSQL.

To fix this, add an entry to `/etc/hosts` that resolves the machine's FQDN to its *public* IP address. This should be done prior to installing PE. However, if PE has already been installed, restarting the `pe-puppetdb` and `pe-postgresql` services after adding the entry to the hosts file should fix things.

### Puppet Enterprise Cannot Locate Samba init Script for Ubuntu 14.04

If you attempt to install and start Samba using PE resource management, you will may encounter the following errors:

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

### Razor Known Issues

Please see the page [Razor Setup Recommendations and Known Issues](./razor_knownissues.html).



Puppet Terminology
-----

For help with Puppet-specific terms and language, visit [the glossary](/references/glossary.html)

For a complete guide to the Puppet language, visit [the reference manual](/puppet/3.6/reference/)

* * *

- [Next: Getting Support](./overview_getting_support.html)





























