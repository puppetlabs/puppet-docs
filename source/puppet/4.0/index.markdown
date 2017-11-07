---
layout: default
title: "Puppet 4.0 Reference Manual"
canonical: "/puppet/latest/index.html"
toc: false
---

Welcome to the Puppet 4.0 Reference Manual. Use the navigation to the left to get around.

## What Is This?

For an introduction to how Puppet manages systems, see the [Overview of Puppet's Architecture.](./architecture.html) 

## Getting Started

Puppet 4 consists of a `puppet-agent` "All-in-One" package that installs Puppet 4.0, Ruby, Facter, Hiera, and supporting code; and a `puppetserver` package that installs Puppet Server 2.0.

To install Puppet 4.0, see the Puppet installation guides for [Linux](./install_linux.html) and [Windows](./install_windows.html). 

### Upgrading from Puppet 3.x

In order to get this release into the world as quickly as possible we had to make two significant tradeoffs for in-place upgrades:

1. Due to the changes in filesystem paths for configuration and SSL files, you'll need to take a few extra steps to install Puppet Agent / Puppet 4 on an existing Puppet 3.x host and have it "just work." Check out the [Agent Upgrade doc](upgrade_agent.html) for details. We'll make an update to the AIO package available in the coming month to address this issue.

2. Changes to Puppet's agent-to-master network communication mean that 4.x agents can only talk to 4.x masters, so the process for upgrading within a major series ("Upgrade your masters first, then agents") isn't sufficient. We're working to make 3.x agents able to talk to the next release of Puppet Server. We do have [step by step instructions](upgrade_server.html) to help you set up 4.x masters. 

## Getting Around

* [The Puppet 4.0 Release Notes](./release_notes.html) contain information about Puppet 4.0's new features, and tracks changes from patch releases.
* If you're an experienced Puppet user, you'll want to take a look at the [Where Did Everything Go?](./whered_it_go.html) page.


## Previous Versions

- [Puppet 3.7](/puppet/3.7)
- [Puppet 3.6](/puppet/3.6)
- [Puppet 3.5](/puppet/3.5)
- [Puppet 3.0 through 3.4](/puppet/3/reference)
