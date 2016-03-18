---
layout: default
title: "puppet-agent: What Is It, and What's In It?"
canonical: "/puppet/latest/reference/about_agent.html"
---

[Facter]: /facter/latest/
[Hiera]: /hiera/latest/
[MCollective]: /mcollective/
[agent]: ./services_agent_unix.html
[apply]: ./services_apply.html
[Puppet Server]: /puppetserver/latest/
[release notes]: ./release_notes_agent.html

## Release Contents: `puppet-agent` 1.x

{% partial /puppet-agent/_agent1.x.html %}

See the table above for details about which components shipped in which `puppet-agent` release, and the [package-specific release notes][release notes] for more information about packaging and installation fixes and features. Visit the [Puppet Enterprise documentation](/pe/latest/overview_version_table.html) to view which versions of `puppet-agent` are shipped with specific PE releases.

## What Are `puppet-agent` and Puppet Server?

Starting with Puppet 4, we distribute Puppet as two core packages:

- `puppet-agent` --- This package contains Puppet's main code and all of the dependencies needed to run it, including [Facter][], [Hiera][], and bundled versions of Ruby and OpenSSL. It also includes [MCollective][]. Once it's installed, you have everything you need to run [the Puppet agent service][agent] and the [`puppet apply` command][apply].
- `puppetserver` --- This package depends on `puppet-agent`, and adds the JVM-based [Puppet Server][] application. Once it's installed, Puppet Server can serve catalogs to nodes running the Puppet agent service.

> **Note:** For information about Puppet agent in Puppet 3, see the [Puppet 3 services documentation](/puppet/3.8/reference/services_commands.html#puppet-agent). To install Puppet agent on Puppet 3, see the [Puppet 3 installation documentation](/puppet/3.8/reference/pre_install.html#next-install-puppet).

## What's Up With the Version Numbers?

Puppet Server is a separate application that, among other things, runs instances of the Puppet master application. It has its own version number separate from the version of Puppet it runs, and can usually work with several nearby Puppet versions. Right now, the agents running versions of Puppet 4 can generally work with masters running versions of Puppet Server 2. (Puppet masters running Puppet Server might depend on a specific version of Puppet Agent, but can still communicate with agents running older versions of Puppet. In other words, updating Puppet Server might also update Puppet Agent on the master, but the master will still work with nodes running previous versions of Puppet Agent.)

The `puppet-agent` package also has its own version number, which doesn't match the version of Puppet it installs. For example, `puppet-agent` 1.3 includes Puppet 4.3.

Since the `puppet-agent` package distributes several different pieces of software, its version number will frequently increase when Puppet's version does not --- for example, `puppet-agent` 1.2.0 and 1.2.1 ship the same Puppet version but different Facter versions. Similarly, new versions of Puppet Server usually don't require updates to the core Puppet code.

Our options were to either let the versions be completely separate, or ship a bunch of "empty" Puppet releases where the version number increases without any changes to Puppet itself. For now, we're going with the former.