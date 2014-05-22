---
layout: default
title: "Puppet's Services: The WEBrick Puppet Master"
canonical: "/puppet/latest/reference/services_master_webrick.html"
---

[webrick]: http://ruby-doc.org/stdlib/libdoc/webrick/rdoc/WEBrick.html
[arrangement]: ./services_arrangement.html
[rack_master]: ./services_master_rack.html

Puppet has the built-in capability to run a complete puppet master server using Ruby's [WEBrick][] library. This server handles all puppet master services as described in [the page on Puppet's arrangement of services][arrangement].

The WEBrick puppet master server is not capable of handling production-level numbers of agent nodes. Since it can't handle concurrent connections, it will be quickly overwhelmed by as few as 10 agents. You should never run a WEBrick puppet master in production, and should always configure a [Rack puppet master server][rack_master] instead.

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

## The Service's Run Environment

The WEBrick puppet master runs as a single Ruby process. This single process does everything related to handling puppet agent requests: It terminates SSL, routes HTTP requests, and executes the Ruby methods that recognize agent requests and build responses to them.

### User

The puppet master process should generally be started as the root user, via `sudo`. Once the process starts, it will drop privileges and start running as the user specified by [the `user` setting][user] (usually `puppet`). Any files and directories the puppet master uses will need to be readable and writable by this user.

[user]: /references/latest/configuration.html#user

### Ports

By default, Puppet's HTTPS traffic uses port 8140. The OS and firewall must allow the puppet master's Ruby process to accept incoming connections on this port.

The port can be changed by changing [the `masterport` setting](/references/latest/configuration.html#masterport) across all agents and puppet masters.
