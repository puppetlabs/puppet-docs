---
layout: default
title: "PE Manual: Using the Puppet Compliance Workflow"
---

{% include pe_nav.markdown %}

Using the Puppet Compliance Workflow
=====

The Compliance Workflow Cycle
----

The puppet compliance workflow is designed to audit changes to systems managed by ad-hoc manual administration. It can also be used to audit changes to resources already managed by Puppet. 

![Baseline compliance workflow diagram](./images/baseline/baseline_workflow.png)

- **A sysadmin** writes manifests defining which resources to audit on which nodes. 
- **Puppet agent** retrieves and caches a catalog compiled from those manifests. 
- **Puppet inspect** reads that catalog to discover which resources to audit, then submits an inspect report to the **puppet master...**
- ...which forwards it to **Puppet Dashboard.** 
- **Dashboard** then calculates a daily report of differences between the inspected system state and the approved baseline state, creating a baseline if one didn't already exist. 
- **A sysadmin** uses the Dashboard interface to approve or reject every difference, then manually reverts any unapproved changes as necessary. 
- **Dashboard** then modifies the baseline to include any approved changes, and awaits the next day's inspect reports.

This summary elides some details regarding daily comparisons and baseline revision; see [the "Internals" chapter](./pb_internals.html) for more details. <!-- TK is this going to point to the same page? -->

Concepts
----

### Auditing

When using this workflow, Puppet audits the state of resources, rather than enforcing a desired state; it does not make changes to any audited resources. Instead, changes are to be made manually (or by some out-of-band process) and reviewed for approval after the fact.

After changes have been reviewed in Puppet Dashboard, any approved changes will be considered the baseline state in future reports. Rejected changes will continue to be reported as non-baseline states until they are reverted manually on the affected machines. 

### Resources and Attributes

Any native Puppet resource type can be used in the baseline compliance workflow. As with similar compliance products, you can audit the content and metadata of files, but you can also audit user accounts, services, cron jobs, and anything for which a custom native type can be written. 

**Resources are audited by attribute** --- you can choose one or more attributes you wish to audit, or audit all attributes of that resource. 

### Manifests

The set of resources to audit is declared in standard Puppet manifests on the master and retrieved as a catalog by the agent. Instead of (or in addition to) declaring the desired state of a resource, these manifests should declare the [`audit`](http://docs.puppetlabs.com/references/latest/metaparameter.html#audit) metaparameter. 

### Inspect Reports

Each node being audited for compliance will routinely report the states of its audited resources. The documents it sends are called _inspect reports,_ and differ from standard Puppet reports.

### Baselines

Conceptually, a _baseline_ is a blessed inspect report for a single node: it lists the approved states for every audited resource on that node. Each node is associated with one and only one baseline, and nodes cannot share baselines. However, nodes with similar baselines can be grouped for convenience.

Baselines are maintained by Puppet Dashboard. They change over time as administrators approve changes to audited resources. **Nodes reporting for the first time are assumed to be in a compliant state,** and their first inspect report will become the baseline against which future changes are compared. 

### Groups

Although nodes cannot share baselines, nodes in a Dashboard group can have similar changes approved or rejected en masse. 


Preparing Agent Nodes For Compliance Reporting
-----

Since agent nodes under compliance auditing need to submit a slightly different type of report, **you will need to apply the `baselines::agent` class to any node whose resources you want to audit.** 

Writing Compliance Manifests
-----

Once compliance reporting has been enabled on your agent nodes, a sysadmin familiar with the Puppet language should write a collection of manifests defining the resources to be audited on the site's various computers. 

In the simplest case, where you want to audit an identical set of resources on every computer, this can be done directly in the site manifest (`/etc/puppetlabs/puppet/manifests/site.pp`). More likely, you'll need to create a set of classes and modules that can be composed to describe the different kinds of computers at your site, then assign those classes using Puppet Dashboard or some other method.

**To mark a resource for auditing, declare its `audit` metaparameter.** The value of `audit` can be one attribute, an array of attributes, or `all`. You can also have Puppet manage some attributes of an audited resource. 

{% highlight ruby %}
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
    user {'admin':
      ensure => present,
      gid    => 'wheel',
      groups => ['admin'],
      shell  => '/bin/zsh',
      audit  => 'password',
    }
{% endhighlight %}


