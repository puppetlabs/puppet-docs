---
layout: default
title: "Resource tips and examples: Service"
---

[service]: /puppet/3.8/type.html#service
[ensure]: /puppet/3.8/type.html#service-attribute-ensure
[enable]: /puppet/3.8/type.html#service-attribute-enable
[start]: /puppet/3.8/type.html#service-attribute-start
[binary]: /puppet/3.8/type.html#service-attribute-binary
[stop]: /puppet/3.8/type.html#service-attribute-stop
[status]: /puppet/3.8/type.html#service-attribute-status
[pattern]: /puppet/3.8/type.html#service-attribute-pattern


Puppet can manage [services][service] on nearly all operating systems.

## Most Linux and \*nix systems

### Normal operation

If your operating system has a good system for managing services, and all the services you care about have working init scripts or service configs, you can write small service resources with just the [`ensure`][ensure] and [`enable`][enable] attributes:

``` puppet
service { 'apache2':
  ensure => running,
  enable => true,
}
```

(Note that some operating systems don't support the `enable` attribute.)

### Defective init script

On platforms that use SysV-style init scripts, Puppet assumes the script will have working `start`, `stop`, and `status` commands.

If the `status` command is missing, you will need to set `hasstatus => false` for that service. This will make Puppet search the process table for the service's name to check whether it's running.

In some rare cases --- such as virtual services like Red Hat's `network` --- a service won't have a matching entry in the process table. If a service acts like this and is _also_ missing a status command, you'll need to set `hasstatus => false` and also specify either the `status` or `pattern` attribute.

### No init script or service config

``` puppet
service { "apache2":
  ensure  => running,
  start   => "/usr/sbin/apachectl start",
  stop    => "/usr/sbin/apachectl stop",
  pattern => "/usr/sbin/httpd",
}
```

If some of your services lack init scripts, Puppet can compensate.

In addition to `ensure`, you'll need to specify several additional attributes. Puppet needs to know how to start the service, how to stop it, how to check whether it's running, and optionally how to restart it.

#### Start

Use either [`start`][start] or [`binary`][binary] to specify a start command. The difference is that `binary` will also give you default behavior for stopping and status.

#### Stop

If you specified `binary`, Puppet will default to finding that same executable in the process table and killing it.

If the service should be stopped some other way, use the [`stop`][stop] attribute to specify a command.

#### Status

If you specified `binary`, Puppet will default to checking for that executable in the process table; if it doesn't find it, it assumes the service isn't running.

If there's a better way to check the service's status, or if the start command is just a script and a different process implements the service itself, use either [`status`][status] (a command that exits 0 if the service is running and nonzero otherwise) or [`pattern`][pattern] (a pattern to search the process table for).

#### Restart

If a service needs to be reloaded, Puppet defaults to stopping it and starting it again. If you have a safer command for restarting a service, you can optionally specify it in the `restart` attribute.

## Mac OS X

OS X handles services much like most Linux-based systems; the main difference is that `enable` and `ensure` are much more closely linked --- running services are always enabled, and stopped ones are always disabled. For best results, either leave `enable` blank or make sure it's set to `true` whenever `ensure => running`.

Also, note that the launchd plists that configure your services must be in one of the following four directories:

* `/System/Library/LaunchDaemons`
* `/System/Library/LaunchAgents`
* `/Library/LaunchDaemons`
* `/Library/LaunchAgents`

You can also specify `start` and `stop` commands to assemble your own services, much like on Linux.

## Windows

On Microsoft Windows, Puppet can start, stop, enable, disable, list, query and configure services. It expects that all services will run via Windows' built-in Service Control Manager (SCM) system. It does not support configuring service dependencies, account to run as, or desktop interaction.

When writing service resources for Windows, remember the following:

* Use the short service name (e.g. `wuauserv`) in Puppet, not the display name (e.g. `Automatic Updates`).
* Setting `enable => true` will assign a service the "Automatic" startup type; setting `enable => manual` will assign the "Manual" startup type.

A complete service resource is very simple:

``` puppet
service { 'mysql':
  ensure => 'running',
  enable => true,
}
```

