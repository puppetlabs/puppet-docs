> **Note:** This document covers the Puppet Collection repository of open source Puppet 4-compatible software packages.
> -   For Puppet 3.8 open source packages, see its [repository documentation](/puppet/3.8/puppet_repositories.html).
> -   For Puppet Enterprise installation tarballs, see its [installation documentation](/pe/latest/install_basic.html).

Puppet maintains official package repositories for several operating systems and distributions. To make the repositories more predictable, we version them as "Puppet Collections" --- each collection has all of the software you need to run a functional Puppet deployment, in versions that are known to work well with each other.

The collections are organized into two tiers that map to the Puppet Enterprise release trains which are "downstream" from the open-source components in the collection. Numbered collections (like PC1) are long-lived, stable repositories that map to Long Term Support (LTS) Puppet Enterprise releases; the standard support PE releases will track a collection named `latest` ([The Puppet Enterprise Lifecycle](https://puppet.com/misc/puppet-enterprise-lifecycle) page has more detail about the PE release trains). A collection repository will support operating system-specific packages for the OSes available when it's launched, until thirty days past the end of their vendor-determined lifespan.

Each collection is opt-in, and if you use `ensure => latest` to manage your Puppet packages, you'll stay current with updated packages in the collection you're using. A numbered collection will keep the same major version of each component package for its lifetime; backwards-incompatibilities will be minimized but so will feature development. The `latest` collection will get every new version of the component packages as they're released, so using it will keep you current. Be aware, though, that it will receive major-version updates which can introduce backwards incompatibilities. We recommend tracking the `latest` collection but keeping your infrastructure "pinned" to known versions. For example, if you're using the [puppetlabs-puppet_agent](https://forge.puppet.com/puppetlabs/puppet_agent) module to manage the installed version of the all-in-one agent, you could use:

```
    class {'::puppet_agent':
      collection => 'latest',
      package_version => '1.7.0'
    }
```
