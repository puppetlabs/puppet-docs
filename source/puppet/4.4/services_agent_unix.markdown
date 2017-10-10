---
layout: default
title: "Puppet's Services: Puppet Agent on *nix Systems"
canonical: "/puppet/latest/services_master_unix.html"
---

[catalogs]: ./subsystem_catalog_compilation.html
[win_agent]: ./services_agent_windows.html
[resource type reference]: ./type.html
[mcollective]: /mcollective
[puppet.conf]: ./config_file_main.html
[runinterval]: ./configuration.html#runinterval
[onetime]: ./configuration.html#onetime
[daemonize]: ./configuration.html#daemonize
[splay]: ./configuration.html#splay
[splaylimit]: ./configuration.html#splaylimit
[listen]: ./configuration.html#listen
[puppetport]: ./configuration.html#puppetport
[pidfile]: ./configuration.html#pidfile
[auth.conf]: ./config_file_auth.html
[short_settings]: ./config_important_settings.html#settings-for-agents-all-nodes
[page on triggering puppet runs]: {{pe}}/orchestration_puppet.html
[report]: /guides/reporting.html

Puppet agent is the application that manages configurations on nodes. It requires a Puppet master server to fetch configuration [catalogs][] from. (For more info, see [Overview of Puppet's Architecture](./architecture.html).)

For details about invoking the Puppet agent command, see [the puppet agent man page](./man/agent.html).

## Supported Platforms

This page describes how Puppet agent behaves on \*nix systems. For information about Windows, see [Puppet Agent on Windows Systems][win_agent].

Not all operating systems can manage the same resources with Puppet; some resource types are OS-specific, and others may have OS-specific features. See the [resource type reference][] for details.

## Puppet Agent's Run Environment

Puppet agent runs as a specific user (usually `root`) and initiates outbound connections on port 8140.

### User

By default, Puppet agent runs as `root`, which lets it manage the configuration of the entire system.

Puppet agent can also run as a non-root user, as long as it is started by that user. This will restrict the resources that Puppet agent can manage (see below), and requires you to run Puppet agent via a cron job instead of a service.

#### Resource Types For Non-Root Puppet Agents

When running without root permissions, most of Puppet's resource providers cannot use `sudo` to elevate permissions. This means Puppet can only manage resources that its user can modify without using `sudo`.

Out of the core resource types listed in the [resource type reference][], the following are available to non-root agents:

* `cron` (only non-root cron jobs can be viewed or set)
* `exec` (cannot run as another user or group)
* `file` (only if the non-root user has read/write privileges)
* `notify`
* `schedule`
* `ssh_key`
* `ssh_authorized_key`
* `service` (for services that don't require root; you can also use the `start`, `stop`, and `status` attributes to specify how non-root users should control the service)
* `augeas`

If you need to install packages into a directory controlled by a non-root user, you can either use an `exec` to unzip a tarball or use a recursive `file` resource to copy a directory into place.

### Ports

By default, Puppet's HTTPS traffic uses port 8140. Your OS and firewall must allow Puppet agent to initiate outbound connections on this port.

If you want to use a non-default port, you'll have to change [the `masterport` setting](./configuration.html#masterport) on all agent nodes, and ensure that you've changed your Puppet master's port as well.

### Logging

When running as a service, Puppet agent logs messages to syslog. Your syslog configuration dictates where these messages will be saved, but the default location is `/var/log/messages` on Linux, `/var/log/system.log` on Mac OS X, and `/var/adm/messages` on Solaris.

You can adjust how verbose the logs are with [the `log_level` setting](./configuration.html#loglevel), which defaults to `notice`. Setting it to `info` is equivalent to running with the `--verbose` option, and setting it to `debug` is equivalent to `--debug`. You can also make logs quieter by dialing back to `warning` or lower.

When running in the foreground with the `--verbose`, `--debug`, or `--test` options, Puppet agent logs directly to the terminal instead of to syslog.

When started with the `--logdest <FILE>` option, Puppet agent logs to the file specified by `<FILE>`.

### Reporting

In addition to local logging, Puppet agent will submit a [report][] to the Puppet master after each run. (This can be disabled by setting [`report = false`](./configuration.html#report) in [puppet.conf][].)

In Puppet Enterprise, you can browse these reports in the PE console's node pages, and you can analyze correlated events with the PE event inspector.

## Managing Systems With Puppet Agent

In a normal Puppet site, every node should periodically do configuration runs, to revert unwanted changes and to pick up recent updates.

On \*nix nodes, there are three main ways to do this:

* **Run Puppet agent as a service.** The easiest method. The Puppet agent daemon will do configuration runs at a set interval, which can be configured.
* **Make a cron job that runs Puppet agent.** Requires more manual configuration, but a good choice if you want to reduce the number of persistent processes on your systems. (This was more important in the past, but some versions of Ruby may still have performance and memory use issues with long-lived daemons.)
* **Only run Puppet agent on demand.** To trigger runs on groups of systems, you can use Puppet Enterprise's built-in orchestration features. (Open source users can also deploy [MCollective][].)

Choose whichever one works best for your infrastructure and culture.

### Running Puppet Agent as a Service

The Puppet agent command can start a long-lived daemon process, which will do configuration runs at a set interval.

**Note:** If you are running Puppet agent as a non-root user, you should use a cron job instead.

#### Starting the Service

The best way to do this is with Puppet agent's init script / service configuration. If you installed Puppet with packages, they should have included an init script or service configuration for controlling Puppet agent, usually with the service name `puppet` (for both open source and Puppet Enterprise).

In Puppet Enterprise, the agent service is automatically configured and started; you don't need to manually start it.

In open source Puppet, you can enable the service with:

~~~ bash
sudo puppet resource service puppet ensure=running enable=true
~~~

Alternately, you can run `sudo puppet agent` on the command line with no additional options; this will cause Puppet agent to start running and daemonize, but you won't have an easy interface for restarting or stopping it. To stop the daemon, use the process ID from the agent's [`pidfile`][pidfile]:

~~~ bash
sudo kill $(puppet config print pidfile --section agent)
~~~

#### Configuring the Run Interval

The Puppet agent service defaults to doing a configuration run every 30 minutes. You can configure this with [the `runinterval` setting][runinterval] in [puppet.conf][]:

~~~
# /etc/puppetlabs/puppet/puppet.conf
[agent]
  runinterval = 2h
~~~

If you don't need an aggressive schedule of configuration runs, a longer run interval will let your Puppet master server(s) handle many more agent nodes.

### Running Puppet Agent as a Cron Job

If [the `onetime` setting][onetime] is set to `true`, the Puppet agent command will do one configuration run and then quit. If [the `daemonize` setting][daemonize] is set to `false`, the command will stay in the foreground until the run is finished; if set to `true`, it will do the run in the background.

This behavior is good for building a cron job that does configuration runs. You may also want to use the [`splay`][splay] and [`splaylimit`][splaylimit] settings to keep the Puppet master from getting overwhelmed, since the system time is probably synchronized on all of your agent nodes.

You can use the Puppet resource command to set up this cron job. Below is an example that runs Puppet once an hour; adjust the path to the Puppet command if you are not using Puppet Enterprise.

~~~ bash
sudo puppet resource cron puppet-agent ensure=present user=root minute=30 command='/opt/puppetlabs/bin/puppet agent --onetime --no-daemonize --splay --splaylimit 60'
~~~

### Running Puppet Agent On Demand

Some sites prefer to only run Puppet agent on demand; others use scheduled runs, but occasionally need to do an on-demand run.

Puppet agent runs can be started locally (while logged in to the target system), or remotely via an orchestration tool.

#### While Logged in to the Target System

If you are currently logged into the machine that needs to run Puppet agent, you can do one of the following:

**Run in the foreground, with verbose logging to the terminal:**

~~~ bash
sudo puppet agent --test
~~~

**Run once in the background:**

~~~ bash
sudo puppet agent --onetime
~~~

Note that this won't notify you when the run is completed.

#### Remotely

To run Puppet agent remotely on one machine, you can simply use ssh:

~~~ bash
ssh ops@magpie.example.com sudo puppet agent --test
~~~

To run remotely on _many_ machines, you will need some form of orchestration or parallel execution tool.

**Puppet Enterprise has built-in tools for this.** For info, see the Puppet Enterprise manual [page on triggering Puppet runs][].

For open source Puppet users, the most flexible tool is [MCollective][], which is somewhat heavyweight to deploy but has many other uses. You'll need to [deploy MCollective](/mcollective/deploy/standard.html) and [the puppet agent plugin](https://github.com/puppetlabs/mcollective-puppet-agent); once everything is ready, see the instructions in [the puppet agent plugin's README](https://github.com/puppetlabs/mcollective-puppet-agent#readme) for usage details.

Alternately, [parallel SSH][pssh] can be a more lightweight solution for doing Puppet runs. Be sure to limit the number of nodes that run at once, so you don't overwhelm your Puppet master(s).

[pssh]: https://code.google.com/p/parallel-ssh/

## Disabling and Re-enabling Puppet Runs

Regardless of how you're running Puppet agent, you can prevent it from doing any Puppet runs by running `sudo puppet agent --disable "<MESSAGE>"`. You can re-enable it with `sudo puppet agent --enable`.

If Puppet agent attempts to do a configuration run while disabled --- either a scheduled run or a manually triggered one --- it will log a message like `Notice: Skipping run of Puppet configuration client; administratively disabled (Reason: 'Investigating a problem 5/23/14 -NF'); Use 'puppet agent --enable' to re-enable.`

## Configuring Puppet Agent

Puppet agent should be configured with [puppet.conf][], using the `[agent]` and/or `[main]` section. For notes on which settings are most relevant to Puppet agent, see the [short list of important settings][short_settings].