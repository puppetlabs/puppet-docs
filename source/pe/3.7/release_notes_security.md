---
title: "PE 3.7 » Release Notes >> Security and Bug Fixes"
layout: default
subtitle: "Security Fixes"
canonical: "/pe/latest/release_notes_security.html"
---

This page contains information about security fixes in Puppet Enterprise (PE) 3.7. It also contains a select list of those bug fixes that we believe you'll want to learn about.

For more information about this release, also see the [Known Issues](./release_notes_known_issues.html) and [New Features](./release_notes.html).

## Puppet Enterprise 3.7.2 (2/10/15)

### Security Fixes

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

### Bug Fixes

Puppet Enterprise 3.7.2 contains a number of performance and documentation improvements, in addition to the fixes that are highlighted below.

#### Install and Upgrade Fixes

* PE installer did not create the symlink for the PE Java cacerts file.
This issue made `puppetserver gem imstall` fail with the error "Certificate verify failed." It also caused the error, "Could not find a valid gem 'hiera-eyaml'".
* PE installer did not check permissions on untarred folders, which caused the installer to fail.
* `pe-puppet` failed to upgrade on RHEL 4.

#### The `node:del` Rake Task Deleted a Node Group Instead of the Node

In PE 3.7, the behavior of the `node:del` rake task changed so that it deleted the node group to which a specified node was pinned. In PE 3.7.2, this behavior has been reverted to the PE 3.3 behavior so that `node:del` now deletes the specified node from the console database. 

A new rake task, `node:delgroup`, was introduced in PE 3.7.2 for deleting a node group.

For more information, see the [rake API documentation](./console_rake_api.html).

#### A Handful of Node Manager Service Fixes

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

####Additional Bug Fixes

The following issues were also fixed for PE 3.7.2

* Automatic classification broke in IE 10 and 11 due to aggressive caching.
* The `pe_accounts` "examples" directory broke RDoc; it's been removed.
* The MCO cron sent spam to the root email account.
* Confusing and unnecessary settings were removed from the `master` section of `puppet.conf`.

## Puppet Enterprise 3.7.1 (12/16/14)

### Security Fixes

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

### Bug Fixes

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

### Security Fixes

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

### Bug Fixes

#### `/etc/puppetlabs/mcollective/client.cfg` Is Left Behind on Console Node After Upgrade

Before PE used `/var/lib/peadmin/.mcollective`, the pe_mcollective module laid down /etc/puppetlabs/mcollective/client.cfg.

When upgrading from those earlier versions to a later version, on the master node, `/etc/puppetlabs/mcollective/client.cfg` is correctly removed by `pe_mcollective::client::peadmin`; however, on the console node `pe_mcollective::client::puppet_dashboard` did not remove that file.

This meant that if you were coming from one of the older PE 2.x versions you had this file lying around on your console node that didn't actually configure anything. This has been fixed.


