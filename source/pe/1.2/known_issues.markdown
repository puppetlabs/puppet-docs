---
layout: default
title: "PE 1.2 Manual: Known Issues"
---

{% include pe_1.2_nav.markdown %}

Known Issues in Puppet Enterprise 1.2
=====

In PE ≤ 1.2.1
-----

### Upgrading From PE 1.1 Breaks Node Classification on Debian and Ubuntu Systems

When upgrading a puppet master with Dashboard from PE 1.1 to 1.2 on Debian and Ubuntu systems, a permissions change to `/etc/puppetlabs/puppet-dashboard` and `/etc/puppetlabs/puppet-dashboard/external_node` breaks Dashboard's node classification abilities. The symptom of this issue is that classes that applied properly to agents on PE 1.1 will no longer be applied. 

The workaround for this issue is to ensure that the permissions of `/etc/puppetlabs/puppet-dashboard` are 755 and that the permissions of `/etc/puppetlabs/puppet-dashboard/external_node` are 755. Running the following command should be sufficient:

    # sudo chmod 755 /etc/puppetlabs/puppet-dashboard /etc/puppetlabs/puppet-dashboard/external_node

This issue only affects Debian/Ubuntu systems being upgraded from PE 1.1 to 1.2.x with a combined master/Dashboard installation.


### Accounts Class Requires an Inert Variable/File

The `accounts` class --- a data-separation wrapper that uses external data to declare a set of `accounts::user` resources --- will not function unless a `$users_hash_default` variable (if using the `namespace` data store) or `accounts_users_default_hash.yaml` file (if using the `yaml` data store) is present, even though this variable/file is never used when creating resources. 

The workaround is to ensure that this variable/file is present in the namespace or data directory.


In PE 1.2.0
-----

### Puppet Inspect Does Not Archive Files

([Issue #9444](https://projects.puppetlabs.com/issues/9444))
In `puppet.conf`, the `archive_files = true` setting was incorrectly placed in an inert `[inspect]` block. This caused puppet inspect to not upload files when submitting compliance reports. 

To repair this issue, edit your `puppet.conf` file to include `archive_files = true` under the `[main]` block. **This will not happen automatically when upgrading from PE 1.2.0 to 1.2.1,** but is fixed in new installations of PE 1.2.1.

