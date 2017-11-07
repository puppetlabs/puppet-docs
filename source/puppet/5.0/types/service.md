---
layout: default
built_from_commit: edcda126535bd31439280bcf21402a4a4f126f71
title: 'Resource Type: service'
canonical: "/puppet/latest/types/service.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2017-06-27 17:23:02 -0500

service
-----

* [Attributes](#service-attributes)
* [Providers](#service-providers)
* [Provider Features](#service-provider-features)

<h3 id="service-description">Description</h3>

Manage running services.  Service support unfortunately varies
widely by platform --- some platforms have very little if any concept of a
running service, and some have a very codified and powerful concept.
Puppet's service support is usually capable of doing the right thing, but
the more information you can provide, the better behaviour you will get.

Puppet 2.7 and newer expect init scripts to have a working status command.
If this isn't the case for any of your services' init scripts, you will
need to set `hasstatus` to false and possibly specify a custom status
command in the `status` attribute. As a last resort, Puppet will attempt to
search the process table by calling whatever command is listed in the `ps`
fact. The default search pattern is the name of the service, but you can
specify it with the `pattern` attribute.

**Refresh:** `service` resources can respond to refresh events (via
`notify`, `subscribe`, or the `~>` arrow). If a `service` receives an
event from another resource, Puppet will restart the service it manages.
The actual command used to restart the service depends on the platform and
can be configured:

* If you set `hasrestart` to true, Puppet will use the init script's restart command.
* You can provide an explicit command for restarting with the `restart` attribute.
* If you do neither, the service's stop and start commands will be used.

<h3 id="service-attributes">Attributes</h3>

<pre><code>service { 'resource title':
  <a href="#service-attribute-name">name</a>       =&gt; <em># <strong>(namevar)</strong> The name of the service to run.  This name is...</em>
  <a href="#service-attribute-ensure">ensure</a>     =&gt; <em># Whether a service should be running.  Valid...</em>
  <a href="#service-attribute-binary">binary</a>     =&gt; <em># The path to the daemon.  This is only used for...</em>
  <a href="#service-attribute-control">control</a>    =&gt; <em># The control variable used to manage services...</em>
  <a href="#service-attribute-enable">enable</a>     =&gt; <em># Whether a service should be enabled to start at...</em>
  <a href="#service-attribute-flags">flags</a>      =&gt; <em># Specify a string of flags to pass to the startup </em>
  <a href="#service-attribute-hasrestart">hasrestart</a> =&gt; <em># Specify that an init script has a `restart...</em>
  <a href="#service-attribute-hasstatus">hasstatus</a>  =&gt; <em># Declare whether the service's init script has a...</em>
  <a href="#service-attribute-manifest">manifest</a>   =&gt; <em># Specify a command to config a service, or a path </em>
  <a href="#service-attribute-path">path</a>       =&gt; <em># The search path for finding init scripts....</em>
  <a href="#service-attribute-pattern">pattern</a>    =&gt; <em># The pattern to search for in the process table...</em>
  <a href="#service-attribute-provider">provider</a>   =&gt; <em># The specific backend to use for this `service...</em>
  <a href="#service-attribute-restart">restart</a>    =&gt; <em># Specify a *restart* command manually.  If left...</em>
  <a href="#service-attribute-start">start</a>      =&gt; <em># Specify a *start* command manually.  Most...</em>
  <a href="#service-attribute-status">status</a>     =&gt; <em># Specify a *status* command manually.  This...</em>
  <a href="#service-attribute-stop">stop</a>       =&gt; <em># Specify a *stop* command...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="service-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the service to run.

This name is used to find the service; on platforms where services
have short system names and long display names, this should be the
short name. (To take an example from Windows, you would use "wuauserv"
rather than "Automatic Updates.")

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether a service should be running.

Valid values are `stopped` (also called `false`), `running` (also called `true`).

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-binary">binary</h4>

The path to the daemon.  This is only used for
systems that do not support init scripts.  This binary will be
used to start the service if no `start` parameter is
provided.

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-control">control</h4>

The control variable used to manage services (originally for HP-UX).
Defaults to the upcased service name plus `START` replacing dots with
underscores, for those providers that support the `controllable` feature.

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-enable">enable</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether a service should be enabled to start at boot.
This property behaves quite differently depending on the platform;
wherever possible, it relies on local tools to enable or disable
a given service.

Valid values are `true`, `false`, `manual`, `mask`.

Requires features enableable.

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-flags">flags</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Specify a string of flags to pass to the startup script.



Requires features flaggable.

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-hasrestart">hasrestart</h4>

Specify that an init script has a `restart` command.  If this is
false and you do not specify a command in the `restart` attribute,
the init script's `stop` and `start` commands will be used.

Defaults to false.

Valid values are `true`, `false`.

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-hasstatus">hasstatus</h4>

Declare whether the service's init script has a functional status
command; defaults to `true`. This attribute's default value changed in
Puppet 2.7.0.

The init script's status command must return 0 if the service is
running and a nonzero value otherwise. Ideally, these exit codes
should conform to [the LSB's specification][lsb-exit-codes] for init
script status actions, but Puppet only considers the difference
between 0 and nonzero to be relevant.

If a service's init script does not support any kind of status command,
you should set `hasstatus` to false and either provide a specific
command using the `status` attribute or expect that Puppet will look for
the service name in the process table. Be aware that 'virtual' init
scripts (like 'network' under Red Hat systems) will respond poorly to
refresh events from other resources if you override the default behavior
without providing a status command.

Valid values are `true`, `false`.

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-manifest">manifest</h4>

Specify a command to config a service, or a path to a manifest to do so.

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-path">path</h4>

The search path for finding init scripts.  Multiple values should
be separated by colons or provided as an array.

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-pattern">pattern</h4>

The pattern to search for in the process table.
This is used for stopping services on platforms that do not
support init scripts, and is also used for determining service
status on those service whose init scripts do not include a status
command.

Defaults to the name of the service. The pattern can be a simple string
or any legal Ruby pattern, including regular expressions (which should
be quoted without enclosing slashes).

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-provider">provider</h4>

The specific backend to use for this `service`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`base`](#service-provider-base)
* [`bsd`](#service-provider-bsd)
* [`daemontools`](#service-provider-daemontools)
* [`debian`](#service-provider-debian)
* [`freebsd`](#service-provider-freebsd)
* [`gentoo`](#service-provider-gentoo)
* [`init`](#service-provider-init)
* [`launchd`](#service-provider-launchd)
* [`openbsd`](#service-provider-openbsd)
* [`openrc`](#service-provider-openrc)
* [`openwrt`](#service-provider-openwrt)
* [`rcng`](#service-provider-rcng)
* [`redhat`](#service-provider-redhat)
* [`runit`](#service-provider-runit)
* [`service`](#service-provider-service)
* [`smf`](#service-provider-smf)
* [`src`](#service-provider-src)
* [`systemd`](#service-provider-systemd)
* [`upstart`](#service-provider-upstart)
* [`windows`](#service-provider-windows)

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-restart">restart</h4>

Specify a *restart* command manually.  If left
unspecified, the service will be stopped and then started.

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-start">start</h4>

Specify a *start* command manually.  Most service subsystems
support a `start` command, so this will not need to be
specified.

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-status">status</h4>

Specify a *status* command manually.  This command must
return 0 if the service is running and a nonzero value otherwise.
Ideally, these exit codes should conform to [the LSB's
specification][lsb-exit-codes] for init script status actions, but
Puppet only considers the difference between 0 and nonzero to be
relevant.

If left unspecified, the status of the service will be determined
automatically, usually by looking for the service in the process
table.

[lsb-exit-codes]: http://refspecs.linuxfoundation.org/LSB_4.1.0/LSB-Core-generic/LSB-Core-generic/iniscrptact.html

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-stop">stop</h4>

Specify a *stop* command manually.

([↑ Back to service attributes](#service-attributes))


<h3 id="service-providers">Providers</h3>

<h4 id="service-provider-base">base</h4>

The simplest form of Unix service support.

You have to specify enough about your service for this to work; the
minimum you can specify is a binary for starting the process, and this
same binary will be searched for in the process table to stop the
service.  As with `init`-style services, it is preferable to specify start,
stop, and status commands.

* Required binaries: `kill`.
* Supported features: `refreshable`.

<h4 id="service-provider-bsd">bsd</h4>

Generic BSD form of `init`-style service management with `rc.d`.

Uses `rc.conf.d` for service enabling and disabling.

* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-daemontools">daemontools</h4>

Daemontools service management.

This provider manages daemons supervised by D.J. Bernstein daemontools.
When detecting the service directory it will check, in order of preference:

* `/service`
* `/etc/service`
* `/var/lib/svscan`

The daemon directory should be in one of the following locations:

* `/var/lib/service`
* `/etc`

...or this can be overridden in the resource's attributes:

    service { 'myservice':
      provider => 'daemontools',
      path     => '/path/to/daemons',
    }

This provider supports out of the box:

* start/stop (mapped to enable/disable)
* enable/disable
* restart
* status

If a service has `ensure => "running"`, it will link /path/to/daemon to
/path/to/service, which will automatically enable the service.

If a service has `ensure => "stopped"`, it will only shut down the service, not
remove the `/path/to/service` link.

* Required binaries: `/usr/bin/svc`, `/usr/bin/svstat`.
* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-debian">debian</h4>

Debian's form of `init`-style management.

The only differences from `init` are support for enabling and disabling
services via `update-rc.d` and the ability to determine enabled status via
`invoke-rc.d`.

* Required binaries: `/usr/sbin/invoke-rc.d`, `/usr/sbin/service`, `/usr/sbin/update-rc.d`.
* Default for `operatingsystem` == `cumuluslinux` and `operatingsystemmajrelease` == `1, 2`. Default for `operatingsystem` == `debian` and `operatingsystemmajrelease` == `5, 6, 7`.
* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-freebsd">freebsd</h4>

Provider for FreeBSD and DragonFly BSD. Uses the `rcvar` argument of init scripts and parses/edits rc files.

* Default for `operatingsystem` == `freebsd, dragonfly`.
* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-gentoo">gentoo</h4>

Gentoo's form of `init`-style service management.

Uses `rc-update` for service enabling and disabling.

* Required binaries: `/sbin/rc-update`.
* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-init">init</h4>

Standard `init`-style service management.

* Supported features: `refreshable`.

<h4 id="service-provider-launchd">launchd</h4>

This provider manages jobs with `launchd`, which is the default service
framework for Mac OS X (and may be available for use on other platforms).

For `launchd` documentation, see:

* <https://developer.apple.com/macosx/launchd.html>
* <http://launchd.macosforge.org/>

This provider reads plists out of the following directories:

* `/System/Library/LaunchDaemons`
* `/System/Library/LaunchAgents`
* `/Library/LaunchDaemons`
* `/Library/LaunchAgents`

...and builds up a list of services based upon each plist's "Label" entry.

This provider supports:

* ensure => running/stopped,
* enable => true/false
* status
* restart

Here is how the Puppet states correspond to `launchd` states:

* stopped --- job unloaded
* started --- job loaded
* enabled --- 'Disable' removed from job plist file
* disabled --- 'Disable' added to job plist file

Note that this allows you to do something `launchctl` can't do, which is to
be in a state of "stopped/enabled" or "running/disabled".

Note that this provider does not support overriding 'restart'

* Required binaries: `/bin/launchctl`.
* Default for `operatingsystem` == `darwin`.
* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-openbsd">openbsd</h4>

Provider for OpenBSD's rc.d daemon control scripts

* Required binaries: `/usr/sbin/rcctl`.
* Default for `operatingsystem` == `openbsd`.
* Supported features: `enableable`, `flaggable`, `refreshable`.

<h4 id="service-provider-openrc">openrc</h4>

Support for Gentoo's OpenRC initskripts

Uses rc-update, rc-status and rc-service to manage services.

* Required binaries: `/bin/rc-status`, `/sbin/rc-service`, `/sbin/rc-update`.
* Default for `operatingsystem` == `gentoo`. Default for `operatingsystem` == `funtoo`.
* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-openwrt">openwrt</h4>

Support for OpenWrt flavored init scripts.

Uses /etc/init.d/service_name enable, disable, and enabled.

* Default for `operatingsystem` == `openwrt`.
* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-rcng">rcng</h4>

RCng service management with rc.d

* Default for `operatingsystem` == `netbsd, cargos`.
* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-redhat">redhat</h4>

Red Hat's (and probably many others') form of `init`-style service
management. Uses `chkconfig` for service enabling and disabling.

* Required binaries: `/sbin/chkconfig`, `/sbin/service`.
* Default for `osfamily` == `redhat`. Default for `operatingsystemmajrelease` == `10, 11` and `osfamily` == `suse`.
* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-runit">runit</h4>

Runit service management.

This provider manages daemons running supervised by Runit.
When detecting the service directory it will check, in order of preference:

* `/service`
* `/etc/service`
* `/var/service`

The daemon directory should be in one of the following locations:

* `/etc/sv`
* `/var/lib/service`

or this can be overridden in the service resource parameters:

    service { 'myservice':
      provider => 'runit',
      path     => '/path/to/daemons',
    }

This provider supports out of the box:

* start/stop
* enable/disable
* restart
* status

* Required binaries: `/usr/bin/sv`.
* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-service">service</h4>

The simplest form of service support.

* Supported features: `refreshable`.

<h4 id="service-provider-smf">smf</h4>

Support for Sun's new Service Management Framework.

Starting a service is effectively equivalent to enabling it, so there is
only support for starting and stopping services, which also enables and
disables them, respectively.

By specifying `manifest => "/path/to/service.xml"`, the SMF manifest will
be imported if it does not exist.

* Required binaries: `/usr/bin/svcs`, `/usr/sbin/svcadm`, `/usr/sbin/svccfg`.
* Default for `osfamily` == `solaris`.
* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-src">src</h4>

Support for AIX's System Resource controller.

Services are started/stopped based on the `stopsrc` and `startsrc`
commands, and some services can be refreshed with `refresh` command.

Enabling and disabling services is not supported, as it requires
modifications to `/etc/inittab`. Starting and stopping groups of subsystems
is not yet supported.

* Required binaries: `/usr/bin/lssrc`, `/usr/bin/refresh`, `/usr/bin/startsrc`, `/usr/bin/stopsrc`, `/usr/sbin/chitab`, `/usr/sbin/lsitab`, `/usr/sbin/mkitab`, `/usr/sbin/rmitab`.
* Default for `operatingsystem` == `aix`.
* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-systemd">systemd</h4>

Manages `systemd` services using `systemctl`.

Because `systemd` defaults to assuming the `.service` unit type, the suffix
may be omitted.  Other unit types (such as `.path`) may be managed by
providing the proper suffix.

* Required binaries: `systemctl`.
* Default for `osfamily` == `archlinux`. Default for `operatingsystemmajrelease` == `7` and `osfamily` == `redhat`. Default for `operatingsystem` == `fedora` and `osfamily` == `redhat`. Default for `osfamily` == `suse`. Default for `osfamily` == `coreos`. Default for `operatingsystem` == `debian` and `operatingsystemmajrelease` == `8, stretch/sid, 9, buster/sid`. Default for `operatingsystem` == `ubuntu` and `operatingsystemmajrelease` == `15.04, 15.10, 16.04, 16.10`. Default for `operatingsystem` == `cumuluslinux` and `operatingsystemmajrelease` == `3`.
* Supported features: `enableable`, `maskable`, `refreshable`.

<h4 id="service-provider-upstart">upstart</h4>

Ubuntu service management with `upstart`.

This provider manages `upstart` jobs on Ubuntu. For `upstart` documentation,
see <http://upstart.ubuntu.com/>.

* Required binaries: `/sbin/initctl`, `/sbin/restart`, `/sbin/start`, `/sbin/status`, `/sbin/stop`.
* Default for `operatingsystem` == `ubuntu` and `operatingsystemmajrelease` == `10.04, 12.04, 14.04, 14.10`.
* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-windows">windows</h4>

Support for Windows Service Control Manager (SCM). This provider can
start, stop, enable, and disable services, and the SCM provides working
status methods for all services.

Control of service groups (dependencies) is not yet supported, nor is running
services as a specific user.

* Required binaries: `net.exe`.
* Default for `operatingsystem` == `windows`.
* Supported features: `enableable`, `refreshable`.

<h3 id="service-provider-features">Provider Features</h3>

Available features:

* `controllable` --- The provider uses a control variable.
* `enableable` --- The provider can enable and disable the service
* `flaggable` --- The provider can pass flags to the service.
* `maskable` --- The provider can 'mask' the service.
* `refreshable` --- The provider can restart the service.

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>controllable</th>
      <th>enableable</th>
      <th>flaggable</th>
      <th>maskable</th>
      <th>refreshable</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>base</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>bsd</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>daemontools</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>debian</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>freebsd</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>gentoo</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>init</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>launchd</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>openbsd</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>openrc</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>openwrt</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>rcng</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>redhat</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>runit</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>service</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>smf</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>src</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>systemd</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>upstart</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>windows</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
  </tbody>
</table>



> **NOTE:** This page was generated from the Puppet source code on 2017-06-27 17:23:02 -0500