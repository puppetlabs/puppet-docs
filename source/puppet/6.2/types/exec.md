---
layout: default
built_from_commit: e08055f43b0d05a8496a3be38ed5a28747bcdf36
title: 'Resource Type: exec'
canonical: "/puppet/latest/types/exec.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2019-02-01 11:08:12 -0800

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




> **NOTE:** This page was generated from the Puppet source code on 2019-02-01 11:08:12 -0800