service
=======

Control OS services

* * *

About
-----

Manage running services. Service support unfortunately varies
widely by platform -- some platforms have very little if any
concept of a running service, and some have a very codified and
powerful concept. Puppet's service support will generally be able
to make up for any inherent shortcomings (e.g., if there is no
'status' command, then Puppet will look in the process table for a
command matching the service name), but the more information you
can provide the better behaviour you will get. Or, you can just use
a platform that has very good service support.

Note that if a `service` receives an event from another resource,
the service will get restarted. The actual command to restart the
service depends on the platform. You can provide a special command
for restarting with the `restart` attribute.

Features
--------

-   **controllable**: The provider uses a control variable.
-   **enableable**: The provider can enable and disable the service
-   **refreshable**: The provider can restart the service.

=========== ============ ========== =========== Provider
controllable enableable refreshable =========== ============
========== =========== base **X** daemontools **X** **X** debian
**X** **X** freebsd **X** **X** gentoo **X** **X** init **X**
launchd **X** **X** redhat **X** **X** runit **X** **X** smf **X**
**X** =========== ============ ========== ===========

Parameters
----------

## binary

The path to the daemon. This is only used for systems that do not
support init scripts. This binary will be used to start the service
if no `start` parameter is provided.

## control

The control variable used to manage services (originally for
HP-UX). Defaults to the upcased service name plus `START` replacing
dots with underscores, for those providers that support the
`controllable` feature.

## enable

Whether a service should be enabled to start at boot. This property
behaves quite differently depending on the platform; wherever
possible, it relies on local tools to enable or disable a given
service. Valid values are `true`, `false`. Requires features
enableable.

## ensure

Whether a service should be running. Valid values are `stopped`
(also called `false`), `running` (also called `true`).

## hasrestart

Specify that an init script has a `restart` option. Otherwise, the
init script's `stop` and `start` methods are used. Valid values are
`true`, `false`.

## hasstatus

Declare the the service's init script has a functional status
command. Based on testing, it was found that a large number of init
scripts on different platforms do not support any kind of status
command; thus, you must specify manually whether the service you
are running has such a command (or you can specify a specific
command using the `status` parameter).

If you do not specify anything, then the service name will be
looked for in the process table. Valid values are `true`, `false`.

## manifest

Specify a command to config a service, or a path to a manifest to
do so.

## name

-   **namevar**

The name of the service to run. This name is used to find the
service in whatever service subsystem it is in.

## path

The search path for finding init scripts. Multiple values should be
separated by colons or provided as an array.

## pattern

The pattern to search for in the process table. This is used for
stopping services on platforms that do not support init scripts,
and is also used for determining service status on those service
whose init scripts do not include a status command.

If this is left unspecified and is needed to check the status of a
service, then the service name will be used instead.

The pattern can be a simple string or any legal Ruby pattern.

## provider

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

-   **base**: The simplest form of service support.

    > You have to specify enough about your service for this to work; the
    > minimum you can specify is a binary for starting the process, and
    > this same binary will be searched for in the process table to stop
    > the service. It is preferable to specify start, stop, and status
    > commands, akin to how you would do so using `init`.
    > 
    > > Required binaries: `kill`. Supported features: `refreshable`.

-   **daemontools**: Daemontools service management.

    > This provider manages daemons running supervised by D.J.Bernstein
    > daemontools. It tries to detect the service directory, with by
    > order of preference:
    > 
    > -   /service
    > -   /etc/service
    > -   /var/lib/svscan
    > 
    > The daemon directory should be placed in a directory that can be by
    > default in:
    > 
    > -   /var/lib/service
    > -   /etc
    > 
    > or this can be overriden in the service resource parameters:
    > 
    >     service {
    >      "myservice":
    >        provider => "daemontools", path => "/path/to/daemons";
    >     }
    > 
    > This provider supports out of the box:
    > 
    > -   start/stop (mapped to enable/disable)
    > -   enable/disable
    > -   restart
    > -   status
    > 
    > If a service has ensure =\> "running", it will link /path/to/daemon
    > to /path/to/service, which will automatically enable the service.
    > 
    > If a service has ensure =\> "stopped", it will only down the
    > service, not remove the /path/to/service link.
    > 
    > > Required binaries: `/usr/bin/svstat`, `/usr/bin/svc`. Supported
    > > features: `enableable`, `refreshable`.

