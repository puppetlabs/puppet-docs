---
layout: default
built_from_commit: e08055f43b0d05a8496a3be38ed5a28747bcdf36
title: Puppet Man Pages
canonical: "/puppet/latest/man/index.html"
---



Puppet's command line tools consist of a single `puppet` binary with many subcommands. The following subcommands are available in this version of Puppet:

Core Tools
-----

These subcommands form the core of Puppet's tool set, and every user should understand what they do.

- [puppet agent](./agent.html)
- [puppet apply](./apply.html)
- [puppet lookup](./lookup.html)
- [puppet module](./module.html)
- [puppet resource](./resource.html)

> Note: The `puppet cert` command is available only in Puppet versions prior to 6.0. For 6.0 and later, use the [`puppetserver cert`command](https://puppet.com/docs/puppet/6.0/puppet_server_ca_cli.html).

Secondary subcommands
-----

Many or most users need to use these subcommands at some point, but they aren't needed for daily use the way the core tools are.

- [puppet config](./config.html)
- [puppet describe](./describe.html)
- [puppet device](./device.html)
- [puppet doc](./doc.html)
- [puppet epp](./epp.html)
- [puppet generate](./generate.html)
- [puppet help](./help.html)
- [puppet node](./node.html)
- [puppet parser](./parser.html)
- [puppet plugin](./plugin.html)
- [puppet script](./script.html)
- [puppet ssl](./ssl.html)


Niche subcommands
-----

Most users can ignore these subcommands. They're only useful for certain niche workflows, and most of them are interfaces to Puppet's internal subsystems.

- [puppet catalog](./catalog.html)
- [puppet facts](./facts.html)
- [puppet filebucket](./filebucket.html)
- [puppet key](./key.html)
- [puppet man](./man.html)
- [puppet report](./report.html)
- [puppet status](./status.html)


