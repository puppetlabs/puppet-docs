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
* The exec has `refreshonly => true`, which only allows Puppet to run the
  command when some other resource is changed. (See the notes on refreshing
  below.)

A caution: There's a widespread tendency to use collections of execs to
manage resources that aren't covered by an existing resource type. This
works fine for simple tasks, but once your exec pile gets complex enough
that you really have to think to understand what's happening, you should
consider developing a custom resource type instead, as it will be much
more predictable and maintainable.

**Refresh:** `exec` resources can respond to refresh events (via
`notify`, `subscribe`, or the `~>` arrow). The refresh behavior of execs
is non-standard, and can be affected by the `refresh` and
`refreshonly` attributes:

* If `refreshonly` is set to true, the exec will _only_ run when it receives an
  event. This is the most reliable way to use refresh with execs.
* If the exec already would have run and receives an event, it will run its
  command **up to two times.** (If an `onlyif`, `unless`, or `creates` condition
  is no longer met after the first run, the second run will not occur.)
* If the exec already would have run, has a `refresh` command, and receives an
  event, it will run its normal command, then run its `refresh` command
  (as long as any `onlyif`, `unless`, or `creates` conditions are still met
  after the normal command finishes).
* If the exec would **not** have run (due to an `onlyif`, `unless`, or `creates`
  attribute) and receives an event, it still will not run.
* If the exec has `noop => true`, would otherwise have run, and receives
  an event from a non-noop resource, it will run once (or run its `refresh`
  command instead, if it has one).

In short: If there's a possibility of your exec receiving refresh events,
it becomes doubly important to make sure the run conditions are restricted.

**Autorequires:** If Puppet is managing an exec's cwd or the executable
file used in an exec's command, the exec resource will autorequire those
files. If Puppet is managing the user that an exec should run as, the
exec resource will autorequire that user.

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
parent directories of a file, the file resource will autorequire them.

Warning: Enabling `recurse` on directories containing large numbers of files slows agent runs. To manage file attributes for many files, consider using alternative methods such as the `chmod_r`, `chown_r`, or `recursive_file_permissions` modules from the Forge.

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

Valid values are `md5`, `md5lite`, `sha224`, `sha256`, `sha256lite`, `sha384`, `sha512`, `mtime`, `ctime`, `none`.

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

* `true` or `yes`
* `false` or `no`

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

* "Who" should be u (user), g (group), o (other), and/or a (all)
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

* `true` or `yes`
* `false` or `no`

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

* `true` or `yes`
* `false` or `no`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-selinux_ignore_defaults">selinux_ignore_defaults</h4>

If this is set then Puppet will not ask SELinux (via matchpathcon) to
supply defaults for the SELinux attributes (seluser, selrole,
seltype, and selrange). In general, you should leave this set at its
default and only set it to true when you need Puppet to not try to fix
SELinux labels automatically.

Valid values are `true`, `false`.

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

* `true` or `yes`
* `false` or `no`

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
* `http:` URIs, which point to files served by common web servers

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

*HTTP* URIs cannot be used to recursively synchronize whole directory
trees. It is also not possible to use `source_permissions` values other
than `ignore`. That's because HTTP servers do not transfer any metadata
that translates to ownership or permission details.

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

Valid values are `use`, `use_when_creating`, `ignore`.

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
      <td><em>X</em> </td>
    </tr>
  </tbody>
</table>

filebucket
-----

