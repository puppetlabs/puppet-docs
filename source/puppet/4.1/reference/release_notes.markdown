---
layout: default
title: "Puppet 4.1 Release Notes"
---

This page lists the changes in Puppet 4.1 and its patch releases.

Puppet's version numbers use the format X.Y.Z, where:

* X must increase for major backwards-incompatible changes
* Y may increase for backwards-compatible new functionality
* Z may increase for bug fixes

## Puppet 4.1.0

Released May 19, 2015.

4.1.0 is a feature release in the Puppet 4 series. This release's main focus was improvements to the Puppet language, but it also includes some improvements to resource types and a few miscellaneous fixes.

Also notable in this release: we're officially deprecating Rack and WEBrick-based Puppet master servers.

* [All tickets fixed in 4.1.0](https://tickets.puppetlabs.com/issues/?filter=14310)
* [Issues introduced in 4.1.0](https://tickets.puppetlabs.com/issues/?filter=14309)

### DEPRECATED: Rack and WEBrick Web Servers for Puppet Master

We're concentrating our future development efforts on Puppet Server, and to make sure we can deliver better features faster, we're going to remove the ability to run a Puppet master under Rack or WEBrick in Puppet 5.0.

* [PUP-4435: Deprecate Puppet WEBrick and Rack servers](https://tickets.puppetlabs.com/browse/PUP-4435)

### New: Language Features

This release improves the Puppet language with a new `$server_facts` variable (opt-in), a new `\u{xxxxxx}` escape sequence for Unicode characters, a new NotUndef data type, the ability to write functions in the Puppet language, and the ability to assign multiple variables from a data structure.

* [PUP-4385: Can't write WOMANS HAT emoji with \uXXXX unicode escapes](https://tickets.puppetlabs.com/browse/PUP-4385)
* [PUP-4483: Add NotUndef type to the set of Puppet types](https://tickets.puppetlabs.com/browse/PUP-4483)
* [PUP-2080: Support functions written in pp](https://tickets.puppetlabs.com/browse/PUP-2080)
* [PUP-2894: Assign multiple variables from an array](https://tickets.puppetlabs.com/browse/PUP-2894)
* [PUP-4443: Assign multiple variables from a hash](https://tickets.puppetlabs.com/browse/PUP-4443)
* [PUP-2630: Server-set global variables like $::environment get overwritten by client facts](https://tickets.puppetlabs.com/browse/PUP-2630)

### New: Structured Logging

The Puppet master and Puppet agent services (and the Puppet apply command) can log to a file if you set the `--logdest` option. Now, if you log to a filename with the `.json` extension, Puppet will log a JSON structure that you can consume with some other tool. Note that Puppet won't close the top-level JSON array in this file; you'll need to add the final `]` character yourself.

* [PUP-4201: Add support for structured logging](https://tickets.puppetlabs.com/browse/PUP-4201)

### New: Function API Change

The Puppet::Functions API now lets you define a parameter that can repeat any number of times and _must_ appear at least once. This was possible before, but was inconvenient and overly wordy.

* [PUP-4438: Add required_repeated_param to 4.x function API](https://tickets.puppetlabs.com/browse/PUP-4438)

### Windows Resource Type Improvements

This release adds some features to the `group`, `package`, and `scheduled_task` types, and fixes bugs with several other types.

* [PUP-400: Manage hidden windows packages](https://tickets.puppetlabs.com/browse/PUP-400)
* [PUP-1279: Windows Group and User fail during deletion even though it is successful](https://tickets.puppetlabs.com/browse/PUP-1279)
* [PUP-1291: scheduled_task : add support for "every X minutes or hours" mode](https://tickets.puppetlabs.com/browse/PUP-1291)
* [PUP-3429: Weekly tasks always notify 'trigger changed'](https://tickets.puppetlabs.com/browse/PUP-3429)
* [PUP-3653: Unable to create/force empty Windows groups](https://tickets.puppetlabs.com/browse/PUP-3653)
* [PUP-4390: Regression: Windows service provider fails to retrieve current state on 2003](https://tickets.puppetlabs.com/browse/PUP-4390)
* [PUP-4437: Update the "puppet-agent" Repo for 4.0.1 to Incorporate Fix for PUP-4390](https://tickets.puppetlabs.com/browse/PUP-4437)
* [PUP-4373: Windows ADSI User groups property should behave similarly to Groups members property](https://tickets.puppetlabs.com/browse/PUP-4373)
* [PUP-3804: User resource cannot add DOMAIN\User style accounts (through Active Directory) and should emit error message](https://tickets.puppetlabs.com/browse/PUP-3804)
* [PUP-2628: Ability to add a member to a group, instead of specifying the complete list](https://tickets.puppetlabs.com/browse/PUP-2628)

### Other Resource Type Improvements

This release adds some new providers for FreeBSD and AIX, improves provider detection, and adds features to some existing providers. It also fixes bugs in several resource types and providers.

New features:

* [PUP-3618: Include pkgng provider for FreeBSD](https://tickets.puppetlabs.com/browse/PUP-3618)
* [PUP-1628: Add mount provider for AIX](https://tickets.puppetlabs.com/browse/PUP-1628)
* [PUP-4198: Add install_options feature to pip provider](https://tickets.puppetlabs.com/browse/PUP-4198)
* [PUP-4203: Add ':uninstall_options' to gem provider](https://tickets.puppetlabs.com/browse/PUP-4203)

Bug fixes:

* [PUP-4351: Default service type and package provider not set on Cumulus Linux](https://tickets.puppetlabs.com/browse/PUP-4351)
* [PUP-4362: Portage package provider does not list all installed packages](https://tickets.puppetlabs.com/browse/PUP-4362)
* [PUP-4491: Adding user to group fails](https://tickets.puppetlabs.com/browse/PUP-4491)
* [PUP-3908: Tidy type is too verbose when working of directories containing lot of files](https://tickets.puppetlabs.com/browse/PUP-3908)
* [PUP-3968: Cache the zypper list-updates output](https://tickets.puppetlabs.com/browse/PUP-3968)
* [PUP-3388: Issue Creating Multiple Mirrors in Zpool Resource](https://tickets.puppetlabs.com/browse/PUP-3388)
* [PUP-4090: Zypper provider doesn't work correctly on SLES 10.4 with install_options set](https://tickets.puppetlabs.com/browse/PUP-4090)
* [PUP-4191: Custom gem provider does not issue the right command to uninstall gem](https://tickets.puppetlabs.com/browse/PUP-4191)
* [PUP-4231: File resources with defined content don't output contents with ensure=>present](https://tickets.puppetlabs.com/browse/PUP-4231)

### Language Bug Fixes

This release fixes several bugs with the Puppet language.

* [PUP-4374: Splatting attributes into an amended attribute block isn't supported](https://tickets.puppetlabs.com/browse/PUP-4374)
* [PUP-3895: EPP validator should error when specified template file does not exist](https://tickets.puppetlabs.com/browse/PUP-3895)
* [PUP-4178: defined() function returns true for undef and empty string, and false for "main"](https://tickets.puppetlabs.com/browse/PUP-4178)
* [PUP-4378: Resource collectors can be assigned to variables by abusing chaining statements](https://tickets.puppetlabs.com/browse/PUP-4378)
* [PUP-4379: Future parser interpolation with [] after variable prefixed with underscore](https://tickets.puppetlabs.com/browse/PUP-4379)
* [PUP-4398: Splat unfolding not supported in method call syntax](https://tickets.puppetlabs.com/browse/PUP-4398)
* [PUP-4428: The 'err' logging function cannot be called as a statement](https://tickets.puppetlabs.com/browse/PUP-4428)
* [PUP-4462: Single backslash before $ blocks interpolation in heredoc with no escapes enabled](https://tickets.puppetlabs.com/browse/PUP-4462)
* [PUP-4463: split with just Regexp (unparameterized type) splits on whitespace](https://tickets.puppetlabs.com/browse/PUP-4463)
* [PUP-4520: Future parser is not correctly handling the default case of a case statement](https://tickets.puppetlabs.com/browse/PUP-4520)
* [PUP-4278: unless with else when then part is empty produces nil result (future parser)](https://tickets.puppetlabs.com/browse/PUP-4278)

### Misc. Bug Fixes

* [PUP-4420: Executable external facts broken in 4.0.0: not executable on agent](https://tickets.puppetlabs.com/browse/PUP-4420)
* [PUP-4436: With a gem install of puppet, when run as root, 'puppet agent` and `puppet apply' fail](https://tickets.puppetlabs.com/browse/PUP-4436)
* [PUP-4461: manifest changes are ignored when using hiera_include](https://tickets.puppetlabs.com/browse/PUP-4461)
* [PUP-4607: External facts no longer load from pluginsync'ed directory](https://tickets.puppetlabs.com/browse/PUP-4607)
* [PUP-927: puppet apply on Windows always uses *nix style newlines from templates](https://tickets.puppetlabs.com/browse/PUP-927)
* [PUP-2455: Puppet running as Solaris SMF service needs to run child processes in separate "contract"](https://tickets.puppetlabs.com/browse/PUP-2455)
* [PUP-3863: hiera('some::key', undef) returns empty string](https://tickets.puppetlabs.com/browse/PUP-3863)
* [PUP-4334: hiera_include stopped working](https://tickets.puppetlabs.com/browse/PUP-4334)
* [PUP-4336: puppet apply --trace has stopped producing output](https://tickets.puppetlabs.com/browse/PUP-4336)
* [PUP-735: Status unchanged when "Could not apply complete catalog"](https://tickets.puppetlabs.com/browse/PUP-735)
* [PUP-3814: Duplicated error output](https://tickets.puppetlabs.com/browse/PUP-3814)






