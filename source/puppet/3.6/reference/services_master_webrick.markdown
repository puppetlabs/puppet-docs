---
layout: default
title: "Puppet's Services: The WEBrick Puppet Master"
canonical: "/puppet/latest/reference/services_master_webrick.html"
---

[webrick]: http://ruby-doc.org/stdlib/libdoc/webrick/rdoc/WEBrick.html
[rack_master]: ./services_master_rack.html

Puppet master is the application that compiles configurations for any number of puppet agent nodes, using Puppet code and various other data sources. (For more info, see [Overview of Puppet's Architecture](./architecture.html).)

Puppet has the built-in capability to run a complete puppet master server using Ruby's [WEBrick][] library.

The WEBrick puppet master server is not capable of handling production-level numbers of agent nodes. Since it can't handle concurrent connections, it will be quickly overwhelmed by as few as 10 agents. You should never run a WEBrick puppet master in production, and should always configure a [Rack puppet master server][rack_master] instead.

For details about invoking the puppet master command, see [the puppet master man page](./man/master.html).

## Supported Platforms

The WEBrick puppet master will run on any \*nix platform, including all Linux variants and OS X.

You cannot run a puppet master on Windows.

## Controlling the Service

The WEBrick puppet master runs as a single Ruby process. You can manage it in one of two ways.

### Use the `puppetmaster` Init Script

The puppet master packages for most platforms install an init script (usually called `puppetmaster`) that lets you manage the puppet master as a service. You can usually do `sudo puppet resource service puppetmaster ensure=running` to start the service. (Use `ensure=stopped` to stop it.)

### Run `puppet master` on the Command Line

By default, running the `puppet master` command will start a puppet master server daemonized in the background. To stop the service, you'll need to check the process table with something like `ps aux | grep puppet`, then `kill` the process.

If you're testing something quickly and want to view logs in real time, it's more useful to run `sudo puppet master --verbose --no-daemonize`. This will keep the puppet master process in the foreground and print verbose logs to your terminal.

## The WEBrick Puppet Master's Run Environment

The WEBrick puppet master runs as a single Ruby process. This single process does everything related to handling puppet agent requests: It terminates SSL, routes HTTP requests, and executes the Ruby methods that recognize agent requests and build responses to them.

### User

The puppet master process should generally be started as the root user, via `sudo`. Once the process starts, it will drop privileges and start running as the user specified by [the `user` setting][user] (usually `puppet`). Any files and directories the puppet master uses will need to be readable and writable by this user.

[user]: /puppet/latest/reference/configuration.html#user

### Ports

By default, Puppet's HTTPS traffic uses port 8140. The OS and firewall must allow the puppet master's Ruby process to accept incoming connections on this port.

The port can be changed by changing [the `masterport` setting](/puppet/latest/reference/configuration.html#masterport) across all agents and puppet masters.

### Logging

When running under WEBrick, puppet master's logging is split.

WEBrick will log all HTTPS requests and errors to the file specified by [the `masterhttplog` setting](./configuration.html#masterhttplog).

The puppet master application itself logs its activity to syslog. This is where things like compilation errors and deprecation warnings go. Your syslog configuration dictates where these messages will be saved, but the default location is `/var/log/messages` on Linux, `/var/log/system.log` on Mac OS X, and `/var/adm/messages` on Solaris.

When running in the foreground with the `--verbose` or `--debug` options, puppet master logs directly to the terminal instead of to syslog.

When started with the `--logdest <FILE>` option, puppet master logs to the file specified by `<FILE>`.

## Configuring a WEBrick Puppet Master

As [described elsewhere,][about_settings] the puppet master application reads most of its settings from [puppet.conf][] and can accept additional settings on the command line.

When running from the command line, puppet master can directly accept command line options. When running via an init script, it sometimes gets command line options from an init script config file. The location and format of this file will vary depending on your platform.

To change the puppet master's settings, you should generally use [puppet.conf][]. The only two options you may want to set on the command line or in the init script config file are `--verbose` or `--debug`, to change the amount of detail in the logs.

[about_settings]: ./config_about_settings.html
[puppet.conf]: ./config_file_main.html