* [Attributes](#filebucket-attributes)

<h3 id="filebucket-description">Description</h3>

A repository for storing and retrieving file content by MD5 checksum. Can
be local to each agent node, or centralized on a puppet master server. All
puppet masters provide a filebucket service that agent nodes can access
via HTTP, but you must declare a filebucket resource before any agents
will do so.

Filebuckets are used for the following features:

- **Content backups.** If the `file` type's `backup` attribute is set to
  the name of a filebucket, Puppet will back up the _old_ content whenever
  it rewrites a file; see the documentation for the `file` type for more
  details. These backups can be used for manual recovery of content, but
  are more commonly used to display changes and differences in a tool like
  Puppet Dashboard.

To use a central filebucket for backups, you will usually want to declare
a filebucket resource and a resource default for the `backup` attribute
in site.pp:

    # /etc/puppetlabs/puppet/manifests/site.pp
    filebucket { 'main':
      path   => false,                # This is required for remote filebuckets.
      server => 'puppet.example.com', # Optional; defaults to the configured puppet master.
    }

    File { backup => main, }

Puppet master servers automatically provide the filebucket service, so
this will work in a default configuration. If you have a heavily
restricted `auth.conf` file, you may need to allow access to the
`file_bucket_file` endpoint.

<h3 id="filebucket-attributes">Attributes</h3>

<pre><code>filebucket { 'resource title':
  <a href="#filebucket-attribute-name">name</a>   =&gt; <em># <strong>(namevar)</strong> The name of the...</em>
  <a href="#filebucket-attribute-path">path</a>   =&gt; <em># The path to the _local_ filebucket; defaults to...</em>
  <a href="#filebucket-attribute-port">port</a>   =&gt; <em># The port on which the remote server is...</em>
  <a href="#filebucket-attribute-server">server</a> =&gt; <em># The server providing the remote filebucket...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="filebucket-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the filebucket.

([↑ Back to filebucket attributes](#filebucket-attributes))

<h4 id="filebucket-attribute-path">path</h4>

The path to the _local_ filebucket; defaults to the value of the
`clientbucketdir` setting.  To use a remote filebucket, you _must_ set
this attribute to `false`.

([↑ Back to filebucket attributes](#filebucket-attributes))

<h4 id="filebucket-attribute-port">port</h4>

The port on which the remote server is listening.

This setting is _only_ consulted if the `path` attribute is set to `false`.

If this attribute is not specified, the first entry in the `server_list`
configuration setting is used, followed by the value of the `masterport`
setting if `server_list` is not set.

([↑ Back to filebucket attributes](#filebucket-attributes))

<h4 id="filebucket-attribute-server">server</h4>

The server providing the remote filebucket service. Defaults to the
value of the `server` setting (that is, the currently configured
puppet master server).

This setting is consulted only if the `path` attribute is set to `false`.

If this attribute is not specified, the first entry in the `server_list`
configuration setting is used, followed by the value of the `server` setting
if `server_list` is not set.

([↑ Back to filebucket attributes](#filebucket-attributes))


group
-----

* [Attributes](#group-attributes)
* [Providers](#group-providers)
* [Provider Features](#group-provider-features)

<h3 id="group-description">Description</h3>

Manage groups. On most platforms this can only create groups.
Group membership must be managed on individual users.

On some platforms such as OS X, group membership is managed as an
attribute of the group, not the user record. Providers must have
the feature 'manages_members' to manage the 'members' property of
a group record.

<h3 id="group-attributes">Attributes</h3>

<pre><code>group { 'resource title':
  <a href="#group-attribute-name">name</a>                 =&gt; <em># <strong>(namevar)</strong> The group name. While naming limitations vary by </em>
  <a href="#group-attribute-ensure">ensure</a>               =&gt; <em># Create or remove the group.  Default: `present`  </em>
  <a href="#group-attribute-allowdupe">allowdupe</a>            =&gt; <em># Whether to allow duplicate GIDs.  Default...</em>
  <a href="#group-attribute-attribute_membership">attribute_membership</a> =&gt; <em># AIX only. Configures the behavior of the...</em>
  <a href="#group-attribute-attributes">attributes</a>           =&gt; <em># Specify group AIX attributes, as an array of...</em>
  <a href="#group-attribute-auth_membership">auth_membership</a>      =&gt; <em># Configures the behavior of the `members...</em>
  <a href="#group-attribute-forcelocal">forcelocal</a>           =&gt; <em># Forces the management of local accounts when...</em>
  <a href="#group-attribute-gid">gid</a>                  =&gt; <em># The group ID.  Must be specified numerically....</em>
  <a href="#group-attribute-ia_load_module">ia_load_module</a>       =&gt; <em># The name of the I&A module to use to manage this </em>
  <a href="#group-attribute-members">members</a>              =&gt; <em># The members of the group. For platforms or...</em>
  <a href="#group-attribute-provider">provider</a>             =&gt; <em># The specific backend to use for this `group...</em>
  <a href="#group-attribute-system">system</a>               =&gt; <em># Whether the group is a system group with lower...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="group-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The group name. While naming limitations vary by operating system,
it is advisable to restrict names to the lowest common denominator,
which is a maximum of 8 characters beginning with a letter.

Note that Puppet considers group names to be case-sensitive, regardless
of the platform's own rules; be sure to always use the same case when
referring to a given group.

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Create or remove the group.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-allowdupe">allowdupe</h4>

Whether to allow duplicate GIDs.

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-attribute_membership">attribute_membership</h4>

AIX only. Configures the behavior of the `attributes` parameter.

* `minimum` (default) --- The provided list of attributes is partial, and Puppet
  **ignores** any attributes that aren't listed there.
* `inclusive` --- The provided list of attributes is comprehensive, and
  Puppet **purges** any attributes that aren't listed there.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-attributes">attributes</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Specify group AIX attributes, as an array of `'key=value'` strings. This
parameter's behavior can be configured with `attribute_membership`.

Requires features manages_aix_lam.

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-auth_membership">auth_membership</h4>

Configures the behavior of the `members` parameter.

* `false` (default) --- The provided list of group members is partial,
  and Puppet **ignores** any members that aren't listed there.
* `true` --- The provided list of of group members is comprehensive, and
  Puppet **purges** any members that aren't listed there.

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-forcelocal">forcelocal</h4>

Forces the management of local accounts when accounts are also
being managed by some other NSS.

Default: `false`

Allowed values:

* `true` or `yes`
* `false` or `no`

Requires features libuser.

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-gid">gid</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The group ID.  Must be specified numerically.  If no group ID is
specified when creating a new group, then one will be chosen
automatically according to local system standards. This will likely
result in the same group having different GIDs on different systems,
which is not recommended.

On Windows, this property is read-only and will return the group's security
identifier (SID).

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-ia_load_module">ia_load_module</h4>

The name of the I&A module to use to manage this user

Requires features manages_aix_lam.

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-members">members</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The members of the group. For platforms or directory services where group
membership is stored in the group objects, not the users. This parameter's
behavior can be configured with `auth_membership`.

Requires features manages_members.

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-provider">provider</h4>

The specific backend to use for this `group`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`aix`](#group-provider-aix)
* [`directoryservice`](#group-provider-directoryservice)
* [`groupadd`](#group-provider-groupadd)
* [`ldap`](#group-provider-ldap)
* [`pw`](#group-provider-pw)
* [`windows_adsi`](#group-provider-windows_adsi)

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-system">system</h4>

Whether the group is a system group with lower GID.

Default: `false`

Allowed values:

* `true` or `yes`
* `false` or `no`

([↑ Back to group attributes](#group-attributes))


<h3 id="group-providers">Providers</h3>

<h4 id="group-provider-aix">aix</h4>

Group management for AIX.

* Required binaries: `/usr/sbin/lsgroup`, `/usr/bin/mkgroup`, `/usr/sbin/rmgroup`, `/usr/bin/chgroup`
* Confined to: `operatingsystem == aix`
* Default for: `operatingsystem` == `aix`
* Supported features: `manages_aix_lam`, `manages_members`

<h4 id="group-provider-directoryservice">directoryservice</h4>

Group management using DirectoryService on OS X.

* Required binaries: `/usr/bin/dscl`
* Confined to: `operatingsystem == darwin`
* Default for: `operatingsystem` == `darwin`
* Supported features: `manages_members`

<h4 id="group-provider-groupadd">groupadd</h4>

Group management via `groupadd` and its ilk. The default for most platforms.

* Required binaries: `groupadd`, `groupdel`, `groupmod`
* Supported features: `system_groups`

<h4 id="group-provider-ldap">ldap</h4>

Group management via LDAP.

This provider requires that you have valid values for all of the
LDAP-related settings in `puppet.conf`, including `ldapbase`.  You will
almost definitely need settings for `ldapuser` and `ldappassword` in order
for your clients to write to LDAP.

Note that this provider will automatically generate a GID for you if you do
not specify one, but it is a potentially expensive operation, as it
iterates across all existing groups to pick the appropriate next one.

* Confined to: `feature == ldap`, `false == (Puppet[:ldapuser] == "")`

<h4 id="group-provider-pw">pw</h4>

Group management via `pw` on FreeBSD and DragonFly BSD.

* Required binaries: `pw`
* Confined to: `operatingsystem == [:freebsd, :dragonfly]`
* Default for `operatingsystem` == `freebsd, dragonfly`.
* Supported features: `manages_members`.

<h4 id="group-provider-windows_adsi">windows_adsi</h4>

Local group management for Windows. Group members can be both users and groups.
Additionally, local groups can contain domain users.

* Confined to: `operatingsystem == windows`
* Default for: `operatingsystem` == `windows`
* Supported features: `manages_members`.

<h3 id="group-provider-features">Provider Features</h3>

Available features:

* `libuser` --- Allows local groups to be managed on systems that also use some other remote NSS method of managing accounts.
* `manages_aix_lam` --- The provider can manage AIX Loadable Authentication Module (LAM) system.
* `manages_members` --- For directories where membership is an attribute of groups not users.
* `system_groups` --- The provider allows you to create system groups with lower GIDs.

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>libuser</th>
      <th>manages aix lam</th>
      <th>manages members</th>
      <th>system groups</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>aix</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>directoryservice</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>groupadd</td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>ldap</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pw</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>windows_adsi</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
  </tbody>
</table>


notify
-----

* [Attributes](#notify-attributes)

<h3 id="notify-description">Description</h3>

Sends an arbitrary message to the agent run-time log.

<h3 id="notify-attributes">Attributes</h3>

<pre><code>notify { 'resource title':
  <a href="#notify-attribute-name">name</a>     =&gt; <em># <strong>(namevar)</strong> An arbitrary tag for your own reference; the...</em>
  <a href="#notify-attribute-message">message</a>  =&gt; <em># The message to be sent to the...</em>
  <a href="#notify-attribute-withpath">withpath</a> =&gt; <em># Whether to show the full object path.  Default...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="notify-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

An arbitrary tag for your own reference; the name of the message.

([↑ Back to notify attributes](#notify-attributes))

<h4 id="notify-attribute-message">message</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The message to be sent to the log.

([↑ Back to notify attributes](#notify-attributes))

<h4 id="notify-attribute-withpath">withpath</h4>

Whether to show the full object path.

Default: `false`

Allowed values:

* `true`
* `false`

([↑ Back to notify attributes](#notify-attributes))



package
-----

* [Attributes](#package-attributes)
* [Providers](#package-providers)
* [Provider Features](#package-provider-features)

<h3 id="package-description">Description</h3>

Manage packages.  There is a basic dichotomy in package
support right now:  Some package types (such as yum and apt) can
retrieve their own package files, while others (such as rpm and sun)
cannot.  For those package formats that cannot retrieve their own files,
you can use the `source` parameter to point to the correct file.

Puppet will automatically guess the packaging format that you are
using based on the platform you are on, but you can override it
using the `provider` parameter; each provider defines what it
requires in order to function, and you must meet those requirements
to use a given provider.

You can declare multiple package resources with the same `name`, as long
as they specify different providers and have unique titles.

Note that you must use the _title_ to make a reference to a package
resource; `Package[<NAME>]` is not a synonym for `Package[<TITLE>]` like
it is for many other resource types.

**Autorequires:** If Puppet is managing the files specified as a
package's `adminfile`, `responsefile`, or `source`, the package
resource will autorequire those files.

<h3 id="package-attributes">Attributes</h3>

<pre><code>package { 'resource title':
  <a href="#package-attribute-name">name</a>                 =&gt; <em># <strong>(namevar)</strong> The package name.  This is the name that the...</em>
  <a href="#package-attribute-provider">provider</a>             =&gt; <em># <strong>(namevar)</strong> The specific backend to use for this `package...</em>
  <a href="#package-attribute-ensure">ensure</a>               =&gt; <em># What state the package should be in. On...</em>
  <a href="#package-attribute-adminfile">adminfile</a>            =&gt; <em># A file containing package defaults for...</em>
  <a href="#package-attribute-allow_virtual">allow_virtual</a>        =&gt; <em># Specifies if virtual package names are allowed...</em>
  <a href="#package-attribute-allowcdrom">allowcdrom</a>           =&gt; <em># Tells apt to allow cdrom sources in the...</em>
  <a href="#package-attribute-category">category</a>             =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-configfiles">configfiles</a>          =&gt; <em># Whether to keep or replace modified config files </em>
  <a href="#package-attribute-description">description</a>          =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-flavor">flavor</a>               =&gt; <em># OpenBSD supports 'flavors', which are further...</em>
  <a href="#package-attribute-install_options">install_options</a>      =&gt; <em># An array of additional options to pass when...</em>
  <a href="#package-attribute-instance">instance</a>             =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-package_settings">package_settings</a>     =&gt; <em># Settings that can change the contents or...</em>
  <a href="#package-attribute-platform">platform</a>             =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-reinstall_on_refresh">reinstall_on_refresh</a> =&gt; <em># Whether this resource should respond to refresh...</em>
  <a href="#package-attribute-responsefile">responsefile</a>         =&gt; <em># A file containing any necessary answers to...</em>
  <a href="#package-attribute-root">root</a>                 =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-source">source</a>               =&gt; <em># Where to find the package file. This is only...</em>
  <a href="#package-attribute-status">status</a>               =&gt; <em># A read-only parameter set by the...</em>
  <a href="#package-attribute-uninstall_options">uninstall_options</a>    =&gt; <em># An array of additional options to pass when...</em>
  <a href="#package-attribute-vendor">vendor</a>               =&gt; <em># A read-only parameter set by the...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="package-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The package name.  This is the name that the packaging
system uses internally, which is sometimes (especially on Solaris)
a name that is basically useless to humans.  If a package goes by
several names, you can use a single title and then set the name
conditionally:

    # In the 'openssl' class
    $ssl = $operatingsystem ? {
      solaris => SMCossl,
      default => openssl
    }

    package { 'openssl':
      ensure => installed,
      name   => $ssl,
    }

    ...

    $ssh = $operatingsystem ? {
      solaris => SMCossh,
      default => openssh
    }

    package { 'openssh':
      ensure  => installed,
      name    => $ssh,
      require => Package['openssl'],
    }

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-provider">provider</h4>

_(**Secondary namevar:** This resource type allows you to manage multiple resources with the same name as long as their providers are different.)_

The specific backend to use for this `package`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`aix`](#package-provider-aix)
* [`appdmg`](#package-provider-appdmg)
* [`apple`](#package-provider-apple)
* [`apt`](#package-provider-apt)
* [`aptitude`](#package-provider-aptitude)
* [`aptrpm`](#package-provider-aptrpm)
* [`blastwave`](#package-provider-blastwave)
* [`dnf`](#package-provider-dnf)
* [`dpkg`](#package-provider-dpkg)
* [`fink`](#package-provider-fink)
* [`freebsd`](#package-provider-freebsd)
* [`gem`](#package-provider-gem)
* [`hpux`](#package-provider-hpux)
* [`macports`](#package-provider-macports)
* [`nim`](#package-provider-nim)
* [`openbsd`](#package-provider-openbsd)
* [`opkg`](#package-provider-opkg)
* [`pacman`](#package-provider-pacman)
* [`pip3`](#package-provider-pip3)
* [`pip`](#package-provider-pip)
* [`pkg`](#package-provider-pkg)
* [`pkgdmg`](#package-provider-pkgdmg)
* [`pkgin`](#package-provider-pkgin)
* [`pkgng`](#package-provider-pkgng)
* [`pkgutil`](#package-provider-pkgutil)
* [`portage`](#package-provider-portage)
* [`ports`](#package-provider-ports)
* [`portupgrade`](#package-provider-portupgrade)
* [`puppet_gem`](#package-provider-puppet_gem)
* [`rpm`](#package-provider-rpm)
* [`rug`](#package-provider-rug)
* [`sun`](#package-provider-sun)
* [`sunfreeware`](#package-provider-sunfreeware)
* [`tdnf`](#package-provider-tdnf)
* [`up2date`](#package-provider-up2date)
* [`urpmi`](#package-provider-urpmi)
* [`windows`](#package-provider-windows)
* [`yum`](#package-provider-yum)
* [`zypper`](#package-provider-zypper)

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

What state the package should be in. On packaging systems that can
retrieve new packages on their own, you can choose which package to
retrieve by specifying a version number or `latest` as the ensure
value. On packaging systems that manage configuration files separately
from "normal" system files, you can uninstall config files by
specifying `purged` as the ensure value. This defaults to `installed`.

Version numbers must match the full version to install, including
release if the provider uses a release moniker. Ranges or semver
patterns are not accepted except for the `gem` package provider. For
example, to install the bash package from the rpm
`bash-4.1.2-29.el6.x86_64.rpm`, use the string `'4.1.2-29.el6'`.

Default: `installed`

Allowed values:

* `present`
* `absent`
* `purged`
* `held`
* `installed`
* `latest`
* `/./`

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-adminfile">adminfile</h4>

A file containing package defaults for installing packages.

This attribute is only used on Solaris. Its value should be a path to a
local file stored on the target system. Solaris's package tools expect
either an absolute file path or a relative path to a file in
`/var/sadm/install/admin`.

The value of `adminfile` will be passed directly to the `pkgadd` or
`pkgrm` command with the `-a <ADMINFILE>` option.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-allow_virtual">allow_virtual</h4>

Specifies if virtual package names are allowed for install and uninstall.

Default: `true`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-allowcdrom">allowcdrom</h4>

Tells apt to allow cdrom sources in the sources.list file.
Normally apt will bail if you try this.

Allowed values:

* `true`
* `false`

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-category">category</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-configfiles">configfiles</h4>

Whether to keep or replace modified config files when installing or
upgrading a package. This only affects the `apt` and `dpkg` providers.

Default: `keep`

Allowed values:

* `keep`
* `replace`

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-description">description</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-flavor">flavor</h4>

OpenBSD supports 'flavors', which are further specifications for
which type of package you want.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-install_options">install_options</h4>

An array of additional options to pass when installing a package. These
options are package-specific, and should be documented by the software
vendor.  One commonly implemented option is `INSTALLDIR`:

    package { 'mysql':
      ensure          => installed,
      source          => 'N:/packages/mysql-5.5.16-winx64.msi',
      install_options => [ '/S', { 'INSTALLDIR' => 'C:\\mysql-5.5' } ],
    }

Each option in the array can either be a string or a hash, where each
key and value pair are interpreted in a provider specific way.  Each
option will automatically be quoted when passed to the install command.

With Windows packages, note that file paths in an install option must
use backslashes. (Since install options are passed directly to the
installation command, forward slashes won't be automatically converted
like they are in `file` resources.) Note also that backslashes in
double-quoted strings _must_ be escaped and backslashes in single-quoted
strings _can_ be escaped.



Requires features install_options.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-instance">instance</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-package_settings">package_settings</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Settings that can change the contents or configuration of a package.

The formatting and effects of package_settings are provider-specific; any
provider that implements them must explain how to use them in its
documentation. (Our general expectation is that if a package is
installed but its settings are out of sync, the provider should
re-install that package with the desired settings.)

An example of how package_settings could be used is FreeBSD's port build
options --- a future version of the provider could accept a hash of options,
and would reinstall the port if the installed version lacked the correct
settings.

    package { 'www/apache22':
      package_settings => { 'SUEXEC' => false }
    }

Again, check the documentation of your platform's package provider to see
the actual usage.



Requires features package_settings.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-platform">platform</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-reinstall_on_refresh">reinstall_on_refresh</h4>

Whether this resource should respond to refresh events (via `subscribe`,
`notify`, or the `~>` arrow) by reinstalling the package. Only works for
providers that support the `reinstallable` feature.

This is useful for source-based distributions, where you may want to
recompile a package if the build options change.

If you use this, be careful of notifying classes when you want to restart
services. If the class also contains a refreshable package, doing so could
cause unnecessary re-installs.

Default: `false`

Allowed values:

* `true`
* `false`

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-responsefile">responsefile</h4>

A file containing any necessary answers to questions asked by
the package.  This is currently used on Solaris and Debian.  The
value will be validated according to system rules, but it should
generally be a fully qualified path.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-root">root</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-source">source</h4>

Where to find the package file. This is only used by providers that don't
automatically download packages from a central repository. (For example:
the `yum` and `apt` providers ignore this attribute, but the `rpm` and
`dpkg` providers require it.)

Different providers accept different values for `source`. Most providers
accept paths to local files stored on the target system. Some providers
may also accept URLs or network drive paths. Puppet will not
automatically retrieve source files for you, and usually just passes the
value of `source` to the package installation command.

You can use a `file` resource if you need to manually copy package files
to the target system.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-status">status</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-uninstall_options">uninstall_options</h4>

An array of additional options to pass when uninstalling a package. These
options are package-specific, and should be documented by the software
vendor.  For example:

    package { 'VMware Tools':
      ensure            => absent,
      uninstall_options => [ { 'REMOVE' => 'Sync,VSS' } ],
    }

Each option in the array can either be a string or a hash, where each
key and value pair are interpreted in a provider specific way.  Each
option will automatically be quoted when passed to the uninstall
command.

On Windows, this is the **only** place in Puppet where backslash
separators should be used.  Note that backslashes in double-quoted
strings _must_ be double-escaped and backslashes in single-quoted
strings _may_ be double-escaped.

Requires features uninstall_options.

([↑ Back to package attributes](#package-attributes))

<h4 id="package-attribute-vendor">vendor</h4>

A read-only parameter set by the package.

([↑ Back to package attributes](#package-attributes))


<h3 id="package-providers">Providers</h3>

<h4 id="package-provider-aix">aix</h4>

Installation from an AIX software directory, using the AIX `installp`
command.  The `source` parameter is required for this provider, and should
be set to the absolute path (on the puppet agent machine) of a directory
containing one or more BFF package files.

The `installp` command will generate a table of contents file (named `.toc`)
in this directory, and the `name` parameter (or resource title) that you
specify for your `package` resource must match a package name that exists
in the `.toc` file.

Note that package downgrades are *not* supported; if your resource specifies
a specific version number and there is already a newer version of the package
installed on the machine, the resource will fail with an error message.

* Required binaries: `/usr/bin/lslpp`, `/usr/sbin/installp`
* Confined to: `operatingsystem == [ :aix ]`
* Default for: `operatingsystem` == `aix`
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-appdmg">appdmg</h4>

Package management which copies application bundles to a target.

* Required binaries: `/usr/bin/hdiutil`, `/usr/bin/curl`, `/usr/bin/ditto`
* Confined to: `operatingsystem == darwin`, `feature == cfpropertylist`
* Supported features: `installable`

<h4 id="package-provider-apple">apple</h4>

Package management based on OS X's built-in packaging system.  This is
essentially the simplest and least functional package system in existence --
it only supports installation; no deletion or upgrades.  The provider will
automatically add the `.pkg` extension, so leave that off when specifying
the package name.

* Required binaries: `/usr/sbin/installer`
* Confined to: `operatingsystem == darwin`
* Supported features: `installable`

<h4 id="package-provider-apt">apt</h4>

Package management via `apt-get`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to apt-get.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `/usr/bin/apt-get`, `/usr/bin/apt-cache`, `/usr/bin/debconf-set-selections`
* Default for: `osfamily` == `debian`
* Supported features: `holdable`, `install_options`, `installable`, `purgeable`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-aptitude">aptitude</h4>

Package management via `aptitude`.

* Required binaries: `/usr/bin/aptitude`, `/usr/bin/apt-cache`
* Supported features: `holdable`, `installable`, `purgeable`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-aptrpm">aptrpm</h4>

Package management via `apt-get` ported to `rpm`.

* Required binaries: `apt-get`, `apt-cache`, `rpm`
* Supported features: `installable`, `purgeable`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-blastwave">blastwave</h4>

Package management using Blastwave.org's `pkg-get` command on Solaris.

* Required binaries: `pkgget`
* Confined to: `osfamily == solaris`
* Supported features: `installable`, `uninstallable`, `upgradeable`

<h4 id="package-provider-dnf">dnf</h4>

Support via `dnf`.

Using this provider's `uninstallable` feature will not remove dependent packages. To
remove dependent packages with this provider use the `purgeable` feature, but note this
feature is destructive and should be used with the utmost care.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to dnf.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `dnf`, `rpm`
* Default for `operatingsystem` == `fedora` and `operatingsystemmajrelease` == `22, 23, 24, 25, 26, 27, 28, 29, 30`.
* Supported features: `install_options`, `installable`, `purgeable`, `uninstallable`, `upgradeable`, `versionable`, `virtual_packages`

<h4 id="package-provider-dpkg">dpkg</h4>

Package management via `dpkg`.  Because this only uses `dpkg`
and not `apt`, you must specify the source of any packages you want
to manage.

* Required binaries: `/usr/bin/dpkg`, `/usr/bin/dpkg-deb`, `/usr/bin/dpkg-query`
* Supported features: `holdable`, `installable`, `purgeable`, `uninstallable`, `upgradeable`

<h4 id="package-provider-fink">fink</h4>

Package management via `fink`.

* Required binaries: `/sw/bin/fink`, `/sw/bin/apt-get`, `/sw/bin/apt-cache`, `/sw/bin/dpkg-query`
* Supported features: `holdable`, `installable`, `purgeable`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-freebsd">freebsd</h4>

The specific form of package management on FreeBSD.  This is an
extremely quirky packaging system, in that it freely mixes between
ports and packages.  Apparently all of the tools are written in Ruby,
so there are plans to rewrite this support to directly use those
libraries.

* Required binaries: `/usr/sbin/pkg_info`, `/usr/sbin/pkg_add`, `/usr/sbin/pkg_delete`
* Confined to: `operatingsystem == freebsd`
* Supported features: `installable`, `purgeable`, `uninstallable`, `upgradeable`.

<h4 id="package-provider-gem">gem</h4>

Ruby Gem support. If a URL is passed via `source`, then that URL is
appended to the list of remote gem repositories; to ensure that only the
specified source is used, also pass `--clear-sources` via `install_options`.
If source is present but is not a valid URL, it will be interpreted as the
path to a local gem file. If source is not present, the gem will be
installed from the default gem repositories. Note that to modify this for Windows, it has to be a valid URL.

This provider supports the `install_options` and `uninstall_options` attributes,
which allow command-line flags to be passed to the gem command.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `gem`
* Supported features: `install_options`, `installable`, `uninstall_options`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-hpux">hpux</h4>

HP-UX's packaging system.

* Required binaries: `/usr/sbin/swinstall`, `/usr/sbin/swlist`, `/usr/sbin/swremove`
* Confined to: `operatingsystem == hp-ux`
* Default for `operatingsystem` == `hp-ux`.
* Supported features: `installable`, `uninstallable`

<h4 id="package-provider-macports">macports</h4>

Package management using MacPorts on OS X.

Supports MacPorts versions and revisions, but not variants.
Variant preferences may be specified using
[the MacPorts variants.conf file](http://guide.macports.org/chunked/internals.configuration-files.html#internals.configuration-files.variants-conf).

When specifying a version in the Puppet DSL, only specify the version, not the revision.
Revisions are only used internally for ensuring the latest version/revision of a port.

* Required binaries: `/opt/local/bin/port`
* Confined to: `operatingsystem == darwin`
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-nim">nim</h4>

Installation from an AIX NIM LPP source.  The `source` parameter is required
for this provider, and should specify the name of a NIM `lpp_source` resource
that is visible to the puppet agent machine.  This provider supports the
management of both BFF/installp and RPM packages.

Note that package downgrades are *not* supported; if your resource specifies
a specific version number and there is already a newer version of the package
installed on the machine, the resource will fail with an error message.

* Required binaries: `/usr/sbin/nimclient`, `/usr/bin/lslpp`, `rpm`
* Confined to: `exists == /etc/niminfo`
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-openbsd">openbsd</h4>

OpenBSD's form of `pkg_add` support.

This provider supports the `install_options` and `uninstall_options`
attributes, which allow command-line flags to be passed to pkg_add and pkg_delete.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `pkg_info`, `pkg_add`, `pkg_delete`
* Confined to: `operatingsystem == openbsd`
* Default for: `operatingsystem` == `openbsd`
* Supported features: `install_options`, `installable`, `purgeable`, `uninstall_options`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-opkg">opkg</h4>

Opkg packaging support. Common on OpenWrt and OpenEmbedded platforms

* Required binaries: `opkg`
* Confined to: `operatingsystem == openwrt`
* Default for `operatingsystem == openwrt`.
* Supported features: `installable`, `uninstallable`, `upgradeable`

<h4 id="package-provider-pacman">pacman</h4>

Support for the Package Manager Utility (pacman) used in Archlinux.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pacman.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `/usr/bin/pacman`
* Confined to: `operatingsystem == [:archlinux, :manjarolinux]`
* Default for: `["operatingsystem", "[:archlinux, :manjarolinux]"] == `
* Supported features: `install_options`, `installable`, `uninstall_options`, `uninstallable`, `upgradeable`, `virtual_packages`

<h4 id="package-provider-pip">pip</h4>

Python packages via `pip`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pip.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Supported features: `install_options`, `installable`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-pip3">pip3</h4>

Python packages via `pip3`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pip3.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Supported features: `install_options`, `installable`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-pkg">pkg</h4>

OpenSolaris image packaging system. See pkg(5) for more information.

This provider supports the `install_options` attribute, which allows
command-line flags to be passed to pkg. These options should be specified as an
array where each element is either a string or a hash.

* Required binaries: `/usr/bin/pkg`
* Confined to: `osfamily == solaris`
* Default for: `["osfamily", "solaris"] == ["kernelrelease", "['5.11', '5.12']"]`
* Supported features: `holdable`, `installable`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-pkgdmg">pkgdmg</h4>

Package management based on Apple's Installer.app and DiskUtility.app.

This provider works by checking the contents of a DMG image for Apple pkg or
mpkg files. Any number of pkg or mpkg files may exist in the root directory
of the DMG file system, and Puppet will install all of them. Subdirectories
are not checked for packages.

This provider can also accept plain .pkg (but not .mpkg) files in addition
to .dmg files.

Notes:

* The `source` attribute is mandatory. It must be either a local disk path
  or an HTTP, HTTPS, or FTP URL to the package.
* The `name` of the resource must be the filename (without path) of the DMG file.
* When installing the packages from a DMG, this provider writes a file to
  disk at `/var/db/.puppet_pkgdmg_installed_NAME`. If that file is present,
  Puppet assumes all packages from that DMG are already installed.
* This provider is not versionable and uses DMG filenames to determine
  whether a package has been installed. Thus, to install new a version of a
  package, you must create a new DMG with a different filename.

* Required binaries: `/usr/sbin/installer`, `/usr/bin/hdiutil`, `/usr/bin/curl`
* Confined to: `operatingsystem == darwin`, `feature == cfpropertylist`
* Default for: `operatingsystem` == `darwin`
* Supported features: `installable`

<h4 id="package-provider-pkgin">pkgin</h4>

Package management using pkgin, a binary package manager for pkgsrc.

* Required binaries: `pkgin`
* Default for: `operatingsystem` == `smartos, netbsd`
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-pkgng">pkgng</h4>

A PkgNG provider for FreeBSD and DragonFly.

* Required binaries: `/usr/local/sbin/pkg`
* Confined to: `operatingsystem == [:freebsd, :dragonfly]`
* Default for: `operatingsystem` == `freebsd, dragonfly`.
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`.

<h4 id="package-provider-pkgutil">pkgutil</h4>

Package management using Peter Bonivart's ``pkgutil`` command on Solaris.

* Required binaries: `pkgutil`
* Confined to: `osfamily == solaris`
* Supported features: `installable`, `uninstallable`, `upgradeable`

<h4 id="package-provider-portage">portage</h4>

Provides packaging support for Gentoo's portage system.

This provider supports the `install_options` and `uninstall_options` attributes, which allows command-line
flags to be passed to emerge. These options should be specified as an array where each element is either a string or a hash.

* Required binaries: `/usr/bin/eix-update`, `/usr/bin/eix`, `/usr/bin/emerge`, `/usr/bin/qatom`
* Confined to: `operatingsystem == gentoo`
* Default for: `operatingsystem` == `gentoo`
* Supported features: `install_options`, `installable`, `purgeable`, `reinstallable`, `uninstall_options`, `uninstallable`, `upgradeable`, `versionable`, `virtual_packages`

<h4 id="package-provider-ports">ports</h4>

Support for FreeBSD's ports.  Note that this, too, mixes packages and ports.

* Required binaries: `/usr/local/sbin/portupgrade`, `/usr/local/sbin/portversion`, `/usr/local/sbin/pkg_deinstall`, `/usr/sbin/pkg_info`
* Supported features: `installable`, `purgeable`, `uninstallable`, `upgradeable`

<h4 id="package-provider-portupgrade">portupgrade</h4>

Support for FreeBSD's ports using the portupgrade ports management software.
Use the port's full origin as the resource name. eg (ports-mgmt/portupgrade)
for the portupgrade port.

* Required binaries: `/usr/local/sbin/portupgrade`, `/usr/local/sbin/portinstall`, `/usr/local/sbin/portversion`, `/usr/local/sbin/pkg_deinstall`, `/usr/sbin/pkg_info`
* Supported features: `installable`, `uninstallable`, `upgradeable`

<h4 id="package-provider-puppet_gem">puppet_gem</h4>

Puppet Ruby Gem support. This provider is useful for managing
gems needed by the ruby provided in the puppet-agent package.

* Required binaries: `/opt/puppetlabs/puppet/bin/gem`
* Supported features: `install_options`, `installable`, `uninstall_options`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-rpm">rpm</h4>

RPM packaging support; should work anywhere with a working `rpm`
binary.

    This provider supports the `install_options` and `uninstall_options`
    attributes, which allow command-line flags to be passed to rpm.
These options should be specified as an array where each element is either a string or a hash.

* Required binaries: `rpm`
* Supported features: `install_options`, `installable`, `uninstall_options`, `uninstallable`, `upgradeable`, `versionable`, `virtual_packages`

<h4 id="package-provider-rug">rug</h4>

Support for suse `rug` package manager.

* Required binaries: `/usr/bin/rug`, `rpm`
* Confined to: `operatingsystem == [:suse, :sles]`
* Supported features: `installable`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-sun">sun</h4>

Sun's packaging system.  Requires that you specify the source for
the packages you're managing.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pkgadd.
These options should be specified as an array where each element is either a string
 or a hash.

* Required binaries: `/usr/bin/pkginfo`, `/usr/sbin/pkgadd`, `/usr/sbin/pkgrm`
* Confined to: `osfamily == solaris`
* Default for: `osfamily` == `solaris`
* Supported features: `install_options`, `installable`, `uninstallable`, `upgradeable`

<h4 id="package-provider-sunfreeware">sunfreeware</h4>

Package management using sunfreeware.com's `pkg-get` command on Solaris.
At this point, support is exactly the same as `blastwave` support and
has not actually been tested.

* Required binaries: `pkg-get`
* Confined to: `osfamily == solaris`
* Supported features: `installable`, `uninstallable`, `upgradeable`

<h4 id="package-provider-tdnf">tdnf</h4>

Support via `tdnf`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to tdnf.
These options should be spcified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}), or an
array where each element is either a string or a hash.

* Required binaries: `tdnf`, `rpm`
* Default for `operatingsystem` == `PhotonOS`
* Supported features: `install_options`, `installable`, `purgeable`, `uninstallable`, `upgradeable`, `versionable`, `virtual_packages`

<h4 id="package-provider-up2date">up2date</h4>

Support for Red Hat's proprietary `up2date` package update
mechanism.

* Required binaries: `/usr/sbin/up2date-nox`
* Confined to: `osfamily == redhat`
* Default for `lsbdistrelease` == `2.1, 3, 4` and `osfamily` == `redhat`
* Supported features: `installable`, `uninstallable`, `upgradeable`

<h4 id="package-provider-urpmi">urpmi</h4>

Support via `urpmi`.

* Required binaries: `urpmi`, `urpmq`, `rpm`, `urpme`
* Default for `operatingsystem` == `mandriva, mandrake`
* Supported features: `installable`, `purgeable`, `uninstallable`, `upgradeable`, `versionable`

<h4 id="package-provider-windows">windows</h4>

Windows package management.

This provider supports either MSI or self-extracting executable installers.

This provider requires a `source` attribute when installing the package.
It accepts paths to local files, mapped drives, or UNC paths.

This provider supports the `install_options` and `uninstall_options`
attributes, which allow command-line flags to be passed to the installer.
These options should be specified as an array where each element is either
a string or a hash.

If the executable requires special arguments to perform a silent install or
uninstall, then the appropriate arguments should be specified using the
`install_options` or `uninstall_options` attributes, respectively.  Puppet
will automatically quote any option that contains spaces.

* Confined to: `operatingsystem == windows`
* Default for: `operatingsystem` == `windows`
* Supported features: `install_options`, `installable`, `uninstall_options`, `uninstallable`, `versionable`

<h4 id="package-provider-yum">yum</h4>

Support via `yum`.

Using this provider's `uninstallable` feature will not remove dependent packages. To
remove dependent packages with this provider use the `purgeable` feature, but note this
feature is destructive and should be used with the utmost care.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to yum.
These options should be specified as an array where each element is either a string or a hash.

* Required binaries: `yum`, `rpm`
* Default for: `osfamily` == `redhat`
* Supported features: `install_options`, `installable`, `purgeable`, `uninstallable`, `upgradeable`, `versionable`, `virtual_packages`

<h4 id="package-provider-zypper">zypper</h4>

Support for SuSE `zypper` package manager. Found in SLES10sp2+ and SLES11.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to zypper.
These options should be specified as an array where each element is either a
string or a hash.

* Required binaries: `/usr/bin/zypper`
* Confined to: `operatingsystem == [:suse, :sles, :sled, :opensuse]`
* Default for: `operatingsystem` == `suse, sles, sled, opensuse`
* Supported features: `install_options`, `installable`, `uninstallable`, `upgradeable`, `versionable`, `virtual_packages`

<h3 id="package-provider-features">Provider Features</h3>

Available features:

* `holdable` --- The provider is capable of placing packages on hold such that they are not automatically upgraded as a result of other package dependencies unless explicit action is taken by a user or another package. Held is considered a superset of installed.
* `install_options` --- The provider accepts options to be passed to the installer command.
* `installable` --- The provider can install packages.
* `package_settings` --- The provider accepts package_settings to be ensured for the given package. The meaning and format of these settings is provider-specific.
* `purgeable` --- The provider can purge packages.  This generally means that all traces of the package are removed, including existing configuration files.  This feature is thus destructive and should be used with the utmost care.
* `reinstallable` --- The provider can reinstall packages.
* `uninstall_options` --- The provider accepts options to be passed to the uninstaller command.
* `uninstallable` --- The provider can uninstall packages.
* `upgradeable` --- The provider can upgrade to the latest version of a package.  This feature is used by specifying `latest` as the desired value for the package.
* `versionable` --- The provider is capable of interrogating the package database for installed version(s), and can select which out of a set of available versions of a package to install if asked.
* `virtual_packages` --- The provider accepts virtual package names for install and uninstall.

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>holdable</th>
      <th>install options</th>
      <th>installable</th>
      <th>package settings</th>
      <th>purgeable</th>
      <th>reinstallable</th>
      <th>uninstall options</th>
      <th>uninstallable</th>
      <th>upgradeable</th>
      <th>versionable</th>
      <th>virtual packages</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>aix</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>appdmg</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>apple</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>apt</td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>aptitude</td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>aptrpm</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>blastwave</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>dnf</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>dpkg</td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>fink</td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>freebsd</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>gem</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>hpux</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>macports</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>nim</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>openbsd</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>opkg</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pacman</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>pip</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pip3</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkg</td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkgdmg</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkgin</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkgng</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkgutil</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>portage</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>ports</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>portupgrade</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>puppet_gem</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>rpm</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>rug</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>sun</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>sunfreeware</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>tdnf</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>up2date</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>urpmi</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>windows</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>yum</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>zypper</td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
  </tbody>
</table>


resources
-----

* [Attributes](#resources-attributes)

<h3 id="resources-description">Description</h3>

This is a metatype that can manage other resource types.  Any
metaparams specified here will be passed on to any generated resources,
so you can purge unmanaged resources but set `noop` to true so the
purging is only logged and does not actually happen.

<h3 id="resources-attributes">Attributes</h3>

<pre><code>resources { 'resource title':
  <a href="#resources-attribute-name">name</a>               =&gt; <em># <strong>(namevar)</strong> The name of the type to be...</em>
  <a href="#resources-attribute-purge">purge</a>              =&gt; <em># Whether to purge unmanaged resources.  When set...</em>
  <a href="#resources-attribute-unless_system_user">unless_system_user</a> =&gt; <em># This keeps system users from being purged.  By...</em>
  <a href="#resources-attribute-unless_uid">unless_uid</a>         =&gt; <em># This keeps specific uids or ranges of uids from...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="resources-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the type to be managed.

([↑ Back to resources attributes](#resources-attributes))

<h4 id="resources-attribute-purge">purge</h4>

Whether to purge unmanaged resources.  When set to `true`, this will
delete any resource that is not specified in your configuration and is not
autorequired by any managed resources. **Note:** The `ssh_authorized_key`
resource type can't be purged this way; instead, see the `purge_ssh_keys`
attribute of the `user` type.

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to resources attributes](#resources-attributes))

<h4 id="resources-attribute-unless_system_user">unless_system_user</h4>

This keeps system users from being purged.  By default, it
does not purge users whose UIDs are less than the minimum UID for the system (typically 500 or 1000), but you can specify
a different UID as the inclusive limit.

Allowed values:

* `true`
* `false`
* `/^\d+$/`

([↑ Back to resources attributes](#resources-attributes))

<h4 id="resources-attribute-unless_uid">unless_uid</h4>

This keeps specific uids or ranges of uids from being purged when purge is true.
Accepts integers, integer strings, and arrays of integers or integer strings.
To specify a range of uids, consider using the range() function from stdlib.

([↑ Back to resources attributes](#resources-attributes))



schedule
-----

* [Attributes](#schedule-attributes)

<h3 id="schedule-description">Description</h3>

Define schedules for Puppet. Resources can be limited to a schedule by using the
[`schedule`](https://puppet.com/docs/puppet/latest/metaparameter.html#schedule)
metaparameter.

Currently, **schedules can only be used to stop a resource from being
applied;** they cannot cause a resource to be applied when it otherwise
wouldn't be, and they cannot accurately specify a time when a resource
should run.

Every time Puppet applies its configuration, it will apply the
set of resources whose schedule does not eliminate them from
running right then, but there is currently no system in place to
guarantee that a given resource runs at a given time.  If you
specify a very  restrictive schedule and Puppet happens to run at a
time within that schedule, then the resources will get applied;
otherwise, that work may never get done.

Thus, it is advisable to use wider scheduling (for example, over a couple
of hours) combined with periods and repetitions.  For instance, if you
wanted to restrict certain resources to only running once, between
the hours of two and 4 AM, then you would use this schedule:

    schedule { 'maint':
      range  => '2 - 4',
      period => daily,
      repeat => 1,
    }

With this schedule, the first time that Puppet runs between 2 and 4 AM,
all resources with this schedule will get applied, but they won't
get applied again between 2 and 4 because they will have already
run once that day, and they won't get applied outside that schedule
because they will be outside the scheduled range.

Puppet automatically creates a schedule for each of the valid periods
with the same name as that period (such as hourly and daily).
Additionally, a schedule named `puppet` is created and used as the
default, with the following attributes:

    schedule { 'puppet':
      period => hourly,
      repeat => 2,
    }

This will cause resources to be applied every 30 minutes by default.

The `statettl` setting on the agent affects the ability of a schedule to
determine if a resource has already been checked. If the `statettl` is
set lower than the span of the associated schedule resource, then a
resource could be checked & applied multiple times in the schedule as
the information about when the resource was last checked will have
expired from the cache.

<h3 id="schedule-attributes">Attributes</h3>

<pre><code>schedule { 'resource title':
  <a href="#schedule-attribute-name">name</a>        =&gt; <em># <strong>(namevar)</strong> The name of the schedule.  This name is used...</em>
  <a href="#schedule-attribute-period">period</a>      =&gt; <em># The period of repetition for resources on this...</em>
  <a href="#schedule-attribute-periodmatch">periodmatch</a> =&gt; <em># Whether periods should be matched by a numeric...</em>
  <a href="#schedule-attribute-range">range</a>       =&gt; <em># The earliest and latest that a resource can be...</em>
  <a href="#schedule-attribute-repeat">repeat</a>      =&gt; <em># How often a given resource may be applied in...</em>
  <a href="#schedule-attribute-weekday">weekday</a>     =&gt; <em># The days of the week in which the schedule...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="schedule-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the schedule.  This name is used when assigning the schedule
to a resource with the `schedule` metaparameter:

    schedule { 'everyday':
      period => daily,
      range  => '2 - 4',
    }

    exec { '/usr/bin/apt-get update':
      schedule => 'everyday',
    }

([↑ Back to schedule attributes](#schedule-attributes))

<h4 id="schedule-attribute-period">period</h4>

The period of repetition for resources on this schedule. The default is
for resources to get applied every time Puppet runs.

Note that the period defines how often a given resource will get
applied but not when; if you would like to restrict the hours
that a given resource can be applied (for instance, only at night
during a maintenance window), then use the `range` attribute.

If the provided periods are not sufficient, you can provide a
value to the *repeat* attribute, which will cause Puppet to
schedule the affected resources evenly in the period the
specified number of times.  Take this schedule:

    schedule { 'veryoften':
      period => hourly,
      repeat => 6,
    }

This can cause Puppet to apply that resource up to every 10 minutes.

At the moment, Puppet cannot guarantee that level of repetition; that
is, the resource can applied _up to_ every 10 minutes, but internal
factors might prevent it from actually running that often (for instance,
if a Puppet run is still in progress when the next run is scheduled to
start, that next run will be suppressed).

See the `periodmatch` attribute for tuning whether to match
times by their distance apart or by their specific value.

Allowed values:

* `hourly`
* `daily`
* `weekly`
* `monthly`
* `never`

([↑ Back to schedule attributes](#schedule-attributes))

<h4 id="schedule-attribute-periodmatch">periodmatch</h4>

Whether periods should be matched by a numeric value (for instance,
whether two times are in the same hour) or by their chronological
distance apart (whether two times are 60 minutes apart).

Default: `distance`

Allowed values:

* `number`
* `distance`

([↑ Back to schedule attributes](#schedule-attributes))

<h4 id="schedule-attribute-range">range</h4>

The earliest and latest that a resource can be applied.  This is
always a hyphen-separated range within a 24 hour period, and hours
must be specified in numbers between 0 and 23, inclusive.  Minutes and
seconds can optionally be provided, using the normal colon as a
separator. For instance:

    schedule { 'maintenance':
      range => '1:30 - 4:30',
    }

This is mostly useful for restricting certain resources to being
applied in maintenance windows or during off-peak hours. Multiple
ranges can be applied in array context. As a convenience when specifying
ranges, you can cross midnight (for example, `range => "22:00 - 04:00"`).

([↑ Back to schedule attributes](#schedule-attributes))

<h4 id="schedule-attribute-repeat">repeat</h4>

How often a given resource may be applied in this schedule's `period`.
Must be an integer.

Default: `1`

([↑ Back to schedule attributes](#schedule-attributes))

<h4 id="schedule-attribute-weekday">weekday</h4>

The days of the week in which the schedule should be valid.
You may specify the full day name 'Tuesday', the three character
abbreviation 'Tue', or a number (as a string or as an integer) corresponding to the day of the
week where 0 is Sunday, 1 is Monday, and so on. Multiple days can be specified
as an array. If not specified, the day of the week will not be
considered in the schedule.

If you are also using a range match that spans across midnight
then this parameter will match the day that it was at the start
of the range, not necessarily the day that it is when it matches.
For example, consider this schedule:

    schedule { 'maintenance_window':
      range   => '22:00 - 04:00',
      weekday => 'Saturday',
    }

This will match at 11 PM on Saturday and 2 AM on Sunday, but not
at 2 AM on Saturday.

([↑ Back to schedule attributes](#schedule-attributes))


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
  <a href="#service-attribute-ensure">ensure</a>     =&gt; <em># Whether a service should be running.  Allowed...</em>
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
  <a href="#service-attribute-timeout">timeout</a>    =&gt; <em># Specify an optional minimum timeout (in seconds) </em>
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

Allowed values:

* `stopped`
* `running`
* `false`
* `true`

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

Allowed values:

* `true`
* `false`
* `manual`
* `mask`

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

Allowed values:

* `true`
* `false`

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-hasstatus">hasstatus</h4>

Declare whether the service's init script has a functional status
command. This attribute's default value changed in Puppet 2.7.0.

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

Default: `true`

Allowed values:

* `true`
* `false`

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

<h4 id="service-attribute-timeout">timeout</h4>

Specify an optional minimum timeout (in seconds) for puppet to wait when syncing service properties

([↑ Back to service attributes](#service-attributes))


<h3 id="service-providers">Providers</h3>

<h4 id="service-provider-base">base</h4>

The simplest form of Unix service support.

You have to specify enough about your service for this to work; the
minimum you can specify is a binary for starting the process, and this
same binary will be searched for in the process table to stop the
service.  As with `init`-style services, it is preferable to specify start,
stop, and status commands.

* Required binaries: `kill`
* Supported features: `refreshable`

<h4 id="service-provider-bsd">bsd</h4>

Generic BSD form of `init`-style service management with `rc.d`.

Uses `rc.conf.d` for service enabling and disabling.

* Confined to: `operatingsystem == [:freebsd, :dragonfly]`
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

* Required binaries: `/usr/bin/svc`, `/usr/bin/svstat`
* Supported features: `enableable`, `refreshable`

<h4 id="service-provider-debian">debian</h4>

Debian's form of `init`-style management.

The only differences from `init` are support for enabling and disabling
services via `update-rc.d` and the ability to determine enabled status via
`invoke-rc.d`.

* Required binaries: `/usr/sbin/update-rc.d`, `/usr/sbin/invoke-rc.d`, `/usr/sbin/service`
* Default for: `["operatingsystem", "cumuluslinux"] == ["operatingsystemmajrelease", "['1','2']"]`, `["operatingsystem", "debian"] == ["operatingsystemmajrelease", "['5','6','7']"]`
* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-freebsd">freebsd</h4>

Provider for FreeBSD and DragonFly BSD. Uses the `rcvar` argument of init scripts and parses/edits rc files.

* Confined to: `operatingsystem == [:freebsd, :dragonfly]`
* Default for `operatingsystem` == `freebsd, dragonfly`.
* Supported features: `enableable`, `refreshable`.

<h4 id="service-provider-gentoo">gentoo</h4>

Gentoo's form of `init`-style service management.

Uses `rc-update` for service enabling and disabling.

* Required binaries: `/sbin/rc-update`
* Confined to: `operatingsystem == gentoo`
* Supported features: `enableable`, `refreshable`

<h4 id="service-provider-init">init</h4>

Standard `init`-style service management.

* Confined to:

  ```
  true == begin
      os = Facter.value(:operatingsystem).downcase
      family = Facter.value(:osfamily).downcase
      !(os == 'debian' || os == 'ubuntu' || family == 'redhat')
  end
  ```
* Supported features: `refreshable`

<h4 id="service-provider-launchd">launchd</h4>

This provider manages jobs with `launchd`, which is the default service
framework for Mac OS X (and may be available for use on other platforms).

For more information, see the `launchd` man page:

* <https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man8/launchd.8.html>

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

* Required binaries: `/bin/launchctl`
* Confined to: `operatingsystem == darwin`, `feature == cfpropertylist`
* Default for `operatingsystem` == `darwin`
* Supported features: `enableable`, `refreshable`

<h4 id="service-provider-openbsd">openbsd</h4>

Provider for OpenBSD's rc.d daemon control scripts

* Required binaries: `/usr/sbin/rcctl`
* Confined to: `operatingsystem == openbsd`
* Default for `operatingsystem` == `openbsd`
* Supported features: `enableable`, `flaggable`, `refreshable`

<h4 id="service-provider-openrc">openrc</h4>

Support for Gentoo's OpenRC initskripts

Uses rc-update, rc-status and rc-service to manage services.

* Required binaries: `/sbin/rc-service`, `/sbin/rc-update`
* Default for `operatingsystem` == `gentoo`, `operatingsystem` == `funtoo`.
* Supported features: `enableable`, `refreshable`

<h4 id="service-provider-openwrt">openwrt</h4>

Support for OpenWrt flavored init scripts.

Uses /etc/init.d/service_name enable, disable, and enabled.

* Confined to: `operatingsystem == openwrt`
* Default for `operatingsystem` == `openwrt`
* Supported features: `enableable`, `refreshable`

<h4 id="service-provider-rcng">rcng</h4>

RCng service management with rc.d

* Confined to: `operatingsystem == [:netbsd, :cargos]`
* Default for `operatingsystem` == `netbsd, cargos`
* Supported features: `enableable`, `refreshable`

<h4 id="service-provider-redhat">redhat</h4>

Red Hat's (and probably many others') form of `init`-style service
management. Uses `chkconfig` for service enabling and disabling.

* Required binaries: `/sbin/chkconfig`, `/sbin/service`
* Default for `osfamily` == `redhat`, `operatingsystemmajrelease` == `10, 11` and `osfamily` == `suse`
* Supported features: `enableable`, `refreshable`

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

* Required binaries: `/usr/bin/sv`
* Supported features: `enableable`, `refreshable`

<h4 id="service-provider-service">service</h4>

The simplest form of service support.

* Supported features: `refreshable`

<h4 id="service-provider-smf">smf</h4>

Support for Sun's new Service Management Framework.

Starting a service is effectively equivalent to enabling it, so there is
only support for starting and stopping services, which also enables and
disables them, respectively.

By specifying `manifest => "/path/to/service.xml"`, the SMF manifest will
be imported if it does not exist.

* Required binaries: `/usr/sbin/svcadm`, `/usr/bin/svcs`, `/usr/sbin/svccfg`
* Confined to: `osfamily == solaris`
* Default for `osfamily` == `solaris`
* Supported features: `enableable`, `refreshable`

<h4 id="service-provider-src">src</h4>

Support for AIX's System Resource controller.

Services are started/stopped based on the `stopsrc` and `startsrc`
commands, and some services can be refreshed with `refresh` command.

Enabling and disabling services is not supported, as it requires
modifications to `/etc/inittab`. Starting and stopping groups of subsystems
is not yet supported.

* Required binaries: `/usr/bin/lssrc`, `/usr/bin/refresh`, `/usr/bin/startsrc`, `/usr/bin/stopsrc`, `/usr/sbin/chitab`, `/usr/sbin/lsitab`, `/usr/sbin/mkitab`, `/usr/sbin/rmitab`
* Confined to: `operatingsystem == aix`
* Default for `operatingsystem` == `aix`
* Supported features: `enableable`, `refreshable`

<h4 id="service-provider-systemd">systemd</h4>

Manages `systemd` services using `systemctl`.

Because `systemd` defaults to assuming the `.service` unit type, the suffix
may be omitted.  Other unit types (such as `.path`) may be managed by
providing the proper suffix.

* Required binaries: `systemctl`
* Default for
  * `osfamily` == `archlinux`
  * `operatingsystemmajrelease` == `7` and `osfamily` == `redhat`
  * `operatingsystem` == `fedora` and `osfamily` == `redhat`
  * `osfamily` == `suse`
  * `osfamily` == `coreos`
  * `operatingsystem` == `amazon` and `operatingsystemmajrelease` == `2`
  * `operatingsystem` == `debian` and `operatingsystemmajrelease` == `8, stretch/sid, 9, buster/sid`
  * `operatingsystem` == `ubuntu` and `operatingsystemmajrelease` == `15.04, 15.10, 16.04, 16.10, 17.04, 17.10, 18.04`
  * `operatingsystem` == `cumuluslinux` and `operatingsystemmajrelease` == `3`.
* Supported features: `enableable`, `maskable`, `refreshable`

<h4 id="service-provider-upstart">upstart</h4>

Ubuntu service management with `upstart`.

This provider manages `upstart` jobs on Ubuntu. For `upstart` documentation,
see <http://upstart.ubuntu.com/>.

* Required binaries: `/sbin/start`, `/sbin/stop`, `/sbin/restart`, `/sbin/status`, `/sbin/initctl`
* Confined to:
  ```
  any == [
    Facter.value(:operatingsystem) == 'Ubuntu',
    (Facter.value(:osfamily) == 'RedHat' and Facter.value(:operatingsystemrelease) =~ /^6\./),
    (Facter.value(:operatingsystem) == 'Amazon' and Facter.value(:operatingsystemmajrelease) =~ /\d{4}/),
    Facter.value(:operatingsystem) == 'LinuxMint',
  ]
  ```

  ```
  exists == /var/run/upstart-socket-bridge.pid
  ```
* Default for `operatingsystem` == `ubuntu` and `operatingsystemmajrelease` == `10.04, 12.04, 14.04, 14.10`
* Supported features: `enableable`, `refreshable`

<h4 id="service-provider-windows">windows</h4>

Support for Windows Service Control Manager (SCM). This provider can
start, stop, enable, and disable services, and the SCM provides working
status methods for all services.

Control of service groups (dependencies) is not yet supported, nor is running
services as a specific user.

* Required binaries: `net.exe`
* Confined to: `operatingsystem == windows`
* Default for `operatingsystem` == `windows`
* Supported features: `enableable`, `refreshable`

<h3 id="service-provider-features">Provider Features</h3>

Available features:

* `configurable_timeout` --- The provider can specify a minumum timeout for syncing service properties
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
      <th>configurable timeout</th>
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
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>windows</td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
  </tbody>
</table>

tidy
-----

* [Attributes](#tidy-attributes)

<h3 id="tidy-description">Description</h3>

Remove unwanted files based on specific criteria.  Multiple
criteria are OR'd together, so a file that is too large but is not
old enough will still get tidied.

If you don't specify either `age` or `size`, then all files will
be removed.

This resource type works by generating a file resource for every file
that should be deleted and then letting that resource perform the
actual deletion.

<h3 id="tidy-attributes">Attributes</h3>

<pre><code>tidy { 'resource title':
  <a href="#tidy-attribute-path">path</a>    =&gt; <em># <strong>(namevar)</strong> The path to the file or directory to manage....</em>
  <a href="#tidy-attribute-age">age</a>     =&gt; <em># Tidy files whose age is equal to or greater than </em>
  <a href="#tidy-attribute-backup">backup</a>  =&gt; <em># Whether tidied files should be backed up.  Any...</em>
  <a href="#tidy-attribute-matches">matches</a> =&gt; <em># One or more (shell type) file glob patterns...</em>
  <a href="#tidy-attribute-recurse">recurse</a> =&gt; <em># If target is a directory, recursively descend...</em>
  <a href="#tidy-attribute-rmdirs">rmdirs</a>  =&gt; <em># Tidy directories in addition to files; that is...</em>
  <a href="#tidy-attribute-size">size</a>    =&gt; <em># Tidy files whose size is equal to or greater...</em>
  <a href="#tidy-attribute-type">type</a>    =&gt; <em># Set the mechanism for determining age.  Default: </em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="tidy-attribute-path">path</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The path to the file or directory to manage.  Must be fully
qualified.

([↑ Back to tidy attributes](#tidy-attributes))

<h4 id="tidy-attribute-age">age</h4>

Tidy files whose age is equal to or greater than
the specified time.  You can choose seconds, minutes,
hours, days, or weeks by specifying the first letter of any
of those words (for example, '1w' represents one week).

Specifying 0 will remove all files.

([↑ Back to tidy attributes](#tidy-attributes))

<h4 id="tidy-attribute-backup">backup</h4>

Whether tidied files should be backed up.  Any values are passed
directly to the file resources used for actual file deletion, so consult
the `file` type's backup documentation to determine valid values.

([↑ Back to tidy attributes](#tidy-attributes))

<h4 id="tidy-attribute-matches">matches</h4>

One or more (shell type) file glob patterns, which restrict
the list of files to be tidied to those whose basenames match
at least one of the patterns specified. Multiple patterns can
be specified using an array.

Example:

    tidy { '/tmp':
      age     => '1w',
      recurse => 1,
      matches => [ '[0-9]pub*.tmp', '*.temp', 'tmpfile?' ],
    }

This removes files from `/tmp` if they are one week old or older,
are not in a subdirectory and match one of the shell globs given.

Note that the patterns are matched against the basename of each
file -- that is, your glob patterns should not have any '/'
characters in them, since you are only specifying against the last
bit of the file.

Finally, note that you must now specify a non-zero/non-false value
for recurse if matches is used, as matches only apply to files found
by recursion (there's no reason to use static patterns match against
a statically determined path).  Requiring explicit recursion clears
up a common source of confusion.

([↑ Back to tidy attributes](#tidy-attributes))

<h4 id="tidy-attribute-recurse">recurse</h4>

If target is a directory, recursively descend
into the directory looking for files to tidy.

Allowed values:

* `true`
* `false`
* `inf`
* `/^[0-9]+$/`

([↑ Back to tidy attributes](#tidy-attributes))

<h4 id="tidy-attribute-rmdirs">rmdirs</h4>

Tidy directories in addition to files; that is, remove
directories whose age is older than the specified criteria.
This will only remove empty directories, so all contained
files must also be tidied before a directory gets removed.

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to tidy attributes](#tidy-attributes))

<h4 id="tidy-attribute-size">size</h4>

Tidy files whose size is equal to or greater than
the specified size.  Unqualified values are in kilobytes, but
*b*, *k*, *m*, *g*, and *t* can be appended to specify *bytes*,
*kilobytes*, *megabytes*, *gigabytes*, and *terabytes*, respectively.
Only the first character is significant, so the full word can also
be used.

([↑ Back to tidy attributes](#tidy-attributes))

<h4 id="tidy-attribute-type">type</h4>

Set the mechanism for determining age.

Default: `atime`

Allowed values:

* `atime`
* `mtime`
* `ctime`

([↑ Back to tidy attributes](#tidy-attributes))



user
-----

* [Attributes](#user-attributes)
* [Providers](#user-providers)
* [Provider Features](#user-provider-features)

<h3 id="user-description">Description</h3>

Manage users.  This type is mostly built to manage system
users, so it is lacking some features useful for managing normal
users.

This resource type uses the prescribed native tools for creating
groups and generally uses POSIX APIs for retrieving information
about them.  It does not directly modify `/etc/passwd` or anything.

**Autorequires:** If Puppet is managing the user's primary group (as
provided in the `gid` attribute) or any group listed in the `groups`
attribute then the user resource will autorequire that group. If Puppet
is managing any role accounts corresponding to the user's roles, the
user resource will autorequire those role accounts.

<h3 id="user-attributes">Attributes</h3>

<pre><code>user { 'resource title':
  <a href="#user-attribute-name">name</a>                 =&gt; <em># <strong>(namevar)</strong> The user name. While naming limitations vary by...</em>
  <a href="#user-attribute-ensure">ensure</a>               =&gt; <em># The basic state that the object should be in....</em>
  <a href="#user-attribute-allowdupe">allowdupe</a>            =&gt; <em># Whether to allow duplicate UIDs.  Default...</em>
  <a href="#user-attribute-attribute_membership">attribute_membership</a> =&gt; <em># Whether specified attribute value pairs should...</em>
  <a href="#user-attribute-attributes">attributes</a>           =&gt; <em># Specify AIX attributes for the user in an array...</em>
  <a href="#user-attribute-auth_membership">auth_membership</a>      =&gt; <em># Whether specified auths should be considered the </em>
  <a href="#user-attribute-auths">auths</a>                =&gt; <em># The auths the user has.  Multiple auths should...</em>
  <a href="#user-attribute-comment">comment</a>              =&gt; <em># A description of the user.  Generally the user's </em>
  <a href="#user-attribute-expiry">expiry</a>               =&gt; <em># The expiry date for this user. Provide as either </em>
  <a href="#user-attribute-forcelocal">forcelocal</a>           =&gt; <em># Forces the management of local accounts when...</em>
  <a href="#user-attribute-gid">gid</a>                  =&gt; <em># The user's primary group.  Can be specified...</em>
  <a href="#user-attribute-groups">groups</a>               =&gt; <em># The groups to which the user belongs.  The...</em>
  <a href="#user-attribute-home">home</a>                 =&gt; <em># The home directory of the user.  The directory...</em>
  <a href="#user-attribute-ia_load_module">ia_load_module</a>       =&gt; <em># The name of the I&A module to use to manage this </em>
  <a href="#user-attribute-iterations">iterations</a>           =&gt; <em># This is the number of iterations of a chained...</em>
  <a href="#user-attribute-key_membership">key_membership</a>       =&gt; <em># Whether specified key/value pairs should be...</em>
  <a href="#user-attribute-keys">keys</a>                 =&gt; <em># Specify user attributes in an array of key ...</em>
  <a href="#user-attribute-loginclass">loginclass</a>           =&gt; <em># The name of login class to which the user...</em>
  <a href="#user-attribute-managehome">managehome</a>           =&gt; <em># Whether to manage the home directory when Puppet </em>
  <a href="#user-attribute-membership">membership</a>           =&gt; <em># If `minimum` is specified, Puppet will ensure...</em>
  <a href="#user-attribute-password">password</a>             =&gt; <em># The user's password, in whatever encrypted...</em>
  <a href="#user-attribute-password_max_age">password_max_age</a>     =&gt; <em># The maximum number of days a password may be...</em>
  <a href="#user-attribute-password_min_age">password_min_age</a>     =&gt; <em># The minimum number of days a password must be...</em>
  <a href="#user-attribute-password_warn_days">password_warn_days</a>   =&gt; <em># The number of days before a password is going to </em>
  <a href="#user-attribute-profile_membership">profile_membership</a>   =&gt; <em># Whether specified roles should be treated as the </em>
  <a href="#user-attribute-profiles">profiles</a>             =&gt; <em># The profiles the user has.  Multiple profiles...</em>
  <a href="#user-attribute-project">project</a>              =&gt; <em># The name of the project associated with a user.  </em>
  <a href="#user-attribute-provider">provider</a>             =&gt; <em># The specific backend to use for this `user...</em>
  <a href="#user-attribute-purge_ssh_keys">purge_ssh_keys</a>       =&gt; <em># Whether to purge authorized SSH keys for this...</em>
  <a href="#user-attribute-role_membership">role_membership</a>      =&gt; <em># Whether specified roles should be considered the </em>
  <a href="#user-attribute-roles">roles</a>                =&gt; <em># The roles the user has.  Multiple roles should...</em>
  <a href="#user-attribute-salt">salt</a>                 =&gt; <em># This is the 32-byte salt used to generate the...</em>
  <a href="#user-attribute-shell">shell</a>                =&gt; <em># The user's login shell.  The shell must exist...</em>
  <a href="#user-attribute-system">system</a>               =&gt; <em># Whether the user is a system user, according to...</em>
  <a href="#user-attribute-uid">uid</a>                  =&gt; <em># The user ID; must be specified numerically. If...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="user-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The user name. While naming limitations vary by operating system,
it is advisable to restrict names to the lowest common denominator,
which is a maximum of 8 characters beginning with a letter.

Note that Puppet considers user names to be case-sensitive, regardless
of the platform's own rules; be sure to always use the same case when
referring to a given user.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic state that the object should be in.

Allowed values:

* `present`
* `absent`
* `role`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-allowdupe">allowdupe</h4>

Whether to allow duplicate UIDs.

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-attribute_membership">attribute_membership</h4>

Whether specified attribute value pairs should be treated as the
**complete list** (`inclusive`) or the **minimum list** (`minimum`) of
attribute/value pairs for the user.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-attributes">attributes</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Specify AIX attributes for the user in an array of attribute = value pairs.

 For example:

 ```
 ['minage=0', 'maxage=5', 'SYSTEM=compat']
 ```

 or

```
attributes => { 'minage' => '0', 'maxage' => '5', 'SYSTEM' => 'compat' }
```

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-auth_membership">auth_membership</h4>

Whether specified auths should be considered the **complete list**
(`inclusive`) or the **minimum list** (`minimum`) of auths the user
has. This setting is specific to managing Solaris authorizations.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-auths">auths</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The auths the user has.  Multiple auths should be
specified as an array.

Requires features manages_solaris_rbac.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-comment">comment</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A description of the user.  Generally the user's full name.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-expiry">expiry</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The expiry date for this user. Provide as either the special
value `absent` to ensure that the account never expires, or as
a zero-padded YYYY-MM-DD format -- for example, 2010-02-19.

Allowed values:

* `absent`
* `/^\d{4}-\d{2}-\d{2}$/`

Requires features manages_expiry.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-forcelocal">forcelocal</h4>

Forces the management of local accounts when accounts are also
being managed by some other NSS

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

Requires features libuser.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-gid">gid</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The user's primary group.  Can be specified numerically or by name.

This attribute is not supported on Windows systems; use the `groups`
attribute instead. (On Windows, designating a primary group is only
meaningful for domain accounts, which Puppet does not currently manage.)

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-groups">groups</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The groups to which the user belongs.  The primary group should
not be listed, and groups should be identified by name rather than by
GID.  Multiple groups should be specified as an array.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-home">home</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The home directory of the user.  The directory must be created
separately and is not currently checked for existence.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-ia_load_module">ia_load_module</h4>

The name of the I&A module to use to manage this user.

Requires features manages_aix_lam.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-iterations">iterations</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

This is the number of iterations of a chained computation of the
[PBKDF2 password hash](https://en.wikipedia.org/wiki/PBKDF2). This parameter
is used in OS X, and is required for managing passwords on OS X 10.8 and
newer.

Requires features manages_password_salt.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-key_membership">key_membership</h4>

Whether specified key/value pairs should be considered the
**complete list** (`inclusive`) or the **minimum list** (`minimum`) of
the user's attributes.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-keys">keys</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Specify user attributes in an array of key = value pairs.

Requires features manages_solaris_rbac.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-loginclass">loginclass</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The name of login class to which the user belongs.

Requires features manages_loginclass.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-managehome">managehome</h4>

Whether to manage the home directory when Puppet creates or removes the user.
This creates the home directory if Puppet also creates the user account, and deletes the
home directory if Puppet also removes the user account.

This parameter has no effect unless Puppet is also creating or removing the user in the
resource at the same time. For instance, Puppet creates a home directory for a managed
user if `ensure => present` and the user does not exist at the time of the Puppet run.
If the home directory is then deleted manually, Puppet will not recreate it on the next
run.

Note that on Windows, this manages creation/deletion of the user profile instead of the
home directory. The user profile is stored in the `C:\Users\<username>` directory.

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-membership">membership</h4>

If `minimum` is specified, Puppet will ensure that the user is a
member of all specified groups, but will not remove any other groups
that the user is a part of.

If `inclusive` is specified, Puppet will ensure that the user is a
member of **only** specified groups.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-password">password</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The user's password, in whatever encrypted format the local system
requires. Consult your operating system's documentation for acceptable password
encryption formats and requirements.

* Mac OS X 10.5 and 10.6, and some older Linux distributions, use salted SHA1
  hashes. You can use Puppet's built-in `sha1` function to generate a salted SHA1
  hash from a password.
* Mac OS X 10.7 (Lion), and many recent Linux distributions, use salted SHA512
  hashes. The Puppet Labs [stdlib][] module contains a `str2saltedsha512` function
  which can generate password hashes for these operating systems.
* OS X 10.8 and higher use salted SHA512 PBKDF2 hashes. When managing passwords
  on these systems, the `salt` and `iterations` attributes need to be specified as
  well as the password.
* Windows passwords can be managed only in cleartext, because there is no Windows
  API for setting the password hash.

[stdlib]: https://github.com/puppetlabs/puppetlabs-stdlib/

Enclose any value that includes a dollar sign ($) in single quotes (') to avoid
accidental variable interpolation.

To redact passwords from reports to PuppetDB, use the `Sensitive` data type. For
example, this resource protects the password:

```puppet
user { 'foo':
  ensure   => present,
  password => Sensitive("my secret password")
}
```

This results in the password being redacted from the report, as in the
`previous_value`, `desired_value`, and `message` fields below.

```yaml
    events:
    - !ruby/object:Puppet::Transaction::Event
      audited: false
      property: password
      previous_value: "[redacted]"
      desired_value: "[redacted]"
      historical_value:
      message: changed [redacted] to [redacted]
      name: :password_changed
      status: success
      time: 2017-05-17 16:06:02.934398293 -07:00
      redacted: true
      corrective_change: false
    corrective_change: false
```

Requires features manages_passwords.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-password_max_age">password_max_age</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The maximum number of days a password may be used before it must be changed.

Requires features manages_password_age.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-password_min_age">password_min_age</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The minimum number of days a password must be used before it may be changed.

Requires features manages_password_age.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-password_warn_days">password_warn_days</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The number of days before a password is going to expire (see the maximum password age) during which the user should be warned.

Requires features manages_password_age.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-profile_membership">profile_membership</h4>

Whether specified roles should be treated as the **complete list**
(`inclusive`) or the **minimum list** (`minimum`) of roles
of which the user is a member.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-profiles">profiles</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The profiles the user has.  Multiple profiles should be
specified as an array.

Requires features manages_solaris_rbac.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-project">project</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The name of the project associated with a user.

Requires features manages_solaris_rbac.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-provider">provider</h4>

The specific backend to use for this `user`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`aix`](#user-provider-aix)
* [`directoryservice`](#user-provider-directoryservice)
* [`hpuxuseradd`](#user-provider-hpuxuseradd)
* [`ldap`](#user-provider-ldap)
* [`openbsd`](#user-provider-openbsd)
* [`pw`](#user-provider-pw)
* [`user_role_add`](#user-provider-user_role_add)
* [`useradd`](#user-provider-useradd)
* [`windows_adsi`](#user-provider-windows_adsi)

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-purge_ssh_keys">purge_ssh_keys</h4>

Whether to purge authorized SSH keys for this user if they are not managed
with the `ssh_authorized_key` resource type. This parameter is a noop if the
ssh_authorized_key type is not available.

Allowed values are:

* `false` (default) --- don't purge SSH keys for this user.
* `true` --- look for keys in the `.ssh/authorized_keys` file in the user's
  home directory. Purge any keys that aren't managed as `ssh_authorized_key`
  resources.
* An array of file paths --- look for keys in all of the files listed. Purge
  any keys that aren't managed as `ssh_authorized_key` resources. If any of
  these paths starts with `~` or `%h`, that token will be replaced with
  the user's home directory.

Default: `false`

Allowed values:

* `true`
* `false`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-role_membership">role_membership</h4>

Whether specified roles should be considered the **complete list**
(`inclusive`) or the **minimum list** (`minimum`) of roles the user
has.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-roles">roles</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The roles the user has.  Multiple roles should be
specified as an array.

Requires features manages_solaris_rbac.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-salt">salt</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

This is the 32-byte salt used to generate the PBKDF2 password used in
OS X. This field is required for managing passwords on OS X >= 10.8.

Requires features manages_password_salt.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-shell">shell</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The user's login shell.  The shell must exist and be
executable.

This attribute cannot be managed on Windows systems.

Requires features manages_shell.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-system">system</h4>

Whether the user is a system user, according to the OS's criteria;
on most platforms, a UID less than or equal to 500 indicates a system
user. This parameter is only used when the resource is created and will
not affect the UID when the user is present.

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-uid">uid</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The user ID; must be specified numerically. If no user ID is
specified when creating a new user, then one will be chosen
automatically. This will likely result in the same user having
different UIDs on different systems, which is not recommended. This is
especially noteworthy when managing the same user on both Darwin and
other platforms, since Puppet does UID generation on Darwin, but
the underlying tools do so on other platforms.

On Windows, this property is read-only and will return the user's
security identifier (SID).

([↑ Back to user attributes](#user-attributes))


<h3 id="user-providers">Providers</h3>

<h4 id="user-provider-aix">aix</h4>

User management for AIX.

* Required binaries: `/usr/sbin/lsuser`, `/usr/bin/mkuser`, `/usr/sbin/rmuser`, `/usr/bin/chuser`, `/bin/chpasswd`
* Confined to: `operatingsystem == aix`
* Default for `operatingsystem` == `aix`.
* Supported features: `manages_aix_lam`, `manages_expiry`, `manages_homedir`, `manages_password_age`, `manages_passwords`, `manages_shell`.

<h4 id="user-provider-directoryservice">directoryservice</h4>

User management on OS X.

* Required binaries: `/usr/bin/uuidgen`, `/usr/bin/dsimport`, `/usr/bin/dscl`, `/usr/bin/dscacheutil`
* Confined to: `operatingsystem == darwin`, `feature == cfpropertylist`
* Default for `operatingsystem` == `darwin`.
* Supported features: `manages_password_salt`, `manages_passwords`, `manages_shell`.

<h4 id="user-provider-hpuxuseradd">hpuxuseradd</h4>

User management for HP-UX. This provider uses the undocumented `-F`
switch to HP-UX's special `usermod` binary to work around the fact that
its standard `usermod` cannot make changes while the user is logged in.
New functionality provides for changing trusted computing passwords and
resetting password expirations under trusted computing.

* Required binaries: `/usr/sam/lbin/usermod.sam`, `/usr/sam/lbin/userdel.sam`, `/usr/sam/lbin/useradd.sam`
* Confined to: `operatingsystem == hp-ux`
* Default for `operatingsystem` == `hp-ux`.
* Supported features: `allows_duplicates`, `manages_homedir`, `manages_passwords`.

<h4 id="user-provider-ldap">ldap</h4>

User management via LDAP.

This provider requires that you have valid values for all of the
LDAP-related settings in `puppet.conf`, including `ldapbase`.  You will
almost definitely need settings for `ldapuser` and `ldappassword` in order
for your clients to write to LDAP.

Note that this provider will automatically generate a UID for you if
you do not specify one, but it is a potentially expensive operation,
as it iterates across all existing users to pick the appropriate next one.

* Confined to: `feature == ldap`, `false == (Puppet[:ldapuser] == "")`
* Supported features: `manages_passwords`, `manages_shell`.

<h4 id="user-provider-openbsd">openbsd</h4>

User management via `useradd` and its ilk for OpenBSD. Note that you
will need to install Ruby's shadow password library (package known as
`ruby-shadow`) if you wish to manage user passwords.

* Required binaries: `useradd`, `userdel`, `usermod`, `passwd`
* Confined to: `operatingsystem == openbsd`
* Default for `operatingsystem` == `openbsd`.
* Supported features: `manages_expiry`, `manages_homedir`, `manages_shell`, `system_users`.

<h4 id="user-provider-pw">pw</h4>

User management via `pw` on FreeBSD and DragonFly BSD.

* Required binaries: `pw`
* Confined to: `operatingsystem == [:freebsd, :dragonfly]`
* Default for `operatingsystem` == `freebsd, dragonfly`.
* Supported features: `allows_duplicates`, `manages_expiry`, `manages_homedir`, `manages_passwords`, `manages_shell`.

<h4 id="user-provider-user_role_add">user_role_add</h4>

User and role management on Solaris, via `useradd` and `roleadd`.

* Required binaries: `useradd`, `userdel`, `usermod`, `passwd`, `roleadd`, `roledel`, `rolemod`
* Default for `osfamily` == `solaris`.
* Supported features: `allows_duplicates`, `manages_homedir`, `manages_password_age`, `manages_passwords`, `manages_shell`, `manages_solaris_rbac`.

<h4 id="user-provider-useradd">useradd</h4>

User management via `useradd` and its ilk.  Note that you will need to
install Ruby's shadow password library (often known as `ruby-libshadow`)
if you wish to manage user passwords.

* Required binaries: `useradd`, `userdel`, `usermod`, `chage`
* Supported features: `allows_duplicates`, `manages_expiry`, `manages_homedir`, `manages_shell`, `system_users`.

<h4 id="user-provider-windows_adsi">windows_adsi</h4>

Local user management for Windows.

* Confined to: `operatingsystem == windows`
* Default for `operatingsystem` == `windows`.
* Supported features: `manages_homedir`, `manages_passwords`.

<h3 id="user-provider-features">Provider Features</h3>

Available features:

* `allows_duplicates` --- The provider supports duplicate users with the same UID.
* `libuser` --- Allows local users to be managed on systems that also use some other remote NSS method of managing accounts.
* `manages_aix_lam` --- The provider can manage AIX Loadable Authentication Module (LAM) system.
* `manages_expiry` --- The provider can manage the expiry date for a user.
* `manages_homedir` --- The provider can create and remove home directories.
* `manages_loginclass` --- The provider can manage the login class for a user.
* `manages_password_age` --- The provider can set age requirements and restrictions for passwords.
* `manages_password_salt` --- The provider can set a password salt. This is for providers that implement PBKDF2 passwords with salt properties.
* `manages_passwords` --- The provider can modify user passwords, by accepting a password hash.
* `manages_shell` --- The provider allows for setting shell and validates if possible
* `manages_solaris_rbac` --- The provider can manage roles and normal users
* `system_users` --- The provider allows you to create system users with lower UIDs.

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>allows duplicates</th>
      <th>libuser</th>
      <th>manages aix lam</th>
      <th>manages expiry</th>
      <th>manages homedir</th>
      <th>manages loginclass</th>
      <th>manages password age</th>
      <th>manages password salt</th>
      <th>manages passwords</th>
      <th>manages shell</th>
      <th>manages solaris rbac</th>
      <th>system users</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>aix</td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>directoryservice</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>hpuxuseradd</td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>ldap</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>openbsd</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>pw</td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>user_role_add</td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>useradd</td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>windows_adsi</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
  </tbody>
</table>

