---
layout: default
title: "Component versions in puppet-agent"
---

[Facter]: {{facter}}/
[Hiera]: {{hiera}}/
[MCollective]: /mcollective/
[agent]: ./services_agent_unix.html
[apply]: ./services_apply.html
[Puppet Server]: {{puppetserver}}/
[release notes]: ./release_notes_agent.html

### Release contents of `puppet-agent` 5.x

See the table for details about which components shipped in which `puppet-agent` release, and the [package-specific release notes][release notes] for more information about packaging and installation fixes and features.

{% partial /puppet-agent/_agent5.x.html %}

>**Note:** [Hiera 5](./hiera_intro.html) is a backwards-compatible evolution of Hiera, which is built into Puppet. To provide some backwards-compatible features, it uses the classic Hiera 3 codebase. This means "Hiera" is still shown as version 3.x in the table above, even though this Puppet version uses Hiera 5.



### What `puppet-agent` and Puppet Server are

We distribute Puppet as two core packages.

- `puppet-agent` --- This package contains Puppet's main code and all of the dependencies needed to run it, including [Facter][], [Hiera][], and bundled versions of Ruby and OpenSSL. It also includes [MCollective][]. Once it's installed, you have everything you need to run [the Puppet agent service][agent] and the [`puppet apply` command][apply].
- `puppetserver` --- This package depends on `puppet-agent`, and adds the JVM-based [Puppet Server][] application. Once it's installed, Puppet Server can serve catalogs to nodes running the Puppet agent service.

### How version numbers work

Puppet Server is a separate application that, among other things, runs instances of the Puppet master application. It has its own version number separate from the version of Puppet it runs and may be compatible with more than one existing Puppet version.

The `puppet-agent` package also has its own version number, which doesn't necessarily match the version of Puppet it installs.

Order is important in the upgrade process. First, update Puppet Server, then you update `puppet-agent`. If you upgrade Puppet Server or PuppetDB to version 5, if you're on the master it will automatically upgrade the `puppet-agent` package to Puppet agent 5.0.0 or newer. Puppet Server 5 will also prevent you from installing anything lower than `puppet-agent` 5.0.0 on your agent nodes.

Since the `puppet-agent` package distributes several different pieces of software, its version number will frequently increase when Puppet's version does not --- for example, `puppet-agent` 1.2.0 and 1.2.1 shipped the same Puppet version but different Facter versions. Similarly, new versions of Puppet Server usually don't require updates to the core Puppet code.

This versioning scheme helps us avoid a bunch of "empty" Puppet releases where the version number increases without any changes to Puppet itself.
