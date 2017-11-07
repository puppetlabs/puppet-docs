---
layout: default
title: Core types cheat sheet
---

[notify]: ./type.html#notify
[file]: ./type.html#file
[package]: ./type.html#package
[service]: ./type.html#service
[exec]: ./type.html#exec
[cron]: ./type.html#cron
[user]: ./type.html#user
[group]: ./type.html#group
[other]: ./type.html

A quick reference guide for the core Puppet types.

For detailed information about these types, see the related topic Type reference.

Related topics:

* [Type reference](./type.html)

{:.concept}
## The Trifecta

Package/file/service: Learn it, live it, love it. Even if this is the only Puppet you know, you can still get a whole lot done.

``` puppet
package { 'openssh-server':
  ensure => installed,
}

file { '/etc/ssh/sshd_config':
  source  => 'puppet:///modules/sshd/sshd_config',
  owner   => 'root',
  group   => 'root',
  mode    => '0640',
  notify  => Service['sshd'], # sshd restarts whenever you edit this file.
  require => Package['openssh-server'],
}

service { 'sshd':
  ensure     => running,
  enable     => true,
}
```

<!--**INSERT PICTURE OF DEPENDENCY GRAPH HERE**-->

{:.concept}
### file

Manages files, directories, and symlinks.

{:.section}
#### Important Attributes

