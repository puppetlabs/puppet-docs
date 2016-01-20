---
layout: default
title: "PE 3.3 » Archived Release Notes"
subtitle: "Archived Puppet Enterprise 3.3.0, 3.3.1 Release Notes"
canonical: "/pe/latest/release_notes_archived.html"
---
This page contains information about security fixes, bug fixes, and new features for PE 3.3.1 and PE 3.3.0 releases. 


## Puppet Enterprise 3.3.1 (8/07/2014)

## Security Fixes

On July 15th, Oracle announced several security vulnerabilities in Java. Puppet Enterprise 3.3.0 contained a vulnerable version of Java. Puppet Enterprise 3.3.1 contains an updated version of Java that has patched the vulnerabilities.

For more information about the Java vulnerabilities, refer to the [Oracle security site](http://www.oracle.com/technetwork/topics/security/cpujul2014-1972956.html).

### Bug Fixes

This release fixes several minor bugs.

## Puppet Enterprise 3.3.0 (6/15/2014)

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

[dir_environments]: /puppet/3.6/reference/environments.html
[config_envir]: /puppet/3.6/reference/environments_classic.html

The latest version of the Puppet core (Puppet 3.6) deprecates the classic [config-file environments][config_envir] in favor of the new and improved [directory environments][dir_environments]. Over time, both Puppet open source and Puppet Enterprise will make more extensive use of this pattern.

Environments are isolated groups of puppet agent nodes. This frees you to use different versions of the same modules for different populations of nodes, which is useful for testing changes to your Puppet code before implementing them on production machines. (You could also do this by running a separate puppet master for testing, but using environments is often easier.)

In this release of PE, please note that if you define environment blocks or use any of the `modulepath`, `manifest`, and `config_version` settings in `puppet.conf`, you will see deprecation warnings intended to prepare you for these changes. Configuring PE to use *no* environments will also produce deprecation warnings.

Once PE has fully moved to directory environments, the default `production` environment will take the place of the global `manifest`/`modulepath`/`config_version` settings.

**PE 3.3 User Impact**

If you use an environment config section in `puppet.conf`, you will see a deprecation warning similar to

     # puppet.conf
     [legacy]
     # puppet config print confdir
     Warning: Sections other than main, master, agent, user are deprecated in puppet.conf. Please use the directory environments feature to specify  environments. (See /puppet/3.6/reference/environments.html)
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

If you have already built a module and are still using a Modulefile, you will receive a deprecation warning when you build your module with `puppet module build`. You will need to perform [migration steps](/puppet/3.6/reference/modules_publishing.html#build-your-module) before you publish your module. For complete instructions on working with metadata.json, see [Publishing Modules](/puppet/3.6/reference/modules_publishing.html)

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

#### [CVE-2014-0224 OpenSSL vulnerability in secure communications](http://puppetlabs.com/security/cve/cve-2014-0224/)

**Assessed Risk Level**: medium

**Affected Platforms**:

* Puppet Enterprise 2.8 (Solaris, Windows)

* Puppet Enterprise 3.2 (Solaris, Windows, AIX)

Due to a vulnerability in OpenSSL versions 1.0.1 and later, an attacker could intercept and decrypt secure communications. This vulnerability requires that both the client and server be running an unpatched version of OpenSSL. Unlike heartbleed, this attack vector occurs after the initial handshake, which means encryption keys are not compromised. However, Puppet Enterprise encrypts catalogs for transmission to agents, so PE manifests containing sensitive information could have been intercepted. We advise all users to avoid including sensitive information in catalogs.

Puppet Enterprise 3.3.0 includes a patched version of OpenSSL.

CVSS v2 score: 2.4 with Vector: AV:N/AC:H/Au:M/C:P/I:P/A:N/E:U/RL:OF/RC:C

#### [CVE-2014-0198 OpenSSL vulnerability could allow denial of service attack](http://puppetlabs.com/security/cve/cve-2014-0198/)

**Assessed Risk Level**: low

**Affected Platforms**: Puppet Enterprise 3.2 (Solaris, Windows, AIX)

Due to a vulnerability in OpenSSL versions 1.0.0 and 1.0.1, if SSL\_MODE_\RELEASE\_BUFFERS is enabled, an attacker could cause a denial of service.

CVSS v2 score: 1.9 with Vector: AV:N/AC:H/Au:N/C:N/I:N/A:P/E:U/RL:OF/RC:C

#### [CVE-2014-3251 MCollective `aes_security` plugin did not correctly validated new server certs](http://puppetlabs.com/security/cve/cve-2014-3251/)

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
