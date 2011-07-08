---
layout: default
title: "Baseline Plugin: Intro/Workflow"
---

Puppet Dashboard Baseline Compliance Workflow
====

This chapter describes the baseline compliance workflow and defines some key terms and concepts.

* * * 

Overview
--------

The baseline compliance workflow is designed to audit changes to systems that are managed by ad-hoc manual administration. This differs from and is incompatible with Puppet's standard managed resources workflow --- although you can use both models of management at the same site (or even in the same catalog), they should be used on disjunct sets of resources.

Concepts
----

### Auditing

When using this workflow, Puppet audits the state of resources, rather than enforcing a desired state; it does not make changes to any audited resources. Instead, changes are to be made ad-hoc and reviewed for approval after the fact.

When reviewing changes in the Dashboard interface, any approved changes will show up as the baseline state in future reports. Rejected changes will continue to be reported as non-baseline states until they are reverted manually on the affected machines. 

### Resources and Attributes

Any native Puppet resource type can be used in the baseline compliance workflow. As with similar compliance products, you can audit the content and metadata of files, but you can also audit user accounts, services, cron jobs, and anything for which a custom native type can be written. 

Resources are audited by attribute --- you can choose one or more attributes you wish to audit, or audit all attributes of that resource. 

### Manifests

The set of resources to audit is declared in standard Puppet manifests on the master and retrieved as a catalog by the agent. Instead of declaring the desired state of a resource, these manifests should declare only titles (and name/namevar, if necessary) and the [`audit`](http://docs.puppetlabs.com/references/latest/metaparameter.html#audit) metaparameter.

### Inspect Reports

Each node being audited for compliance will routinely report the states of its audited resources. The documents it sends are called _inspect reports_ (to differentiate them from standard Puppet reports). 

### Baselines

Conceptually, a _baseline_ is a blessed inspect report for a single node: it lists the approved states for every audited resource on that node. Each node is associated with one and only one baseline, and nodes cannot share baselines. However, nodes with similar baselines can be grouped for convenience.

Baselines are maintained by the Puppet Dashboard baseline compliance plugin. They change over time as administrators approve changes to audited resources. 

### Groups

Although nodes cannot share baselines, nodes with similar baselines can be grouped for convenience. This can speed up the approval or rejection of similar changes. 

The Compliance Workflow Cycle
----

1. Sysadmin: Write manifests defining which resources to audit on which nodes. 
2. Agent nodes: Retrieve catalog with puppet agent and update list of resources to audit if necessary.
3. Agent nodes: Audit resources from catalog and submit inspect reports with puppet inspect. 
4. Dashboard: Calculate daily report of differences between inspected system state and approved baseline state. 
5. Sysadmin: Use Dashboard interface to approve or reject every difference. Manually revert unapproved changes on affected systems.
6. Dashboard: Modify baseline to include approved changes.

Repeat steps 3-7 daily and steps 1-2 as needed.

