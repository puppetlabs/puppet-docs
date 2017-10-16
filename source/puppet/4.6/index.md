---
layout: default
title: "Puppet 4.6 reference manual"
canonical: "/puppet/latest/index.html"
toc: false
---

[Overview of Puppet's Architecture]: ./architecture.html
[pre-install instructions]: ./install_pre.html
[Facter 3]: {{facter}}/
[Hiera 3]: {{hiera}}/
[Puppet Server]: /puppetserver/2.4/
[PuppetDB]: /puppetdb/4.2/
[Linux installation]: ./install_linux.html
[Windows installation]: ./install_windows.html
[OSX installation]: ./install_osx.html
[pre-upgrade guide]: ./upgrade_major_pre.html
[Agent major upgrade]: ./upgrade_major_agent.html
[Server major upgrade]: ./upgrade_major_server.html
[post-upgrade guide]: ./upgrade_major_post.html
[minor upgrade guide]: ./upgrade_minor.html
[Updating 3.x Manifests for Puppet 4.x]: ./lang_updating_manifests.html
[Release Notes]: ./release_notes.html

Welcome to the Puppet reference manual. Use the navigation to the left to get around.

## What is this?

For an introduction to how Puppet manages systems, see the [Overview of Puppet's Architecture][].

## Getting started

Puppet 4.6 consists of:

* A `puppet-agent` "All-in-One" package that installs Puppet, Ruby, [Facter 3][], [Hiera 3][], and supporting code.
* A `puppetserver` package that installs [Puppet Server][].
* A `puppetdb` package that installs [PuppetDB][].

To install these, read the [pre-install instructions][], then see the Puppet installation guides for [Linux][Linux installation], [Windows][Windows installation], and [Mac OS X][OSX installation].

### Upgrading from Puppet 3

Puppet 4 changes many things about how Puppet works, and you must be careful when upgrading from Puppet 3. We've made four guides to help walk you through the upgrade process:

1. Prepare for the upgrade by following the [pre-upgrade guide][], which covers how to update and move your site's configuration files to Puppet 4's revised standards.

2. Follow our [step-by-step instructions][Server major upgrade] to upgrade Puppet Server.

3. You need to take a few steps before upgrading your Puppet 3 agents. We've created a special Puppet module, `puppet_agent`, to help; check out the [Puppet agent major upgrade documentation][Agent major upgrade] for details.

4. After the upgrade, confirm that everything's working and clean up your configuration with the [post-upgrade guide][].

### Updating from earlier versions of Puppet 4

If you're already running Puppet 4, the [minor upgrade guide][] can help you update Puppet across your infrastructure.

## Getting around

This manual is split into several sections, which can be reached from the left sidebar. A few notable pages:

* The [Release Notes][] cover what's new and different in this version of Puppet.
* If you're an experienced Puppet user who's new to Puppet 4, review the [Where Did Everything Go?](./whered_it_go.html) page.
* Use the [Resource Type Reference](./type.html) for up-to-date information on core Puppet concepts.
* Puppet uses its own configuration language, which is documented in this reference's language section. You can start with:
    * The [Language Summary](./lang_summary.html), which gives an overview and some context for the language.
    * The [Visual Index](./lang_visual_index.html), which can help you find docs for syntax when you know what it looks like but don't know what it's called.
    * [Updating 3.x Manifests for Puppet 4.x][], if you're experienced with Puppet and want to focus on new and changed features.
* The [Modules Fundamentals](./modules_fundamentals.html) guide explains how to organize Puppet manifests, install pre-built modules from the Puppet Forge, and share your own modules.
