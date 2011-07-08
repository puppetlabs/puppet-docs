Puppet Baseline Compliance Workflow
====

This document describes an alternate workflow for change management using the Puppet Dashboard baseline compliance plugin.

Assumptions and Requirements
----

This workflow is designed to audit changes to systems that are managed by ad-hoc manual administration. This differs from and is incompatible with Puppet's standard managed resources workflow --- although you can use both models of management at the same site (or even in the same catalog), they should be used on disjunct sets of resources.

Working with compliance features requires a puppet master server, as well as a Puppet Dashboard server with the baseline compliance plugin installed and filebucket access configured. The Dashboard server must have one or more `delayed_job` worker tasks running, and additionally must be running the `puppet:plugin:baseline:daily` task from cron on at least a daily basis.

This workflow also requires that all agent nodes be configured to:

* Retrieve configurations from the puppet master (with puppet agent, as a daemon or from cron)
* Send inspect reports on at least a daily basis (with puppet inspect, from cron)
* Submit file contents along with inspect reports (`archive_files = true` in puppet.conf)

Concepts
----

### Resources and Attributes

Any native Puppet resource type can be used in the baseline compliance workflow. As with similar compliance products, you can audit the content and metadata of files, but you can also audit user accounts, services, cron jobs, and anything for which a custom native type can be written. 

Resources are audited by attribute --- you can choose one or more attributes you wish to audit, or audit all attributes of that resource. 

### Manifests

The set of resources to audit is declared in standard Puppet manifests on the master and retrieved as a catalog by the agent. Instead of declaring the desired state of a resource, declare only its title (and name/namevar, if necessary) and the `audit` metaparameter.

### Reports

Each node being audited for compliance will routinely report the states of its audited resources. The documents it sends are called _inspect reports_ (to differentiate them from standard Puppet reports). 

### Baselines

Conceptually, a _baseline_ is a blessed inspect report for a single node: it lists the approved states for every audited resource on that node. Each node is associated with one and only one baseline, and nodes cannot share baselines. However, nodes with similar baselines can be grouped for convenience.

Baselines are maintained by the Puppet Dashboard baseline compliance plugin. They change over time as administrators approve changes to audited resources. 

### Groups

Although nodes cannot share baselines, nodes with similar baselines can be grouped for convenience. This can speed up the approval or rejection of similar changes. 

The Compliance Workflow Cycle In Outline
----

1. Sysadmin: Write manifests defining which resources to audit on which nodes. 
2. Agent nodes: Retrieve catalog with puppet agent and update list of resources to audit if necessary.
3. Agent nodes: Audit resources from catalog and submit inspect report with puppet inspect. 
4. Dashboard: Calculate daily report of differences between inspected system state and approved baseline state. 
5. Sysadmin: Use Dashboard interface to approve or reject every difference. Manually revert unapproved changes on affected systems.
6. Dashboard: Modify baseline to include approved changes.

Repeat steps 3-7 daily and steps 1-2 as needed.

Workflow Details
----

### Writing Compliance Manifests

Once all prerequisites are in place, a sysadmin (or group of sysadmins) familiar with the Puppet language should write a collection of manifests defining the resources to be audited on the site's various computers. 

In the simplest case, where you want to audit an identical set of resources on every computer, this can be done strictly in the site manifest by declaring all resources in node `default`. More likely, you'll need to create a more conventional set of classes and modules that can be composed to describe the different kinds of computers at your site. 

To mark a resource for auditing, declare its `audit` metaparameter and avoid declaring `ensure` or any other attributes that describe a desired state. The value of `audit` can be one attribute, a list of attributes, or `all`.

{% highlight ruby %}
    file {'hosts':
      path  => '/etc/hosts',
      audit => 'ensure, content, owner, group, type',
    }
    file {'/etc/sudoers':
      audit => 'ensure, content, owner, group, mode, type',
    }
    user {'httpd':
      audit => 'all',
    }
{% endhighlight %}

As with any Puppet site design, you'll need to classify your nodes with a site manifest or an external node classifier to ensure they get the correct catalog. The implementation of a Puppet site design is beyond the scope of this document. 

### Agent Node Configuration

Agent nodes send compliance reports in a two-step process: they use puppet agent to retrieve a catalog, then they use puppet inspect to build and submit a report on the resources it finds in the cached catalog. Puppet inspect has no effect unless it can read a cached catalog retrieved by puppet agent.

This means you'll need to configure your nodes to run puppet inspect at least daily (via cron), and puppet agent at an interval of your choosing (via cron or in its default daemon mode). Running these tasks more often than necessary should have no undesired effects.

Note that the cron job that runs puppet inspect can be managed in the same catalog that contains the resources for auditing. 

