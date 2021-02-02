---
layout: default
toc_levels: 1234
title: "Puppet 5.5 known issues"
---

As known issues are discovered in Puppet 5.5 and its patch releases, they'll be added here. Once a known issue is resolved, it is listed as a resolved issue in the release notes for that release, and removed from this list.

- Testing modules using rspec-puppet versions earlier than 2.7.10 results in the error "undefined local variable or method `default_env` for Puppet::Util:Module". As a workaround, update rspec-puppet to version 2.7.10. If using PDK, run `pdk bundle update rspec-puppet` or update your PDK package. If not using PDK, run `bundle update`. [PUP-10586](https://tickets.puppetlabs.com/browse/PUP-10586)

- The `host` type supports only one IP address for each hostname. Because of this, you cannot use both an IPv4 and IPv6 address for the same hostname. [PUP-9480](https://tickets.puppetlabs.com/browse/PUP-9480)

- Puppet 5.5.11 adds support for macOS 10.14 Mojave. However to manage users and groups, you must grant Puppet Full Disk Access. To give Puppet access on a machine running macOS 10.14, go to `System Preferences > Security & Privacy > Privacy > Full Disk Access`, and add the path to the Puppet executable. [PA-2226](https://tickets.puppetlabs.com/browse/PA-2226), [PA-2227](https://tickets.puppetlabs.com/browse/PA-2227)

- Puppet runs generate an autosign warning, indicating that autosign is deprecated. We're un-deprecating autosign in a future release and you can ignore this warning.

- [PUP-8009](https://tickets.puppetlabs.com/browse/PUP-8009): Puppet 5.1.0 introduced support for internationalized strings in Puppet modules. However, this feature can cause significant performance regressions if [environment caching](./environments_creating.markdown#environment_timeout) is disabled, for instance by setting `environment_timeout==0`, even if the module doesn't include internationalized content. Puppet 5.3.2 introduced an optional `disable_i18n` setting in `puppet.conf` to avoid using localized strings and restore degraded performance.

- When specifying a deep merge behaviour in Hiera, the `knockout_prefix` identifier is effective only against values in an adjacent array, and not in hierarchies more than three levels deep. [HI-223](https://tickets.puppetlabs.com/browse/HI-223)

- Puppet 5 stdlib functions handle `undef` less strictly then they should. In Puppet 6, many functions from stdlib were moved into Forge modules, and now treat `undef` more strictly. In Puppet 6, some code that relies on `undef` values being implicitly treated as other types will return an evaluation error. For more information on which functions were moved out of stdlib, see the [Puppet 6.0 release notes](https://puppet.com/docs/puppet/6.0/release_notes_puppet.html#select-types-moved-to-modules).

- Registry references to nssm.exe were removed in [PA-3263](https://tickets.puppetlabs.com/browse/PA-3263). Upgrading from a version without this update to a version that contains it triggers a Windows SecureRepair sequence that fails if any of the files delivered in the original *.msi package are missing. This is an issue when upgrading to one of the following Puppet agent versions: 5.5.21, 5.5.22, 6.17.0, 6.18.0, 6.19.0, 6.19.1, 6.20.0, 7.0.0, 7.1.0 or 7.3.0. To work around this issue, put the *.msi file for the currently installed version in the C:\Windows\Installer folder before you upgrade. Starting with Puppet agent 6.21.0 and 7.4.0, the nssm.exe registry value will be replaced with an empty string, instead of the registry key being removed, to avoid triggering Windows SecureRepair. [PA-3545](https://tickets.puppetlabs.com/browse/PA-3545)
