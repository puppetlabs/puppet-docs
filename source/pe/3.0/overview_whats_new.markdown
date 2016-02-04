---
layout: default
title: "PE 3.0 » Overview » What's New"
subtitle: "New Features in PE 3.0"
canonical: "/pe/latest/release_notes.html"
---

### Version 3.0.1
Puppet Enterprise version 3.0.1 is a feature and maintenance release. It adds new features, fixes bugs and addresses security issues. Specifically, the 3.0.1 release includes the following:

  * *Complete Upgrader Functionality*

    The puppet installer script can now be used to upgrade all roles in an existing PE deployment, master, agent, console, cloud provisioner, and database support. Upgrades are supported for all PE roles running 2.8.2 or later. For complete information and instructions, visit the [upgrading PE page](install_upgrading.html).

  * *SLES Support*

    PE 3.0.1 now fully supports all PE roles on nodes running SLES 11 SP1 or higher.

  * *Changes and Additions to Console Rake Tasks*

    The PE console provides a number of rake tasks that can be used as a minimal API to perform many functions of the GUI. These can be used to automate workflows, perform large-scale changes, etc. A number of these tasks have been changed (although the old syntax still works, with deprecation warning) See the [Console Rake API](console_rake_api.html) page for more information.

  * *Security Patches*

    A number of vulnerabilities have been addressed in PE 3.0.1. For details, check the [release notes](appendix.html#release-notes).


### Version 3.0.0

#### Overview

Puppet Enterprise (PE) 3.0 is a major release that includes many new functions and features, significant improvements in performance and scalability, many bug fixes and refinements, and upgrades to most major components.

The most significant changes in PE 3.0 are the upgrade to Puppet 3.2, major improvements to PE's orchestration engine with the upgrade to MCollective 2.2.4, and the integration of PuppetDB 1.3. These changes result in considerable performance increases and add major new functionality.

* Information on changes in Puppet 3 versus Puppet 2.x can be found in the [Puppet 3.x release notes](/puppet/3/reference/release_notes.html) --- in particular, look for items labeled "BREAK" in the table of contents. This [blog post](https://puppetlabs.com/blog/say-hello-to-puppet-3/) also provides a good overview of what’s new and different in Puppet 3. In particular, you’ll want to ensure your manifests do not use [dynamic scope lookup](/guides/scope_and_puppet.html) (they shouldn’t since it has been deprecated for some time). You’ll also want to get familiar with how Puppet 3 changes the way Puppet deals with [classes and class parameters](/puppet/3/reference/lang_classes.html) generally, and [automatic parameter lookup](/hiera/1/puppet.html#automatic-parameter-lookup) in particular.
* For information on what you can now do with orchestration, check out the [orchestration section of this manual](./orchestration_overview.html). Specifically:
    * For an overview of what’s new in the orchestration engine, refer to this [blog post introducing MCollective version 2.0](http://puppetlabs.com/blog/announcing-the-marionette-collective-2-0/) or, for more detail, the [MCollective Release Notes](/mcollective/releasenotes.html).
    * To install new orchestration actions, see [the Adding Actions page of this manual](./orchestration_adding_actions.html). For information about writing plugins, see the [MCollective agent writing guide](/mcollective/simplerpc/agents.html). Note that if you have written custom plugins to use with MCollective 1.2.x, you may need to revise them to work with 2.2.4.
    * To learn the improved command line capabilities, see [the Invoking Orchestration Actions on the Command Line page of this manual](./orchestration_invoke_cli.html). In particular, check out the new `--batch` option and [compound filters with data plugins](./orchestration_invoke_cli.html#compound-select-filters).
* For information on what you can now do with PuppetDB, check out the [PuppetDB manual](/puppetdb/1.3/). You can also learn about the [specific features in PuppetDB 1.3](https://puppetlabs.com/blog/puppetdb-1-3/). If you’re unfamiliar with PuppetDB, Puppet Labs developer Nick Lewis provides a [good introduction](http://puppetlabs.com/blog/introducing-puppetdb-put-your-data-to-work/).

Note that orchestration tools and PuppetDB are automatically installed and configured by PE 3.0, so you can ignore any installation instructions in documentation linked above.

#### Component Upgrades & Additions

Many of the “under the hood” constituent parts of Puppet Enterprise have been updated in version 3.0. Most notably these include:

* Ruby 1.9.3
* Puppet 3.2.2
* Facter 1.7.1
* Hiera 1.2.1
* MCollective 2.2.4
* Dashboard 2.0

In addition, PuppetDB 1.3.1 is now packaged and fully integrated with PE. Since PuppetDB uses PostgreSQL, we have moved all of PE’s database-using components (e.g., the console) to Postgres, and all MySQL databases have been replaced.

For a complete list of package upgrades, visit the [release notes](./appendix.html#release-notes).

#### Other Functional Changes & Noteworthy Improvements

* Live management and orchestration now support Windows.
* Puppet agents are now supported on Windows Server 2012.
* The addition of [parameterized class](/puppet/latest/reference/lang_classes.html#class-parameters-and-variables) support in the console makes it easier to use pre-built modules from the [Puppet Forge](http://forge.puppetlabs.com/).
* A new resource type, [service](/puppet/3.2/reference/type.html#service), is now available for browsing in live management.
* Live management cloning is deprecated and has been removed from the console. For alternate ways to accomplish similar functionality, the [release notes](./appendix.html#release-notes) contain suggestions.
* Compliance is deprecated and has been removed from the console. For alternate ways to accomplish similar functionality, visit this page that describes an [alternate workflow in greater detail](./compliance_alt.html).
* Facter 1.7 provides support for [external facts](https://puppetlabs.com/blog/facter-1-7-introduces-external-facts/), which makes writing custom Facter facts much easier than before.
* All deprecated commands that precede Puppet 2.6.x (e.g., `puppetmasterd`, `puppetd`, `ralsh`, etc.) are now removed.

#### New Browser Requirements
In 3.0, the PE console must be accessed via one of the following browsers:

* Chrome (current versions)
* Firefox (current versions)
* Safari 5.1 and higher
* Internet Explorer 9, 10 (IE 8 is no longer supported)

#### Delayed Support for Upgrading and SLES

* Full functionality for upgrades is not yet complete in 3.0. Upgrading is not yet supported for master, console and database roles, but is fully supported for agents. Visit the [upgrading page](./install_upgrading) for complete instructions on how to migrate a 2.8 deployment to PE 3.0 now. Full upgrade support will be included in the next release of PE 3.0, no later than August 15, 2013.
* Support for nodes running the SLES operating system is not yet completed. It will be included in the next release of PE 3.0, no later than August 15, 2013.


* * *

- [Next: Getting Support](./overview_getting_support.html)
