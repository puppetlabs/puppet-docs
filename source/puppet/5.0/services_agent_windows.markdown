---
layout: default
title: "Puppet's services: Puppet agent on Windows systems"
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
[report]: ./reporting_about.html
[running]: ./services_commands_windows.html

Puppet agent is the application that manages configurations on nodes. It requires a Puppet master server to fetch configuration [catalogs][] from. (For more info, see [Overview of Puppet's Architecture](./architecture.html).)

For details about invoking the Puppet agent command, see [the puppet agent man page](./man/agent.html).

## Puppet agent's run environment

Puppet agent runs as a specific user, (defaulting to `LocalSystem`) and initiates outbound connections on port 8140.

### Ports

By default, Puppet's HTTPS traffic uses port 8140. Your operating system and firewall must allow Puppet agent to initiate outbound connections on this port.

If you want to use a non-default port, change [the `masterport` setting](./configuration.html#masterport) on all agent nodes, and ensure that you've changed your Puppet master's port as well.

### User

By default, Puppet agent runs as the `LocalSystem` user. This lets it manage the configuration of the entire system, but prevents it from accessing files on UNC shares.

Puppet can also run as a different user. You can change the user in the Service Control Manager (SCM). To start the SCM, from the Start menu choose "Run..." and type `Services.msc`.

You can also specify a different user when installing Puppet. To do this, install via the command line and [specify the required MSI properties][msiproperties] (`PUPPET_AGENT_ACCOUNT_USER`, `PUPPET_AGENT_ACCOUNT_PASSWORD`, and `PUPPET_AGENT_ACCOUNT_DOMAIN`).

Puppet agent's user can be a local or domain user. If this user isn't already a local administrator, the Puppet installer adds it to the `Administrators` group. The installer also grants [Logon as Service](http://msdn.microsoft.com/en-us/library/ms813948.aspx) to the user.

## Managing systems with Puppet agent

In a normal Puppet configuration, every node periodically does configuration runs to revert unwanted changes and to pick up recent updates.

On Windows nodes, there are two main ways to do this:

* **Run Puppet agent as a service.** The easiest method. The Puppet agent service does configuration runs at a set interval, which can be configured.
* **Only run Puppet agent on demand.** You can also deploy [MCollective][] to run on demand on many nodes.

Since the Windows version of the Puppet agent service is much simpler than the \*nix version, there's no real performance to be gained by running Puppet as a scheduled task, but if you do want scheduled configuration runs, use the Windows service.

### Running Puppet agent as a service

By default, the Puppet installer configures Puppet agent to run as a Windows service and automatically starts it. No further action is needed. Puppet agent does configuration runs at a set interval.

#### Configuring the run interval

The Puppet agent service defaults to doing a configuration run every 30 minutes. If you don't need an aggressive schedule of configuration runs, a longer run interval lets your Puppet master server(s) handle many more agent nodes.

You can configure this with [the `runinterval` setting][runinterval] in [puppet.conf][]:

    # C:\ProgramData\PuppetLabs\puppet\etc\puppet.conf
    [agent]
      runinterval = 2h

Once the run interval has been changed, the service sticks to the prior schedule for the next run and then switches to the new run interval for subsequent runs.

#### Configuring the service start up type

The Puppet agent service defaults to starting automatically. If you'd rather start it manually or disable it, you can configure this during installation.

To do this, install via the command line and [specify the `PUPPET_AGENT_STARTUP_MODE` MSI property][msiproperties].

You can also configure this after installation with the Service Control Manager (SCM). To start the SCM, choose "Run..." from the Start menu and type `Services.msc`.

You can also configure agent service with the `sc.exe` command. To prevent the service from starting on boot:

    C:\>sc config puppet start= demand
    [SC] ChangeServiceConfig SUCCESS

>**Important:** The space after `start=` is mandatory! Also note that this must be run in cmd.exe; this command won't work from PowerShell.

To restart the service:

    C:\>sc stop puppet
    C:\>sc start puppet

To change the arguments used when triggering a Puppet agent run (this example changes the level of detail that gets written to the Event Log):

    C:\>sc start puppet --debug --logdest eventlog


### Running Puppet agent on demand

Some sites prefer to only run Puppet agent on demand; others occasionally need to do an on-demand run.

Puppet agent runs can be started locally while logged in to the target system, or remotely with MCollective.

#### While logged in to the target system

On Windows, you can start a configuration run with the "Run Puppet Agent" Start menu item. This shows the status of the run in a command prompt window.

You **must be logged in as an administrator** to do this. On Windows 7/2008 and later, Windows asks for User Account Control confirmation when you start a configuration run:

![UAC dialog][uac]

##### Running other Puppet commands

If you want to run other Puppet-related commands, you must start a command prompt **with administrative privileges.** (You can do so with either the standard `cmd.exe` program, or the "Start Command Prompt with Puppet" Start menu item added by the Puppet installer.)

To do this, right-click the start menu item and choose "Run as administrator:"

![the right click menu, with run as administrator highlighted][rightclick]

This prompts it to ask for UAC confirmation:

![UAC dialog][uac]

#### Remotely

Open source Puppet users can install [MCollective][] and [the puppet agent plugin](https://github.com/puppetlabs/mcollective-puppet-agent) to get similar capabilities, but Puppet doesn't provide standalone MCollective packages for Windows.

## Disabling and re-enabling Puppet runs

Whether you're troubleshooting errors, working in a maintenance window, or simply developing in a sandbox environment, you may need to temporarily disable the Puppet agent from running.

1. Start a command prompt with elevated privileges.
2. Run one of these commands, depending on whether you want to disable or re-enable the agent:

   * Disable -- `puppet agent --disable "<MESSAGE>"`
   * Enable -- `puppet agent --enable`

## Configuring Puppet agent on Windows

The Puppet agent comes with a default configuration that may not be the most convenient for you.

Configure Puppet agent with [puppet.conf][], using the `[agent]` and/or `[main]` section. For notes on which settings are most relevant to Puppet agent, see the [short list of important settings][short_settings].

### Logging for Puppet agent on Windows systems

When running as a service, Puppet agent logs messages to the Windows Event Log. You can view its logs by browsing the Event Viewer. (Control Panel → System and Security → Administrative Tools → Event Viewer)

You can adjust how verbose the logs are with [the `log_level` setting](./configuration.html#loglevel), which defaults to `notice`.

When running in the foreground with the `--verbose`, `--debug`, or `--test` options, Puppet agent logs directly to the terminal.

When started with the `--logdest <FILE>` option, Puppet agent logs to the file specified by `<FILE>`.

### Reporting for Puppet agent on Windows systems

In addition to local logging, Puppet agent submits a [report][] to the Puppet master after each run. (This can be disabled by setting [`report = false`](./configuration.html#report) in [puppet.conf][].)

