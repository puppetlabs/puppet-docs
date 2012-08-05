---
layout: legacy
title: "PE 1.2 Manual: Known Issues"
---

{% include pe_1.2_nav.markdown %}

{% capture security_info %}Information about security issues is always available at <http://puppetlabs.com/security>, and security hotfixes for all supported versions of Puppet Enterprise are always available at <http://puppetlabs.com/security/hotfixes>. For email notification of security issues, make sure you're on the [PE-Users](http://groups.google.com/group/puppet-users) mailing list.{% endcapture %}

Known Issues in Puppet Enterprise 1.2
=====

The following is a list of known issues in each maintenance release of Puppet Enterprise 1.2. To find out which issues you are affected by, run `/opt/puppet/bin/puppet --version`, the output of which will look something like `2.6.9 (Puppet Enterprise 1.2.3)`.

In PE 1.2.4 and Earlier
-----

### Upgrading From PE 1.1 Breaks Node Classification on Debian and Ubuntu Systems

([Issue #9444](https://projects.puppetlabs.com/issues/9444))

When upgrading a puppet master with Dashboard from PE 1.1 to 1.2 on Debian and Ubuntu systems, a permissions change to `/etc/puppetlabs/puppet-dashboard` and `/etc/puppetlabs/puppet-dashboard/external_node` breaks Dashboard's node classification abilities. The symptom of this issue is that classes that applied properly to agents on PE 1.1 will no longer be applied. 

The workaround for this issue is to ensure that the permissions of `/etc/puppetlabs/puppet-dashboard` are 755 and that the permissions of `/etc/puppetlabs/puppet-dashboard/external_node` are 755. Running the following command should be sufficient:

    $ sudo chmod 755 /etc/puppetlabs/puppet-dashboard /etc/puppetlabs/puppet-dashboard/external_node

This issue only affects Debian/Ubuntu systems being upgraded from PE 1.1 to 1.2.x with a combined master/Dashboard installation.

### Accounts Class Requires an Inert Variable/File

The `accounts` class --- a data-separation wrapper that uses external data to declare a set of `accounts::user` resources --- will not function unless a `$users_hash_default` variable (if using the `namespace` data store) or `accounts_users_default_hash.yaml` file (if using the `yaml` data store) is present, even though this variable/file is never used when creating resources. 

The workaround is to ensure that this variable/file is present in the namespace or data directory.

### Security Issue: XSS Vulnerability in Puppet Dashboard (CVE-2012-0891)

This issue was fixed in PE 1.2.5 and 2.0.1.

Puppet Dashboard was found to be vulnerable to cross-site scripting attacks due to insufficient sanitization of user input. [See here][dashboard_xss] for more details, including hotfixes for previous versions of PE.

This vulnerability has a CVE identifier of [CVE-2012-0891][dashxss_cve].

[dashboard_xss]: http://puppetlabs.com/security/cve/cve-2012-0891/
[dashxss_cve]: http://cve.mitre.org/cgi-bin/cvename.cgi?name=cve-2012-0891

In PE 1.2.3 and Earlier
-----

### Major Security Issue: AltNames Vulnerability (CVE-2011-3872)

The [CVE-2011-3872 AltNames vulnerability][altnamespage], patched in PE 1.2.4, affects all prior PE installations. If your site has **ever** had any version of PE prior to 1.2.4 installed, your node population contains dangerous certificates which can be used to impersonate the puppet master and gain control of nodes. 

**Upgrading PE is insufficient to protect your site** --- you must also specifically mitigate the vulnerability. You should download and use Puppet Labs' [remediation toolkit module][altnamesmodule]; see the README files included with the module for full documentation. 

[altnamespage]: http://puppetlabs.com/security/cve/cve-2011-3872/
[altnamesmodule]: https://github.com/puppetlabs/puppetlabs-cve20113872/

In PE 1.2.2 and Earlier
-----

### Three Security Issues: CVE-2011-3869, CVE-2011-3870, and CVE-2011-3871

[Three security vulnerabilities in Puppet (CVE-2011-3869, CVE-2011-3870, and CVE-2011-3871)][3869announce], which allowed local privilege escalation, were fixed in Puppet Enterprise 1.2.3. **If you are running Puppet Enterprise 1.2.2 or earlier, you must [upgrade](./upgrading.html) to version 1.2.3 or [install the security hotfix for this issue][3869hot].** 

[3869hot]: http://puppetlabs.com/security/hotfixes/cve-2011-3869-hotfixes/
[3869announce]: http://groups.google.com/group/puppet-announce/browse_thread/thread/91e3b46d2328a1cb

{{ security_info }}

In PE 1.2.1 and Earlier
-----

### Security Issue: CVE-2011-3848

[A security vulnerability in Puppet (CVE-2011-3848)][3848announce], which allowed unsafe directory traversal when saving certificate signing requests, was fixed in Puppet Enterprise 1.2.2. **If you are running Puppet Enterprise 1.2.1 or earlier, you must [upgrade](./upgrading.html) to version 1.2.3 or [install the security hotfix for this issue][3848hot].** 

[3848announce]: http://groups.google.com/group/puppet-users/browse_thread/thread/e57ce2740feb9406
[3848hot]: http://puppetlabs.com/security/hotfixes/cve-2011-3848-hotfixes/

{{ security_info }}

In PE 1.2.0
-----

### Puppet Inspect Does Not Archive Files

In `puppet.conf`, the `archive_files = true` setting was incorrectly placed in an inert `[inspect]` block. This caused puppet inspect to not upload files when submitting compliance reports. 

To repair this issue, edit your `puppet.conf` file to include `archive_files = true` under the `[main]` block. **This will not happen automatically when upgrading from PE 1.2.0 to 1.2.1,** but is fixed in new installations of PE 1.2.1.

