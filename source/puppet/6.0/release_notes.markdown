---
layout: default
toc_levels: 1234
title: "Puppet 6.0 Release Notes"
---

This page lists the changes in Puppet 6.0 and its patch releases. You can also view [known issues](known_issues.html) in this release.

Puppet's version numbers use the format X.Y.Z, where:

-   X must increase for major backward-incompatible changes
-   Y can increase for backward-compatible new functionality or significant bug fixes
-   Z can increase for bug fixes

## If you're upgrading from Puppet 4.x

Read the [Puppet 5.0.0 release notes](/puppet/5.0/release_notes.html#puppet-500), because they cover breaking changes since Puppet 4.10.

Read the [Puppet 5.1](../5.1/release_notes.html), [Puppet 5.2](../5.2/release_notes.html), [Puppet 5.3](../5.3/release_notes.html), and [Puppet 5.4](../5.4/release_notes.html) release notes, because they cover important new features and changes since Puppet 5.0.

Also of interest: the [Puppet 4.10 release notes](../4.10/release_notes.html) and [Puppet 4.9 release notes](../4.9/release_notes.html).

## Puppet 6.0

Released 18 September 2018

**{description of release)**


### New features and improvements

- The following types were moved from the Puppet core codeblock to supported modules on the Forge. This change enables easier composability and reusability of the Puppet codebase and enables development to proceed more quickly without fear of destabilizing the rest of Puppet. These types are repackaged back into Puppet agent, so you don't have to install them separately. See the module readmes for information.

    - augeas
    - cron
    - host
    - mount
    - scheduled_task
    - selboolean
    - selmodule
    - ssh_authorized_key
    - sshkey
    - yumrepo
    - zfs
    - zone
    - zpool

- The following types were also moved to modules, but these are not supported and they are not repackaged into Puppet agent. If you need to use them, you must install the modules separately.

    - k5login
    - mailalias
    - maillist

- The following subcommands were deprecated in Puppet 5.5.6. They are now un-deprecated. 


    -   `ca_name`
    -   `cadir`
    -   `cacert`
    -   `cakey`
    -   `capub`
    -   `cacrl`
    -   `caprivatedir`
    -   `csrdir`
    -   `signeddir`
    -   `capass`
    -   `serial`
    -   `autosign`
    -   `allow_duplicate_certs`
    -   `ca_ttl`
    -   `cert_inventory`

### Bug fixes





### Deprecations

- The `computer`, `macauthorization`, and `mcx` types and providers have been moved to a module: https://forge.puppet.com/puppetlabs/macdslocal_core. It is not being repackaged into puppet-agent for 6.0
- The Nagios types no longer ship with Puppet, and are now available as the `puppetlabs/nagios_core` module from the Forge.
- The Cisco network device types no longer ship with Puppet. These types and providers have been deprecated in favor of the `puppetlabs/cisco_ios` module, which is available on the Forge.
    



