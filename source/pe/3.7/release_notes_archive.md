---
layout: default
title: "Archived Release Notes"
subtitle: "Archived Puppet Enterprise Release Notes"
canonical: "/pe/latest/release_notes_archived.html"
---
This page contains information about security fixes, bug fixes, and new features for the following releases:

* PE 3.7.2
* PE 3.7.1
* PE 3.7.0
* PE 3.3.2
* PE 3.3.1
* PE 3.3.0

## Puppet Enterprise 3.7.2 (2/10/15)

This section provides Puppet Enterprise (PE) 3.7.2 release information.

## New Features 

PE 3.7.2 introduced the following new features and improvements. 

### RBAC Can Query an Entire Base DN For Users and Groups

Previously, RBAC required an RDN (relative distinguished name) for user and group queries to an external directory. An RDN is no longer required. This means that you can search an entire base DN (distinguished name) for a user or group.

For more information, see [Connecting Puppet Enterprise with LDAP Services](./rbac_ldap.html).

### `jruby_max_active_instances` Now Available

This new setting enables you to tune the number of JRuby instances you're running. Doing so helps you control the amount of heap space your infrastructure uses. See [this known issue](./release_notes_known_issues.html#running-pe-puppetserver-on-a-server-with-more-than-four-cores-might-require-tuning) for more information and suggestions for using this setting.

## Security Fixes

#### CVE - OpenSSL January 2015 Security Fixes

Posted February 10, 2015

On January 8th, the OpenSSL project announced several security vulnerabilities in OpenSSL. Puppet Enterprise versions prior to 3.7.2 contained vulnerable versions of OpenSSL. Puppet Enterprise 3.7.2 contains updated versions of OpenSSL that have patched the vulnerabilities.

