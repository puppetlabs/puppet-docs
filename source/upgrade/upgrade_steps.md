---
layout: default
title: "Upgrading from Puppet 3 to Puppet 4+: Summary of upgrade steps"
canonical: "/upgrade/upgrade_steps.html"
---

You want your upgrade to go quickly and safely. You've got services to run and don't want to waste time. This upgrading guide distills the process down to four main steps with short checklists for each one. (Real talk though: some of those checklists are more involved than others.) Read through this page to get an overview of the scope of the upgrading process. Then when you're confident, dive into each section.

### 1. Review your node classification strategy

_Node classification_ means determining which classes are applied to a given node, and what parameters are supplied to those classes. There have been a number of strategies for this through the course of Puppet's history, from node inheritance, to `import nodes/*.pp`, to GUI classification in Puppet Enterprise. The community and Puppet Enterprise have converged on a pattern known as "Roles and Profiles." You'll want to configure your setup to use Roles and Profiles if you can. It provides a great amount of flexibility and power, while remaining maintainable and scalable as your teams and your infrastructure evolve.

* For PE 3.3 users: [Migrate to the new node classifier](https://docs.puppet.com/pe/3.8/install_upgrade_migration_tool.html).

* [Read more about roles and profiles](https://docs.puppet.com/pe/latest/puppet_assign_configurations.html#assigning-configuration-data-with-role-and-profile-modules)

* Import is deprecated, but the same functionality happens automatically if you [use the `manifestdir` setting](https://docs.puppet.com/puppet/latest/reference/dirs_manifest.html#directory-behavior-vs-single-file).

### 2. Prepare your code

One of the biggest changes in Puppet 4 was the new parser. It has been available through an option called `--parser future` since late 2013, but it's not the "future" anymore -- it's here. Most Puppet 3 code works just fine, but there are enough changes that you should test your codebase out. Here's how:

* **Set up revision control:** If you're not already using version control on your Puppet code, now's the time to start. If you are (please, please say you are!), you'll make a new branch from your production branch, so you can test the code and commit fixes without affecting your business critical systems.

* **Find and resolve problems:** Now it's time to dig into the `puppetlabs-catalog_preview` module. This module contains a command-line application which compiles two catalogs for nodes you specify: one using the 3.x parser and one using the new, rewritten parser. It then analyzes the differences between the catalogs and produces a report to show you the file and line number that caused each difference. After working through the output from the catalog preview module, you'll have a Puppet 4 compliant branch of code that will produce predictable, consistent results.

We've got a detailed, step-by-step upgrade workflow document to walk you through using the catalog preview module, plus technical docs enumerating each of the changes between the 3.x and 4.x and newer language:

  * [Code upgrade workflow walkthrough](/upgrade/upgrade_code_workflow.html)
  * [Updating 3.x manifests for Puppet 4 and newer](/upgrade/updating_manifests.html)
  * [A PE-centric `catalog_preview` module walkthrough](https://docs.puppet.com/pe/latest/migrate_pe_catalog_preview.html)

If you're feeling extra motivated, this is a great opportunity to implement r10k and its branch-per-environment workflow, but that's completely optional. One thing at a time.

  * [r10K documentation](/pe/latest/r10k.html)

### 3. Migrate your servers

You've got a fork in the road at this point. You can either *upgrade* your existing server infrastructure to the latest version of its components, or you can *migrate* to new servers, putting your configuration and data onto a clean installation. We strongly recommend migration because it gives you a fresh start. There's less to go awry during the setup phase and if something does go wrong, it's easy to recycle the servers and try again. Migration also offers you the chance to refresh your operating system's installation.

>**Puppet Enterprise 3.x installations _must_ migrate**. All of our testing and documentation is geared towards migration. 

Assuming you're going to go down the migration route, there's a wealth of documentation to help you:

* [PE monolithic migration documentation](https://docs.puppet.com/pe/latest/migrate_monolithic.html)
* [Open source major upgrade documentation](https://docs.puppet.com/puppet/latest/reference/upgrade_major_pre.html)


### 4. Upgrade your agents

Finally, your fleet needs their Puppet agents updated to a version that matches that of the servers. The philosophy here is *"one, some, all"*: make the change to _one_ node manually, and watch it closely for unexpected behavior. Then expand to a larger set of _some_ nodes, potentially iterating a few times if your fleet's baseline configuration diverges widely. Ultimately, expand the change to _all_ of your nodes and watch for stragglers or strays who need extra intervention. As an additional measure of protection, you can run each batch of hosts in no-op mode first before actually making the change.

The Puppet 3.x to 4.x upgrade is different than previous versions because the packaging and file system layout have changed. There's now the same Ruby stack and library dependencies for both open source Puppet and Puppet Enterprise, and it's all contained inside one package that installs itself into `/opt/puppetlabs`, out of the way of your OS libraries. On Unix and Linux systems, configuration files now live under `/etc/puppetlabs` and we make symlinks for the binaries into `/usr/local/bin`, so you might need to adjust your scripts and CLI interactions. On Windows, we've been using this all-in-one methodology since the start, so nothing special should be needed.

All of this works really nicely, but it is a bit of a jump to get everything moved over. So, we did what any self-respecting devops organization would do: we automated it. The `puppetlabs-puppet_agent` module works with both PE and open source agents, and when applied to a 3.x node, will take care of the details of moving SSL certificates and keys, dropping in new config files while preserving local customizations, and upgrading the packages themselves.

* You can check out the [module documentation](https://forge.puppet.com/puppetlabs/puppet_agent) on the Forge.

* Also, read through the [PE-specific instructions](/pe/latest/install_upgrading_agents.html#upgrade-agents-using-the-puppetagent-module) for assigning and configuring the class on your nodes.

### Wrapping it up

Still with us? Great. It can feel like a lot to take in, but there's plenty of resources and help if you get stuck. And once you're done, your shiny new Puppet infrastructure will work faster, be more reliable, and enable you to use next-generation modules written with the enhanced Puppet language. You can get real-time help on the `#upgraders` channel on the [Puppet Community Slack](https://puppetcommunity.slack.com/), send mail to the [puppet-users Google group](https://groups.google.com/forum/#!forum/puppet-users), and for PE users, [send in a support request](https://support.puppet.com/) with "Upgraders" in the subject line to fast-track it to a dedicated team of support engineers.

Happy upgrading!
