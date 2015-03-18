---
layout: default
title: "Puppet 4.0 Preview Docs"
---


Welcome to the preview release of Puppet 4.0, and thanks for helping test the next version! We've posted this set of documents to help testers install the new packages and get oriented. We'll be publishing full documentation for Puppet 4.0 as we get closer to the final release.

Use the navigation to the left to browse this section. Most users will want to take a look at the [Where Did Everything Go?](./whered_it_go.html) page and the [updated install instructions.](./install_el.html)

What's In This Release?
-----

Right now, the Puppet 4 release candidate consists of a `puppet-agent` package that installs Puppet 4.0, and a `puppetserver` package that installs Puppet Server 2.0.

Notably, we don't have compatible PuppetDB packages yet. If you want to use PuppetDB with the preview release, you'll need to install it (and the terminus plugins) from source.

Puppet 3.x agents can't currently talk to a Puppet 4.0 master.


Supported Versions
-----

Currently, the preview of Puppet 4.0 and Puppet Server 2.0 only support RHEL 7, CentOS 7, and derived distros.

We'll be releasing preview packages for other systems as we get closer to a final release.

