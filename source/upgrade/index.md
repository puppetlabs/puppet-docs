---
layout: default
title: "Puppet upgraders reference"
canonical: "/upgrade/index.html"
---

## Your guide to modernizing your infrastructure

Puppet 4.0 was an open source release in April 2015, and rolled into Puppet Enterprise 2015.2 a few months later. It was the first major version release of Puppet since 2012 and contained some great improvements, which subsequent releases have built upon and expanded. But as everyone who runs production systems knows, every change also contains an element of risk. Why fix what isn’t broken? As a result, our community has split fairly evenly between people who are staying current with the latest versions, and those who are still running a Puppet 3 based infrastructure.

That's why we started this project: we want to bring the whole community forward onto the latest versions. There's information here for everyone, whether you're curious about the benefits of Puppet, you know you want to upgrade but aren't sure where to start, or you're a module author who wants to take advantage of the powerful features of the enhanced Puppet language.

## What's so awesome about Puppet 4, anyway?

### Scalability

Right out of the box, Puppet 4 scales better than ever. There are two big innovations under the hood that supercharge its performance: the Clojure-based Puppet Server and static catalogs. The Puppet Server takes the place of the Apache+Passenger parts of the network stack and lets the same master serve more agents, faster. Static catalogs optimize the most computationally expensive part of Puppet by reducing both the number of catalogs compiled and file checksum requests as the agents are applying their catalogs.

### Language

There's more —- much more -- on this topic below, but the Puppet language received a huge overhaul for Puppet 4. A completely rewritten parser, new constructs like iterators and lambdas, and an opt-in data type system all make for modules that do more with less work. There are improved error messages to reduce the amount of time you spend head-scratching, structured facts to allow you to access inventory data like network interfaces more intuitively, resources that apply in top-down order so your manifests work the way you expect them to, and much more. It all adds up to a system with a better combination of power and usability than anything else on the market —- including earlier versions of Puppet.

### All-in-one packaging
Managing your agent software is a lot easier with Puppet 4's all-in-one packaging. There's now a single, unified package for open source Puppet and Puppet Enterprise. And not only are the underlying components bundled and tested together, the component stack is consistent across all the operating systems Puppet runs on: Linux, network devices, commercial Unixes like Solaris and AIX, Windows, and Mac OS X. There are some great updates tucked inside the bundle, too: a super-fast Facter rewritten in C++, an updated Ruby, and the latest Augeas. There's a great module on the Forge (`puppetlabs/puppet_agent`) to help you update while preserving your certificates and custom settings.

### Puppet Enterprise

If you haven't looked at Puppet Enterprise lately, be prepared to be impressed. In 2015, Puppet Enterprise moved to a quarterly release cadence with a numbering scheme that represents the year/number/patch, like Puppet Enterprise 2016.1.2, to decouple their numbers from the Puppet codebase. Since the first of these (Puppet Enterprise 2015.2), each release has built killer features on the open source platform: orchestration, visualization and reporting, and role-based access control are just some of the highlights.

In 2016, we debuted new orchestration capabilities in Puppet Enterprise that make it easier to deploy changes rapidly with confidence and run ordered deployments across your infrastructure and applications. You can orchestrate change on demand and run phased deployments, with full and direct control, real-time visibility and feedback, and built-in intelligence to account for dependencies across your infrastructure.

#### The graph

Puppet Enterprise now includes new ways to visualize your infrastructure model as a graph, making it easy to see the upstream and downstream dependencies across all the configurations you define and enforce on each node. This makes it easier than ever to collaborate, troubleshoot issues, and understand which configuration resources depend on each other so you can deploy more confidently.

#### r10k improvements

Building on the popular r10k tool, Puppet Enterprise now includes automated workflows to review, test, promote and deploy Puppet code across your development, testing and production environments. You can check your code into common version control systems, automatically sync code across multiple compile masters, and more easily ensure consistency across your environments.

#### Day One provisioning

PE now includes new supported modules and workflows to automate Day One provisioning across your bare metal, virtual, cloud, and containerized infrastructure. You’ll find supported modules to install and launch AWS, Docker, Microsoft Azure, and vSphere, plus fully supported Razor for bare metal provisioning.

#### RBAC

Finally, PE includes powerful role-based access control (RBAC) to enable you to safely delegate work to the right individuals and teams. You can assign permissions and control who has access to what, and set guard rails so your teams can work together safely.

Regardless of whether you're running open source Puppet or Puppet Enterprise, you'll find a Puppet 4 based infrastructure scales better, takes less work to manage, and unlocks powerful new capabilities for modules.

## Upgrade steps

If you're running an existing Puppet infrastructure, you probably have questions about how to upgrade safely and quickly. Any upgrade can feel overwhelming and you've got services to run --- who has time to wade through tons of documentation just to figure out how to upgrade? Well, this section's for you. We've distilled the process down to four main steps with short checklists for each one. (Real talk though: some of those checklists are more involved than others.) First you'll need to prepare your codebase. Once your modules are good to go, upgrade or migrate your server-side components. Lastly, get your agents upgraded with a staged rollout and enjoy the shiny goodness.

### 1. Review your classification strategy

