---
layout: default
title: "PE 2.5 » Overview » What's New"
subtitle: "New Features in PE 2.5"
canonical: "/pe/latest/release_notes.html"
---


Version 2.5 is a major new release of Puppet Enterprise (PE). In addition to many fixes and refinements, PE 2.5 introduces the following new major features:

### Role-Based Access Control

The Puppet Enterprise Console now has support for user authorization and management. User accounts can now be created that provide access to the Console with read-only, read-write, or admin privileges. Puppet admins now have more information and options for managing Puppet users and controlling access. For more information, see the [Console Access page](./console_auth.html).

### Windows Support

Puppet Enterprise can now be installed and run on agents running Windows Server 2003, 2008, or Windows 7. Windows agents have all basic Puppet Enterprise functionality, including compliance support. Note however that MCollective,  live management, and the pe_accounts module are not yet supported on Windows agents. Support for these and other functions is already under development. Installation can be done via the command line or a Windows GUI-based installer. For more information, see the [Windows pages](../../windows/index.html)

### Puppet Forge

Access to Puppet's online library of pre-built, freely downloadable configuration modules is integrated into the PE 2.5 redesigned module tool. By providing community-contributed configurations, Puppet Forge lets you solve configuration problems easily and get automation up and running quickly. Modules can be easily installed and uninstalled using the Puppet Module Tool. For more information, visit [Puppet Forge](http://forge.puppetlabs.com/).

### Big Data

With PE 2.5, system administrators can access detailed information about their infrastructure through the Puppet Data Library. The Puppet Data Library provides comprehensive and volumninous information about the who, what, where, when and why of infrastructure changes. This data gives sysadmins insight into how infrastructure changes effect service levels and can be used to generate automatic IT compliance audits. In addition, third-party vendors such as Boundary and Nodeable have built innovative tools based on Data Library information that provide powerful tools for analysis and management. For more information, see the [Puppet Data Library page](./puppet_data_library.html). 

See the [Puppet Enterprise 2.5 release notes](./appendix.html#release-notes) for more details.


* * * 

- [Next: Getting Support](./overview_getting_support.html)
