---
layout: default
title: "PE 2.5 » Compliance » Using the Workflow"
subtitle: "Using the Compliance Workflow"
canonical: "/pe/latest/compliance_alt.html"
---

Prerequisites
-----

Before using the compliance workflow, check to make sure that the `pe_compliance` Puppet class has been assigned to all of your agent nodes. 

This probably does not require any action on your part; by default, `pe_compliance` is assigned to the [default group](./console_classes_groups.html#the-default-group), which all agent nodes are assigned to a few minutes after their first report. 

Compliance Tasks
-----

PE's compliance workflow consists of the following routine tasks:

- Writing compliance manifests
- Reviewing changes
- Comparing whole groups against a single baseline

See below for detailed explanations of these tasks.

Writing Compliance Manifests
-----

To tell Puppet which resources to audit, you must write a collection of modules in the Puppet language and assign them to your nodes. See this manual's [introduction to Puppet](./puppet_overview.html) for a quick tutorial on creating a module and applying its classes. 

When writing compliance classes in Puppet, you should **declare [the `audit` metaparameter](/puppet/2.7/reference/metaparameter.html#audit)** for each resource. The value of `audit` can be one attribute name, an array of attribute names, or `all`. Puppet can also actively manage attributes of an audited resource. 

~~~ ruby
    file {'hosts':
      path  => '/etc/hosts',
      audit => 'content',
    }
    file {'/etc/sudoers':
      audit => [ensure, content, owner, group, mode, type],
    }
    user {'httpd':
      audit => 'all',
    }
    # Allow this user to change their password, but trigger an audit event when they do:
    user {'admin':
      ensure => present,
      gid    => 'wheel',
      groups => ['admin'],
      shell  => '/bin/zsh',
      audit  => 'password',
    }
~~~


Reviewing Changes
-----

To audit changes, first scan the day's node and group summaries to see which nodes have unreviewed changes. 

![summary_with_differences][]

Once you've seen the overview, you can navigate to any pages with unreviewed changes. If there are any unreviewed changes on previous days, there will be a warning next to the date changer drop-down, and the drop-down will note which days aren't fully reviewed. 

![date_changer_with_unreviewed][]

Changes can be **accepted** or **rejected.** Accepted changes will become part of the baseline for the next day's comparisons. Rejecting a change does nothing, and if an admin doesn't manually revert the change, it will appear as a difference again on the next day's comparisons. 

When accepting multiple days' changes to the same resource, the most recently accepted change will win. 

### Reviewing Individual Nodes

Changes to individual nodes are straightforward to review: navigate to the node's page, view each change, and use the green plus and red minus buttons when you've decided whether the change was legitimate. 

![accept_and_reject_buttons][]

Each change is displayed in a table of attributes, with the previously approved ("baseline") state on the left and the inspected state on the right. You will also see links for viewing the original and modified contents of any changed files, as well as a "differences" link for showing the exact changes. 

You can also accept or reject all of the day's changes to this node at once with the controls below the node's summary. **Note that rejecting all changes is "safe," since it makes no edits to the node's baseline;** if you reject all changes without manually reverting them, you're effectively deferring a decision on them to the next day. 

### Reviewing Groups

If you've collected similar nodes into groups in the console, you can greatly speed up the review of similar changes with the "Common Differences" tab. You can also use the "Individual Differences" tab to navigate to the individual nodes.

#### Same Change on Multiple Nodes

![group_same_change][]

If the same change was made on several nodes in a group, you can:

- Accept or reject the change for **all** affected nodes
- View the individual node pages to approve or reject the change selectively

#### Different Changes to the Same Resource

![group_different_changes][]

If **different** changes were made to the **same resource** on several nodes, the changes will be grouped for easy comparison. You can:

- Accept or reject **each cluster** of changes
- View the individual node pages to approve or reject the changes selectively

#### Convergence of differing baselines

![group_converging][]

If several nodes in a group had a different baseline value for one resource but were recently brought into an identical state, you can click through to examine the previous baselines, and can:

- Approve or reject the single new state for **all** affected nodes
- View the individual node pages to approve or reject the changes selectively

Comparing Groups Against a Single Baseline
-----

The console can also generate custom reports which **compare an entire group to a single member node's baseline.** While the day-to-day compliance views are meant for tracking changes to a node or group of nodes over time, custom reports are meant for tracking how far a group of nodes have drifted away from each other. 

- Custom reports only examine the most recent inspection report for each group member
- Custom reports **do not** allow you to approve or reject changes

The console will maintain **one** cached custom report for **each group;** generating a new report for that group will erase the old one.

![core_group_custom_report][]

Custom reports are generated from the console's **group pages** --- **not** from the group views in the compliance pages. To generate a report, choose which baseline to compare against and press the generate button; the report will be queued and a progress indicator will display. (The indicator is static markup that does not automatically poll for updates; you will need to reload the page periodically to update status on the report.) 

Once generated, custom reports can be viewed from **the console's page for that group,** the **main compliance overview page,** and the **compliance group pages.** 

![custom_report_core_group_link][]

![custom_report_compliance_group_link][]

![custom_report_compliance_main_link][]

A custom report is split into a "Common Differences" tab and an "Individual Differences" tab. This is very similar to the layout of the group compliance review pages and can be read in the same fashion. The only difference is that all comparisons are to a single baseline instead of per-node baselines. 

![custom_report_common][]

[accept_and_reject_buttons]: ./images/baseline/accept_and_reject_buttons.png
[core_group_custom_report]: ./images/baseline/core_group_custom_report.png
[custom_report_core_group_link]: ./images/baseline/custom_report_core_group_link.png
[custom_report_compliance_group_link]: ./images/baseline/custom_report_compliance_group_link.png
[custom_report_compliance_main_link]: ./images/baseline/custom_report_compliance_main_link.png
[custom_report_common]: ./images/baseline/custom_report_common.png
[date_changer_with_unreviewed]: ./images/baseline/date_changer_with_unreviewed.png
[group_converging]: ./images/baseline/group_converging.png
[group_different_changes]: ./images/baseline/group_different_changes.png
[group_same_change]: ./images/baseline/group_same_change.png
[summary_with_differences]: ./images/baseline/summary_with_differences.png



* * * 

- [Next: Compliance Tutorial](./compliance_tutorial.html)
