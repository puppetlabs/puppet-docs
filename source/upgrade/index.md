---
layout: default
title: "Puppet upgraders reference"
canonical: "/upgrade/index.html"
---

## Your guide to modernizing your infrastructure

Puppet 4.0 was an open source release in April 2015, and rolled into Puppet Enterprise 2015.2 a few months later. It was the first major version release of Puppet since 2012 and contained some great improvements, which subsequent releases have built upon and expanded. But as everyone who runs production systems knows, every change also contains an element of risk. Why fix what isn’t broken? As a result, our community has split fairly evenly between people who are staying current with the latest versions, and those who are still running a Puppet 3 based infrastructure.

That's why we started this project: we want to bring the whole community forward onto the latest versions. There's information here for everyone, whether you're curious about the benefits of Puppet, you know you want to upgrade but aren't sure where to start, or you're a module author who wants to take advantage of the powerful features of the enhanced Puppet language.

Follow the guide outlined on the [Upgrade steps page](/upgrade/upgrade_steps.html), or use the links to the left for upgrade resources.

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