For more information about the OpenSSL vulnerabilities, refer to the [OpenSSL security announcement](https://www.openssl.org/news/secadv_20150108.txt).

OpenSSL issues affected PE 2.x and 3.x. They're resolved in PE 3.7.2.

#### CVE - Oracle Java January 2015 Security Fixes

Posted February 10, 2015
Assessed Risk Level: Medium

On January 20th, Oracle announced several security vulnerabilities in Java. Puppet Enterprise versions prior to 3.7.2 contained a vulnerable version of Java. Puppet Enterprise 3.7.2 contains an updated version of Java that has patched the vulnerabilities.

For more information about the Java vulnerabilities, refer to the [Oracle security announcement](http://www.oracle.com/technetwork/topics/security/cpujan2015-1972971.html).

This issue affected PE 3.x. It's resolved in PE 3.7.2.

#### CVE - 2015-1426 - Potential Sensitive Information Leakage in Facter's Amazon EC2 Metadata Facts Handling

Posted February 10, 2015
Assessed Risk Level: Low

An issue exists where sensitive Amazon EC2 IAM instance metadata could be added to an Amazon EC2 node's facts, where a non-privileged local user could access the information via Facter.

Although Amazon’s API allows anyone who can access an EC2 instance to view its instance metadata, facts containing sensitive EC2 instance metadata could be unintentionally exposed through off-host applications that display facts.

CVSS v2 Score: 1.3

Vector AV:L/AC:L/Au:S/C:P/I:N/A:N/E:U/RL:OF/RC:C

This issue affects PE 2.x and 3.x, Facter 1.6.0 - 2.4.0, and CFacter 0.2.0 and earlier. It's resolved in PE 3.7.2 and CFacter 0.3.0.

## Bug Fixes 

PE 3.7.2 contains a number of performance and documentation improvements, in addition to the fixes that are highlighted below.

#### Install and Upgrade Fixes

* PE installer did not create the symlink for the PE Java cacerts file.
This issue made `puppetserver gem install` fail with the error "Certificate verify failed." It also caused the error, "Could not find a valid gem 'hiera-eyaml'".
* PE installer did not check permissions on untarred folders, which caused the installer to fail.
* `pe-puppet` failed to upgrade on RHEL 4.

#### The `node:del` Rake Task Deleted a Node Group Instead of the Node

In PE 3.7, the behavior of the `node:del` rake task changed so that it deleted the node group to which a specified node was pinned. In PE 3.7.2, this behavior has been reverted to the PE 3.3 behavior so that `node:del` now deletes the specified node from the console database.

A new rake task, `node:delgroup`, was introduced in PE 3.7.2 for deleting a node group.

For more information, see the [rake API documentation](./console_rake_api.html).

#### Additional Node Manager Service Fixes

* Environments are now removed from the classifier when they are no longer populated.
* In PE console service, changes to logback.xml are now dynamically taken up.
* Escaping DNs is now in place for searching for group membership.
* Classifier synchronization failed if an environment couldn't be loaded.

#### Role-Based Access Control Fixes

* Previously, when tracing back an LDAP or Active Directory user's group membership, if one of the groups had a DN with a special character in it, the search would break. Now that search has been updated and should properly escape all special characters.
* When resetting the admin password in RBAC, it wasn't obfuscated. It's now obfuscated.

#### Agent Install Did Not Normalize FQDN for Certname

Previously, if an agent was installed on a node with capital letters in the FQDN, then that FQDN with capital letters would be placed directly into the certname in puppet.conf.  Due to an older issue in Puppet, mixed-case certnames allow a certificate to be created and signed that is lowercase and that does not match the certname in puppet.conf.

This mismatch was addressed by a fix to the PE 3.7.2 agent installer that downcases the entire certname before placing it in puppet.conf.

#### PE PostgreSQL Was Started After Services That Depended On It

Services like PuppetDB and Console Services were started before PostgreSQL and then were dead after a reboot.

#### `puppet_enterprise::packages` Was Overriding Package Resource Defaults

This was a problem because if `pe_gem` was installed, it would become the preferred provider over Zypper and cause package installs to fail.

#### Puppet Server Was Aggressively Transforming Request Data to UTF-8

The Clojure code that processed requests for delivery to JRuby aggressively transformed the request body to UTF-8. This altered the data contained in the request body and was not appropriate for all requests submitted to a Puppet Master. Notably, file bucket uploads failed if the file content being saved was not strictly UTF-8. The fix is that Puppet Server handles arbitrary character encodings, including raw binary.

#### Additional Bug Fixes

The following issues were also fixed for PE 3.7.2

* Automatic classification broke in IE 10 and 11 due to aggressive caching.
* The `pe_accounts` "examples" directory broke RDoc; it's been removed.
* The MCO cron sent spam to the root email account.
* Confusing and unnecessary settings were removed from the `master` section of `puppet.conf`.

## Puppet Enterprise 3.7.1 (12/16/14)
This section provides PE 3.7.1 release information.

## New Features 

PE 3.7.1 introduced the following new features and improvements. 

### SLES 12 Support (all components)

This release provides full support for SLES 12 on all PE components, including the Puppet master.

For more information, see the [system requirements](./install_system_requirements.html).

### Node Classifier Improvements

The default sync time for the node classifier has been changed from 15 minutes to 3 minutes to be the same as the default refresh time for the environment cache. This means that, by default, the node classifier now retrieves new classes from the master every 3 minutes. For more information, see the [Getting Started With Classification](./console_classes_groups.html#adding-classes-that-apply-to-all-nodes) page.

In addition, PE 3.7.1 has a **Refresh** button in the **Classes** page that allows you to manually retrieve new classes from the master without waiting for the 3 minute sync period. The timestamp to the left of the **Refresh** button shows the time that has elapsed since the last sync.

### Improvements to the Windows User Experience

Puppet 3.7.3 provided Windows users with two useful new facts, as well as a fix to the PATH variable that are now available to PE users.

These are the new facts:

* [`$system32`](/facter/latest/core_facts.html#system32) is the path to the **native** system32 directory, regardless of Ruby and system architecture. This means that inside a 32-bit Puppet/Ruby on Windows x64, this fact typically resolves to `c:\windows\sysnative`. On a 64-bit Puppet/Ruby on Windows x64, this fact typically resolves to `c:\windows\system32`. In other words, this always gets the `system32` directory with binaries that are the same bitness as the current OS.
* [`$rubyplatform`](/facter/latest/core_facts.html#rubyplatform) reports the value of Ruby's `RUBY_PLATFORM` constant.

For details on these improvements, see the [Puppet 3.7.3 Release Notes](/puppet/3.7/reference/release_notes.html#puppet-373).

In addition, all of the **Windows versions of Puppet Enterprise supported modules** have been updated to support 64-bit as well as 32-bit Ruby runtime. For more information about supported modules, see the [Supported Modules page in the Forge documentation](https://forge.puppetlabs.com/supported).

**Scheduled tasks** have also been improved for this release in the following ways:

* An error message will notify you when the task scheduler is disabled. Previously, the Win32-taskscheduler gem 0.2.2 crashed.
* The Windows scheduled task (scheduled_task) provider was generating spurious messages during Puppet runs that suggested that scheduled task resources were being reapplied during each run even when the task was present and its associated resource had not been modified. This has been fixed. For more information, see the information on [scheduled tasks on Windows](/puppet/3.7/reference/resources_scheduled_task_windows.html) in the **Puppet** documentation.

## Security Fixes

#### CVE-2014-9355 - Information Leakage in Puppet Enterprise Console

Posted December 16, 2014
Assessed Risk Level: Medium

In Puppet Enterprise 3.7.0, an authenticated Puppet Enterprise console user with no permissions could access certain API endpoints that provide information about PE licensing and certificate signing requests.

This issue affected Puppet Enterprise 3.7.0. It has been fixed for Puppet Enterprise 3.7.1.

CVSS v2 Score: 4.0
Vector AV:N/AC:L/Au:S/C:P/I:N/A:N/E:H/RL:U/RC:C

For information on previous releases, see the [Archived Release Notes](./release_notes_archive.html).

#### CVE-2014-7818 and CVE-2014-7829 Rails Action Pack Vulnerabilities Allow Arbitrary File Existence Disclosure

Posted December 16, 2014
Assessed Risk Level: Medium

Vulnerabilities in Rails Action Pack allow an attacker to determine the existence of files outside the Rails application root directory. The files will not be served, but attackers can determine whether or not specific files exist.

This issue affected Puppet Enterprise 3.x. It is resolved in Puppet Enterprise 3.7.1.

CVE-2014-7818:
Upstream CVSS v2 Score: 4.3
Vector: AV:N/AC:L/Au:N/C:P/I:N/A:N/E:POC/RL:W/RC:C

CVE-2014-7829:
Upstream CVSS v2 Score: 5.0
Vector: AV:N/AC:L/Au:N/C:P/I:N/A:N

## Bug Fixes 

#### puppet_enterprise Module Was Missing Values for Several PuppetDB Attributes

PE 3.7.0 contained a version of the puppet_enterprise module that does not have the parameters to manage several important PuppetDB attributes, such as `gc-interval`, `node-ttl`, `node-purge-ttl`, and `report-ttl`. This was fixed in PE 3.7.1.

#### `puppet_enterprise::master` Did Not Allow Multiple DNS Alt Names

The resource that manages the `dns_alt_names` entry for `puppet.conf` did not operate correctly with arrays, and only the first element of the array was used. This was fixed in PE 3.7.1.

#### Upgrader Failed If `basemodulepath` Was Changed

If you changed your config so that `/opt/puppet/share/puppet/modules` wasn't in your modulepath anymore, one of the `puppet resource` calls in the upgrader would fail because it couldn't find the module it needed.

This is fixed. Now, the `puppet resource` call explicitly sets its modulepath, so that it doesn't matter what you've set yours to.

This was listed as a Known Issue for PE 3.7.0.

#### Changing the ssl-host to `0.0.0.0` Caused the Upgrade to Change Other Settings, Making PuppetDB Unusable

During an upgrade, the installer used the value of ssl-host in `/etc/puppetlabs/puppetdb/conf.d/jetty.ini` to determine the value of `q_puppetdb_hostname`. If you changed the ssl-host to `0.0.0.0` so that PuppetDB could listen on any interface, the upgrade changed other settings that were filled in with `q_puppetdb_hostname` that made PuppetDB unusable after an upgrade in a monolithic installation.

This has been fixed. Now, the agent certname is used to figure out the PuppetDB hostname, since those two things have to match.

## Puppet Enterprise 3.7.0 (11/11/14)
This section provides PE 3.7.0 release information.

## New Features 

PE 3.7.0 introduced the following new features and improvements.

### Next-Generation Puppet Server

PE 3.7.0 introduces the Puppet server, built on a JVM stack, which functions as a seamless drop-in replacement for the former Apache/Passenger Puppet master stack.

For users upgrading from an earlier version of PE, there are a few things you'll notice after upgrading due to changes in the underlying architecture of the Puppet server.

[About the Puppet Server](./install_upgrading_puppet_server_notes.html) details some items that are intentionally different between the Puppet server and the Apache/Passenger stack; you may also be interested in the PE [Known Issues Related to Puppet Server](./release_notes_known_issues.html#puppet-server-known-issues), where we've listed a handful of issues that we expect to fix in future releases.

[Graphing Puppet Server Metrics](./puppet_server_metrics.html) provides instructions on setting up a Graphite server running Grafana to track Puppet server performance metrics.

### Adding Puppet Masters to a PE Deployment

This release supports the ability to add additional Puppet masters to large PE deployments managing more than 1500 agent nodes. Using additional Puppet masters in such scenarios will provide quicker, more efficient compilation times as multiple masters can share the load of requests when agent nodes run.

For instructions on adding additional Puppet masters, refer to [Additional Puppet Master Installation](./install_multimaster.html).

### Node Manager

PE 3.7.0 introduces the rules-based node classifier, which is the first part of the Node Manager app that was announced in September. The node classifier provides a powerful and flexible new way to organize and configure your nodes. We’ve built a robust, API-driven backend service and an intuitive new GUI that encourages a modern, cattle-not-pets approach to managing your infrastructure. Classes are now assigned at the group level, and nodes are dynamically matched to groups based on user-defined rules.

For a detailed overview of the new node classifier, refer to the [PE user's guide](./console_classes_groups.html).

### Role-Based Access Control

With RBAC, PE nodes can now be segmented so that tasks can be safely delegated to the right people. For example, RBAC allows segmenting of infrastructure across application teams so that they can manage their own servers without affecting other applications. Plus, to ease the administration of users and authentication, RBAC connects directly with standard directory services including Microsoft Active Directory and OpenLDAP.

For detailed information to get started with RBAC, see the [PE user's guide](./rbac_intro.html).

### Adding MCollective Hub and Spokes

PE 3.7.0 provides the ability to add additional ActiveMQ hubs and spokes to large PE deployments managing more than 1500 agent nodes. Building out your ActiveMQ brokers will provide efficient load balancing of network connections for relaying MCollective messages through your PE infrastructure.

For instructions on adding additional ActiveMQ Hubs and Spokes, refer to [Additional ActiveMQ Hub and Spoke Installation](./install_add_activemq.html).

### Upgrades to Directory Environments

PE 3.7.0 introduces full support for directory environments, which will be enabled by default.

Environments are isolated groups of Puppet agent nodes. This frees you to use different versions of the same modules for different populations of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines. Directory environments let you add a new environment by simply adding a new directory of config data.

For your reference, we've provided some notes on what you may experience during upgrades from a previous version of PE. See [Important Information about Upgrades to PE 3.7 and Directory Environments](./install_upgrading_dir_env_notes.html).

Before getting started, visit the Puppet docs to read up on the [Structure of an  Environment](/puppet/3.7/reference/environments_creating.html#structure-of-an-environment), [Global Settings for Configuring Environments](/puppet/3.7/latest/reference/environments_configuring.html#global-settings-for-configuring-environments), and [creating directory environments](/puppet/3.7/reference/environments_creating.html).

#### A Note about `environment_timeout` in PE 3.7.0

The [environment_timeout](/puppet/3.7/reference/environments_configuring.html#environmenttimeout) defaults to 3 minutes. This means that code changes you make might not appear until after that timeout has been reached. In addition it's possible that back to back runs of Puppet could flip between the new code and the old code until the `environment_timeout` is reached.

### Support Script Improvements

PE 3.7.0 includes several improvements to the support script, which is bundle in the PE tarball. Check out the [Getting Support page](./overview_getting_support.html#the-pe-support-script) for more information about the support script.

### SLES 10 Support (agent only)

This release provides support for SLES 10 for agent only installation.

For more information, see the [system requirements](./install_system_requirements.html).

### Enhanced Security For Using HTTP CA API Endpoints

To use the Puppet master's `certificate_status` API endpoint, you now need to add your client to the whitelist in [`ca.conf`](/puppetserver/1.0/configuration.html#caconf). After you add your client to the whitelist, restart Puppet Server using `service pe-puppetserver restart`.

## Security Fixes

#### OpenSSL Security Vulnerabilities

On October 15th, the OpenSSL project announced several security vulnerabilities in OpenSSL. Puppet Enterprise versions prior to 3.7.0 contained vulnerable versions of OpenSSL. Puppet Enterprise 3.7 contains updated versions of OpenSSL that have patched the vulnerabilities.

For more information about the OpenSSL vulnerabilities, refer to the OpenSSL [security announcement](https://www.openssl.org/news/secadv_20141015.txt).

Affected Software Versions:
* Puppet Enterprise 2.x
* Puppet Enterprise 3.x

Resolved in:
Puppet Enterprise 3.7.0

#### Oracle Java Security Vulnerabilities

Assessed Risk Level: Medium

On October 14th, Oracle announced several security vulnerabilities in Java. Puppet Enterprise versions prior to 3.7.0 contained a vulnerable version of Java. Puppet Enterprise 3.7.0 contains an updated version of Java that has patched the vulnerabilities.

For more information about the Java vulnerabilities, refer to the Oracle [security announcement](http://www.oracle.com/technetwork/topics/security/cpuoct2014-1972960.html).

Affected Software Versions:
Puppet Enterprise 3.x

Resolved in:
Puppet Enterprise 3.7.0

#### CVE-2014-3566 - POODLE SSLv3 Vulnerability

Posted November 11, 2014
Assessed Risk Level: Medium

On October 14th, the OpenSSL project announced CVE-2014-3566, the POODLE attack vulnerability in the SSLv3 protocol. Fixes for this vulnerability disable SSLv3 protocol negotiation to prevent fallback to the insecure protocol.

Resolved in:
Puppet Enterprise 3.7.0
Manual remediation provided for Puppet Enterprise 3.3
Puppet 3.7.2, Puppet-Server 0.3.0, PuppetDB 2.2, MCollective 2.6.1

Users of Puppet Enterprise 3.3 who cannot upgrade can follow the remediation instructions in our [impact assessment](http://puppetlabs.com/blog/impact-assessment-sslv3-vulnerability-poodle-attack).

## Bug Fixes 

#### `/etc/puppetlabs/mcollective/client.cfg` Is Left Behind on Console Node After Upgrade

Before PE used `/var/lib/peadmin/.mcollective`, the pe_mcollective module laid down /etc/puppetlabs/mcollective/client.cfg.

When upgrading from those earlier versions to a later version, on the master node, `/etc/puppetlabs/mcollective/client.cfg` is correctly removed by `pe_mcollective::client::peadmin`; however, on the console node `pe_mcollective::client::puppet_dashboard` did not remove that file.

This meant that if you were coming from one of the older PE 2.x versions you had this file lying around on your console node that didn't actually configure anything. This has been fixed.

## Puppet Enterprise 3.3.2 (9/9/14)
This section provides PE 3.3.2 release information.

## Security Fixes (9/9/14)

####[CVE-2014-0226 - Apache vulnerabilty in mod_status module could allow arbitrary code execution](http://puppetlabs.com/security/cve/cve-2014-0226/)

**Assessed risk level**: medium

**Affected platforms**: Puppet Enterprise 2.x and 3.x

**Resolved in**: Puppet Enterprise 2.8.8, 3.3.2

A race condition in the mod_status module in the Apache HTTP Server before 2.4.10 allows remote attackers to cause a denial of service (due to heap-based buffer overflow), or possibly obtain sensitive credential information or execute arbitrary code.

Upstream CVSS v2 Score: 4.4 with Vector:  AV:L/AC:M/Au:N/C:P/I:P/A:P/E:ND/RL:U/RC:C

####[CVE-2014-0118 - Apache vulnerability in mod_deflate module could allow denial of service attacks](http://puppetlabs.com/security/cve/cve-2014-0118)

**Assessed risk level**: medium

**Affected platforms**: Puppet Enterprise 2.x and 3.x on Debian-based platforms only

**Resolved in**: Puppet Enterprise 2.8.8, 3.3.2

The `deflate_in_filter` function in the mod_deflate module in the Apache HTTP Server before 2.4.10 allows remote attackers to cause a denial of service (due to resource consumption) via crafted request data that decompresses to a much larger size.

Upstream CVSS v2 Score: 5.0 with Vector: AV:N/AC:L/Au:N/C:N/I:N/A:P/E:ND/RL:U/RC:C

####[CVE-2014-0231 - Apache vulnerability in mod_cgid module could allow denial of service attacks](http://puppetlabs.com/security/cve/cve-2014-0231)

**Assessed risk level**: low

**Affected platforms**: Puppet Enterprise 2.x and 3.x on Debian-based platforms only

**Resolved in**: Puppet Enterprise 2.8.8, 3.3.2

The mod_cgid module in the Apache HTTP Server before 2.4.10 does not have a timeout mechanism, which allows remote attackers to cause a denial of service (due to process hang) via a request to a CGI script that does not read from its stdin file descriptor.

Upstream CVSS v2 Score: 2.6 with Vector: AV:N/AC:H/Au:N/C:N/I:N/A:P/E:ND/RL:U/RC:C)

####Additional Security Information for this Release: OpenSSL Security Fixes

On August 6, the OpenSSL project announced several security vulnerabilities in OpenSSL. Puppet Enterprise 2.x and 3.x contained vulnerable versions of OpenSSL. Puppet Enterprise 2.8.8 and 3.3.2 contain updated versions of OpenSSL that have patched the vulnerabilities.

For more information about the OpenSSL vulnerabilities, refer to the [OpenSSL security site](https://www.openssl.org/news/vulnerabilities.html).

##Bug Fixes

**Incomplete /etc/inittab entry for pe-puppet service on AIX**

On AIX, the Puppet Enterprise installation created an incomplete /etc/inittab entry for the pe-puppet service. As a result, Puppet would not automatically start on boot unless the /etc/inittab entry was corrected.

This issue is now fixed.

**Ruby using incorrect LIBPATH on AIX**

Under certain conditions on AIX clients, Puppet Enterprise attempted to use an incorrect OpenSSL library, causing Puppet runs to fail with a Ruby "load failed" error.

This issue is fixed in PE 3.3.2.

## Puppet Enterprise 3.3.1 (8/07/2014)

## Security Fixes

On July 15th, Oracle announced several security vulnerabilities in Java. Puppet Enterprise 3.3.0 contained a vulnerable version of Java. Puppet Enterprise 3.3.1 contains an updated version of Java that has patched the vulnerabilities.

For more information about the Java vulnerabilities, refer to the [Oracle security site](http://www.oracle.com/technetwork/topics/security/cpujul2014-1972956.html).

### Bug Fixes

This release fixes several minor bugs.

## Puppet Enterprise 3.3.0 (6/15/2014)

## New Features

Puppet Enterprise 3.3.0 introduced the following new features and improvements.

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

[dir_environments]: /puppet/3.7/reference/environments.html
[config_envir]: /puppet/3.7/reference/environments_classic.html

The latest version of the Puppet core (Puppet 3.6) deprecates the classic [config-file environments][config_envir] in favor of the new and improved [directory environments][dir_environments]. Over time, both Puppet open source and Puppet Enterprise will make more extensive use of this pattern.

Environments are isolated groups of Puppet agent nodes. This frees you to use different versions of the same modules for different populations of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines. (You could also do this by running a separate Puppet master for testing, but using environments is often easier.)

In this release of PE, please note that if you define environment blocks or use any of the `modulepath`, `manifest`, and `config_version` settings in `puppet.conf`, you will see deprecation warnings intended to prepare you for these changes. Configuring PE to use *no* environments will also produce deprecation warnings.

Once PE has fully moved to directory environments, the default `production` environment will take the place of the global `manifest`/`modulepath`/`config_version` settings.

**PE 3.3 User Impact**

If you use an environment config section in `puppet.conf`, you will see a deprecation warning similar to

     # puppet.conf
     [legacy]
     # puppet config print confdir
     Warning: Sections other than main, master, agent, user are deprecated in puppet.conf. Please use the directory environments feature to specify  environments. (See /puppet/3.7/reference/environments.html)
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

> **Note**: Executing Puppet commands will raise the `modulepath` deprecation warning.

> **About Disabling Deprecation Warnings**
>
> You can disable deprecation warnings by adding `disable_warnings = deprecations` to the `[main]` section of `puppet.conf`. However, please note that this will disable **ALL** deprecation warnings. We recommend that you re-enable deprecation warnings when upgrading so that you don't potentially miss new warnings.

The Puppet 3.6 documentation has a comprehensive overview on working with [directory environments][dir_environments].

### New Puppet Enterprise Supported Modules

This release adds new modules to the list of Puppet Enterprise supported modules: ACL (for Windows), vcsrepo, and Windows PowerShell. Visit the [supported modules](https://forge.puppetlabs.com/supported) page to learn more, or check out the ReadMes for [ACL](https://forge.puppetlabs.com/puppetlabs/acl/1.0.1), [vcsrepo](https://forge.puppetlabs.com/puppetlabs/vcsrepo/1.0.2), and [PowerShell](https://forge.puppetlabs.com/puppetlabs/powershell/1.0.1).

### Puppet Module Tool (PMT) Improvements

The PMT has been updated to deprecate the Modulefile in favor of metadata.json. To help ease the transition, when you run `puppet module generate` the module tool will kick off an interview and generate metadata.json based on your responses.

If you have already built a module and are still using a Modulefile, you will receive a deprecation warning when you build your module with `puppet module build`. You will need to perform [migration steps](/puppet/3.7/reference/modules_publishing.html#build-your-module) before you publish your module. For complete instructions on working with metadata.json, see [Publishing Modules](/puppet/3.7/reference/modules_publishing.html)

Please see [Known Issues](#known-issues) for information about a bug impacting modules that were built with the new PMT but did not perform the migration steps.

### Console Data Export

Every node list view in the console now includes a link to export the table data in CSV format, so that you can include the data in a spreadsheet or other tool.

### Support for Red Hat Enterprise Linux 7

This release provides full support for RHEL 7 for all applicable PE features and capabilities. For more information, see the [system requirements](./install_system_requirements.html).

### Support for Ubuntu 14.04 LTS

This release provides full support for Ubuntu 14.04 LTS for all applicable PE features and capabilities. For more information, see the [system requirements](./install_system_requirements.html).

### Support for Mac OS X (Agent Only)

The Puppet agent can now be installed on nodes running Mac OS X Mavericks (10.9). Other components (e.g., master) are not supported. For more information, see the [system requirements](./install_system_requirements.html) and the [Mac OS X installation instructions](./install_osx.html).

### Support for Windows 2012 R2 (Agent Only)

This release provides agent only support for nodes running Windows 2012 R2. For more information, see the [system requirements](./install_system_requirements.html) and [Installing Windows Agents](./install_windows.html).

### Additional OS Support for Agent Install via Package Management Tools

This release increases the number of PE supported operating systems than can install agents via package management tools, making the agent installation process faster and simpler. For details, visit [Installing Puppet Enterprise Agents](./install_agents.html).

### Support for stdlib 4

This version of PE is fully compatible with version 4.x of stdlib.

### Razor Provisioning Tech Preview Usability Enhancements and Bug Fixes

Razor was included in PE 3.3 as a [tech preview](http://puppetlabs.com/services/tech-preview). This version of Razor includes usability enhancements and bug fixes. For more information, refer to the [Razor documentation](./razor_intro.html).

>**Note**: Razor is included in Puppet Enterprise 3.3 as a tech preview. Puppet Labs tech previews provide early access to new technology still under development. As such, you should only use them for evaluation purposes and not in production environments. You can find more information on tech previews on the [tech preview](http://puppetlabs.com/services/tech-preview) support scope page.

## Security Fixes

####[CVE-2014-0224 OpenSSL vulnerability in secure communications](http://puppetlabs.com/security/cve/cve-2014-0224/)

**Assessed Risk Level**: medium

**Affected Platforms**:

* Puppet Enterprise 2.8 (Solaris, Windows)

* Puppet Enterprise 3.2 (Solaris, Windows, AIX)

Due to a vulnerability in OpenSSL versions 1.0.1 and later, an attacker could intercept and decrypt secure communications. This vulnerability requires that both the client and server be running an unpatched version of OpenSSL. Unlike heartbleed, this attack vector occurs after the initial handshake, which means encryption keys are not compromised. However, Puppet Enterprise encrypts catalogs for transmission to agents, so PE manifests containing sensitive information could have been intercepted. We advise all users to avoid including sensitive information in catalogs.

Puppet Enterprise 3.3.0 includes a patched version of OpenSSL.

CVSS v2 score: 2.4 with Vector: AV:N/AC:H/Au:M/C:P/I:P/A:N/E:U/RL:OF/RC:C

####[CVE-2014-0198 OpenSSL vulnerability could allow denial of service attack](http://puppetlabs.com/security/cve/cve-2014-0198/)

**Assessed Risk Level**: low

**Affected Platforms**: Puppet Enterprise 3.2 (Solaris, Windows, AIX)

Due to a vulnerability in OpenSSL versions 1.0.0 and 1.0.1, if SSL\_MODE_\RELEASE\_BUFFERS is enabled, an attacker could cause a denial of service.

CVSS v2 score: 1.9 with Vector: AV:N/AC:H/Au:N/C:N/I:N/A:P/E:U/RL:OF/RC:C

####[CVE-2014-3251 MCollective `aes_security` plugin did not correctly validated new server certs](http://puppetlabs.com/security/cve/cve-2014-3251/)

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
* When upgrading from PE3.1 to PE3.2, Hiera variables set in PE3.1 would revert back to default values because `::pe` was added to the variable name in PE3.2. This issue has been fixed and PE3.3 recognizes variable names both with and without `::pe` in the name.

- [Next: Compliance: Alternate Workflow](./compliance_alt.html)
