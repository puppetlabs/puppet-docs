---
layout: default
title: "puppet-agent: What Is It, and What's In It?"
canonical: "/puppet/latest/about_agent.html"
---

[facter]: /facter/latest/
[hiera]: /hiera/latest/
[mcollective]: /mcollective/
[agent]: ./services_agent_unix.html
[apply]: ./services_apply.html
[puppet server]: /puppetserver/latest/


Starting with Puppet 4, we distribute Puppet as two core packages:

- `puppet-agent` --- This package contains Puppet's main code and all of the dependencies needed to run it, including [Facter][], [Hiera][], and bundled versions of Ruby and OpenSSL. It also includes [MCollective][]. Once it's installed, you have everything you need to run [the Puppet agent service][agent] and the [Puppet apply command][apply].
- `puppetserver` --- This package depends on `puppet-agent`, and adds the JVM-based [Puppet Server][] application. Once it's installed, a server can serve catalogs to nodes running the Puppet agent service.

## What's Up With the Version Numbers?

The `puppet-agent` package has its own version number, which doesn't match the version of Puppet it installs. Right now, `puppet-agent` 1.0 includes Puppet 4.0, 1.1 includes Puppet 4.1, etc.

This is kind of confusing, but we haven't yet found a way to avoid it. Since `puppet-agent` is a distribution made up of many different pieces of software, its version number will frequently increase when Puppet's version does not --- for example, `puppet-agent` 1.2.0 and 1.2.1 ship the same Puppet version but different Facter versions.

Our options were to either let the versions be completely separate, or ship a bunch of "empty" Puppet releases where the version number increases without any changes to Puppet itself. For now we're going with the former.

See the table below for details about which components shipped in which `puppet-agent` release.

## Release Contents: `puppet-agent` 1.x

{% partial /puppet-agent/_agent1.x.html %}

