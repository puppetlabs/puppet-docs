---
layout: default
title: Core types cheat sheet
---

[notify]: ./types/notify.html
[file]: ./types/file.html
[package]: ./types/package.html
[service]: ./types/service.html
[exec]: ./types/exec.html
[cron]: ./types/cron.html
[user]: ./types/user.html
[group]: ./types/group.html
[other]: ./type.html

A quick reference guide for the core Puppet types.

For detailed information about these types, see the related topic Type reference.

Related topics:

-   [Type reference][other]

{:.concept}
## The trifecta

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
  ensure => running,
  enable => true,
}
```

<!--**INSERT PICTURE OF DEPENDENCY GRAPH HERE**-->

{:.concept}
### file

Manages files, directories, and symlinks.

{:.section}
#### Important attributes

-   [`ensure`](./types/file.html#file-attribute-ensure) -- Whether the file should exist, and what it should be. Allowed values:
    -   `file` (a normal file)
    -   `directory` (a directory)
    -   `link` (a symlink)
    -   `present` (anything)
    -   `absent`
-   [`path`](./types/file.html#file-attribute-path) -- The full path to the file on disk; **defaults to title.**
-   [`owner`](./types/file.html#file-attribute-owner) -- By name or UID.
-   [`group`](./types/file.html#file-attribute-group) -- By name or GID.
-   [`mode`](./types/file.html#file-attribute-mode) -- Must be specified exactly. Does the right thing for directories.

{:.section}
#### For normal files

-   [`source`](./types/file.html#file-attribute-source) -- Where to download contents for the file. Usually a `puppet:///` URL.
-   [`content`](./types/file.html#file-attribute-content) -- The file's desired contents, as a string. Most useful when paired with [templates](./lang_template.html), but you can also use the output of the [file function](./function.html#file).

{:.section}
#### For directories

-   [`source`](./types/file.html#file-attribute-source) -- Where to download contents for the directory, when `recurse => true`.
-   [`recurse`](./types/file.html#file-attribute-recurse) -- Whether to recursively manage files in the directory.
-   [`purge`](./types/file.html#file-attribute-purge) -- Whether unmanaged files in the directory should be deleted, when `recurse => true`.

{:.section}
#### For symlinks

-   [`target`](./types/file.html#file-attribute-target) -- The symlink target. (Required when `ensure => link`.)

{:.section}
#### Other notable attributes

-   [`backup`](./types/file.html#file-attribute-backup)
-   [`checksum`](./types/file.html#file-attribute-checksum)
-   [`force`](./types/file.html#file-attribute-force)
-   [`ignore`](./types/file.html#file-attribute-ignore)
-   [`links`](./types/file.html#file-attribute-links)
-   [`recurselimit`](./types/file.html#file-attribute-recurselimit)
-   [`replace`](./types/file.html#file-attribute-replace)

{:.concept}
### package

Manages software packages.

{:.section}
#### Important attributes

-   [`name`](./types/package.html#package-attribute-name) -- The name of the package, as known to your packaging system; **defaults to title.**
-   [`ensure`](./types/package.html#package-attribute-ensure) -- Whether the package should be installed, and what version to use. Allowed values:
    -   `present`
    -   `latest` (implies `present`)
    -   any version string (implies `present`)
    -   `absent`
    -   `purged` (Potentially dangerous. Ensures absent, then zaps configuration files and dependencies, including those that other packages depend on. Provider-dependent.)
-   [`source`](./types/package.html#package-attribute-source) -- Where to obtain the package, if your system's packaging tools don't use a repository.
-   [`provider`](./types/package.html#package-attribute-provider) -- Which packaging system to use (e.g. Yum vs. Rubygems), if a system has more than one available.

{:.concept}
### service

Manages services running on the node. Like with packages, some platforms have better tools than others, so read up.

You can make services restart whenever a file changes, with the `subscribe` or `notify` metaparameters. For more info, read the related topic about relationships

Related topics:

-   [Relationships](./lang_relationships.html)

{:.section}
#### Important attributes

-   [`name`](./types/service.html#service-attribute-name) -- The name of the service to run; **defaults to title.**
-   [`ensure`](./types/service.html#service-attribute-ensure) -- The desired status of the service. Allowed values:
    -   `running` (or `true`)
    -   `stopped` (or `false`)
-   [`enable`](./types/service.html#service-attribute-enable) -- Whether the service should start on boot. Doesn't work on all systems.
-   [`hasrestart`](./types/service.html#service-attribute-hasrestart) -- Whether to use the init script's restart command instead of stop+start. Defaults to false.
-   [`hasstatus`](./types/service.html#service-attribute-hasstatus) -- Whether to use the init script's status command. Defaults to true.

{:.section}
#### Other notable attributes

If a service has a bad init script, you can work around it and manage almost anything using the [`status`](./types/service.html#service-attribute-status), [`start`](./types/service.html#service-attribute-start), [`stop`](./types/service.html#service-attribute-stop), [`restart`](./types/service.html#service-attribute-restart), [`pattern`](./types/service.html#service-attribute-pattern), and [`binary`](./types/service.html#service-attribute-binary) attributes.

{:.concept}
## Hello World

{:.concept}
### notify

Logs an arbitrary message, at the `notice` log level. This appears in the POSIX syslog or Windows Event Log on the Puppet agent node and is also logged in reports.

``` puppet
notify { "This message is getting logged on the agent node.": }
```

{:.section}
#### Important attributes

-   [`message`](./types/notify.html#notify-attribute-message) -- **Defaults to title.**

{:.concept}
## Grab bag

{:.concept}
### [exec][]

Executes an arbitrary command on the agent node. When using execs, you must either make sure the command can be safely run multiple times, or specify that it should only run under certain conditions.

{:.section}
#### Important attributes

-   [`command`](./types/exec.html#exec-attribute-command) -- The command to run; **defaults to title.**   If this isn't a fully-qualified path, use the `path` attribute.
-   [`path`](./types/exec.html#exec-attribute-path) -- Where to look for executables, as a colon-separated list or an array.
-   [`returns`](./types/exec.html#exec-attribute-returns) -- Which exit codes indicate success. Defaults to `0`.
-   [`environment`](./types/exec.html#exec-attribute-environment) -- An array of environment variables to set (for example, `['MYVAR=somevalue', 'OTHERVAR=othervalue']`).

{:.section}
#### Attributes to limit when a command should run

-   [`creates`](./types/exec.html#exec-attribute-creates) -- A file to look for before running the command. The command only runs if the file doesn’t exist.
-   [`refreshonly`](./types/exec.html#exec-attribute-refreshonly) -- If `true`, the command only run if a resource it subscribes to (or a resource which notifies it) has changed.
-   [`onlyif`](./types/exec.html#exec-attribute-onlyif) -- A command or array of commands; if any have a non-zero return value, the command won't run.
-   [`unless`](./types/exec.html#exec-attribute-unless) -- The opposite of onlyif.

{:.section}
#### Other notable attributes

[`cwd`](./types/exec.html#exec-attribute-cwd), [`group`](./types/exec.html#exec-attribute-group), [`logoutput`](./types/exec.html#exec-attribute-logoutput), , [`timeout`](./types/exec.html#exec-attribute-timeout), [`tries`](./types/exec.html#exec-attribute-tries), [`try_sleep`](./types/exec.html#exec-attribute-try_sleep), [`user`](./types/exec.html#exec-attribute-user).

{:.concept}
### [cron][]

Manages cron jobs. Largely self-explanatory. On Windows, you should use [`scheduled_task`](./types/scheduledtask.html) instead.

``` puppet
cron { 'logrotate':
  command => "/usr/sbin/logrotate",
  user    => "root",
  hour    => 2,
  minute  => 0,
}
```

{:.section}
#### Important attributes

-   [`command`](./types/cron.html#cron-attribute-command) -- The command to execute.
-   [`ensure`](./types/cron.html#cron-attribute-ensure) -- Whether the job should exist.
    -   present
    -   absent
-   [`hour`](./types/cron.html#cron-attribute-hour), [`minute`](./types/cron.html#cron-attribute-minute), [`month`](./types/cron.html#cron-attribute-month), [`monthday`](./types/cron.html#cron-attribute-monthday), and [`weekday`](./types/cron.html#cron-attribute-weekday) -- The timing of the cron job.

{:.section}
#### Other notable attributes

[`environment`](./types/cron.html#cron-attribute-environment), [`name`](./types/cron.html#cron-attribute-name), [`special`](./types/cron.html#cron-attribute-special), [`target`](./types/cron.html#cron-attribute-target), [`user`](./types/cron.html#cron-attribute-user).

{:.concept}
### [user][]

Manages user accounts; mostly used for system users.

``` puppet
user { 'jane':
    ensure     => present,
    uid        => '507',
    gid        => 'admin',
    shell      => '/bin/zsh',
    home       => '/home/jane',
    managehome => true,
}
```

{:.section}
#### Important attributes

-   [`name`](./types/user.html#user-attribute-name) -- The name of the user; **defaults to title.**
-   [`ensure`](./types/user.html#user-attribute-ensure) -- Whether the user should exist. Allowed values:
    -   `present`
    -   `absent`
    -   `role`
-   [`uid`](./types/user.html#user-attribute-uid) -- The user ID. Must be specified numerically; chosen automatically if omitted. Read-only on Windows.
-   [`gid`](./types/user.html#user-attribute-gid) -- The user’s primary group. Can be specified numerically or by name. (Not used on Windows; use `groups` instead.)
-   [`groups`](./types/user.html#user-attribute-groups) -- An array of other groups to which the user belongs. (Don't include the group specified as the `gid`.)
-   [`home`](./types/user.html#user-attribute-home) -- The user's home directory.
-   [`managehome`](./types/user.html#user-attribute-managehome) -- Whether to manage the home directory when managing the user; if you don't set this to true, you'll need to create the user's home directory manually.
-   [`shell`](./types/user.html#user-attribute-shell) -- The user's login shell.

{:.section}
#### Other notable attributes

[`comment`](./types/user.html#user-attribute-comment), [`expiry`](./types/user.html#user-attribute-expiry), [`membership`](./types/user.html#user-attribute-membership), [`password`](./types/user.html#user-attribute-password), [`password_max_age`](./types/user.html#user-attribute-password_max_age), [`password_min_age`](./types/user.html#user-attribute-password_min_age), [`purge_ssh_keys`](./types/user.html#user-attribute-purge_ssh_keys), [`salt`](./types/user.html#user-attribute-salt).

{:.concept}
### [group][]

Manages groups.

{:.section}
#### Important attributes

-   [`name`](./types/group.html#group-attribute-name) -- The name of the group; **defaults to title.**
-   [`ensure`](./types/group.html#group-attribute-ensure) -- Whether the group should exist. Allowed values:
    -   `present`
    -   `absent`
-   [`gid`](./types/group.html#group-attribute-gid) -- The group ID; must be specified numerically, and is chosen automatically if omitted. Read-only on Windows.
-   [`members`](./types/group.html#group-attribute-members) -- Users and groups that should be members of the group. Only applicable to certain operating systems; see the full type reference for details.
