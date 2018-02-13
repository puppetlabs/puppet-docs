---
layout: default
toc_levels: 1234
title: "Puppet 5.4 known issues"
---

As known issues are discovered in Puppet 5.4 and its patch releases, they'll be added here. Once a known issue is resolved, it is listed as a resolved issue in the release notes for that release, and removed from this list.

-   In Puppet 5.4.0 on macOS, the `puppet master` command might not work correctly. To resolve this issue, set `bindaddress` if you want Puppet to listen on an IPv4 network interface, or to "0.0.0.0" to listen on an IPv6 interface.

-   [PUP-8009](https://tickets.puppetlabs.com/browse/PUP-8009): [Puppet 5.1.0](../5.1/release_notes.html) introduced support for internationalized strings in Puppet modules. However, this feature can cause significant performance regressions if [environment caching](./environments_creating.markdown#environment_timeout) is disabled, for instance by setting `environment_timeout==0`, even if the module doesn't include internationalized content. Puppet 5.3.2 introduces an optional `disable_i18n` setting in `puppet.conf` to avoid using localized strings and restore degraded performance.