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



### Bug fixes





### Deprecations

-   All Puppet subcommands that perform actions on the CA are deprecated. This includes `cert`, `ca`, `certificate`, `certificate_revocation_list`, and `certificate_request`. Their functionality will be replaced in Puppet 6 by a new CA command-line interface under Puppet Server, and a new client-side subcommand for SSL client tasks. This change deprecates `puppet.conf` settings:

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

    


