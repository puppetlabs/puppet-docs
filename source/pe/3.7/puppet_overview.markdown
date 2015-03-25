---
layout: default
title: "PE 3.7 » Puppet » Overview"
subtitle: "An Overview of Puppet"
canonical: "/pe/latest/puppet_overview.html"
---

> **Note:** This page gives a broad overview of how Puppet configures systems, and provides links to deeper information. If you prefer to learn by doing, you can follow the Puppet Enterprise quick start guide:
>
> * [Quick Start: Using PE](./quick_start.html)
> * [Quick Start: Writing Modules](./quick_writing_nix.html)


Summary of Puppet
-----

Puppet Enterprise (PE) uses **Puppet** as the core of its configuration management features. Puppet models desired system states, enforces those states, and reports any variances so you can track what Puppet is doing.

To model system states, Puppet uses a declarative resource-based language --- this means a user describes a _desired final state_ (e.g. "this package must be installed" or "this service must be running") rather than describing a series of steps to execute.

Puppet breaks configuration management out into four major areas of activity:

1. The user [describes re-usable pieces of configuration][step1] by creating or downloading Puppet modules.
2. The user [assigns (and configures) classes][step2] to each machine in the PE deployment.
3. Each node [fetches and applies its complete configuration][step3] from the Puppet master server, either on a recurring schedule or on demand. This configuration includes all of the classes that have been assigned to that node. Applying a configuration enforces the desired state that was defined by the user, and submits a report about any changes that had to be made.
4. The user may view aggregate and individual reports to monitor what resources have been changed by Puppet.

Continue reading this page for an overview of the first three activities and links to deeper info. See [the Viewing Reports and Inventory Data page](./console_reports.html) to learn how to monitor Puppet's activity from the PE console.

[step1]: #modules-and-manifests
[step2]: #assigning-and-configuring-classes
[step3]: #managing-and-triggering-configuration-runs

Modules and Manifests
-----

Puppet uses its own domain-specific language (DSL) to describe re-usable pieces of configuration. Puppet code is saved in files called _manifests,_ which are in turn stored in structured directories called _modules._ Pre-built Puppet modules can be downloaded from [the Puppet Forge](http://forge.puppetlabs.com), and most users will write at least some of their own modules.

* [**See the Modules and Manifests page of this manual**](./puppet_modules_manifests.html) for information on how Puppet code is written and arranged.


Assigning and Configuring Classes
-----

**Classes** are re-usable pieces of configuration stored in modules. Some classes can be configured to behave differently to suit different needs. (This is most common with general-purpose classes written to solve many problems at once.)

To compose a complete configuration for a node, you will generally assign a combination of several classes to it. (For example, a node that serves as a load balancer might have an HAProxy class, but it would also have classes to keep time synchronized, manage important file permissions, and manage login security.)

PE includes several ways to _assign and configure_ classes; some require you to specifically identify each node, others can operate automatically on metadata, and most users will use a combination of a few methods.

* [**See the Assigning Configurations to Nodes page of this manual**](./puppet_assign_configurations.html) for information on how to compose classes into complete configurations.

Managing and Triggering Configuration Runs
-----

Puppet Enterprise has a default schedule and behavior for each node's configuration runs, but you can reconfigure this arrangement.

### Default Run Behavior

In a default PE deployment:

* Each agent node runs the Puppet agent service (`pe-puppet`) as a daemon. This service idles in the background and does a configuration run at regular intervals.
* The default run interval is every 30 minutes, as configured by the `runinterval` setting in the node's puppet.conf file.
* Additional on-demand runs can be triggered when necessary; see [the Controlling Puppet page in the orchestration section][orch] for details.

[orch]: ./orchestration_puppet.html
[stop]: ./orchestration_puppet.html#start-and-stop-the-puppet-agent-service

### Alternate Run Behaviors

#### Prioritizing Processes

You can change the priority of Puppet processes (`puppet agent`, `puppet apply`) using the [priority setting](/references/3.latest/configuration.html#priority). This can be helpful if you want to manage resource-intensive loads on busy nodes. Note that the process must be running as privileged user if it is going to *raise* its priority.

#### Different Run Interval

You can change the run interval by setting a new value for [the `runinterval` setting][runinterval] in each agent node's puppet.conf file.

[runinterval]: /references/3.7.latest/configuration.html#runinterval

* This file is located at `/etc/puppetlabs/puppet/puppet.conf` on \*nix nodes, and [`<DATADIR>`](/guides/install_puppet/install_windows.html#data-directory)`\puppet.conf` on Windows.
* Make sure you put this setting in [the `[agent]` or `[main]` block of puppet.conf](/guides/configuring.html#config-blocks).
* Since you will be managing this file on many systems at once, you may wish to manage puppet.conf with a Puppet template.

#### Run From Cron

On \*nix nodes, the `pe-puppet` daemon process can sometimes use more memory than is desired. This was a common problem in PE 2.x which is largely solved in PE 3, but some users may still wish to disable it.

You can [turn off the daemon][stop] and still get scheduled runs by creating a cron task for Puppet agent on your \*nix nodes. An example snippet of Puppet code, which would create this task on non-Windows nodes:

{% highlight ruby %}
    # Place in /etc/puppetlabs/puppet/manifests/site.pp on the Puppet master node, outside any node statement.
    # Run Puppet agent hourly (with splay) on non-Windows nodes:
    if $osfamily != windows {
      cron { 'puppet_agent':
        ensure  => 'present',
        command => '/opt/puppet/bin/puppet agent --onetime --no-daemonize --splay --splaylimit 1h --logdest syslog',
        user    => 'root',
        minute  => 0,
      }
    }
{% endhighlight %}

Remember, after creating this task you should [turn off the `pe-puppet` service][stop] on \*nix nodes.

> **Windows note:** This is unnecessary on Windows, since it doesn't use the same version of the `pe-puppet` service; the Windows service was implemented long after the \*nix service, and was designed from the start to limit memory usage. Additionally, it's more difficult on Windows to make a scheduled task run multiple times a day.

#### On-Demand Only

You can stop all scheduled runs by [stopping the `pe-puppet` service][stop] on all nodes. This will cause nodes to only fetch configurations when you [explicitly trigger runs with the orchestration engine.][orch]

If you are only doing on-demand runs, you're likely to be running large numbers of nodes at once. For best performance, you should take advantage of the orchestration engine's ability to [run many nodes in a controlled series](./orchestration_puppet.html#run-puppet-on-many-nodes-in-a-controlled-series).



* * *

- [Next: Puppet Modules and Manifests](./puppet_modules_manifests.html)
