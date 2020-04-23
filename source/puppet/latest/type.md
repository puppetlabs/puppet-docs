---
layout: default
built_from_commit: 6acf62c4a6573bb3c54e84a875935da7fc71aa0d
title: Resource Type Reference 
canonical: "/puppet/latest/type.html"
toc_levels: 2
toc: columns
---


## About resource types

### Built-in types and custom types

This is the documentation for Puppet's built-in resource types and providers. Additional resource types are distributed in Puppet modules.

You can find and install modules by browsing the
[Puppet Forge](http://forge.puppet.com). See each module's documentation for
information on how to use its custom resource types. For more information about creating custom types, see [Custom resources](/docs/puppet/latest/custom_resources.html).

> As of Puppet 6.0, some resource types were removed from Puppet and repackaged as individual modules. These supported type modules are still included in the `puppet-agent` package, so you don't have to download them from the Forge. See the complete list of affected types in the [supported type modules](#supported-type-modules-in-puppet-agent) section.


### Declaring resources

To manage resources on a target system, declare them in Puppet
manifests. For more details, see
[the resources page of the Puppet language reference.](/docs/puppet/latest/lang_resources.html)

You can also browse and manage resources interactively using the
`puppet resource` subcommand; run `puppet resource --help` for more information.

### Namevars and titles

All types have a special attribute called the _namevar_. This is the attribute
used to uniquely identify a resource on the target system.

Each resource has a specific namevar attribute, which is listed on this page in
each resource's reference. If you don't specify a value for the namevar, its
value defaults to the resource's _title_.

**Example of a title as a default namevar:**

```puppet
file { '/etc/passwd':
  owner => 'root',
  group => 'root',
  mode  => '0644',
}
```

In this code, `/etc/passwd` is the _title_ of the file resource.

The file type's namevar is `path`. Because we didn't provide a `path` value in
this example, the value defaults to the title, `/etc/passwd`.

**Example of a namevar:**

```puppet
file { 'passwords':
  path  => '/etc/passwd',
  owner => 'root',
  group => 'root',
  mode  => '0644',
```

This example is functionally similar to the previous example. Its `path`
namevar attribute has an explicitly set value separate from the title, so
its name is still `/etc/passwd`.

Other Puppet code can refer to this resource as `File['/etc/passwd']` to
declare relationships.

### Attributes, parameters, properties

The _attributes_ (sometimes called _parameters_) of a resource determine its
desired state. They either directly modify the system (internally, these are
called "properties") or they affect how the resource behaves (for instance,
adding a search path for `exec` resources or controlling directory recursion
on `file` resources).

### Providers

_Providers_ implement the same resource type on different kinds of systems.
They usually do this by calling out to external commands.

Although Puppet automatically selects an appropriate default provider, you
can override the default with the `provider` attribute. (For example, `package`
resources on Red Hat systems default to the `yum` provider, but you can specify
`provider => gem` to install Ruby libraries with the `gem` command.)

Providers often specify binaries that they require. Fully qualified binary
paths indicate that the binary must exist at that specific path, and
unqualified paths indicate that Puppet searches for the binary using the
shell path.

### Features

_Features_ are abilities that some providers might not support. Generally, a
feature corresponds to some allowed values for a resource attribute.

This is often the case with the `ensure` attribute. In most types, Puppet
doesn't create new resources when omitting `ensure` but still modifies existing
resources to match specifications in the manifest. However, in some types this
isn't always the case, or additional values provide more granular control. For
example, if a `package` provider supports the `purgeable` feature, you can
specify `ensure => purged` to delete configuration files installed by the
package.

Resource types define the set of features they can use, and providers can
declare which features they provide.

## Puppet 6.0 type changes

In Puppet 6.0, we removed some of Puppet's built-in types and moved them into individual modules.

### Supported type modules in `puppet-agent`

The following types are included in supported modules on the Forge. However, they are also included in the `puppet-agent` package, so you do not have to install them separately. See each module's README for detailed information about that type.

- [`augeas`](https://forge.puppet.com/puppetlabs/augeas_core)
- [`cron`](https://forge.puppet.com/puppetlabs/cron_core)
- [`host`](https://forge.puppet.com/puppetlabs/host_core)
- [`mount`](https://forge.puppet.com/puppetlabs/mount_core)
- [`scheduled_task`](https://forge.puppet.com/puppetlabs/scheduled_task)
- [`selboolean`](https://forge.puppet.com/puppetlabs/selinux_core)
- [`selmodule`](https://forge.puppet.com/puppetlabs/selinux_core)
- [`ssh_authorized_key`](https://forge.puppet.com/puppetlabs/sshkeys_core)
- [`sshkey`](https://forge.puppet.com/puppetlabs/sshkeys_core)
- [`yumrepo`](https://forge.puppet.com/puppetlabs/yumrepo_core)
- [`zfs`](https://forge.puppet.com/puppetlabs/zfs_core)
- [`zone`](https://forge.puppet.com/puppetlabs/zone_core)
- [`zpool`](https://forge.puppet.com/puppetlabs/zfs_core)

### Type modules available on the Forge

The following types are contained in modules that are maintained, but are not repackaged into Puppet agent. If you need to use them, you must install the modules separately. 

- [`k5login`](https://forge.puppet.com/puppetlabs/k5login_core)
- [`mailalias`](https://forge.puppet.com/puppetlabs/mailalias_core)
- [`maillist`](https://forge.puppet.com/puppetlabs/maillist_core)

### Deprecated types

The following types were deprecated with Puppet 6.0.0. They are available in modules, but are not updated. If you need to use them, you must install the modules separately.

- [`computer`](https://forge.puppet.com/puppetlabs/macdslocal_core)
- [`interface`](https://github.com/puppetlabs/puppetlabs-network_device_core) (Use the updated [`cisco_ios module`](https://forge.puppet.com/puppetlabs/cisco_ios/readme) instead.
- [`macauthorization`](https://forge.puppet.com/puppetlabs/macdslocal_core)
- [`mcx`](https://forge.puppet.com/puppetlabs/macdslocal_core)
- [The Nagios types](https://forge.puppet.com/puppetlabs/nagios_core)
- [`router`](https://github.com/puppetlabs/puppetlabs-network_device_core) (Use the updated [`cisco_ios module`](https://forge.puppet.com/puppetlabs/cisco_ios/readme) instead.
- [`vlan`](https://github.com/puppetlabs/puppetlabs-network_device_core) (Use the updated [`cisco_ios module`](https://forge.puppet.com/puppetlabs/cisco_ios/readme) instead.

## Puppet core types

The following types are located in the core Puppet code base.

exec
-----

* [Attributes](#exec-attributes)
* [Providers](#exec-providers)

<h3 id="exec-description">Description</h3>

Executes external commands.

Any command in an `exec` resource **must** be able to run multiple times
without causing harm --- that is, it must be *idempotent*. There are three
main ways for an exec to be idempotent:

* The command itself is already idempotent. (For example, `apt-get update`.)
* The exec has an `onlyif`, `unless`, or `creates` attribute, which prevents
  Puppet from running the command unless some condition is met.
* The exec has `refreshonly => true`, which allows Puppet to run the
  command only when some other resource is changed. (See the notes on refreshing
  below.)

The state managed by an `exec` resource represents whether the specified command
_needs to be_ executed during the catalog run. The target state is always that
the command does not need to be executed. If the initial state is that the
command _does_ need to be executed, then successfully executing the command
transitions it to the target state.

The `unless`, `onlyif`, and `creates` properties check the initial state of the
resource. If one or more of these properties is specified, the exec might not
need to run. If the exec does not need to run, then the system is already in
the target state. In such cases, the exec is considered successful without
actually executing its command.

A caution: There's a widespread tendency to use collections of execs to
manage resources that aren't covered by an existing resource type. This
works fine for simple tasks, but once your exec pile gets complex enough
that you really have to think to understand what's happening, you should
consider developing a custom resource type instead, as it is much
more predictable and maintainable.

**Duplication:** Even though `command` is the namevar, Puppet allows
multiple `exec` resources with the same `command` value.

**Refresh:** `exec` resources can respond to refresh events (via
`notify`, `subscribe`, or the `~>` arrow). The refresh behavior of execs
is non-standard, and can be affected by the `refresh` and
`refreshonly` attributes:

* If `refreshonly` is set to true, the exec runs _only_ when it receives an
  event. This is the most reliable way to use refresh with execs.
* If the exec has already run and then receives an event, it runs its
  command **up to two times.** If an `onlyif`, `unless`, or `creates` condition
  is no longer met after the first run, the second run does not occur.
* If the exec has already run, has a `refresh` command, and receives an
  event, it runs its normal command. Then, if any `onlyif`, `unless`, or `creates`
  conditions are still met, the exec runs its `refresh` command.
* If the exec has an `onlyif`, `unless`, or `creates` attribute that prevents it
  from running, and it then receives an event, it still will not run.
* If the exec has `noop => true`, would otherwise have run, and receives
  an event from a non-noop resource, it runs once. However, if it has a `refresh`
  command, it runs that instead of its normal command.

In short: If there's a possibility of your exec receiving refresh events,
it is extremely important to make sure the run conditions are restricted.

**Autorequires:** If Puppet is managing an exec's cwd or the executable
file used in an exec's command, the exec resource autorequires those
files. If Puppet is managing the user that an exec should run as, the
exec resource autorequires that user.

<h3 id="exec-attributes">Attributes</h3>

<pre><code>exec { 'resource title':
  <a href="#exec-attribute-command">command</a>     =&gt; <em># <strong>(namevar)</strong> The actual command to execute.  Must either be...</em>
  <a href="#exec-attribute-creates">creates</a>     =&gt; <em># A file to look for before running the command...</em>
  <a href="#exec-attribute-cwd">cwd</a>         =&gt; <em># The directory from which to run the command.  If </em>
  <a href="#exec-attribute-environment">environment</a> =&gt; <em># An array of any additional environment variables </em>
  <a href="#exec-attribute-group">group</a>       =&gt; <em># The group to run the command as.  This seems to...</em>
  <a href="#exec-attribute-logoutput">logoutput</a>   =&gt; <em># Whether to log command output in addition to...</em>
  <a href="#exec-attribute-onlyif">onlyif</a>      =&gt; <em># A test command that checks the state of the...</em>
  <a href="#exec-attribute-path">path</a>        =&gt; <em># The search path used for command execution...</em>
  <a href="#exec-attribute-provider">provider</a>    =&gt; <em># The specific backend to use for this `exec...</em>
  <a href="#exec-attribute-refresh">refresh</a>     =&gt; <em># An alternate command to run when the `exec...</em>
  <a href="#exec-attribute-refreshonly">refreshonly</a> =&gt; <em># The command should only be run as a refresh...</em>
  <a href="#exec-attribute-returns">returns</a>     =&gt; <em># The expected exit code(s).  An error will be...</em>
  <a href="#exec-attribute-timeout">timeout</a>     =&gt; <em># The maximum time the command should take.  If...</em>
  <a href="#exec-attribute-tries">tries</a>       =&gt; <em># The number of times execution of the command...</em>
  <a href="#exec-attribute-try_sleep">try_sleep</a>   =&gt; <em># The time to sleep in seconds between 'tries'....</em>
  <a href="#exec-attribute-umask">umask</a>       =&gt; <em># Sets the umask to be used while executing this...</em>
  <a href="#exec-attribute-unless">unless</a>      =&gt; <em># A test command that checks the state of the...</em>
  <a href="#exec-attribute-user">user</a>        =&gt; <em># The user to run the command as.  > **Note:*...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="exec-attribute-command">command</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The actual command to execute.  Must either be fully qualified
or a search path for the command must be provided.  If the command
succeeds, any output produced will be logged at the instance's
normal log level (usually `notice`), but if the command fails
(meaning its return code does not match the specified code) then
any output is logged at the `err` log level.

Multiple `exec` resources can use the same `command` value; Puppet
only uses the resource title to ensure `exec`s are unique.

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-creates">creates</h4>

A file to look for before running the command. The command will
only run if the file **doesn't exist.**

This parameter doesn't cause Puppet to create a file; it is only
useful if **the command itself** creates a file.

    exec { 'tar -xf /Volumes/nfs02/important.tar':
      cwd     => '/var/tmp',
      creates => '/var/tmp/myfile',
      path    => ['/usr/bin', '/usr/sbin',],
    }

In this example, `myfile` is assumed to be a file inside
`important.tar`. If it is ever deleted, the exec will bring it
back by re-extracting the tarball. If `important.tar` does **not**
actually contain `myfile`, the exec will keep running every time
Puppet runs.

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-cwd">cwd</h4>

The directory from which to run the command.  If
this directory does not exist, the command will fail.

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-environment">environment</h4>

An array of any additional environment variables you want to set for a
command, such as `[ 'HOME=/root', 'MAIL=root@example.com']`.
Note that if you use this to set PATH, it will override the `path`
attribute. Multiple environment variables should be specified as an
array.

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-group">group</h4>

The group to run the command as.  This seems to work quite
haphazardly on different platforms -- it is a platform issue
not a Ruby or Puppet one, since the same variety exists when
running commands as different users in the shell.

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-logoutput">logoutput</h4>

Whether to log command output in addition to logging the
exit code. Defaults to `on_failure`, which only logs the output
when the command has an exit code that does not match any value
specified by the `returns` attribute. As with any resource type,
the log level can be controlled with the `loglevel` metaparameter.

Default: `on_failure`

Allowed values:

* `true`
* `false`
* `on_failure`

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-onlyif">onlyif</h4>

A test command that checks the state of the target system and restricts
when the `exec` can run. If present, Puppet runs this test command
first, and only runs the main command if the test has an exit code of 0
(success). For example:

    exec { 'logrotate':
      path     => '/usr/bin:/usr/sbin:/bin',
      provider => shell,
      onlyif   => 'test `du /var/log/messages | cut -f1` -gt 100000',
    }

This would run `logrotate` only if that test returns true.

Note that this test command runs with the same `provider`, `path`, `cwd`, `user`, and `group` as the main command. If the `path` isn't set, you
must fully qualify the command's name.

This parameter can also take an array of commands. For example:

    onlyif => ['test -f /tmp/file1', 'test -f /tmp/file2'],

This `exec` would only run if every command in the array has an
exit code of 0 (success).

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-path">path</h4>

The search path used for command execution.
Commands must be fully qualified if no path is specified.  Paths
can be specified as an array or as a ':' separated list.

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-provider">provider</h4>

The specific backend to use for this `exec`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`posix`](#exec-provider-posix)
* [`shell`](#exec-provider-shell)
* [`windows`](#exec-provider-windows)

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-refresh">refresh</h4>

An alternate command to run when the `exec` receives a refresh event
from another resource. By default, Puppet runs the main command again.
For more details, see the notes about refresh behavior above, in the
description for this resource type.

Note that this alternate command runs with the same `provider`, `path`,
`user`, and `group` as the main command. If the `path` isn't set, you
must fully qualify the command's name.

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-refreshonly">refreshonly</h4>

The command should only be run as a
refresh mechanism for when a dependent object is changed.  It only
makes sense to use this option when this command depends on some
other object; it is useful for triggering an action:

    # Pull down the main aliases file
    file { '/etc/aliases':
      source => 'puppet://server/module/aliases',
    }

    # Rebuild the database, but only when the file changes
    exec { newaliases:
      path        => ['/usr/bin', '/usr/sbin'],
      subscribe   => File['/etc/aliases'],
      refreshonly => true,
    }

Note that only `subscribe` and `notify` can trigger actions, not `require`,
so it only makes sense to use `refreshonly` with `subscribe` or `notify`.

Allowed values:

* `true`
* `false`

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-returns">returns</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The expected exit code(s).  An error will be returned if the
executed command has some other exit code. Can be specified as an array
of acceptable exit codes or a single value.

On POSIX systems, exit codes are always integers between 0 and 255.

On Windows, **most** exit codes should be integers between 0
and 2147483647.

Larger exit codes on Windows can behave inconsistently across different
tools. The Win32 APIs define exit codes as 32-bit unsigned integers, but
both the cmd.exe shell and the .NET runtime cast them to signed
integers. This means some tools will report negative numbers for exit
codes above 2147483647. (For example, cmd.exe reports 4294967295 as -1.)
Since Puppet uses the plain Win32 APIs, it will report the very large
number instead of the negative number, which might not be what you
expect if you got the exit code from a cmd.exe session.

Microsoft recommends against using negative/very large exit codes, and
you should avoid them when possible. To convert a negative exit code to
the positive one Puppet will use, add it to 4294967296.

Default: `0`

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-timeout">timeout</h4>

The maximum time the command should take.  If the command takes
longer than the timeout, the command is considered to have failed
and will be stopped. The timeout is specified in seconds. The default
timeout is 300 seconds and you can set it to 0 to disable the timeout.

Default: `300`

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-tries">tries</h4>

The number of times execution of the command should be tried.
This many attempts will be made to execute the command until an
acceptable return code is returned. Note that the timeout parameter
applies to each try rather than to the complete set of tries.

Default: `1`

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-try_sleep">try_sleep</h4>

The time to sleep in seconds between 'tries'.

Default: `0`

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-umask">umask</h4>

Sets the umask to be used while executing this command

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-unless">unless</h4>

A test command that checks the state of the target system and restricts
when the `exec` can run. If present, Puppet runs this test command
first, then runs the main command unless the test has an exit code of 0
(success). For example:

    exec { '/bin/echo root >> /usr/lib/cron/cron.allow':
      path   => '/usr/bin:/usr/sbin:/bin',
      unless => 'grep root /usr/lib/cron/cron.allow 2>/dev/null',
    }

This would add `root` to the cron.allow file (on Solaris) unless
`grep` determines it's already there.

Note that this test command runs with the same `provider`, `path`, `cwd`, `user`, and `group` as the main command. If the `path` isn't set, you
must fully qualify the command's name.

This parameter can also take an array of commands. For example:

    unless => ['test -f /tmp/file1', 'test -f /tmp/file2'],

This `exec` runs only if every command in the array has a
non-zero exit code.

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-user">user</h4>

The user to run the command as.

> **Note:** Puppet cannot execute commands as other users on Windows.

Note that if you use this attribute, any error output is not captured
due to a bug within Ruby. If you use Puppet to create this user, the
exec automatically requires the user, as long as it is specified by
name.

The $HOME environment variable is not automatically set when using
this attribute.

([↑ Back to exec attributes](#exec-attributes))


<h3 id="exec-providers">Providers</h3>

<h4 id="exec-provider-posix">posix</h4>

Executes external binaries directly, without passing through a shell or
performing any interpolation. This is a safer and more predictable way
to execute most commands, but prevents the use of globbing and shell
built-ins (including control logic like "for" and "if" statements).

* Confined to: `feature == posix`
* Default for: `feature` == `posix`

<h4 id="exec-provider-shell">shell</h4>

Passes the provided command through `/bin/sh`; only available on
POSIX systems. This allows the use of shell globbing and built-ins, and
does not require that the path to a command be fully-qualified. Although
this can be more convenient than the `posix` provider, it also means that
you need to be more careful with escaping; as ever, with great power comes
etc. etc.

This provider closely resembles the behavior of the `exec` type
in Puppet 0.25.x.

* Confined to: `feature == posix`

<h4 id="exec-provider-windows">windows</h4>

Execute external binaries on Windows systems. As with the `posix`
provider, this provider directly calls the command with the arguments
given, without passing it through a shell or performing any interpolation.
To use shell built-ins --- that is, to emulate the `shell` provider on
Windows --- a command must explicitly invoke the shell:

    exec {'echo foo':
      command => 'cmd.exe /c echo "foo"',
    }

If no extension is specified for a command, Windows will use the `PATHEXT`
environment variable to locate the executable.

**Note on PowerShell scripts:** PowerShell's default `restricted`
execution policy doesn't allow it to run saved scripts. To run PowerShell
scripts, specify the `remotesigned` execution policy as part of the
command:

    exec { 'test':
      path    => 'C:/Windows/System32/WindowsPowerShell/v1.0',
      command => 'powershell -executionpolicy remotesigned -file C:/test.ps1',
    }

* Confined to: `operatingsystem == windows`
* Default for: `["operatingsystem", "windows"] == `

file
-----

* [Attributes](#file-attributes)
* [Providers](#file-providers)
* [Provider Features](#file-provider-features)

<h3 id="file-description">Description</h3>

Manages files, including their content, ownership, and permissions.

The `file` type can manage normal files, directories, and symlinks; the
type should be specified in the `ensure` attribute.

File contents can be managed directly with the `content` attribute, or
downloaded from a remote source using the `source` attribute; the latter
can also be used to recursively serve directories (when the `recurse`
attribute is set to `true` or `local`). On Windows, note that file
contents are managed in binary mode; Puppet never automatically translates
line endings.

**Autorequires:** If Puppet is managing the user or group that owns a
file, the file resource will autorequire them. If Puppet is managing any
parent directories of a file, the file resource autorequires them.

Warning: Enabling `recurse` on directories containing large numbers of
files slows agent runs. To manage file attributes for many files,
consider using alternative methods such as the `chmod_r`, `chown_r`,
 or `recursive_file_permissions` modules from the Forge.

<h3 id="file-attributes">Attributes</h3>

<pre><code>file { 'resource title':
  <a href="#file-attribute-path">path</a>                    =&gt; <em># <strong>(namevar)</strong> The path to the file to manage.  Must be fully...</em>
  <a href="#file-attribute-ensure">ensure</a>                  =&gt; <em># Whether the file should exist, and if so what...</em>
  <a href="#file-attribute-backup">backup</a>                  =&gt; <em># Whether (and how) file content should be backed...</em>
  <a href="#file-attribute-checksum">checksum</a>                =&gt; <em># The checksum type to use when determining...</em>
  <a href="#file-attribute-checksum_value">checksum_value</a>          =&gt; <em># The checksum of the source contents. Only md5...</em>
  <a href="#file-attribute-content">content</a>                 =&gt; <em># The desired contents of a file, as a string...</em>
  <a href="#file-attribute-ctime">ctime</a>                   =&gt; <em># A read-only state to check the file ctime. On...</em>
  <a href="#file-attribute-force">force</a>                   =&gt; <em># Perform the file operation even if it will...</em>
  <a href="#file-attribute-group">group</a>                   =&gt; <em># Which group should own the file.  Argument can...</em>
  <a href="#file-attribute-ignore">ignore</a>                  =&gt; <em># A parameter which omits action on files matching </em>
  <a href="#file-attribute-links">links</a>                   =&gt; <em># How to handle links during file actions.  During </em>
  <a href="#file-attribute-mode">mode</a>                    =&gt; <em># The desired permissions mode for the file, in...</em>
  <a href="#file-attribute-mtime">mtime</a>                   =&gt; <em># A read-only state to check the file mtime. On...</em>
  <a href="#file-attribute-owner">owner</a>                   =&gt; <em># The user to whom the file should belong....</em>
  <a href="#file-attribute-provider">provider</a>                =&gt; <em># The specific backend to use for this `file...</em>
  <a href="#file-attribute-purge">purge</a>                   =&gt; <em># Whether unmanaged files should be purged. This...</em>
  <a href="#file-attribute-recurse">recurse</a>                 =&gt; <em># Whether to recursively manage the _contents_ of...</em>
  <a href="#file-attribute-recurselimit">recurselimit</a>            =&gt; <em># How far Puppet should descend into...</em>
  <a href="#file-attribute-replace">replace</a>                 =&gt; <em># Whether to replace a file or symlink that...</em>
  <a href="#file-attribute-selinux_ignore_defaults">selinux_ignore_defaults</a> =&gt; <em># If this is set then Puppet will not ask SELinux...</em>
  <a href="#file-attribute-selrange">selrange</a>                =&gt; <em># What the SELinux range component of the context...</em>
  <a href="#file-attribute-selrole">selrole</a>                 =&gt; <em># What the SELinux role component of the context...</em>
  <a href="#file-attribute-seltype">seltype</a>                 =&gt; <em># What the SELinux type component of the context...</em>
  <a href="#file-attribute-seluser">seluser</a>                 =&gt; <em># What the SELinux user component of the context...</em>
  <a href="#file-attribute-show_diff">show_diff</a>               =&gt; <em># Whether to display differences when the file...</em>
  <a href="#file-attribute-source">source</a>                  =&gt; <em># A source file, which will be copied into place...</em>
  <a href="#file-attribute-source_permissions">source_permissions</a>      =&gt; <em># Whether (and how) Puppet should copy owner...</em>
  <a href="#file-attribute-sourceselect">sourceselect</a>            =&gt; <em># Whether to copy all valid sources, or just the...</em>
  <a href="#file-attribute-staging_location">staging_location</a>        =&gt; <em># When rendering a file first render it to this...</em>
  <a href="#file-attribute-target">target</a>                  =&gt; <em># The target for creating a link.  Currently...</em>
  <a href="#file-attribute-type">type</a>                    =&gt; <em># A read-only state to check the file...</em>
  <a href="#file-attribute-validate_cmd">validate_cmd</a>            =&gt; <em># A command for validating the file's syntax...</em>
  <a href="#file-attribute-validate_replacement">validate_replacement</a>    =&gt; <em># The replacement string in a `validate_cmd` that...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="file-attribute-path">path</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The path to the file to manage.  Must be fully qualified.

On Windows, the path should include the drive letter and should use `/` as
the separator character (rather than `\\`).

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether the file should exist, and if so what kind of file it should be.
Possible values are `present`, `absent`, `file`, `directory`, and `link`.

* `present` accepts any form of file existence, and creates a
  normal file if the file is missing. (The file will have no content
  unless the `content` or `source` attribute is used.)
* `absent` ensures the file doesn't exist, and deletes it if necessary.
* `file` ensures it's a normal file, and enables use of the `content` or
  `source` attribute.
* `directory` ensures it's a directory, and enables use of the `source`,
  `recurse`, `recurselimit`, `ignore`, and `purge` attributes.
* `link` ensures the file is a symlink, and **requires** that you also
  set the `target` attribute. Symlinks are supported on all Posix
  systems and on Windows Vista / 2008 and higher. On Windows, managing
  symlinks requires Puppet agent's user account to have the "Create
  Symbolic Links" privilege; this can be configured in the "User Rights
  Assignment" section in the Windows policy editor. By default, Puppet
  agent runs as the Administrator account, which has this privilege.

Puppet avoids destroying directories unless the `force` attribute is set
to `true`. This means that if a file is currently a directory, setting
`ensure` to anything but `directory` or `present` will cause Puppet to
skip managing the resource and log either a notice or an error.

There is one other non-standard value for `ensure`. If you specify the
path to another file as the ensure value, it is equivalent to specifying
`link` and using that path as the `target`:

    # Equivalent resources:

    file { '/etc/inetd.conf':
      ensure => '/etc/inet/inetd.conf',
    }

    file { '/etc/inetd.conf':
      ensure => link,
      target => '/etc/inet/inetd.conf',
    }

However, we recommend using `link` and `target` explicitly, since this
behavior can be harder to read and is
[deprecated](https://docs.puppet.com/puppet/4.3/deprecated_language.html)
as of Puppet 4.3.0.

Valid values are `absent` (also called `false`), `file`, `present`, `directory`, `link`. Values can match `/./`.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-backup">backup</h4>

Whether (and how) file content should be backed up before being replaced.
This attribute works best as a resource default in the site manifest
(`File { backup => main }`), so it can affect all file resources.

* If set to `false`, file content won't be backed up.
* If set to a string beginning with `.`, such as `.puppet-bak`, Puppet will
  use copy the file in the same directory with that value as the extension
  of the backup. (A value of `true` is a synonym for `.puppet-bak`.)
* If set to any other string, Puppet will try to back up to a filebucket
  with that title. See the `filebucket` resource type for more details.
  (This is the preferred method for backup, since it can be centralized
  and queried.)

Default value: `puppet`, which backs up to a filebucket of the same name.
(Puppet automatically creates a **local** filebucket named `puppet` if one
doesn't already exist.)

Backing up to a local filebucket isn't particularly useful. If you want
to make organized use of backups, you will generally want to use the
puppet master server's filebucket service. This requires declaring a
filebucket resource and a resource default for the `backup` attribute
in site.pp:

    # /etc/puppetlabs/puppet/manifests/site.pp
    filebucket { 'main':
      path   => false,                # This is required for remote filebuckets.
      server => 'puppet.example.com', # Optional; defaults to the configured puppet master.
    }

    File { backup => main, }

If you are using multiple puppet master servers, you will want to
centralize the contents of the filebucket. Either configure your load
balancer to direct all filebucket traffic to a single master, or use
something like an out-of-band rsync task to synchronize the content on all
masters.

Default: `puppet`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-checksum">checksum</h4>

The checksum type to use when determining whether to replace a file's contents.

The default checksum type is md5.

Allowed values:

* `md5`
* `md5lite`
* `sha224`
* `sha256`
* `sha256lite`
* `sha384`
* `sha512`
* `mtime`
* `ctime`
* `none`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-checksum_value">checksum_value</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The checksum of the source contents. Only md5, sha256, sha224, sha384 and sha512
are supported when specifying this parameter. If this parameter is set,
source_permissions will be assumed to be false, and ownership and permissions
will not be read from source.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-content">content</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The desired contents of a file, as a string. This attribute is mutually
exclusive with `source` and `target`.

Newlines and tabs can be specified in double-quoted strings using
standard escaped syntax --- \n for a newline, and \t for a tab.

With very small files, you can construct content strings directly in
the manifest...

    define resolve($nameserver1, $nameserver2, $domain, $search) {
        $str = "search ${search}
            domain ${domain}
            nameserver ${nameserver1}
            nameserver ${nameserver2}
            "

        file { '/etc/resolv.conf':
          content => $str,
        }
    }

...but for larger files, this attribute is more useful when combined with the
[template](https://puppet.com/docs/puppet/latest/function.html#template)
or [file](https://puppet.com/docs/puppet/latest/function.html#file)
function.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-ctime">ctime</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A read-only state to check the file ctime. On most modern \*nix-like
systems, this is the time of the most recent change to the owner, group,
permissions, or content of the file.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-force">force</h4>

Perform the file operation even if it will destroy one or more directories.
You must use `force` in order to:

* `purge` subdirectories
* Replace directories with files or links
* Remove a directory when `ensure => absent`

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-group">group</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Which group should own the file.  Argument can be either a group
name or a group ID.

On Windows, a user (such as "Administrator") can be set as a file's group
and a group (such as "Administrators") can be set as a file's owner;
however, a file's owner and group shouldn't be the same. (If the owner
is also the group, files with modes like `"0640"` will cause log churn, as
they will always appear out of sync.)

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-ignore">ignore</h4>

A parameter which omits action on files matching
specified patterns during recursion.  Uses Ruby's builtin globbing
engine, so shell metacharacters such as `[a-z]*` are fully supported.
Matches that would descend into the directory structure are ignored,
such as `*/*`.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-links">links</h4>

How to handle links during file actions.  During file copying,
`follow` will copy the target file instead of the link and `manage`
will copy the link itself. When not copying, `manage` will manage
the link, and `follow` will manage the file to which the link points.

Default: `manage`

Allowed values:

* `follow`
* `manage`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-mode">mode</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The desired permissions mode for the file, in symbolic or numeric
notation. This value **must** be specified as a string; do not use
un-quoted numbers to represent file modes.

If the mode is omitted (or explicitly set to `undef`), Puppet does not
enforce permissions on existing files and creates new files with
permissions of `0644`.

The `file` type uses traditional Unix permission schemes and translates
them to equivalent permissions for systems which represent permissions
differently, including Windows. For detailed ACL controls on Windows,
you can leave `mode` unmanaged and use
[the puppetlabs/acl module.](https://forge.puppetlabs.com/puppetlabs/acl)

Numeric modes should use the standard octal notation of
`<SETUID/SETGID/STICKY><OWNER><GROUP><OTHER>` (for example, "0644").

* Each of the "owner," "group," and "other" digits should be a sum of the
  permissions for that class of users, where read = 4, write = 2, and
  execute/search = 1.
* The setuid/setgid/sticky digit is also a sum, where setuid = 4, setgid = 2,
  and sticky = 1.
* The setuid/setgid/sticky digit is optional. If it is absent, Puppet will
  clear any existing setuid/setgid/sticky permissions. (So to make your intent
  clear, you should use at least four digits for numeric modes.)
* When specifying numeric permissions for directories, Puppet sets the search
  permission wherever the read permission is set.

Symbolic modes should be represented as a string of comma-separated
permission clauses, in the form `<WHO><OP><PERM>`:

* "Who" should be any combination of u (user), g (group), and o (other), or a (all)
* "Op" should be = (set exact permissions), + (add select permissions),
  or - (remove select permissions)
* "Perm" should be one or more of:
    * r (read)
    * w (write)
    * x (execute/search)
    * t (sticky)
    * s (setuid/setgid)
    * X (execute/search if directory or if any one user can execute)
    * u (user's current permissions)
    * g (group's current permissions)
    * o (other's current permissions)

Thus, mode `"0664"` could be represented symbolically as either `a=r,ug+w`
or `ug=rw,o=r`.  However, symbolic modes are more expressive than numeric
modes: a mode only affects the specified bits, so `mode => 'ug+w'` will
set the user and group write bits, without affecting any other bits.

See the manual page for GNU or BSD `chmod` for more details
on numeric and symbolic modes.

On Windows, permissions are translated as follows:

* Owner and group names are mapped to Windows SIDs
* The "other" class of users maps to the "Everyone" SID
* The read/write/execute permissions map to the `FILE_GENERIC_READ`,
  `FILE_GENERIC_WRITE`, and `FILE_GENERIC_EXECUTE` access rights; a
  file's owner always has the `FULL_CONTROL` right
* "Other" users can't have any permissions a file's group lacks,
  and its group can't have any permissions its owner lacks; that is, "0644"
  is an acceptable mode, but "0464" is not.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-mtime">mtime</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A read-only state to check the file mtime. On \*nix-like systems, this
is the time of the most recent change to the content of the file.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-owner">owner</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The user to whom the file should belong.  Argument can be a user name or a
user ID.

On Windows, a group (such as "Administrators") can be set as a file's owner
and a user (such as "Administrator") can be set as a file's group; however,
a file's owner and group shouldn't be the same. (If the owner is also
the group, files with modes like `"0640"` will cause log churn, as they
will always appear out of sync.)

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-provider">provider</h4>

The specific backend to use for this `file`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`posix`](#file-provider-posix)
* [`windows`](#file-provider-windows)

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-purge">purge</h4>

Whether unmanaged files should be purged. This option only makes
sense when `ensure => directory` and `recurse => true`.

* When recursively duplicating an entire directory with the `source`
  attribute, `purge => true` will automatically purge any files
  that are not in the source directory.
* When managing files in a directory as individual resources,
  setting `purge => true` will purge any files that aren't being
  specifically managed.

If you have a filebucket configured, the purged files will be uploaded,
but if you do not, this will destroy data.

Unless `force => true` is set, purging will **not** delete directories,
although it will delete the files they contain.

If `recurselimit` is set and you aren't using `force => true`, purging
will obey the recursion limit; files in any subdirectories deeper than the
limit will be treated as unmanaged and left alone.

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-recurse">recurse</h4>

Whether to recursively manage the _contents_ of a directory. This attribute
is only used when `ensure => directory` is set. The allowed values are:

* `false` --- The default behavior. The contents of the directory will not be
  automatically managed.
* `remote` --- If the `source` attribute is set, Puppet will automatically
  manage the contents of the source directory (or directories), ensuring
  that equivalent files and directories exist on the target system and
  that their contents match.

  Using `remote` will disable the `purge` attribute, but results in faster
  catalog application than `recurse => true`.

  The `source` attribute is mandatory when `recurse => remote`.
* `true` --- If the `source` attribute is set, this behaves similarly to
  `recurse => remote`, automatically managing files from the source directory.

  This also enables the `purge` attribute, which can delete unmanaged
  files from a directory. See the description of `purge` for more details.

  The `source` attribute is not mandatory when using `recurse => true`, so you
  can enable purging in directories where all files are managed individually.

By default, setting recurse to `remote` or `true` manages _all_
subdirectories. You can use the `recurselimit` attribute to limit the
recursion depth.

Allowed values:

* `true`
* `false`
* `remote`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-recurselimit">recurselimit</h4>

How far Puppet should descend into subdirectories, when using
`ensure => directory` and either `recurse => true` or `recurse => remote`.
The recursion limit affects which files will be copied from the `source`
directory, as well as which files can be purged when `purge => true`.

Setting `recurselimit => 0` is the same as setting `recurse => false` ---
Puppet will manage the directory, but all of its contents will be treated
as unmanaged.

Setting `recurselimit => 1` will manage files and directories that are
directly inside the directory, but will not manage the contents of any
subdirectories.

Setting `recurselimit => 2` will manage the direct contents of the
directory, as well as the contents of the _first_ level of subdirectories.

This pattern continues for each incremental value of `recurselimit`.

Allowed values:

* `/^[0-9]+$/`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-replace">replace</h4>

Whether to replace a file or symlink that already exists on the local system but
whose content doesn't match what the `source` or `content` attribute
specifies.  Setting this to false allows file resources to initialize files
without overwriting future changes.  Note that this only affects content;
Puppet will still manage ownership and permissions.

Default: `true`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-selinux_ignore_defaults">selinux_ignore_defaults</h4>

If this is set then Puppet will not ask SELinux (via matchpathcon) to
supply defaults for the SELinux attributes (seluser, selrole,
seltype, and selrange). In general, you should leave this set at its
default and only set it to true when you need Puppet to not try to fix
SELinux labels automatically.

Default: `false`

Allowed values:

* `true`
* `false`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-selrange">selrange</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

What the SELinux range component of the context of the file should be.
Any valid SELinux range component is accepted.  For example `s0` or
`SystemHigh`.  If not specified it defaults to the value returned by
matchpathcon for the file, if any exists.  Only valid on systems with
SELinux support enabled and that have support for MCS (Multi-Category
Security).

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-selrole">selrole</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

What the SELinux role component of the context of the file should be.
Any valid SELinux role component is accepted.  For example `role_r`.
If not specified it defaults to the value returned by matchpathcon for
the file, if any exists.  Only valid on systems with SELinux support
enabled.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-seltype">seltype</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

What the SELinux type component of the context of the file should be.
Any valid SELinux type component is accepted.  For example `tmp_t`.
If not specified it defaults to the value returned by matchpathcon for
the file, if any exists.  Only valid on systems with SELinux support
enabled.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-seluser">seluser</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

What the SELinux user component of the context of the file should be.
Any valid SELinux user component is accepted.  For example `user_u`.
If not specified it defaults to the value returned by matchpathcon for
the file, if any exists.  Only valid on systems with SELinux support
enabled.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-show_diff">show_diff</h4>

Whether to display differences when the file changes, defaulting to
true.  This parameter is useful for files that may contain passwords or
other secret data, which might otherwise be included in Puppet reports or
other insecure outputs.  If the global `show_diff` setting
is false, then no diffs will be shown even if this parameter is true.

Default: `true`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-source">source</h4>

A source file, which will be copied into place on the local system. This
attribute is mutually exclusive with `content` and `target`. Allowed
values are:

* `puppet:` URIs, which point to files in modules or Puppet file server
mount points.
* Fully qualified paths to locally available files (including files on NFS
shares or Windows mapped drives).
* `file:` URIs, which behave the same as local file paths.
* `http:` URIs, which point to files served by common web servers.

The normal form of a `puppet:` URI is:

`puppet:///modules/<MODULE NAME>/<FILE PATH>`

This will fetch a file from a module on the Puppet master (or from a
local module when using Puppet apply). Given a `modulepath` of
`/etc/puppetlabs/code/modules`, the example above would resolve to
`/etc/puppetlabs/code/modules/<MODULE NAME>/files/<FILE PATH>`.

Unlike `content`, the `source` attribute can be used to recursively copy
directories if the `recurse` attribute is set to `true` or `remote`. If
a source directory contains symlinks, use the `links` attribute to
specify whether to recreate links or follow them.

_HTTP_ URIs cannot be used to recursively synchronize whole directory
trees. You cannot use `source_permissions` values other than `ignore`
because HTTP servers do not transfer any metadata that translates to
ownership or permission details.

The `http` source uses the server `Content-MD5` header as a checksum to
determine if the remote file has changed. If the server response does not
include that header, Puppet defaults to using the `Last-Modified` header.

Multiple `source` values can be specified as an array, and Puppet will
use the first source that exists. This can be used to serve different
files to different system types:

    file { '/etc/nfs.conf':
      source => [
        "puppet:///modules/nfs/conf.${host}",
        "puppet:///modules/nfs/conf.${operatingsystem}",
        'puppet:///modules/nfs/conf'
      ]
    }

Alternately, when serving directories recursively, multiple sources can
be combined by setting the `sourceselect` attribute to `all`.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-source_permissions">source_permissions</h4>

Whether (and how) Puppet should copy owner, group, and mode permissions from
the `source` to `file` resources when the permissions are not explicitly
specified. (In all cases, explicit permissions will take precedence.)
Valid values are `use`, `use_when_creating`, and `ignore`:

* `ignore` (the default) will never apply the owner, group, or mode from
  the `source` when managing a file. When creating new files without explicit
  permissions, the permissions they receive will depend on platform-specific
  behavior. On POSIX, Puppet will use the umask of the user it is running as.
  On Windows, Puppet will use the default DACL associated with the user it is
  running as.
* `use` will cause Puppet to apply the owner, group,
  and mode from the `source` to any files it is managing.
* `use_when_creating` will only apply the owner, group, and mode from the
  `source` when creating a file; existing files will not have their permissions
  overwritten.

Default: `ignore`

Allowed values:

* `use`
* `use_when_creating`
* `ignore`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-sourceselect">sourceselect</h4>

Whether to copy all valid sources, or just the first one.  This parameter
only affects recursive directory copies; by default, the first valid
source is the only one used, but if this parameter is set to `all`, then
all valid sources will have all of their contents copied to the local
system. If a given file exists in more than one source, the version from
the earliest source in the list will be used.

Default: `first`

Allowed values:

* `first`
* `all`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-staging_location">staging_location</h4>

When rendering a file first render it to this location. The default
location is the same path as the desired location with a unique filename.
This parameter is useful in conjuction with validate_cmd to test a
file before moving the file to it's final location.
WARNING: File replacement is only guaranteed to be atomic if the staging
location is on the same filesystem as the final location.

([↑ Back to file attributes](#file-attributes))


<h4 id="file-attribute-target">target</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The target for creating a link.  Currently, symlinks are the
only type supported. This attribute is mutually exclusive with `source`
and `content`.

Symlink targets can be relative, as well as absolute:

    # (Useful on Solaris)
    file { '/etc/inetd.conf':
      ensure => link,
      target => 'inet/inetd.conf',
    }

Directories of symlinks can be served recursively by instead using the
`source` attribute, setting `ensure` to `directory`, and setting the
`links` attribute to `manage`.

Allowed values:

* `notlink`
* `/./`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-type">type</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A read-only state to check the file type.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-validate_cmd">validate_cmd</h4>

A command for validating the file's syntax before replacing it. If
Puppet would need to rewrite a file due to new `source` or `content`, it
will check the new content's validity first. If validation fails, the file
resource will fail.

This command must have a fully qualified path, and should contain a
percent (`%`) token where it would expect an input file. It must exit `0`
if the syntax is correct, and non-zero otherwise. The command will be
run on the target system while applying the catalog, not on the puppet master.

Example:

    file { '/etc/apache2/apache2.conf':
      content      => 'example',
      validate_cmd => '/usr/sbin/apache2 -t -f %',
    }

This would replace apache2.conf only if the test returned true.

Note that if a validation command requires a `%` as part of its text,
you can specify a different placeholder token with the
`validate_replacement` attribute.

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-validate_replacement">validate_replacement</h4>

The replacement string in a `validate_cmd` that will be replaced
with an input file name.

Default: `%`

([↑ Back to file attributes](#file-attributes))


<h3 id="file-providers">Providers</h3>

<h4 id="file-provider-posix">posix</h4>

Uses POSIX functionality to manage file ownership and permissions.

* Confined to: `feature == posix`
* Supported features: `manages_symlinks`

<h4 id="file-provider-windows">windows</h4>

Uses Microsoft Windows functionality to manage file ownership and permissions.

* Confined to: `operatingsystem == windows`
* Supported features: `manages_symlinks`

<h3 id="file-provider-features">Provider Features</h3>

Available features:

* `manages_symlinks` --- The provider can manage symbolic links.

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>manages symlinks</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>posix</td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>windows</td>
      <td> </td>
    </tr>
  </tbody>
</table>

