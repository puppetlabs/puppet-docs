---
layout: default
title: "Puppet 3.6 System Requirements"
canonical: "/puppet/latest/reference/system_requirements.html"
---

> To install Puppet 3.6, see [the Puppet installation guide](/puppet/3.8/reference/pre_install.html).

Hardware
-----

The puppet agent service has no particular hardware requirements and can run on nearly anything.

However, the puppet master service is fairly resource intensive, and should be installed on a robust dedicated server.

* At minimum, your puppet master server should have two processor cores and at least 1 GB RAM.
* To comfortably serve at least 1000 nodes, it should have 2-4 processor cores and at least 4 GB RAM.

The demands on the puppet master will vary widely between different deployments. The total needs are affected by the number of agents being served, how frequently those agents check in, how many resources are being managed on each agent, and the complexity of the manifests and modules in use.

Platforms With Packages
-----

Puppet 3.6 and all of its prerequisites will run on the following platforms, and Puppet Labs provides official packages in [our package repositories.](/guides/puppetlabs_package_repositories.html)

### Red Hat Enterprise Linux (and Derivatives)

{% include platforms_redhat_like.markdown %}

### Debian and Ubuntu

{% include platforms_debian_like.markdown %}

### Fedora

{% include platforms_fedora.markdown %}

### Windows

{% include platforms_windows.markdown %}

### Mac OS X

Although we publish packages for Mac OS X, we do not run automated testing on it.

- Mac OS X, version 10.9 (Mavericks) and higher

Platforms Without Packages
-----

Puppet and its prerequisites are known to run on the following platforms, but we do not provide official packages and do not perform automated testing.

### Other Linux

- SUSE Linux Enterprise Server, version 11 and higher
- Gentoo Linux
- Mandriva Corporate Server 4
- ArchLinux

### Other Unix

- Oracle Solaris, version 10 and higher (Puppet Labs performs limited automated testing on Solaris 11.)
- AIX, version 5.3 and higher
- FreeBSD 4.7 and later
- OpenBSD 4.1 and later
- HP-UX

Basic Requirements
-----

If you're installing Puppet via the official packages, you won't need to worry about these prerequisites; your system's package manager will handle all of them. These are only listed for those running Puppet from source or on unsupported systems.

Puppet 3.6 has the following prerequisites:

### Ruby

Use one of the following versions of MRI (standard) Ruby:

* 2.1.x --- **Note:** We run spec tests for Ruby 2.1, but since none of our tested platforms ship with it yet, we don't run acceptance tests on it. This means we think it's good, but it might have problems we don't know about yet.
* 2.0.x
* 1.9.3
* 1.8.7

Other interpreters and versions of Ruby are not covered by our tests, and may or may not work.

### Mandatory Libraries

- [Facter](http://www.puppetlabs.com/puppet/related-projects/facter/) 1.7.0 or later
- [Hiera](/hiera/latest/) 1.0 or later
- The `json` gem (any modern version).

### Optional Libraries

- The [`rgen` gem](http://ruby-gen.org/downloads) version 0.6.1 or later is required when using Puppet [with `parser = future` enabled](./experiments_future.html).
- The `msgpack` gem is required if you are using [msgpack serialization](./experiments_msgpack.html).
