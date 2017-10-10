---
layout: default
title: "Puppet's services: Puppet agent on Windows systems"
canonical: "/puppet/latest/services_master_windows.html"
---

[catalogs]: ./subsystem_catalog_compilation.html
[unix_agent]: ./services_agent_unix.html
[resource type reference]: ./type.html
[mcollective]: /mcollective
[puppet.conf]: ./config_file_main.html
[runinterval]: ./configuration.html#runinterval
[short_settings]: ./config_important_settings.html#settings-for-agents-all-nodes
[page on triggering puppet runs]: {{pe}}/orchestration_puppet.html
[msiproperties]: ./install_windows.html#automated-installation
[uac]: ./images/uac.png
[rightclick]: ./images/run_as_admin.png
[report]: /guides/reporting.html
[running]: ./services_commands_windows.html

Puppet agent is the application that manages configurations on nodes. It requires a Puppet master server to fetch configuration [catalogs][] from. (For more info, see [Overview of Puppet's Architecture](./architecture.html).)

For details about invoking the Puppet agent command, see [the puppet agent man page](./man/agent.html).

## Supported platforms

This page describes how Puppet agent behaves on Windows systems. For information about Linux, OS X, and other Unix-like operating systems, see [Puppet Agent on \*nix Systems][unix_agent].

> **Note:** Running 32-bit Puppet agent on a 64-bit Windows system is now deprecated. Update your Puppet installation to the 64-bit platform.

Not all operating systems can manage the same resources with Puppet; some resource types are OS-specific, and others may have OS-specific features. See the [resource type reference][] for details.

## Puppet agent's run environment

Puppet agent runs as a specific user (defaulting to `LocalSystem`) and initiates outbound connections on port 8140.

### User

By default, Puppet agent runs as the `LocalSystem` user. This lets it manage the configuration of the entire system, but prevents it from accessing files on UNC shares.

Puppet can also run as a different user. You can change the user in the Service Control Manager (SCM). To start the SCM, choose "Run..." from the Start menu and type `Services.msc`.

You can also specify a different user when installing Puppet. To do this, install via the command line and [specify the required MSI properties][msiproperties] (`PUPPET_AGENT_ACCOUNT_USER`, `PUPPET_AGENT_ACCOUNT_PASSWORD`, and `PUPPET_AGENT_ACCOUNT_DOMAIN`).

Puppet agent's user can be a local or domain user. If this user isn't already a local administrator, the Puppet installer will add it to the `Administrators` group. The installer will also grant [Logon as Service](http://msdn.microsoft.com/en-us/library/ms813948.aspx) to the user.

### Ports

By default, Puppet's HTTPS traffic uses port 8140. Your OS and firewall must allow Puppet agent to initiate outbound connections on this port.

If you want to use a non-default port, you'll have to change [the `masterport` setting](./configuration.html#masterport) on all agent nodes, and ensure that you've changed your Puppet master's port as well.

### Logging

When running as a service, Puppet agent logs messages to the Windows Event Log. You can view its logs by browsing the Event Viewer. (Control Panel → System and Security → Administrative Tools → Event Viewer)

You can adjust how verbose the logs are with [the `log_level` setting](./configuration.html#loglevel), which defaults to `notice`. Setting it to `info` is equivalent to running with the `--verbose` option, and setting it to `debug` is equivalent to `--debug`. You can also make logs quieter by dialing back to `warning` or lower.

When running in the foreground with the `--verbose`, `--debug`, or `--test` options, Puppet agent logs directly to the terminal.

When started with the `--logdest <FILE>` option, Puppet agent logs to the file specified by `<FILE>`.

### Reporting

In addition to local logging, Puppet agent will submit a [report][] to the Puppet master after each run. (This can be disabled by setting [`report = false`](./configuration.html#report) in [puppet.conf][].)

In Puppet Enterprise, you can browse these reports in the PE console's node pages, and you can analyze correlated events with the PE event inspector.

## Managing systems with Puppet agent

In a normal Puppet site, every node should periodically do configuration runs, to revert unwanted changes and to pick up recent updates.

On Windows nodes, there are two main ways to do this:

* **Run Puppet agent as a service.** The easiest method. The Puppet agent service will do configuration runs at a set interval, which can be configured.
* **Only run Puppet agent on demand.** To trigger runs on groups of systems, you can use Puppet Enterprise's built-in orchestration features.

Since the Windows version of the Puppet agent service is much simpler than the \*nix version, there's no real performance to be gained by running Puppet as a scheduled task. All users who want scheduled configuration runs should run the Windows service.

### Running Puppet agent as a service

By default, the Puppet installer will configure Puppet agent to run as a Windows service and will automatically start it. No further action is needed. Puppet agent will do configuration runs at a set interval.

#### Configuring the run interval

The Puppet agent service defaults to doing a configuration run every 30 minutes. You can configure this with [the `runinterval` setting][runinterval] in [puppet.conf][]:

    # C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf
    [agent]
      runinterval = 2h

If you don't need an aggressive schedule of configuration runs, a longer run interval will let your Puppet master server(s) handle many more agent nodes.

Once the run interval has been changed, the service will stick to the prior schedule for the next run and then switch to the new run interval for subsequent runs.

#### Configuring the service start up type

The Puppet agent service defaults to starting automatically. If you'd rather start it manually or disable it, you can configure this during installation. To do this, install via the command line and [specify the `PUPPET_AGENT_STARTUP_MODE` MSI property][msiproperties].

You can also configure this after installation with the Service Control Manager (SCM). To start the SCM, choose "Run..." from the Start menu and type `Services.msc`.

You can also configure agent service with the `sc.exe` command. To prevent the service from starting on boot:

    C:\>sc config puppet start= demand
    [SC] ChangeServiceConfig SUCCESS

(Note that the space after `start=` is mandatory! Also note that this must be run in cmd.exe; this command won't work from PowerShell.)

To restart the service:

    C:\>sc stop puppet
    C:\>sc start puppet

To change the arguments used when triggering a Puppet agent run (this example changes the level of detail that gets written to the Event Log):

    C:\>sc start puppet --debug --logdest eventlog


### Running Puppet agent on demand

Some sites prefer to only run Puppet agent on demand; others use scheduled runs, but occasionally need to do an on-demand run.

Puppet agent runs can be started locally (while logged in to the target system), or remotely via Puppet Enterprise's orchestration tools.

#### While logged in to the target system

On Windows, you can start a configuration run with the "Run Puppet Agent" Start menu item. This will show the status of the run in a command prompt window.

You **must be logged in as an administrator** to do this. On Windows 7/2008 and later, Windows will ask for User Account Control confirmation when you start a configuration run:

![UAC dialog][uac]

##### Running other Puppet commands

If you want to run other Puppet-related commands, you must start a command prompt **with administrative privileges.** (You can do so with either the standard `cmd.exe` program, or the "Start Command Prompt with Puppet" Start menu item added by the Puppet installer.)

To do this, right-click the start menu item and choose "Run as administrator:"

![the right click menu, with run as administrator highlighted][rightclick]

This will ask for UAC confirmation:

![UAC dialog][uac]

#### Remotely

To run Puppet agent remotely on any number of systems, you should use Puppet Enterprise's orchestration tools. For info, see the Puppet Enterprise manual [page on triggering Puppet runs][].

Open source Puppet users can install [MCollective][] and [the puppet agent plugin](https://github.com/puppetlabs/mcollective-puppet-agent) to get similar capabilities, but Puppet doesn't provide standalone MCollective packages for Windows.

## Disabling and re-enabling Puppet runs

You can prevent Puppet agent from doing any Puppet runs by [starting a command prompt with elevated privileges][running] and running `puppet agent --disable "<MESSAGE>"`. You can re-enable it with `puppet agent --enable`.

If Puppet agent attempts to do a configuration run while disabled --- either a scheduled run or a manually triggered one --- it will log a message like:

    Notice: Skipping run of Puppet configuration client; administratively disabled
    (Reason: 'Investigating a problem 5/23/14 -NF'); Use 'puppet agent --enable' to re-enable.

## Configuring Puppet agent

Puppet agent should be configured with [puppet.conf][], using the `[agent]` and/or `[main]` section. For notes on which settings are most relevant to Puppet agent, see the [short list of important settings][short_settings].

