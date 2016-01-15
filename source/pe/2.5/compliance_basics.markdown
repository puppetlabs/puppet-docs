---
layout: default
title: "PE 2.5 » Compliance » Basics and UI"
subtitle: "Compliance Basics and UI"
canonical: "/pe/latest/compliance_alt.html"
---

The Compliance Workflow Cycle
-----

PE's compliance workflow is designed to audit changes in systems that are managed manually. It can also audit changes to resources being actively managed by Puppet. 

![Baseline compliance workflow diagram](./images/baseline/baseline_workflow.png)

- **A sysadmin** writes manifests that define which resources to audit on which nodes. 
- **Puppet agent** retrieves and caches a catalog compiled from those manifests. 
- **Puppet inspect** reads that catalog to discover which resources to audit, then submits an inspect report.
- **The console** analyzes inspect reports, then calculates a daily report of differences between the inspected system state and the approved baseline state. (Or, if this is the node's first inspect report, it will create an initial baseline for it.)
- **A sysadmin** uses the console's compliance pages to approve or reject every difference, then manually reverts any unapproved changes as necessary. 
- **The console** then modifies the baseline to include any approved changes, and awaits the next day's inspect reports.

Concepts
-----

### Auditing

When using this workflow, Puppet audits the state of resources, rather than enforcing a desired state; it does not make changes to any audited resources. Instead, changes are to be made manually (or by some out-of-band process) and reviewed for approval after the fact.

After changes have been reviewed in the console, any approved changes will be considered the baseline state in future reports. Rejected changes will continue to be reported as non-baseline states until they are reverted manually on the affected machines. 

### Resources and Attributes

Any native Puppet resource type can be used in the baseline compliance workflow. As with similar compliance products, you can audit the content and metadata of files, but you can also audit user accounts, services, cron jobs, and anything for which a custom native type can be written. 

**Resources are audited by attribute** --- you can choose one or more attributes you wish to audit, or audit all attributes of that resource. 

### Compliance Manifests

The set of resources to audit is declared in standard Puppet manifests on the master and retrieved as a catalog by the agent. Instead of (or in addition to) declaring the desired state of a resource, these manifests should declare the [`audit`](/puppet/2.7/reference/metaparameter.html#audit) metaparameter. 

### Inspect Reports

Each node being audited will routinely report the states of its audited resources. The documents it sends are called _inspect reports_ and differ from standard Puppet reports.

By default, every PE agent node sends daily inspect reports, regardless of whether it is auditing any resources.

### Baselines

Conceptually, a **baseline** is a blessed inspect report for a single node: it lists the approved states for every audited resource on that node. Each node is associated with one and only one baseline and nodes cannot share baselines. However, nodes with similar baselines can be grouped for convenience.

Baselines are maintained by the console. They change over time as administrators approve changes to audited resources. **Nodes reporting for the first time are assumed to be in a compliant state** and their first inspect report will become the baseline against which future changes are compared. 

### Groups

Although nodes cannot share baselines, nodes in groups can have similar changes approved or rejected in bulk. 


The Console's Compliance UI
-----

Puppet's compliance UI appears in the console. The compliance module adds the following new elements:

- A summary and custom report control on each group's page
- A set of dedicated compliance pages, accessible from the "Compliance" link in the console's main header menu

![compliance_link][]

Each of these pages shows compliance information for a single day and contains a date changer drop-down for changing the view. The most recently selected date will persist while you navigate these pages.

![date_changer_with_unreviewed][]

### New Controls on Group Pages

![core_group_page][]

Each group page will now have:

- A compliance summary in its node information section
- A control for generating [custom reports](./compliance_using.html#comparing-groups-against-a-single-baseline)

![core_group_custom_report][]

### Compliance Overview

![main_overview][]

The main compliance overview page shows a single day's comparison results, with aggregate summaries for grouped nodes and individual summaries for groupless nodes. 

### Compliance Node Page

![individual_node][]

Individual node pages show one node's off-baseline inspection results for a single day. You can accept or reject changes from this page. 

Links to the node pages of ungrouped nodes are displayed on the main compliance overview page. To see the details of a node which is in at least one group, navigate to its group page and use the "Individual Differences" tab.

### Compliance Group Page

![group_common][]

![group_individual][]

Compliance group pages show the collected differences for a group of nodes. Two tabs are available:

- Use the **"Common Differences"** tab to approve and reject aggregate changes in bulk
- Use the **"Individual Differences"** tab to access node pages and act individually

Groups are one of the console's core constructs, and nodes can be added to or removed from groups in the console's main node pages.

Although the console allows groups to contain other groups, a compliance group page will only list nodes that are direct children of that group. 

[compliance_link]: ./images/baseline/compliance_link.png
[date_changer_with_unreviewed]: ./images/baseline/date_changer_with_unreviewed.png
[main_overview]: ./images/baseline/main_overview.png
[individual_node]: ./images/baseline/individual_node.png
[group_common]: ./images/baseline/group_common.png
[group_individual]: ./images/baseline/group_individual.png
[core_group_page]: ./images/baseline/core_group_page.png
[core_group_custom_report]: ./images/baseline/core_group_custom_report.png



* * * 

- [Next: Using the Compliance Workflow](./compliance_using.html) 
