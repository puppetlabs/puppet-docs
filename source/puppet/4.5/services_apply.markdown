---
layout: default
title: "Puppet's services: Puppet apply"
canonical: "/puppet/latest/services_apply.html"
---


[man]: ./man/apply.html
[resource type reference]: ./type.html
[environments]: ./environments.html
[main manifest]: ./dirs_manifest.html
[manifest_setting]: ./configuration.html#manifest
[env_main_manifest]: ./environments_creating.html#the-main-manifest
[modules]: ./modules_fundamentals.html
[enc]: /guides/external_nodes.html
[http_report]: ./report.html#http
[puppetdb]: {{puppetdb}}/
[report handlers]: ./report.html
[reports_setting]: ./configuration.html#reports
[reports_guide]: /guides/reporting.html
[puppet.conf]: ./config_file_main.html
[short_settings]: ./config_important_settings.html#settings-for-agents-all-nodes

Puppet apply is an application that compiles and manages configurations on nodes. It acts like a self-contained combination of the Puppet master and Puppet agent applications. For more info about Puppet's architecture, see [Overview of Puppet's Architecture](./architecture.html) --- in particular, read the note at the end about [differences and trade-offs between agent/master and puppet apply.](architecture.html#note-differences-between-agentmaster-and-puppet-apply)

For details about invoking the Puppet apply command, see [the puppet apply man page][man].

## Supported platforms

Puppet apply runs similarly on both \*nix and Windows systems.

Not all operating systems can manage the same resources with Puppet; some resource types are OS-specific, and others may have OS-specific features. See the [resource type reference][] for details.

## Puppet apply's run environment

Unlike Puppet agent, Puppet apply never runs as a daemon or service. It always runs as a single task in the foreground, which compiles a catalog, applies it, files a report, and exits.

By default, it never initiates outbound network connections, although it can be configured to do so. It never accepts inbound network connections.

### Main manifest

Like the Puppet master application, Puppet apply uses its [settings][short_settings] (such as `basemodulepath`) and the configured [environments][] to locate the Puppet code and configuration data it will use when compiling a catalog.

The one exception is the [main manifest][]. Puppet apply always requires a single command line argument, which acts as its main manifest. It ignores the [main manifest from its environment][env_main_manifest].

(Alternately, you can write a tiny main manifest directly on the command line, with the `-e` option. See [the puppet apply man page][man] for details.)

### User

Puppet apply runs as whichever user executed the Puppet apply command.

To manage a complete system, you should run Puppet apply as:

* `root` on \*nix systems
* Either `LocalService` or a member of the `Administrators` group on Windows systems

Puppet apply can also run as a non-root user. This will restrict the resources that Puppet can manage (see below).

#### Resource types for non-root Puppet apply runs

When running without root permissions, most of Puppet's resource providers cannot use `sudo` to elevate permissions. This means Puppet can only manage resources that its user can modify without using `sudo`.

Out of the core resource types listed in the [resource type reference][], the following are available to non-root Puppet apply runs:

* `cron` (only non-root cron jobs can be viewed or set)
* `exec` (cannot run as another user or group)
* `file` (only if the non-root user has read/write privileges)
* `notify`
* `schedule`
* `ssh_key`
* `ssh_authorized_key`
* `service` (for services that don't require root. You can also use the `start`, `stop`, and `status` attributes to specify how non-root users should control the service; see [the tips and examples for the `service` type](./resources_service.html) for more info.)
* `augeas`

If you need to install packages into a directory controlled by a non-root user, you can either use an `exec` to unzip a tarball or use a recursive `file` resource to copy a directory into place.

### Network access

By default, Puppet apply does not communicate over the network. It uses its local collection of [modules][] for any file sources, and does not submit reports to a central server.

Depending on your system and the resources you are managing, it may download packages from your configured package repositories or access files on UNC shares.

If you have configured an [external node classifier (ENC)][enc], your ENC script might create an outbound HTTP connection. Additionally, if you've configured [the HTTP report processor][http_report], Puppet agent may send reports via HTTP or HTTPS.

If you have configured [PuppetDB][], Puppet apply will create outbound HTTPS connections to PuppetDB.

### Logging

By default, Puppet apply logs directly to the terminal. This is good for interactive use, and less good when running as a scheduled task or cron job.

You can adjust how verbose the logs are with [the `log_level` setting](./configuration.html#loglevel), which defaults to `notice`. Setting it to `info` is equivalent to running with the `--verbose` option, and setting it to `debug` is equivalent to `--debug`. You can also make logs quieter by dialing back to `warning` or lower.

When started with the `--logdest syslog` option, Puppet apply logs to the \*nix syslog service. Your syslog configuration dictates where these messages will be saved, but the default location is `/var/log/messages` on Linux, `/var/log/system.log` on Mac OS X, and `/var/adm/messages` on Solaris.

When started with the `--logdest eventlog` option, it logs to the Windows Event Log. You can view its logs by browsing the Event Viewer. (Control Panel → System and Security → Administrative Tools → Event Viewer)

When started with the `--logdest <FILE>` option, it logs to the file specified by `<FILE>`.

### Reporting

In addition to local logging, Puppet apply will process a report using its configured [report handlers][], like a Puppet master does. You can enable different reports with [the `reports` setting][reports_setting]; see the [list of available reports][report handlers] for more info. For more about reporting, see [the guide to reporting][reports_guide].

To disable reporting and avoid taking up disk space with the `store` report handler, you can set [`report = false`](./configuration.html#report) in [puppet.conf][].


## Managing systems with Puppet apply

In a normal Puppet site, every node should periodically do configuration runs, to revert unwanted changes and to pick up recent updates.

Since Puppet apply doesn't run as a service, you must manually create a scheduled task or cron job if you want it to run on a regular basis.

On \*nix, you can use the Puppet resource command to set up a cron job. Below is an example that runs Puppet once an hour; adjust the path to the Puppet command if you are not using Puppet Enterprise.

    sudo puppet resource cron puppet-apply ensure=present user=root minute=30 command='/opt/puppetlabs/bin/puppet apply /etc/puppetlabs/puppet/manifests --logdest syslog'

## Configuring Puppet apply

Puppet apply should be configured with [puppet.conf][], using the `[user]` and/or `[main]` section. For notes on which settings are most relevant to puppet apply, see the [short list of important settings][short_settings].
