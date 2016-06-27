> **Note:** This document covers the Puppet Collection repository of open source Puppet 4-compatible software packages.
> -   For Puppet 3.8 open source packages, see its [repository documentation](/puppet/3.8/puppet_repositories.html).
> -   For Puppet Enterprise installation tarballs, see its [installation documentation](/pe/latest/install_basic.html).

Puppet maintains official package repositories for several operating systems and distributions. To make the repositories more predictable, we version them as "Puppet Collections" --- each collection has all of the software you need to run a functional Puppet deployment, in versions that are known to work well with each other. Each collection is opt-in, and if you use `ensure => latest` to manage your Puppet packages, you’ll get the latest compatible versions in the collection you’re using. Whenever we make significant breaking changes that introduce incompatibilities between versions of our software, we make a new collection so that you can perform safe major upgrades at your convenience.

We maintain Puppet Collection repositories throughout the corresponding operating systems' lifespan, plus one additional month.