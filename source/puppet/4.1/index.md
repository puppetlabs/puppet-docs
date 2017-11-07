---
layout: default
title: "Puppet 4.1 Reference Manual"
canonical: "/puppet/latest/index.html"
toc: false
---

Welcome to the Puppet 4.1 Reference Manual. Use the navigation to the left to get around.

## What Is This?

For an introduction to how Puppet manages systems, see the [Overview of Puppet's Architecture.](./architecture.html)

## Getting Started

Puppet 4 consists of:

* A `puppet-agent` "All-in-One" package that installs Puppet, Ruby, Facter, Hiera, and supporting code.
* A `puppetserver` package that installs Puppet Server.

To install these, read the [pre-install instructions](./install_pre.html), then see the Puppet installation guides for [Linux](./install_linux.html) and [Windows](./install_windows.html).

### Upgrading from Puppet 3.x

In order to get this release into the world as quickly as possible we had to make two significant tradeoffs for in-place upgrades:

1. Due to the changes in filesystem paths for configuration and SSL files, you'll need to take a few extra steps to install Puppet Agent / Puppet 4 on an existing Puppet 3.x host and have it "just work." Check out the [Agent Upgrade doc](upgrade_agent.html) for details.

2. Changes to Puppet's agent-to-master network communication mean that 4.x agents can only talk to 4.x masters, so the process for upgrading within a major series ("Upgrade your masters first, then agents") isn't sufficient. We're working to make 3.x agents able to talk to the next release of Puppet Server. We do have [step by step instructions](upgrade_server.html) to help you set up 4.x masters.

## Getting Around

This manual is split into several sections, which can be reached from the left sidebar. A few notable pages:

* The [Release Notes](./release_notes.html) have information about what's new and different in Puppet 4.1, and track changes from patch releases.
* If you're an experienced Puppet user, you'll want to take a look at the [Where Did Everything Go?](./whered_it_go.html) page.
* The [Resource Type Reference](/puppet/3.8/type.html) is the page where experienced Puppet users spend most of their time.
* Puppet uses its own configuration language, which is documented in the language section of this reference. Two good starting points are:
    * The [Language Summary](./lang_summary.html), which gives an overview and some context.
    * The [Visual Index](./lang_visual_index.html), which can help you find docs for syntax when you know what it looks like but don't know what it's called.
* [Modules](./modules_fundamentals.html) explains how to organize your Puppet manifests, obtain pre-existing modules, and publish your own modules for public use.

