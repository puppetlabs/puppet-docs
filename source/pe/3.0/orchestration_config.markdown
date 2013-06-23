---
layout: default
title: "PE 3.0 » Orchestration » Configuration"
subtitle: "Configuring Orchestration "
---

available console vars:

$::activemq_heap_mb
default = 512

does this belong in the performance/resource usage page of config section?

$::mcollective_registerinterval
default  = 600

$::activemq_brokers
investigate the format and invocation; should be comma-sep'd list, but it looks like a different class invocation may be necessary to scale this?

$::mcollective_enable_stomp_ssl
default - true

$::fact_stomp_server
comma-sep list ok. you can configure this?? it's set by the installer...

$::fact_stomp_port

$::stomp_password

need to also describe:

- actionpolicy files (/etc/puppetlabs/mcollective/policies/<agent>.policy) http://projects.puppetlabs.com/projects/mcollective-plugins/wiki/AuthorizationActionPolicy

- link to installing new actions

- plugin.d stuff  http://docs.puppetlabs.com/mcollective/configure/server.html#plugin-config-directory-optional

- scaling activemq servers? classes to apply, vars to set, etc.


In order to support PE agent nodes that are not necessarily
MCollective nodes (network devices for example), we've added two new console
groups that are managed by the `/etc/cron.d/default-add-all-nodes` rake tasks.

The change in behavior is as follows:

 1. The cron job no longer adds the `pe_mcollective` class to the default group.
 2. The cron job creates the `mcollective` and `no mcollective` groups if they
    don't exist.
 3. The cron job adds the `pe_mcollective` class to the `mcollective` group.
 4. All nodes are added to the `mcollective` group unless they're in the
    `no mcollective` group.

In order to prevent a PE node from receiving the mcollective configuration the
user should add the node to the `no mcollective` group. The node will then stop
receiving the `pe_mcollective` classification. This applies to device nodes and
"normal" nodes.

*Stuff from old configuring pages:*

Tuning the ActiveMQ Heap Size
-----

The puppet master node runs an ActiveMQ server to support orchestration commands. By default, the ActiveMQ process uses a Java heap size of 512 MB, which has been tested to support thousands of nodes.

You can increase or reduce the amount of memory used by ActiveMQ by navigating to the puppet master node's page in the console and creating a new parameter called `activemq_heap_mb`. The value you assign to it will be the amount of memory, in megabytes, used by ActiveMQ; delete the parameter to revert to the default setting.

This is most commonly used to create stable proof-of-concept deployments on virtual machines with limited amounts of RAM. Many of the puppet master's features can fail if ActiveMQ consumes all of the available memory on the system, and reducing its heap size by half or more can prevent these problems on a starved VM.

Setting ActiveMQ Thread Pooling
-----

By default, ActiveMQ is set up to use a dedicated thread for every destination. In environments with large numbers of destinations, this can cause memory resource issues. If the ActiveMQ log is full of "java.lang.OutOfMemoryError: unable to create new native thread" errors, you can configure ActiveMQ to use a thread pool by setting the system property: `-Dorg.apache.activemq.UseDedicatedTaskRunner=false`. This is specified in the ActiveMQ start script via ACTIVEMQ_OPTS. Using a thread pool will reduce the number of threads required by ActiveMQ and so should reduce its memory consumption.




* * *

- [Next: ](./foo.html)
