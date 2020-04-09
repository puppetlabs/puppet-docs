---
layout: default
toc_levels: 1234
title: "Puppet 5.5 known issues"
---

As known issues are discovered in Puppet 5.5 and its patch releases, they'll be added here. Once a known issue is resolved, it is listed as a resolved issue in the release notes for that release, and removed from this list.

- The `host` type supports only one IP address for each hostname. Because of this, you cannot use both an IPv4 and IPv6 address for the same hostname. [PUP-9480](https://tickets.puppetlabs.com/browse/PUP-9480)

- Puppet 5.5.11 adds support for macOS 10.14 Mojave. However to manage users and groups, you must grant Puppet Full Disk Access. To give Puppet access on a machine running macOS 10.14, go to `System Preferences > Security & Privacy > Privacy > Full Disk Access`, and add the path to the Puppet executable. [PA-2226](https://tickets.puppetlabs.com/browse/PA-2226), [PA-2227](https://tickets.puppetlabs.com/browse/PA-2227)

- Puppet runs generate an autosign warning, indicating that autosign is deprecated. We're un-deprecating autosign in a future release and you can ignore this warning.

- [PUP-8009](https://tickets.puppetlabs.com/browse/PUP-8009): Puppet 5.1.0 introduced support for internationalized strings in Puppet modules. However, this feature can cause significant performance regressions if [environment caching](./environments_creating.markdown#environment_timeout) is disabled, for instance by setting `environment_timeout==0`, even if the module doesn't include internationalized content. Puppet 5.3.2 introduced an optional `disable_i18n` setting in `puppet.conf` to avoid using localized strings and restore degraded performance.

- When specifying a deep merge behaviour in Hiera, the `knockout_prefix` identifier is effective only against values in an adjacent array, and not in hierarchies more than three levels deep. [HI-223](https://tickets.puppetlabs.com/browse/HI-223)
