---
layout: default
built_from_commit: 4c6a439852c8609e8cefbbc8701d89a7a46f49a3
title: Puppet Man Pages
canonical: "/puppet/latest/man/index.html"
---



Puppet's command line tools consist of a single `puppet` binary with many subcommands. The following subcommands are available in this version of Puppet:

Core Tools
-----

These subcommands form the core of Puppet's tool set, and every user should understand what they do.

- [puppet agent](./agent.html)
- [puppet apply](./apply.html)
- [puppet cert](./cert.html)
- [puppet module](./module.html)
- [puppet resource](./resource.html)
- [puppet lookup](./lookup.html)


Secondary subcommands
-----

Many or most users will need to use these subcommands at some point, but they aren't needed for daily use the way the core tools are.

- [puppet config](./config.html)
- [puppet describe](./describe.html)
- [puppet device](./device.html)
- [puppet doc](./doc.html)
- [puppet epp](./epp.html)
- [puppet help](./help.html)
- [puppet man](./man.html)
- [puppet node](./node.html)
- [puppet parser](./parser.html)
- [puppet plugin](./plugin.html)


Niche subcommands
-----

Most users can ignore these subcommands. They're only useful for certain niche workflows, and most of them are interfaces to Puppet's internal subsystems.

- [puppet catalog](./catalog.html)
- [puppet facts](./facts.html)
- [puppet filebucket](./filebucket.html)
- [puppet key](./key.html)
- [puppet report](./report.html)
- [puppet status](./status.html)


## Puppet Enterprise-specific subcommands

Puppet Enterprise (PE) has some unique subcommands, such as `puppet infrastructure`. For reference information about these commands, use the `puppet help` command, such as `puppet help infrastructure`. For usage information, see the [Puppet Enterprise documentation](https://puppet.com/docs/pe/).

Unknown or new subcommands
-----

These subcommands have not yet been added to any of the categories above.

- [puppet ssl](./ssl.html)
- [puppet script](./script.html)
- [puppet generate](./generate.html)

