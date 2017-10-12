---
layout: default
title: "Puppet 5.2 reference manual"
toc: false
---

[Overview of Puppet's Architecture]: ./architecture.html
[pre-install instructions]: ./install_pre.html
[Facter]: {{facter}}/
[Hiera]: ./hiera_intro.html
[Puppet Server]: {{puppetserver}}/
[PuppetDB]: /puppetdb/5.1/
[Linux installation]: ./install_linux.html
[Windows installation]: ./install_windows.html
[macOS installation]: ./install_osx.html
[pre-upgrade guide]: ./upgrade_major_pre.html
[Agent major upgrade]: ./upgrade_major_agent.html
[Server major upgrade]: ./upgrade_major_server.html
[post-upgrade guide]: ./upgrade_major_post.html
[upgrade guide]: ./upgrade_minor.html
[major upgrade guide]: ./upgrade_major_pre.html
[release notes]: ./release_notes.html

Welcome to the Puppet reference manual. Use the navigation to the left to get around.

## How it works

For an introduction to how Puppet manages systems, see the [Overview of Puppet's Architecture][].

## Getting started

Puppet consists of:

* A `puppet-agent` "All-in-One" package that installs Puppet, Ruby, [Facter][], [Hiera][], and supporting code.
* A `puppetserver` package that installs [Puppet Server][].
* A `puppetdb` package that installs [PuppetDB][].

To install these, read the [pre-install instructions][], then see the Puppet installation guides for [Linux][Linux installation], [Windows][Windows installation], and [macOS][macOS installation].

## Getting around

This manual is split into several sections, which can be reached from the left sidebar. A few notable pages:

* The [release notes][] cover what's new and different in this version of Puppet.
* Use the [Resource Type Reference](./type.html) for up-to-date information on core Puppet concepts.
* Puppet uses its own configuration language, which is documented in this reference's language section. You can start with:
    * The [Language Summary](./lang_summary.html), which gives an overview and some context for the language.
    * The [Visual Index](./lang_visual_index.html), which can help you find docs for syntax when you know what it looks like but don't know what it's called.
* The [Modules Fundamentals](./modules_fundamentals.html) guide explains how to organize Puppet manifests, install pre-built modules from the Puppet Forge, and share your own modules.

### Upgrading from Puppet 4

If you're already running Puppet 4, the [upgrade guide][] can help you update Puppet across your infrastructure.

### Upgrading from Puppet 3.8.x

You can use the [major upgrade guide][] to upgrade from Puppet 3.8.x, but this upgrade path hasn't yet been tested or verified.