Node classification means determining which classes are applied to a given node, and what parameters are supplied to those classes. There have been a number of strategies for this through the course of Puppet's history, from node inheritance, to `import nodes/*.pp`, to GUI classification in Puppet Enterprise. The community and Puppet Enterprise have converged on a standard pattern known as "Roles and Profiles", and you'll want to configure your setup to use Roles and Profiles if you can. It provides a great amount of flexibility and power, while remaining maintainable and scalable as your teams and your infrastructure evolve.

* For PE 3.3 users, you'll need to [migrate to the new node classifier](https://docs.puppet.com/pe/3.8/install_upgrade_migration_tool.html).

* [Read more about roles and profiles](https://docs.puppet.com/pe/latest/puppet_assign_configurations.html#assigning-configuration-data-with-role-and-profile-modules)  (TODO: replace with link to new content)

* Import is deprecated, but the same functionality happens automatically if you [use the `manifestdir` setting](https://docs.puppet.com/puppet/latest/reference/dirs_manifest.html#directory-behavior-vs-single-file).

### 2. Prepare your code

One of the biggest changes in Puppet 4 is the new parser. It's been available through an option called `future parser` since 2013, but it's not the "future" anymore: it's here. Most Puppet 3 code works just fine, but there are enough changes under the hood that you should test your codebase out. Here's how:

* Branch your code repo: If you're not already using version control on your Puppet code, now's the time to start. If you are (please, please say you are!), you should make a new branch from your production branch, so you can test the code and commit fixes without affecting your business critical systems. If you're feeling extra motivated, this is a great opportunity to implement r10k and its branch-per-environment workflow, but that's completely optional. One thing at a time.

  * Code workflow
  * Upgrading manifests checklist
  * r10K documentation https://docs.puppet.com/pe/latest/r10k.html

* Use catalog preview: Now it's time to dig into the `puppetlabs-catalog_preview` module. This module contains a command-line application which compiles two catalogs for nodes you specify: one using the 3.x parser and one using the new, rewritten parser. It then analyzes the differences between the catalogs and produces a report to show you the file and line number that caused each difference. After working through the output from catalog preview, you should have a Puppet-4-compliant branch of code that will produce predictable, consistent results.
    * https://docs.puppet.com/pe/latest/migrate_pe_catalog_preview.html

### 3. Update your servers

You've got a fork in the road at this point. You can either *upgrade* your existing server infrastructure to the latest version of its components, or you can *migrate* to new servers, putting your configuration and data onto a clean installation. We strongly recommend migration because it gives you a fresh start. There's less to go awry during the setup phase and if something does go wrong, it's easy to recycle the servers and try again. Migration also offers you the chance to refresh your operating system's installation.

*Puppet Enterprise 3.x installations _must_ migrate*; all of our testing and documentation is geared towards migration. In fact, we're reluctant to suggest that upgrading is an option at all, but it is technically possible, so for completeness' sake it seemed worthy of a mention; open source sites are free to try it... and power users might even make it work.

But assuming you're going to go down the migration route, there's a wealth of documentation to help you:

* [Open source major upgrade documentation](https://docs.puppet.com/puppet/latest/reference/upgrade_major_pre.html)
* [PE monolithic migration documentation](https://docs.puppet.com/pe/latest/migrate_monolithic.html) 

### 4. Upgrade your agents

It's the moment of truth. Your fleet needs their Puppet agents updated to a version which matches that of the servers. The philosophy here is *"one, some, all"*: make the change to one node manually, and watch it closely for unexpected behavior. Then expand to a larger set of nodes, potentially iterating a few times if your fleet's baseline configuration diverges widely. Ultimately, expand the change to all of your nodes and watch for stragglers or strays who need extra intervention. As an additional measure of protection, you can run each batch of hosts in no-op mode first before actually making the change.

The Puppet 3.x to 4.x upgrade is different than previous versions because as mentioned above, the packaging and file system layout have changed. There's now the same Ruby stack and library dependencies for both open source Puppet and Puppet Enterprise, and it's all contained inside one package that installs itself into `/opt/puppetlabs`, out of the way of your OS libraries. On Unix and Linux systems, configuration files now live under `/etc/puppetlabs` and we make symlinks for the binaries into `/usr/local/bin` so scripts and CLI interactions might need adjustment. On Windows, we've been using this all-in-one methodology since the start, so nothing special should be needed.

All of this works really nicely, but it is a bit of a jump to get everything moved over. So, we did what any self-respecting devops organization would do: we automated it. There's a really slick module, `puppetlabs-puppet_agent`,  which works with both PE and open source agents, and when applied to a 3.x node, will take care of the details of moving SSL certificates and keys, dropping in new config files while preserving local customizations, and upgrading the packages themselves.

* You can check out the [module documentation](https://forge.puppet.com/puppetlabs/puppet_agent) on the Forge.

* Also, read through the [PE-specific instructions](https://docs.puppet.com/pe/latest/install_upgrading_agents.html#upgrade-agents-using-the-puppetagent-module) for assigning and configuring the class on your nodes.

### Wrapping it up

Still with us? Great. It can feel like a lot to take in, but there's plenty of resources and help if you get stuck, and once you're done, your shiny new Puppet infrastructure will work faster, be more reliable, and enable you to use next-generation modules written with the enhanced Puppet language. You can get real-time help on the `#upgraders` channel on the Puppet Community Slack, send mail to the puppet-users Google group, and for PE users, send in a support request with "Upgraders" in the subject line to fast track it to a dedicated team of support engineers.

Happy upgrading!


