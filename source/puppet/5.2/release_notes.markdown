---
layout: default
toc_levels: 1234
title: "Puppet 5.2 Release Notes"
---

This page lists the changes in Puppet 5.2 and its patch releases. You can also view [current known issues](known_issues.html) in this release.

Puppet's version numbers use the format X.Y.Z, where:

-   X must increase for major backward-incompatible changes
-   Y can increase for backward-compatible new functionality or significant bug fixes
-   Z can increase for bug fixes

## If you're upgrading from Puppet 4.x

Read the [Puppet 5.0.0 release notes](/puppet/5.0/release_notes.html#puppet-500), because they cover breaking changes since Puppet 4.10.

Read the [Puppet 5.1 release notes](/puppet/5.1/release_notes.html), because they cover important new features and changes since Puppet 5.0.

Also of interest: the [Puppet 4.10 release notes](/puppet/4.10/release_notes.html) and [Puppet 4.9 release notes](/puppet/4.9/release_notes.html).

## Puppet 5.2.0

Released September 13, 2017.

This is a feature and improvement release in the Puppet 5 series that also includes several bug fixes.

-   [All issues resolved in Puppet 5.2.0](https://tickets.puppetlabs.com/issues/?jql=fixVersion%20%3D%20%27PUP%205.2.0%27)

### New Features

-   [PA-1104](https://tickets.puppetlabs.com/browse/PUP-7645): Puppet can output warning and error strings in Japanese on systems with a Japanese locale setting. For details about configuring locale settings for the Puppet agent service, see [Configuration: How Puppet is configured](./config_about_settings.html).

-   [PUP-7645](https://tickets.puppetlabs.com/browse/PUP-7645): Puppet 5.2.0 ensures that translated strings can be loaded in the puppet gem.

### Bug fixes

-   [PUP-7821](https://tickets.puppetlabs.com/browse/PUP-7821): Previous versions of Puppet 4.10 and Puppet 5.x on Windows could crash if a corrupt environment variable was set. Puppet 5.2.0 resolves this issue.

-   [PUP-7835](https://tickets.puppetlabs.com/browse/PUP-7835): In previous versions of Puppet 5, a type mismatch involving an aliased Struct type would cause an `undefined method 'from'` error during a Puppet run. Puppet 5.2.0 resolves this issue by producing a more accurate evaluation error message.

-   [PUP-7804](https://tickets.puppetlabs.com/browse/PUP-7804): Previous versions of Puppet repeatedly attempted to fetch file metadata from the `server` setting when entries in `server_list` could not be reached. Puppet 5.2.0 resolves this issue by ignoring the `server` setting when `server_list` is present.

-   [PUP-7813](https://tickets.puppetlabs.com/browse/PUP-7813): In previous versions of Puppet, The `yum` package provider could crash if yum plugins generated valid but unexpected additional output. Puppet 5.2.0 resolves this issue.

-   [PUP-7855](https://tickets.puppetlabs.com/browse/PUP-7855): When using the special value `default` as a value for something being serialized, such as a catalog, in previous versions of Puppet, Puppet would encode the value as a rich-data hash instead of transforming it to the string "default", even if the [`rich_data` setting](./configuration.html#richdata) was not enabled. Puppet 5.2.0 resolves this issue and produces a warning or error depending on the [`strict` setting](./configuration.html#strict).

-   [PUP-7885](https://tickets.puppetlabs.com/browse/PUP-7885): In previous versions of Puppet, you could create an illegal specification of an Enum data type by providing numeric entries instead of string entries, such as `Enum\[blue, 42]`. This illegal Enum type would then either cause an error when attempting to use it, or would have undefined matching behavior. Puppet 5.2.0 resolves this issue by raising an error when encountering this illegal specification.

-   [PUP-7914](https://tickets.puppetlabs.com/browse/PUP-7914): [Puppet's event logging destination setting on Windows](./services_agent_windows.html), introduced in Puppet 5.0.0, is now documented.

-   [PUP-7668](https://tickets.puppetlabs.com/browse/PUP-7668): Previous versions of Puppet could report an incorrect position in source code after optimizing a code block with a single expression. Puppet 5.2.0 resolves this issue.

-   [PUP-7824](https://tickets.puppetlabs.com/browse/PUP-7824): When using the `String.new()` function in previous versions of Puppet, Puppet would accept unintended characters suffixed to format specifiers, such as `%s` and `%p`, without error. For instance, `%s` could be suffixed as `%strange`, which results in a nonsense specifier that Puppet would erroneously accept. Pupept 5.2.0 resolves this issue by more strictly validating format specifiers and producing an error when parsing an invalid specifier.

-   [PUP-7818](https://tickets.puppetlabs.com/browse/PUP-7818) and [PUP-6364](https://tickets.puppetlabs.com/browse/PUP-6364): Puppet 5.2.0 can correctly install packages with the AIX provider when a manifest also includes a package being removed with `ensure => absent`, and updates installed packages as expected when a manifest sets them to `ensure => latest`.
