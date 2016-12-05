---
layout: default
title: "Puppet's services: The WEBrick Puppet master"
---

[webrick]: http://ruby-doc.org/stdlib/libdoc/webrick/rdoc/WEBrick.html
[rack_master]: ./services_master_rack.html
[deprecate]: http://links.puppetlabs.com/deprecate-rack-webrick-servers

> ## Important: Deprecation warning
>
> [The WEBrick Puppet master server is deprecated][deprecate] and will be removed in a future Puppet release.

Puppet master is the application that compiles configurations for any number of Puppet agent nodes, using Puppet code and various other data sources. (For more info, see [Overview of Puppet's Architecture](./architecture.html).)

Puppet has the built-in capability to run a complete Puppet master server using Ruby's [WEBrick][] library.

The WEBrick Puppet master server is not capable of handling production-level numbers of agent nodes. Since it can't handle concurrent connections, it will be quickly overwhelmed by as few as 10 agents. You should never run a WEBrick Puppet master in production, and should always configure a [Rack Puppet master server][rack_master] instead.

For details about invoking the Puppet master command, see [the puppet master man page](./man/master.html).

## Supported platforms

The WEBrick Puppet master will run on any \*nix platform, including all Linux variants and OS X.

You cannot run a Puppet master on Windows.

## Controlling the service

The WEBrick Puppet master runs as a single Ruby process. You can manage it from the command line.

### Run `puppet master` on the command line

By default, running the `puppet master` command will start a Puppet master server daemonized in the background. To stop the service, you'll need to check the process table with something like `ps aux | grep puppet`, then `kill` the process.

If you're testing something quickly and want to view logs in real time, it's more useful to run `sudo puppet master --verbose --no-daemonize`. This will keep the Puppet master process in the foreground and print verbose logs to your terminal.

## The WEBrick Puppet master's run environment

The WEBrick Puppet master runs as a single Ruby process. This single process does everything related to handling Puppet agent requests: It terminates SSL, routes HTTP requests, and executes the Ruby methods that recognize agent requests and build responses to them.

### User

The Puppet master process should generally be started as the root user, via `sudo`. Once the process starts, it will drop privileges and start running as the user specified by [the `user` setting][user] (usually `puppet`). Any files and directories the Puppet master uses will need to be readable and writable by this user.

Note that you'll need to manually create the `puppet` user account, as the puppet-agent package does not create it. To create this account, run the following commands:

```
puppet resource group puppet ensure=present
puppet resource user puppet ensure=present gid=puppet
```

[user]: ./configuration.html#user

### Ports

By default, Puppet's HTTPS traffic uses port 8140. The OS and firewall must allow the Puppet master's Ruby process to accept incoming connections on this port.

The port can be changed by changing [the `masterport` setting](./configuration.html#masterport) across all agents and Puppet masters.

### Logging

When running under WEBrick, Puppet master's logging is split.

WEBrick will log all HTTPS requests and errors to the file specified by [the `masterhttplog` setting](./configuration.html#masterhttplog).

The Puppet master application itself logs its activity to syslog. This is where things like compilation errors and deprecation warnings go. Your syslog configuration dictates where these messages will be saved, but the default location is `/var/log/messages` on Linux, `/var/log/system.log` on Mac OS X, and `/var/adm/messages` on Solaris.

You can adjust how verbose the logs are with [the `log_level` setting](./configuration.html#loglevel), which defaults to `notice`. Setting it to `info` is equivalent to running with the `--verbose` option, and setting it to `debug` is equivalent to `--debug`. You can also make logs quieter by dialing back to `warning` or lower.

When running in the foreground with the `--verbose` or `--debug` options, Puppet master logs directly to the terminal instead of to syslog.

When started with the `--logdest <FILE>` option, Puppet master logs to the file specified by `<FILE>`.

## Configuring a WEBrick Puppet master

As [described elsewhere,][about_settings] the Puppet master application reads most of its settings from [puppet.conf][] and can accept additional settings on the command line.

When running from the command line, Puppet master can directly accept command line options. When running via an init script, it sometimes gets command line options from an init script config file. The location and format of this file will vary depending on your platform.

To change the Puppet master's settings, you should generally use [puppet.conf][]. The only two options you may want to set on the command line or in the init script config file are `--verbose` or `--debug`, to change the amount of detail in the logs.

[about_settings]: ./config_about_settings.html
[puppet.conf]: ./config_file_main.html