* [`ensure`](./type.html#file-attribute-ensure) -- Whether the file should exist, and what it should be. Allowed values:
    * `file` (a normal file)
    * `directory` (a directory)
    * `link` (a symlink)
    * `present` (anything)
    * `absent`
* [`path`](./type.html#file-attribute-path) -- The full path to the file on disk; **defaults to title.**
* [`owner`](./type.html#file-attribute-owner) -- By name or UID.
* [`group`](./type.html#file-attribute-group) -- By name or GID.
* [`mode`](./type.html#file-attribute-mode) -- Must be specified exactly. Does the right thing for directories.

{:.section}
#### For Normal Files

* [`source`](./type.html#file-attribute-source) -- Where to download contents for the file. Usually a `puppet:///` URL.
* [`content`](./type.html#file-attribute-content) -- The file's desired contents, as a string. Most useful when paired with [templates](https://docs.puppet.com/guides/templating.html), but you can also use the output of the [file function](./function.html#file).

{:.section}
#### For Directories

* [`source`](./type.html#file-attribute-source) -- Where to download contents for the directory, when `recurse => true`.
* [`recurse`](./type.html#file-attribute-recurse) -- Whether to recursively manage files in the directory.
* [`purge`](./type.html#file-attribute-purge) -- Whether unmanaged files in the directory should be deleted, when `recurse => true`.

{:.section}
#### For Symlinks

* [`target`](./type.html#file-attribute-target) -- The symlink target. (Required when `ensure => link`.)

{:.section}
#### Other Notable Attributes

* [`backup`](./type.html#file-attribute-backup)
* [`checksum`](./type.html#file-attribute-checksum) 
* [`force`](./type.html#file-attribute-force)
* [`ignore`](./type.html#file-attribute-ignore)
* [`links`](./type.html#file-attribute-links)
* [`recurselimit`](./type.html#file-attribute-recurselimit)
* [`replace`](./type.html#file-attribute-replace)

{:.concept}
### package

Manages software packages.

{:.section}
#### Important Attributes

* [`name`](./type.html#package-attribute-name) -- The name of the package, as known to your packaging system; **defaults to title.**
* [`ensure`](./type.html#package-attribute-ensure) -- Whether the package should be installed, and what version to use. Allowed values:
    * `present`
    * `latest` (implies `present`)
    * any version string (implies `present`)
    * `absent`
    * `purged` (Potentially dangerous. Ensures absent, then zaps configuration files and dependencies, including those that other packages depend on. Provider-dependent.)
* [`source`](./type.html#package-attribute-source) -- Where to obtain the package, if your system's packaging tools don't use a repository.
* [`provider`](./type.html#package-attribute-provider) -- Which packaging system to use (e.g. Yum vs. Rubygems), if a system has more than one available.

{:.concept}
### service

Manages services running on the node. Like with packages, some platforms have better tools than others, so read up.

You can make services restart whenever a file changes, with the `subscribe` or `notify` metaparameters. For more info, read the related topic about relationships

Related topics:

* [Relationships](./lang_relationships.html)

{:.section}
#### Important Attributes

* [`name`](./type.html#service-attribute-name) -- The name of the service to run; **defaults to title.**
* [`ensure`](./type.html#service-attribute-ensure) -- The desired status of the service. Allowed values:
    * `running` (or `true`)
    * `stopped` (or `false`)
* [`enable`](./type.html#service-attribute-enable) -- Whether the service should start on boot. Doesn't work on all systems.
* [`hasrestart`](./type.html#service-attribute-hasrestart) -- Whether to use the init script's restart command instead of stop+start. Defaults to false.
* [`hasstatus`](./type.html#service-attribute-hasstatus) -- Whether to use the init script's status command. Defaults to true.

{:.section}
#### Other Notable Attributes

If a service has a bad init script, you can work around it and manage almost anything using the [`status`](./type.html#service-attribute-status), [`start`](./type.html#service-attribute-start), [`stop`](./type.html#service-attribute-stop), [`restart`](./type.html#service-attribute-restart), [`pattern`](./type.html#service-attribute-pattern), and [`binary`](./type.html#service-attribute-binary) attributes.


{:.concept}
## Hello World

{:.concept}
### notify

Logs an arbitrary message, at the `notice` log level. This appears in the POSIX syslog or Windows Event Log on the Puppet agent node and is also logged in reports.

``` puppet
notify { "This message is getting logged on the agent node.": }
```

{:.section}
#### Important Attributes

* [`message`](./type.html#notify-attribute-message) -- **Defaults to title.**

{:.concept}
## Grab bag

{:.concept}
### [exec][]

Executes an arbitrary command on the agent node. When using execs, you must either make sure the command can be safely run multiple times, or specify that it should only run under certain conditions.

{:.section}
#### Important Attributes

* [`command`](./type.html#exec-attribute-command) -- The command to run; **defaults to title.** If this isn't a fully-qualified path, use the `path` attribute.
* [`path`](./type.html#exec-attribute-path) -- Where to look for executables, as a colon-separated list or an array.
* [`returns`](./type.html#exec-attribute-returns) -- Which exit codes indicate success. Defaults to `0`.
* [`environment`](./type.html#exec-attribute-environment) -- An array of environment variables to set (for example, `['MYVAR=somevalue', 'OTHERVAR=othervalue']`).

{:.section}
#### Attributes to Limit When a Command Should Run

* [`creates`](./type.html#exec-attribute-creates) -- A file to look for before running the command. The command only runs if the file doesn’t exist.
* [`refreshonly`](./type.html#exec-attribute-refreshonly) -- If `true`, the command only run if a resource it subscribes to (or a resource which notifies it) has changed.
* [`onlyif`](./type.html#exec-attribute-onlyif) -- A command or array of commands; if any have a non-zero return value, the command won't run.
* [`unless`](./type.html#exec-attribute-unless) -- The opposite of onlyif.

{:.section}
#### Other Notable Attributes:

[`cwd`](./type.html#exec-attribute-cwd), [`group`](./type.html#exec-attribute-group), [`logoutput`](./type.html#exec-attribute-logoutput), , [`timeout`](./type.html#exec-attribute-timeout), [`tries`](./type.html#exec-attribute-tries), [`try_sleep`](./type.html#exec-attribute-try_sleep), [`user`](./type.html#exec-attribute-user).

{:.concept}
### [cron][]

Manages cron jobs. Largely self-explanatory. On Windows, you should use [`scheduled_task`](./type.html#scheduledtask) instead.

    cron { 'logrotate':
      command => "/usr/sbin/logrotate",
      user    => "root",
      hour    => 2,
      minute  => 0,
    }

{:.section}
#### Important Attributes

* [`command`](./type.html#cron-attribute-command) -- The command to execute.
* [`ensure`](./type.html#cron-attribute-ensure) -- Whether the job should exist.
    * present
    * absent
* [`hour`](./type.html#cron-attribute-hour), [`minute`](./type.html#cron-attribute-minute), [`month`](./type.html#cron-attribute-month), [`monthday`](./type.html#cron-attribute-monthday), and [`weekday`](./type.html#cron-attribute-weekday) -- The timing of the cron job.

{:.section}
#### Other Notable Attributes

[`environment`](./type.html#cron-attribute-environment), [`name`](./type.html#cron-attribute-name), [`special`](./type.html#cron-attribute-special), [`target`](./type.html#cron-attribute-target), [`user`](./type.html#cron-attribute-user).

{:.concept}
### [user][]

Manages user accounts; mostly used for system users.

    user { "jane":
        ensure     => present,
        uid        => '507',
        gid        => 'admin',
        shell      => '/bin/zsh',
        home       => '/home/jane',
        managehome => true,
    }

{:.section}
#### Important Attributes

* [`name`](./type.html#user-attribute-name) -- The name of the user; **defaults to title.**
* [`ensure`](./type.html#user-attribute-ensure) -- Whether the user should exist. Allowed values:
    * `present`
    * `absent`
    * `role`
* [`uid`](./type.html#user-attribute-uid) -- The user ID. Must be specified numerically; chosen automatically if omitted. Read-only on Windows.
* [`gid`](./type.html#user-attribute-gid) -- The user’s primary group. Can be specified numerically or by name. (Not used on Windows; use `groups` instead.)
* [`groups`](./type.html#user-attribute-groups) -- An array of other groups to which the user belongs. (Don't include the group specified as the `gid`.)
* [`home`](./type.html#user-attribute-home) -- The user's home directory.
* [`managehome`](./type.html#user-attribute-managehome) -- Whether to manage the home directory when managing the user; if you don't set this to true, you'll need to create the user's home directory manually.
* [`shell`](./type.html#user-attribute-shell) -- The user's login shell.

{:.section}
#### Other Notable Attributes

[`comment`](./type.html#user-attribute-comment), [`expiry`](./type.html#user-attribute-expiry), [`membership`](./type.html#user-attribute-membership), [`password`](./type.html#user-attribute-password), [`password_max_age`](./type.html#user-attribute-password_max_age), [`password_min_age`](./type.html#user-attribute-password_min_age), [`purge_ssh_keys`](./type.html#user-attribute-purge_ssh_keys), [`salt`](./type.html#user-attribute-salt).

{:.concept}
### [group][]

Manages groups.

{:.section}
#### Important Attributes

* [`name`](./type.html#group-attribute-name) -- The name of the group; **defaults to title.**
* [`ensure`](./type.html#group-attribute-ensure) -- Whether the group should exist. Allowed values:
    * `present`
    * `absent`
* [`gid`](./type.html#group-attribute-gid) -- The group ID; must be specified numerically, and is chosen automatically if omitted. Read-only on Windows.
* [`members`](./type.html#group-attribute-members) -- Users and groups that should be members of the group. Only applicable to certain operating systems; see the full type reference for details.
