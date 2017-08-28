---
layout: default
title: "Why upgrade from Puppet 3?"
canonical: "/upgrade/index.html"
---

## Your guide to modernizing your infrastructure

Puppet 4.0 released to the open-source community in April 2015, and rolled into Puppet Enterprise 2015.2 a few months later. It was the first major version release of Puppet since 2012 and contained some great improvements, which subsequent releases have built upon and expanded. But as everyone who runs production systems knows, every change also contains an element of risk. Why fix what isn’t broken? As a result, our community is split fairly evenly between people who are staying current with the latest versions, and those who are still running a Puppet 3 based infrastructure.

However, **December 31, 2016 was the end of life date for Puppet 3**. From then on, the company and community are focusing on supporting Puppet 4 and newer. We want to bring the whole ecosystem forward onto the latest versions. This guide provides the information you need to upgrade to Puppet 4 and newer, whether you're curious about the benefits of Puppet, you know you want to upgrade but aren't sure where to start, or you're a module author who wants to take advantage of the powerful features of the enhanced Puppet language.

Follow the guide outlined on the [Upgrade steps page](/upgrade/upgrade_steps.html), or use the links to the left for upgrade resources.

**Note:** If you are looking for information about upgrading from Puppet 4.x to the latest feature release, see the [minor upgrades section of the Puppet documentation](./puppet/latest/reference/upgrade_minor.html). For upgrading PE to the latest from 2015.2 or newer, see [Upgrading PE: monolithic](/pe/latest/upgrade_mono.html).

## What's so awesome about newer versions of Puppet, anyway?

Puppet 4 introduced several features, and deprecated others. Puppet 5 improved scalability and performance, and removed many deprecated cruft. 

See the [Puppet 5 Platform announcement](https://puppet.com/blog/puppet-5-platform-released) and the [Puppet 5.0][/puppet/5.0/release_notes.html#puppet-500] release notes to learn about these improvements and removals.

### Scalability

Right out of the box, Puppet 4 and 5 scale better than ever. There are two big innovations under the hood that supercharge its performance: Puppet Server and static catalogs. The Clojure-based Puppet Server replaces the Apache+Passenger parts of the network stack. With it, one master serves more agents, faster. Static catalogs optimize the most computationally expensive part of Puppet by reducing both the number of catalogs compiled and file checksum requests as the agents are applying their catalogs.

### Language

The Puppet language received an overhaul for Puppet 4. A completely rewritten parser, new constructs like iterators and lambdas, and an opt-in data type system all make for modules that do more with less work. Improved error messages reduce the amount of time you spend head-scratching. Structured facts allow you to access inventory data such as network interfaces more intuitively. Resources apply in top-down order so your manifests work the way you expect them to, combining power and usability to meet your needs unlike any other product, including earlier versions of Puppet.

### All-in-one packaging

Managing your agent software is a lot easier with the new Puppet all-in-one packaging. There's now a single, unified package for open source Puppet and Puppet Enterprise. And not only are the underlying components bundled and tested together, the component stack is consistent across all the operating systems Puppet runs on: Linux, network devices, commercial Unixes like Solaris and AIX, Windows, and Mac OS X. There are some great updates tucked inside the bundle, too: a super-fast Facter rewritten in C++, an updated Ruby, and the latest Augeas. There's a great module on the Forge (`puppetlabs/puppet_agent`) to help you update while preserving your certificates and custom settings.

### Puppet Enterprise

Updating your codebase to Puppet 4 and above also lets you take advantage of the latest advances in Puppet Enterprise. In 2015, Puppet Enterprise moved to an approximately quarterly release cadence with version numbers that indicate the year, quarter, and patch level, as in Puppet Enterprise 2016.1.2. Since the first of these (Puppet Enterprise 2015.2), each release has supplemented the open source platform with exciting features such as orchestration, visualization and reporting, and role-based access control.

#### Orchestration

Orchestration capabilities in Puppet Enterprise make it easier to deploy changes rapidly with confidence, and to run ordered deployments across your infrastructure and applications. You can orchestrate change on demand and run phased deployments, with full and direct control, real-time visibility and feedback, and built-in intelligence to account for dependencies across your infrastructure.

#### Interactive dependency visualization

Puppet Enterprise lets you visualize your infrastructure model as a graph, making it easy to see the upstream and downstream dependencies across all the configurations you define and enforce on each node. This makes it easier to collaborate, troubleshoot issues, and understand which configuration resources depend on each other so you can deploy more confidently.

#### Code Manager and r10k workflows

Building on the popular r10k tool, Puppet Enterprise includes automated workflows to review, test, promote and deploy Puppet code across your development, testing and production environments. You can check your code into common version control systems, automatically sync code across multiple compile masters, and more easily ensure consistency across your environments.

#### Day One provisioning

PE includes supported modules and workflows to automate Day One provisioning across your bare metal, virtual, cloud, and containerized infrastructure. You’ll find supported modules to install and launch AWS, Docker, Microsoft Azure, and vSphere, plus fully supported Razor for bare metal provisioning.

#### Role-based access control

PE's powerful role-based access control (RBAC) lets you safely delegate work to the right individuals and teams. You can assign permissions, specify who has access to what, and set guard rails so your teams can work together safely.

### Awesomeness for all

Regardless of whether you're running open source Puppet or Puppet Enterprise, you'll find a Puppet 4 or Puppet 5 based infrastructure scales better, takes less work to manage, and unlocks powerful new capabilities. Use this guide to start migrating to a newer version of Puppet today.
