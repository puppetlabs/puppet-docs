---
layout: default
title: "Puppet 4.0 Docs"
---


Welcome to the release of Puppet 4.0! We've posted this set of documents to help you get started. We'll be publishing full documentation for Puppet 4.0 over the next several weeks as the dust settles.

Use the navigation to the left to browse this section. Most users will want to take a look at the [Where Did Everything Go?](./whered_it_go.html) page and the [updated install instructions.](./install_el.html)

What's In This Release?
-----

Puppet 4 consists of a `puppet-agent` "All-in-One" package that installs Puppet 4.0, Ruby, Facter, Hiera, and supporting code; and a `puppetserver` package that installs Puppet Server 2.0.

Notes for Upgraders
-----

In order to get this release into the world as quickly as possible we had to make two significant tradeoffs for in-place upgrades; please read on for details.

1. Due to the changes in filesystem paths for configuration and SSL files, it will require a few extra steps to install Puppet Agent / Puppet 4 on an existing Puppet 3.x host and have it "just work" today. Check out the [Agent Upgrade doc](upgrade_agent.html) for details. An update to the AIO package will be available in the coming month to address this issue.

2. Changes to Puppet's agent-to-master network communication mean that 4.x agents can only talk to 4.x masters, so the process for upgrading within a major series ("Upgrade your masters first, then agents") isn't sufficient. Again, we're working to make 3.x agents able to talk to the next release of Puppet Server, but it's not available today. We do have [step by step instructions](upgrade_server.html) to help you setup 4.x masters. On a positive tip, if you've been looking for an opportunity to migrate your puppetmasters to fresh OS installs and try out the Puppet-Server based stack, now's your opportunity.  