-   **debian**: Debian's form of `init`-style management.

    > The only difference is that this supports service enabling and
    > disabling via `update-rc.d` and determines enabled status via
    > `invoke-rc.d`.
    > 
    > > Required binaries: `/usr/sbin/update-rc.d`,
    > > `/usr/sbin/invoke-rc.d`. Default for `operatingsystem` ==
    > > `debianubuntu`. Supported features: `enableable`, `refreshable`.

-   **freebsd**: FreeBSD's (and probably NetBSD?) form of
    `init`-style service management.

    > Uses `rc.conf.d` for service enabling and disabling.
    > 
    > Default for `operatingsystem` == `freebsd`. Supported features:
    > `enableable`, `refreshable`.

-   **gentoo**: Gentoo's form of `init`-style service management.

    > Uses `rc-update` for service enabling and disabling.
    > 
    > > Required binaries: `/sbin/rc-update`. Default for `operatingsystem`
    > > == `gentoo`. Supported features: `enableable`, `refreshable`.

-   **init**: Standard init service management.

    > This provider assumes that the init script has no `status` command,
    > because so few scripts do, so you need to either provide a status
    > command or specify via `hasstatus` that one already exists in the
    > init script.
    > 
    > > Supported features: `refreshable`.

-   **launchd**: launchd service management framework.

    > This provider manages launchd jobs, the default service framework
    > for Mac OS X, that has also been open sourced by Apple for possible
    > use on other platforms.
    > 
    > See:
    > :   -   [http://developer.apple.com/macosx/launchd.html](http://developer.apple.com/macosx/launchd.html)
    >     -   [http://launchd.macosforge.org/](http://launchd.macosforge.org/)
    > 
    > This provider reads plists out of the following directories:
    > :   -   /System/Library/LaunchDaemons
    >     -   /System/Library/LaunchAgents
    >     -   /Library/LaunchDaemons
    >     -   /Library/LaunchAgents
    > 
    > 
    > and builds up a list of services based upon each plists "Label"
    > entry.
    > 
    > This provider supports:
    > :   -   ensure =\> running/stopped,
    >     -   enable =\> true/false
    >     -   status
    >     -   restart
    > 
    > Here is how the Puppet states correspond to launchd states:
    > :   -   stopped =\> job unloaded
    >     -   started =\> job loaded
    >     -   enabled =\> 'Disable' removed from job plist file
    >     -   disabled =\> 'Disable' added to job plist file
    > 
    > 
    > Note that this allows you to do something launchctl can't do, which
    > is to be in a state of "stopped/enabled or "running/disabled".
    > 
    > > Required binaries: `/usr/bin/sw_vers`, `/bin/launchctl`. Default
    > > for `operatingsystem` == `darwin`. Supported features:
    > > `enableable`, `refreshable`.

-   **redhat**: Red Hat's (and probably many others) form of
    `init`-style service management:

    > Uses `chkconfig` for service enabling and disabling.
    > 
    > > Required binaries: `/sbin/chkconfig`, `/sbin/service`. Default for
    > > `operatingsystem` == `redhatfedorasusecentosslesoelovm`. Supported
    > > features: `enableable`, `refreshable`.

-   **runit**: Runit service management.

    This provider manages daemons running supervised by Runit. It tries
    to detect the service directory, with by order of preference:

    > -   /service
    > -   /var/service
    > -   /etc/service

    The daemon directory should be placed in a directory that can be by
    default in:

    > -   /etc/sv

    or this can be overriden in the service resource parameters:

        service {
         "myservice":
           provider => "runit", path => "/path/to/daemons";
        }

    This provider supports out of the box:

    > -   start/stop
    > -   enable/disable
    > -   restart
    > -   status

    Required binaries: `/usr/bin/sv`. Supported features: `enableable`,
    `refreshable`.
-   **smf**: Support for Sun's new Service Management Framework.

    > Starting a service is effectively equivalent to enabling it, so
    > there is only support for starting and stopping services, which
    > also enables and disables them, respectively.
    > 
    > By specifying manifest =\> "/path/to/service.xml", the SMF manifest
    > will be imported if it does not exist.
    > 
    > > Required binaries: `/usr/sbin/svcadm`, `/usr/bin/svcs`,
    > > `/usr/sbin/svccfg`. Default for `operatingsystem` == `solaris`.
    > > Supported features: `enableable`, `refreshable`.


## restart

Specify a *restart* command manually. If left unspecified, the
service will be stopped and then started.

## start

Specify a *start* command manually. Most service subsystems support
a `start` command, so this will not need to be specified.

## status

Specify a *status* command manually. If left unspecified, the
status method will be determined automatically, usually by looking
for the service in the process table.

## stop

Specify a *stop* command manually.


* * * * *

