---
layout: default
title: "Puppet's services: Puppet agent on *nix systems"
---

[resource type reference]: ./type.html
[MCollective]: /mcollective
[puppet.conf]: ./config_file_main.html
[runinterval]: ./configuration.html#runinterval
[onetime]: ./configuration.html#onetime
[daemonize]: ./configuration.html#daemonize
[splay]: ./configuration.html#splay
[splaylimit]: ./configuration.html#splaylimit
[pidfile]: ./configuration.html#pidfile
[short_settings]: ./config_important_settings.html#settings-for-agents-all-nodes
[report]: ./reporting_about.html

<!--Overview-->

Puppet agent is the application that manages configurations on your nodes. It requires a Puppet master server to fetch configuration catalogs from.

You can manage systems with Puppet agent as a service, as a cron job, or on demand, depending on your infrastructure and needs.

For details about invoking the Puppet agent command, see [the puppet agent man page](./man/agent.html).

## Puppet agent's run environment

Puppet agent runs as a specific user, (usually `root`) and initiates outbound connections on port 8140.

### Ports

By default, Puppet's HTTPS traffic uses port 8140. Your operating system and firewall must allow Puppet agent to initiate outbound connections on this port.

If you want to use a non-default port, you have to change [the `masterport` setting](./configuration.html#masterport) on all agent nodes, and ensure that you change your Puppet master's port as well.

### User

By default, Puppet agent runs as `root`, which lets it manage the configuration of the entire system.

Puppet agent can also run as a non-root user, as long as it is started by that user. However, this restricts the resources that Puppet agent can manage, and requires you to run Puppet agent as a cron job instead of a service.

If you need to install packages into a directory controlled by a non-root user, either use an `exec` to unzip a tarball or use a recursive `file` resource to copy a directory into place.

When running without root permissions, most of Puppet's resource providers cannot use `sudo` to elevate permissions. This means Puppet can only manage resources that its user can modify without using `sudo`.

Out of the core resource types listed in the [resource type reference][], only a few are available to non-root agents.

#### Non-root agent resource types

Resource type | Exception
--------------|-----------
`augeas`      |
`cron`        | Only non-root cron jobs can be viewed or set.
`exec`        | Cannot run as another user or group.
`file`        | Only if the non-root user has read/write privileges.
`notify`      |
`schedule`    |
`service`     | For services that don't require root. You can also use the `start`, `stop`, and `status` attributes to specify how non-root users should control the service.
`ssh_authorized_key` |
`ssh_key`     |

## Manage systems with Puppet agent

<!--Multi-task with child task topics-->

In a normal Puppet configuration, every node periodically does configuration runs to revert unwanted changes and to pick up recent updates.

On \*nix nodes, there are three main ways to do this:

* **Run Puppet agent as a service.** The easiest method. The Puppet agent daemon does configuration runs at a set interval, which can be configured.
* **Make a cron job that runs Puppet agent.** Requires more manual configuration, but a good choice if you want to reduce the number of persistent processes on your systems.
* **Only run Puppet agent on demand.** You can also deploy [MCollective][] to run on demand on many nodes.

Choose whichever one works best for your infrastructure and culture. 

### Run Puppet agent as a service

The Puppet agent command can start a long-lived daemon process, which does configuration runs at a set interval.

>**Note:** If you are running Puppet agent as a non-root user, use a cron job instead.

1. Start the service

   The best way to do this is with Puppet agent's init script / service configuration. If you installed Puppet with packages, they should have included an init script or service configuration for controlling Puppet agent, usually with the service name `puppet` (for both open source and Puppet Enterprise).

   In Puppet Enterprise, the agent service is automatically configured and started; you don't need to manually start it.

   In open source Puppet, you can enable the service with:

   ``` bash
   sudo puppet resource service puppet ensure=running enable=true
   ```

   Alternately, you can run `sudo puppet agent` on the command line with no additional options; this will cause Puppet agent to start running and daemonize, but you won't have an easy interface for restarting or stopping it. To stop the daemon, use the process ID from the agent's [`pidfile`][pidfile]:

   ``` bash
   sudo kill $(puppet config print pidfile --section agent)
   ```

2. (Optional) Configure the run interval

   The Puppet agent service defaults to doing a configuration run every 30 minutes. You can configure this with [the `runinterval` setting][runinterval] in [puppet.conf][]:

   ```
   # /etc/puppetlabs/puppet/puppet.conf
   [agent]
     runinterval = 2h
   ```

   If you don't need an aggressive schedule of configuration runs, a longer run interval lets your Puppet master servers handle many more agent nodes.

### Run Puppet agent as a cron job

Run Puppet agent as a cron job when running as a non-root user.

If [the `onetime` setting][onetime] is set to `true`, the Puppet agent command does one configuration run and then quits. If [the `daemonize` setting][daemonize] is set to `false`, the command stays in the foreground until the run is finished; if set to `true`, it does the run in the background.

This behavior is good for building a cron job that does configuration runs. You can use the [`splay`][splay] and [`splaylimit`][splaylimit] settings to keep the Puppet master from getting overwhelmed, because the system time is probably synchronized across all of your agent nodes.

1. Use the Puppet resource command to set up a cron job.

   This example runs Puppet once an hour:

   ``` bash
   sudo puppet resource cron puppet-agent ensure=present user=root minute=30 command='/opt/puppetlabs/bin/puppet agent --onetime --no-daemonize --splay --splaylimit 60'
   ```

### Run Puppet agent on demand

Some sites prefer to only run Puppet agent on demand; others use scheduled runs, but occasionally need to do an on-demand run.

Puppet agent runs can be started while logged in to the target system, or remotely with MCollective.

1. Run Puppet agent on one machine, using ssh:

   ``` bash
   ssh ops@magpie.example.com sudo puppet agent --test
   ```

To run remotely on _many_ machines, you need some form of orchestration or parallel execution tool, such as MCollective. MCollective ships as a part of the `puppet-agent` package, but you need to [deploy it](/mcollective/deploy/standard.html) and [the puppet agent plugin](https://github.com/puppetlabs/mcollective-puppet-agent). Once everything is ready, see the instructions in [the puppet agent plugin's README](https://github.com/puppetlabs/mcollective-puppet-agent#readme) for usage details.

## Disable and re-enable Puppet runs

<!-- maybe this should go at the top? seems like a frequently used command. -->

Whether you're troubleshooting errors, working in a maintenance window, or simply developing in a sandbox environment, you may need to temporarily disable the Puppet agent from running.

1. Run one of these commands, depending on whether you want to disable or re-enable the agent:

   * Disable -- `sudo puppet agent --disable "<MESSAGE>"`.
   * Enable -- `sudo puppet agent --enable`.



## Configuring Puppet agent

The Puppet agent comes with a default configuration that may not be the most convenient for you.

Configure Puppet agent with [puppet.conf][], using the `[agent]` and/or `[main]` section. For notes on which settings are most relevant to Puppet agent, see the [short list of important settings][short_settings].

### Logging for Puppet agent on *nix systems

When running as a service, Puppet agent logs messages to syslog. Your syslog configuration dictates where these messages are saved, but the default location is `/var/log/messages` on Linux, `/var/log/system.log` on Mac OS X, and `/var/adm/messages` on Solaris.

You can adjust how verbose the logs are with [the `log_level` setting](./configuration.html#loglevel), which defaults to `notice`.

When running in the foreground with the `--verbose`, `--debug`, or `--test` options, Puppet agent logs directly to the terminal instead of to syslog.

When started with the `--logdest <FILE>` option, Puppet agent logs to the file specified by `<FILE>`.

### Reporting for Puppet agent on *nix systems

In addition to local logging, Puppet agent submits a [report][] to the Puppet master after each run. (This can be disabled by setting [`report = false`](./configuration.html#report) in [puppet.conf][].)