> **Note:** This document covers the Puppet Collection repository of open source Puppet 4-compatible software packages.
> -   For Puppet 3.8 open source packages, see its [repository documentation](/puppet/3.8/reference/puppet_repositories.html).
> -   For Puppet Enterprise installation tarballs, see its [installation documentation](/pe/latest/install_basic.html).

Puppet maintains official package repositories for several operating systems and distributions. To make the repositories more predictable, we version them as "Puppet Collections" --- each collection has all of the software you need to run a functional Puppet deployment, in versions that are known to work well with each other. Each collection is opt-in, and you must choose a collection (and on some operating systems, install a package on Puppet-managed systems) to install software and receive updates from that collection.

Collection repositories are organized into two tiers that correspond to Puppet Enterprise releases, which are downstream from the collection's open-source components:

-   **Numbered collections, such as Puppet Collection 1 (PC1),** are long-lived, stable repositories from which Long-Term Support (LTS) Puppet Enterprise releases are built. Numbered collections maintain the same major version of each component package during its lifetime, which delivers bug fixes and minimizes breaking changes, but also introduces fewer new features.
-   **The "latest" collection** follows every release of Puppet Enterprise, including versions not considered LTS releases, and is updated with new major-version releases that might introduce breaking changes.

Puppet publishes updates for operating systems starting from the time a package is first published for that operating system to a collection repository, and stops updating those packages 30 days after the end of the operating system's vendor-determined lifespan.

See [The Puppet Enterprise Lifecycle](https://puppet.com/misc/puppet-enterprise-lifecycle) for information about PE release trains.

To receive the most up-to-date Puppet software without introducing breaking changes, use the `latest` collection, pin your infrastructure to known versions, and update the pinned version manually when you're ready to update. For example, if you're using the [`puppetlabs-puppet_agent` module](https://forge.puppet.com/puppetlabs/puppet_agent) to manage the installed `puppet-agent` package, use this resource to pin it to version 1.7.0:

```
class { '::puppet_agent':
  collection      => 'latest',
  package_version => '1.7.0',
}
```

When `puppet-agent` 2.0.0 is released, update `package_version` when you're ready to upgrade to that version:

```
class { '::puppet_agent':
  collection      => 'latest',
  package_version => '2.0.0',
}
```
