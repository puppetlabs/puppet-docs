---
layout: default
title: "Optional Resource Types for Windows"
toc: false
---



In addition to the resource types included with Puppet's core, you can install custom resource types as Puppet modules from [the Puppet Forge](https://forge.puppetlabs.com).

This is especially useful when managing Windows systems, because there are several important Windows-specific resource types that are developed as modules rather than part of Puppet's core. If you're doing heavy management of Windows systems, you may want to check out the following:

> **Note:** plugins from the Puppet Forge may not have the same amount of QA and test coverage as Puppet's core types.

* [puppetlabs/registry](https://forge.puppetlabs.com/puppetlabs/registry) --- A resource type for managing arbitrary registry keys.
* [puppetlabs/reboot](https://forge.puppetlabs.com/puppetlabs/reboot) --- A resource type for managing conditional reboots, which may be necessary for installing certain software.
* [puppetlabs/dism](https://forge.puppetlabs.com/puppetlabs/dism) --- A resource type for enabling and disabling Windows features (on Windows 7/2008 R2 and newer).
* [puppetlabs/powershell](https://forge.puppetlabs.com/puppetlabs/powershell) --- An alternate `exec` provider that can directly execute powershell commands.

There are also other resource types on the Puppet Forge created by community members. The best way to find new resource types is by [searching for "windows" on the Puppet Forge](http://forge.puppetlabs.com/modules?sort=rank&q=windows&pop) and exploring the results.

