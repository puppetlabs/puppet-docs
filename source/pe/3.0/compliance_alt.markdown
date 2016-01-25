---
layout: default
title: "PE 3.0 » Compliance » Alternate Workflow"
subtitle: "Alternate Workflow to Replace Compliance Tool"
canonical: "/pe/latest/compliance_alt.html"
---


This page describes an alternate workflow which will allow you to maintain baseline states and audit changes in your puppet-controlled infrastructure.

Compliance Alternate Workflow
-----

#### Workflow In Brief

 - _Instead of writing audit manifests:_ Write manifests that describe the desired baseline state(s). This is identical to writing Puppet manifests to _manage_ systems: you use the resource declaration syntax to describe the desired state of each significant resource.
 - _Instead of running puppet agent in its default mode:_ Make it sync the significant resources in **noop mode,** which can be done for the entire Puppet run, or per-resource. (See below.) This causes Puppet to detect changes and _simulate_ changes, without automatically enforcing the desired state.
 - _In the console:_ Look for "pending" events and node status. "Pending" is how the console represents detected differences and simulated changes.

#### Controlling Your Manifests

 As part of a solid change control process, you should be maintaining your Puppet manifests in a version control system like Git. A well-designed branch structure in version control will allow changes to your manifests to be tracked, controlled, and audited.

#### Noop Features

 Puppet resources or catalogs can be marked as "noop" before they are applied by the agent nodes. This means that the user describes a desired state for the resource, and Puppet will detect and report any divergence from this desired state. Puppet will report what _should_ change to bring the resource into the desired state, but it will not _make_ those changes automatically.

 * To set an individual resource as noop, set [the `noop` metaparameter](/puppet/latest/reference/metaparameter.html#noop) to `true`.

         file {'/etc/sudoers':
           owner => root,
           group => root,
           mode  => 0600,
           noop  => true,
         }

     This allows you to mix enforced resources and noop resources in the same Puppet run.
 * To do an entire Puppet run in noop, set [the `noop` setting](/puppet/latest/reference/configuration.html#noop) to `true`. This can be done in the `[agent]` block of puppet.conf, or as a `--noop` command-line flag. If you are running puppet agent in the default daemon mode, you would set noop in puppet.conf.

#### In the Console

 In the console, you can locate the changes Puppet has detected by looking for "pending" nodes, reports, and events. A "pending" status means Puppet has detected a change and simulated a fix, but has not automatically managed the resource.

 You can find a pending status in the following places:

 * The node summary, which lists the number of nodes that have had changes detected:

 ![The node summary with one node in pending status](./images/baseline/pending_node_summary.png)

 * The list of recent reports, which uses an orange asterisk to show reports with changes detected:

 ![The recent reports, with a few reports containing pending events](./images/baseline/pending_recent_reports.png)

 * The _log_ and _events_ tabs of any report containing pending events; these tabs will show you what changes were detected, and how they differ from the desired system state described in your manifests:

 ![The events tab of a report with pending events](./images/baseline/pending_events.png)

 ![The log tab of a report with pending events](./images/baseline/pending_log.png)

#### After Detection

 When a Puppet node reports noop events, this means someone has made changes to a noop resource that has a desired state desribed. Generally, this either means an unauthorized change has been made, or an authorized change was made but the manifests have not yet been updated to contain the change. You will need to either:

 * Revert the system to the desired state (possibly by running puppet agent with `--no-noop`).
 * Edit your manifests to contain the new desired state, and check the changed manifests into version control.

#### Before Detection

 However, your admins should generally be changing the manifests before making authorized changes. This serves as documentation of the change's approval.

#### Summary

 In this alternate workflow, you are essentially still maintaining baselines of your systems' desired states. However, instead of maintaining an _abstract_ baseline by approving changes in the console, you are maintaining _concrete_ baselines in readable Puppet code, which can be audited via version control records.

* * *

