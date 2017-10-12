---
layout: default
built_from_commit: ab595327c42b4fbafdd669d8a0208ce081c03133
title: Resource Type Reference (Single-Page)
canonical: "/puppet/latest/type.html"
toc_levels: 2
toc: columns
---

> **NOTE:** This page was generated from the Puppet source code on 2017-10-04 17:17:52 -0700

## About Resource Types

### Built-in Types and Custom Types

This is the documentation for the _built-in_ resource types and providers, keyed
to a specific Puppet version. (See sidebar.) Additional resource types can be
distributed in Puppet modules; you can find and install modules by browsing the
[Puppet Forge](http://forge.puppetlabs.com). See each module's documentation for
information on how to use its custom resource types.

### Declaring Resources

To manage resources on a target system, you should declare them in Puppet
manifests. For more details, see
[the resources page of the Puppet language reference.](/puppet/latest/lang_resources.html)

You can also browse and manage resources interactively using the
`puppet resource` subcommand; run `puppet resource --help` for more information.

### Namevars and Titles

All types have a special attribute called the *namevar.* This is the attribute
used to uniquely identify a resource _on the target system._ If you don't
specifically assign a value for the namevar, its value will default to the
_title_ of the resource.

Example:

    file { '/etc/passwd':
      owner => 'root',
      group => 'root',
      mode  => '0644',
    }

In this code, `/etc/passwd` is the _title_ of the file resource; other Puppet
code can refer to the resource as `File['/etc/passwd']` to declare
relationships. Because `path` is the namevar for the file type and we did not
provide a value for it, the value of `path` will default to `/etc/passwd`.

### Attributes, Parameters, Properties

The *attributes* (sometimes called *parameters*) of a resource determine its
desired state.  They either directly modify the system (internally, these are
called "properties") or they affect how the resource behaves (e.g., adding a
search path for `exec` resources or controlling directory recursion on `file`
resources).

### Providers

*Providers* implement the same resource type on different kinds of systems.
They usually do this by calling out to external commands.

Although Puppet will automatically select an appropriate default provider, you
can override the default with the `provider` attribute. (For example, `package`
resources on Red Hat systems default to the `yum` provider, but you can specify
`provider => gem` to install Ruby libraries with the `gem` command.)

Providers often specify binaries that they require. Fully qualified binary
paths indicate that the binary must exist at that specific path, and
unqualified paths indicate that Puppet will search for the binary using the
shell path.

### Features

*Features* are abilities that some providers may not support. Generally, a
feature will correspond to some allowed values for a resource attribute; for
example, if a `package` provider supports the `purgeable` feature, you can
specify `ensure => purged` to delete config files installed by the package.

Resource types define the set of features they can use, and providers can
declare which features they provide.

----------------

augeas
-----

* [Attributes](#augeas-attributes)
* [Providers](#augeas-providers)
* [Provider Features](#augeas-provider-features)

<h3 id="augeas-description">Description</h3>

Apply a change or an array of changes to the filesystem
using the augeas tool.

Requires:

- [Augeas](http://www.augeas.net)
- The ruby-augeas bindings

Sample usage with a string:

    augeas{"test1" :
      context => "/files/etc/sysconfig/firstboot",
      changes => "set RUN_FIRSTBOOT YES",
      onlyif  => "match other_value size > 0",
    }

Sample usage with an array and custom lenses:

    augeas{"jboss_conf":
      context   => "/files",
      changes   => [
          "set etc/jbossas/jbossas.conf/JBOSS_IP $ipaddress",
          "set etc/jbossas/jbossas.conf/JAVA_HOME /usr",
        ],
      load_path => "$/usr/share/jbossas/lenses",
    }

<h3 id="augeas-attributes">Attributes</h3>

<pre><code>augeas { 'resource title':
  <a href="#augeas-attribute-changes">changes</a>    =&gt; <em># The changes which should be applied to the...</em>
  <a href="#augeas-attribute-force">force</a>      =&gt; <em># Optional command to force the augeas type to...</em>
  <a href="#augeas-attribute-incl">incl</a>       =&gt; <em># Load only a specific file, e.g. `/etc/hosts`...</em>
  <a href="#augeas-attribute-lens">lens</a>       =&gt; <em># Use a specific lens, e.g. `Hosts.lns`. When this </em>
  <a href="#augeas-attribute-load_path">load_path</a>  =&gt; <em># Optional colon-separated list or array of...</em>
  <a href="#augeas-attribute-returns">returns</a>    =&gt; <em># The expected return code from the augeas...</em>
  <a href="#augeas-attribute-root">root</a>       =&gt; <em># A file system path; all files loaded by Augeas...</em>
  <a href="#augeas-attribute-show_diff">show_diff</a>  =&gt; <em># Whether to display differences when the file...</em>
  <a href="#augeas-attribute-type_check">type_check</a> =&gt; <em># Whether augeas should perform typechecking...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="augeas-attribute-changes">changes</h4>

The changes which should be applied to the filesystem. This
can be a command or an array of commands. The following commands are supported:

* `set <PATH> <VALUE>` --- Sets the value `VALUE` at location `PATH`
* `setm <PATH> <SUB> <VALUE>` --- Sets multiple nodes (matching `SUB` relative to `PATH`) to `VALUE`
* `rm <PATH>` --- Removes the node at location `PATH`
* `remove <PATH>` --- Synonym for `rm`
* `clear <PATH>` --- Sets the node at `PATH` to `NULL`, creating it if needed
* `clearm <PATH> <SUB>` --- Sets multiple nodes (matching `SUB` relative to `PATH`) to `NULL`
* `touch <PATH>` --- Creates `PATH` with the value `NULL` if it does not exist
* `ins <LABEL> (before|after) <PATH>` --- Inserts an empty node `LABEL` either before or after `PATH`.
* `insert <LABEL> <WHERE> <PATH>` --- Synonym for `ins`
* `mv <PATH> <OTHER PATH>` --- Moves a node at `PATH` to the new location `OTHER PATH`
* `move <PATH> <OTHER PATH>` --- Synonym for `mv`
* `rename <PATH> <LABEL>` --- Rename a node at `PATH` to a new `LABEL`
* `defvar <NAME> <PATH>` --- Sets Augeas variable `$NAME` to `PATH`
* `defnode <NAME> <PATH> <VALUE>` --- Sets Augeas variable `$NAME` to `PATH`, creating it with `VALUE` if needed

If the `context` parameter is set, that value is prepended to any relative `PATH`s.

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-force">force</h4>

Optional command to force the augeas type to execute even if it thinks changes
will not be made. This does not override the `onlyif` parameter.

Default: `false`

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-incl">incl</h4>

Load only a specific file, e.g. `/etc/hosts`. This can greatly speed
up the execution the resource. When this parameter is set, you must also
set the `lens` parameter to indicate which lens to use.

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-lens">lens</h4>

Use a specific lens, e.g. `Hosts.lns`. When this parameter is set, you
must also set the `incl` parameter to indicate which file to load.
The Augeas documentation includes [a list of available lenses](http://augeas.net/stock_lenses.html).

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-load_path">load_path</h4>

Optional colon-separated list or array of directories; these directories are searched for schema definitions. The agent's `$libdir/augeas/lenses` path will always be added to support pluginsync.

Default: `""`

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-returns">returns</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The expected return code from the augeas command. Should not be set.

Default: `0`

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-root">root</h4>

A file system path; all files loaded by Augeas are loaded underneath `root`.

Default: `/`

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-show_diff">show_diff</h4>

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

([↑ Back to augeas attributes](#augeas-attributes))

<h4 id="augeas-attribute-type_check">type_check</h4>

Whether augeas should perform typechecking. Defaults to false.

Default: `false`

Allowed values:

* `true`
* `false`

([↑ Back to augeas attributes](#augeas-attributes))


<h3 id="augeas-providers">Providers</h3>

<h4 id="augeas-provider-augeas">augeas</h4>



* Confined to: `feature == augeas`

<h3 id="augeas-provider-features">Provider Features</h3>

Available features:

* `execute_changes` --- Actually make the changes
* `need_to_run?` --- If the command should run
* `parse_commands` --- Parse the command string

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>execute changes</th>
      <th>need to run?</th>
      <th>parse commands</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>augeas</td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
  </tbody>
</table>



---------

component
-----

* [Attributes](#component-attributes)

<h3 id="component-description">Description</h3>

The name of the component.  Generally optional.

<h3 id="component-attributes">Attributes</h3>

<pre><code>component { 'resource title':
  <a href="#component-attribute-name">name</a> =&gt; <em># <strong>(namevar)</strong> The name of the component.  Generally...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="component-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the component.  Generally optional.

([↑ Back to component attributes](#component-attributes))





---------

computer
-----

* [Attributes](#computer-attributes)
* [Providers](#computer-providers)

<h3 id="computer-description">Description</h3>

Computer object management using DirectoryService
on OS X.

Note that these are distinctly different kinds of objects to 'hosts',
as they require a MAC address and can have all sorts of policy attached to
them.

This provider only manages Computer objects in the local directory service
domain, not in remote directories.

If you wish to manage `/etc/hosts` file on Mac OS X, then simply use the host
type as per other platforms.

This type primarily exists to create localhost Computer objects that MCX
policy can then be attached to.

**Autorequires:** If Puppet is managing the plist file representing a
Computer object (located at `/var/db/dslocal/nodes/Default/computers/{name}.plist`),
the Computer resource will autorequire it.

<h3 id="computer-attributes">Attributes</h3>

<pre><code>computer { 'resource title':
  <a href="#computer-attribute-name">name</a>       =&gt; <em># <strong>(namevar)</strong> The authoritative 'short' name of the computer...</em>
  <a href="#computer-attribute-ensure">ensure</a>     =&gt; <em># Control the existences of this computer record...</em>
  <a href="#computer-attribute-en_address">en_address</a> =&gt; <em># The MAC address of the primary network...</em>
  <a href="#computer-attribute-ip_address">ip_address</a> =&gt; <em># The IP Address of the Computer...</em>
  <a href="#computer-attribute-realname">realname</a>   =&gt; <em># The 'long' name of the computer...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="computer-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The authoritative 'short' name of the computer record.

([↑ Back to computer attributes](#computer-attributes))

<h4 id="computer-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Control the existences of this computer record. Set this attribute to
`present` to ensure the computer record exists.  Set it to `absent`
to delete any computer records with this name

Allowed values:

* `present`
* `absent`

([↑ Back to computer attributes](#computer-attributes))

<h4 id="computer-attribute-en_address">en_address</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The MAC address of the primary network interface. Must match en0.

([↑ Back to computer attributes](#computer-attributes))

<h4 id="computer-attribute-ip_address">ip_address</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The IP Address of the Computer object.

([↑ Back to computer attributes](#computer-attributes))

<h4 id="computer-attribute-realname">realname</h4>

The 'long' name of the computer record.

([↑ Back to computer attributes](#computer-attributes))


<h3 id="computer-providers">Providers</h3>

<h4 id="computer-provider-directoryservice">directoryservice</h4>

Computer object management using DirectoryService on OS X.
Note that these are distinctly different kinds of objects to 'hosts',
as they require a MAC address and can have all sorts of policy attached to
them.

This provider only manages Computer objects in the local directory service
domain, not in remote directories.

If you wish to manage /etc/hosts on Mac OS X, then simply use the host
type as per other platforms.

* Confined to: `operatingsystem == darwin`
* Default for: `["operatingsystem", "darwin"] == `




---------

cron
-----

* [Attributes](#cron-attributes)
* [Providers](#cron-providers)

<h3 id="cron-description">Description</h3>

Installs and manages cron jobs.  Every cron resource created by Puppet
requires a command and at least one periodic attribute (hour, minute,
month, monthday, weekday, or special).  While the name of the cron job is
not part of the actual job, the name is stored in a comment beginning with
`# Puppet Name: `. These comments are used to match crontab entries created
by Puppet with cron resources.

If an existing crontab entry happens to match the scheduling and command of a
cron resource that has never been synched, Puppet will defer to the existing
crontab entry and will not create a new entry tagged with the `# Puppet Name: `
comment.

Example:

    cron { 'logrotate':
      command => '/usr/sbin/logrotate',
      user    => 'root',
      hour    => 2,
      minute  => 0,
    }

Note that all periodic attributes can be specified as an array of values:

    cron { 'logrotate':
      command => '/usr/sbin/logrotate',
      user    => 'root',
      hour    => [2, 4],
    }

...or using ranges or the step syntax `*/2` (although there's no guarantee
that your `cron` daemon supports these):

    cron { 'logrotate':
      command => '/usr/sbin/logrotate',
      user    => 'root',
      hour    => ['2-4'],
      minute  => '*/10',
    }

An important note: _the Cron type will not reset parameters that are
removed from a manifest_. For example, removing a `minute => 10` parameter
will not reset the minute component of the associated cronjob to `*`.
These changes must be expressed by setting the parameter to
`minute => absent` because Puppet only manages parameters that are out of
sync with manifest entries.

**Autorequires:** If Puppet is managing the user account specified by the
`user` property of a cron resource, then the cron resource will autorequire
that user.

<h3 id="cron-attributes">Attributes</h3>

<pre><code>cron { 'resource title':
  <a href="#cron-attribute-name">name</a>        =&gt; <em># <strong>(namevar)</strong> The symbolic name of the cron job.  This name is </em>
  <a href="#cron-attribute-ensure">ensure</a>      =&gt; <em># The basic property that the resource should be...</em>
  <a href="#cron-attribute-command">command</a>     =&gt; <em># The command to execute in the cron job.  The...</em>
  <a href="#cron-attribute-environment">environment</a> =&gt; <em># Any environment settings associated with this...</em>
  <a href="#cron-attribute-hour">hour</a>        =&gt; <em># The hour at which to run the cron job. Optional; </em>
  <a href="#cron-attribute-minute">minute</a>      =&gt; <em># The minute at which to run the cron job...</em>
  <a href="#cron-attribute-month">month</a>       =&gt; <em># The month of the year.  Optional; if specified...</em>
  <a href="#cron-attribute-monthday">monthday</a>    =&gt; <em># The day of the month on which to run the...</em>
  <a href="#cron-attribute-special">special</a>     =&gt; <em># A special value such as 'reboot' or 'annually'...</em>
  <a href="#cron-attribute-target">target</a>      =&gt; <em># The name of the crontab file in which the cron...</em>
  <a href="#cron-attribute-user">user</a>        =&gt; <em># The user who owns the cron job.  This user must...</em>
  <a href="#cron-attribute-weekday">weekday</a>     =&gt; <em># The weekday on which to run the command...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="cron-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The symbolic name of the cron job.  This name
is used for human reference only and is generated automatically
for cron jobs found on the system.  This generally won't
matter, as Puppet will do its best to match existing cron jobs
against specified jobs (and Puppet adds a comment to cron jobs it adds),
but it is at least possible that converting from unmanaged jobs to
managed jobs might require manual intervention.

([↑ Back to cron attributes](#cron-attributes))

<h4 id="cron-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to cron attributes](#cron-attributes))

<h4 id="cron-attribute-command">command</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The command to execute in the cron job.  The environment
provided to the command varies by local system rules, and it is
best to always provide a fully qualified command.  The user's
profile is not sourced when the command is run, so if the
user's environment is desired it should be sourced manually.

All cron parameters support `absent` as a value; this will
remove any existing values for that field.

([↑ Back to cron attributes](#cron-attributes))

<h4 id="cron-attribute-environment">environment</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Any environment settings associated with this cron job.  They
will be stored between the header and the job in the crontab.  There
can be no guarantees that other, earlier settings will not also
affect a given cron job.


Also, Puppet cannot automatically determine whether an existing,
unmanaged environment setting is associated with a given cron
job.  If you already have cron jobs with environment settings,
then Puppet will keep those settings in the same place in the file,
but will not associate them with a specific job.

Settings should be specified exactly as they should appear in
the crontab, e.g., `PATH=/bin:/usr/bin:/usr/sbin`.

([↑ Back to cron attributes](#cron-attributes))

<h4 id="cron-attribute-hour">hour</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The hour at which to run the cron job. Optional;
if specified, must be between 0 and 23, inclusive.

([↑ Back to cron attributes](#cron-attributes))

<h4 id="cron-attribute-minute">minute</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The minute at which to run the cron job.
Optional; if specified, must be between 0 and 59, inclusive.

([↑ Back to cron attributes](#cron-attributes))

<h4 id="cron-attribute-month">month</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The month of the year.  Optional; if specified
must be between 1 and 12 or the month name (e.g., December).

([↑ Back to cron attributes](#cron-attributes))

<h4 id="cron-attribute-monthday">monthday</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The day of the month on which to run the
command.  Optional; if specified, must be between 1 and 31.

([↑ Back to cron attributes](#cron-attributes))

<h4 id="cron-attribute-special">special</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A special value such as 'reboot' or 'annually'.
Only available on supported systems such as Vixie Cron.
Overrides more specific time of day/week settings.
Set to 'absent' to make puppet revert to a plain numeric schedule.

([↑ Back to cron attributes](#cron-attributes))

<h4 id="cron-attribute-target">target</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The name of the crontab file in which the cron job should be stored.

This property defaults to the value of the `user` property if set, the
user running Puppet or `root`.

For the default crontab provider, this property is functionally
equivalent to the `user` property and should be avoided. In particular,
setting both `user` and `target` to different values will result in
undefined behavior.

([↑ Back to cron attributes](#cron-attributes))

<h4 id="cron-attribute-user">user</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The user who owns the cron job.  This user must
be allowed to run cron jobs, which is not currently checked by
Puppet.

This property defaults to the user running Puppet or `root`.

The default crontab provider executes the system `crontab` using
the user account specified by this property.

([↑ Back to cron attributes](#cron-attributes))

<h4 id="cron-attribute-weekday">weekday</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The weekday on which to run the command.
Optional; if specified, must be between 0 and 7, inclusive, with
0 (or 7) being Sunday, or must be the name of the day (e.g., Tuesday).

([↑ Back to cron attributes](#cron-attributes))


<h3 id="cron-providers">Providers</h3>

<h4 id="cron-provider-crontab">crontab</h4>



* Required binaries: `crontab`




---------

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
  <a href="#exec-attribute-cwd">cwd</a>         =&gt; <em># The directory from which to run the command.  If </em>
  <a href="#exec-attribute-environment">environment</a> =&gt; <em># Any additional environment variables you want to </em>
  <a href="#exec-attribute-group">group</a>       =&gt; <em># The group to run the command as.  This seems to...</em>
  <a href="#exec-attribute-logoutput">logoutput</a>   =&gt; <em># Whether to log command output in addition to...</em>
  <a href="#exec-attribute-path">path</a>        =&gt; <em># The search path used for command execution...</em>
  <a href="#exec-attribute-refresh">refresh</a>     =&gt; <em># An alternate command to run when the `exec...</em>
  <a href="#exec-attribute-returns">returns</a>     =&gt; <em># The expected exit code(s).  An error will be...</em>
  <a href="#exec-attribute-timeout">timeout</a>     =&gt; <em># The maximum time the command should take.  If...</em>
  <a href="#exec-attribute-tries">tries</a>       =&gt; <em># The number of times execution of the command...</em>
  <a href="#exec-attribute-try_sleep">try_sleep</a>   =&gt; <em># The time to sleep in seconds between 'tries'....</em>
  <a href="#exec-attribute-umask">umask</a>       =&gt; <em># Sets the umask to be used while executing this...</em>
  <a href="#exec-attribute-user">user</a>        =&gt; <em># The user to run the command as.  Note that if...</em>
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

<h4 id="exec-attribute-cwd">cwd</h4>

The directory from which to run the command.  If
this directory does not exist, the command will fail.

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-environment">environment</h4>

Any additional environment variables you want to set for a
command.  Note that if you use this to set PATH, it will override
the `path` attribute.  Multiple environment variables should be
specified as an array.

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-group">group</h4>

The group to run the command as.  This seems to work quite
haphazardly on different platforms -- it is a platform issue
not a Ruby or Puppet one, since the same variety exists when
running commands as different users in the shell.

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-logoutput">logoutput</h4>

Whether to log command output in addition to logging the
exit code.  Defaults to `on_failure`, which only logs the output
when the command has an exit code that does not match any value
specified by the `returns` attribute. As with any resource type,
the log level can be controlled with the `loglevel` metaparameter.

Default: `on_failure`

Allowed values:

* `true`
* `false`
* `on_failure`

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-path">path</h4>

The search path used for command execution.
Commands must be fully qualified if no path is specified.  Paths
can be specified as an array or as a '

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

<h4 id="exec-attribute-returns">returns</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The expected exit code(s).  An error will be returned if the
executed command has some other exit code.  Defaults to 0. Can be
specified as an array of acceptable exit codes or a single value.

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
Defaults to '1'. This many attempts will be made to execute
the command until an acceptable return code is returned.
Note that the timeout parameter applies to each try rather than
to the complete set of tries.

Default: `1`

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-try_sleep">try_sleep</h4>

The time to sleep in seconds between 'tries'.

Default: `0`

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-umask">umask</h4>

Sets the umask to be used while executing this command

([↑ Back to exec attributes](#exec-attributes))

<h4 id="exec-attribute-user">user</h4>

The user to run the command as.  Note that if you
use this then any error output is not currently captured.  This
is because of a bug within Ruby.  If you are using Puppet to
create this user, the exec will automatically require the user,
as long as it is specified by name.

Please note that the $HOME environment variable is not automatically set
when using this attribute.

([↑ Back to exec attributes](#exec-attributes))


<h3 id="exec-providers">Providers</h3>

<h4 id="exec-provider-posix">posix</h4>

Executes external binaries directly, without passing through a shell or
performing any interpolation. This is a safer and more predictable way
to execute most commands, but prevents the use of globbing and shell
built-ins (including control logic like "for" and "if" statements).

* Confined to: `feature == posix`
* Default for: `["feature", "posix"] == `

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




---------

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

<h3 id="file-attributes">Attributes</h3>

<pre><code>file { 'resource title':
  <a href="#file-attribute-path">path</a>                 =&gt; <em># <strong>(namevar)</strong> The path to the file to manage.  Must be fully...</em>
  <a href="#file-attribute-backup">backup</a>               =&gt; <em># Whether (and how) file content should be backed...</em>
  <a href="#file-attribute-force">force</a>                =&gt; <em># Perform the file operation even if it will...</em>
  <a href="#file-attribute-ignore">ignore</a>               =&gt; <em># A parameter which omits action on files matching </em>
  <a href="#file-attribute-links">links</a>                =&gt; <em># How to handle links during file actions.  During </em>
  <a href="#file-attribute-purge">purge</a>                =&gt; <em># Whether unmanaged files should be purged. This...</em>
  <a href="#file-attribute-recurse">recurse</a>              =&gt; <em># Whether to recursively manage the _contents_ of...</em>
  <a href="#file-attribute-recurselimit">recurselimit</a>         =&gt; <em># How far Puppet should descend into...</em>
  <a href="#file-attribute-replace">replace</a>              =&gt; <em># Whether to replace a file or symlink that...</em>
  <a href="#file-attribute-show_diff">show_diff</a>            =&gt; <em># Whether to display differences when the file...</em>
  <a href="#file-attribute-sourceselect">sourceselect</a>         =&gt; <em># Whether to copy all valid sources, or just the...</em>
  <a href="#file-attribute-validate_cmd">validate_cmd</a>         =&gt; <em># A command for validating the file's syntax...</em>
  <a href="#file-attribute-validate_replacement">validate_replacement</a> =&gt; <em># The replacement string in a `validate_cmd` that...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="file-attribute-path">path</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The path to the file to manage.  Must be fully qualified.

On Windows, the path should include the drive letter and should use `/` as
the separator character (rather than `\\`).

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-backup">backup</h4>

Whether (and how) file content should be backed up before being replaced.
This attribute works best as a resource default in the site manifest
(`File { backup => main }`), so it can affect all file resources.

* If set to `false`, file content won't be backed up.
* If set to a string beginning with `.` (e.g., `.puppet-bak`), Puppet will
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

<h4 id="file-attribute-ignore">ignore</h4>

A parameter which omits action on files matching
specified patterns during recursion.  Uses Ruby's builtin globbing
engine, so shell metacharacters are fully supported, e.g. `[a-z]*`.
Matches that would descend into the directory structure are ignored,
e.g., `*/*`.

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

By default, setting recurse to `remote` or `true` will manage _all_
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

And so on --- 3 will manage the contents of the second level of
subdirectories, etc.

Allowed values:

* `/^[0-9]+$/`

([↑ Back to file attributes](#file-attributes))

<h4 id="file-attribute-replace">replace</h4>

Whether to replace a file or symlink that already exists on the local system but
whose content doesn't match what the `source` or `content` attribute
specifies.  Setting this to false allows file resources to initialize files
without overwriting future changes.  Note that this only affects content;
Puppet will still manage ownership and permissions. Defaults to `true`.

Default: `true`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

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
with an input file name. Defaults to: `%`

Default: `%`

([↑ Back to file attributes](#file-attributes))


<h3 id="file-providers">Providers</h3>

<h4 id="file-provider-posix">posix</h4>

Uses POSIX functionality to manage file ownership and permissions.

* Confined to: `feature == posix`

<h4 id="file-provider-windows">windows</h4>

Uses Microsoft Windows functionality to manage file ownership and permissions.

* Confined to: `operatingsystem == windows`

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



---------

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
  <a href="#filebucket-attribute-port">port</a>   =&gt; <em># </em>
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



([↑ Back to filebucket attributes](#filebucket-attributes))

<h4 id="filebucket-attribute-server">server</h4>

The server providing the remote filebucket service. Defaults to the
value of the `server` setting (that is, the currently configured
puppet master server).

This setting is _only_ consulted if the `path` attribute is set to `false`.

([↑ Back to filebucket attributes](#filebucket-attributes))





---------

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
  <a href="#group-attribute-ensure">ensure</a>               =&gt; <em># Create or remove the group.  Allowed values:  ...</em>
  <a href="#group-attribute-allowdupe">allowdupe</a>            =&gt; <em># Whether to allow duplicate GIDs. Defaults to...</em>
  <a href="#group-attribute-attribute_membership">attribute_membership</a> =&gt; <em># AIX only. Configures the behavior of the...</em>
  <a href="#group-attribute-attributes">attributes</a>           =&gt; <em># Specify group AIX attributes, as an array of...</em>
  <a href="#group-attribute-auth_membership">auth_membership</a>      =&gt; <em># Configures the behavior of the `members...</em>
  <a href="#group-attribute-forcelocal">forcelocal</a>           =&gt; <em># Forces the management of local accounts when...</em>
  <a href="#group-attribute-gid">gid</a>                  =&gt; <em># The group ID.  Must be specified numerically....</em>
  <a href="#group-attribute-ia_load_module">ia_load_module</a>       =&gt; <em># The name of the I&A module to use to manage this </em>
  <a href="#group-attribute-members">members</a>              =&gt; <em># The members of the group. For platforms or...</em>
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

Allowed values:

* `present`
* `absent`

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-allowdupe">allowdupe</h4>

Whether to allow duplicate GIDs. Defaults to `false`.

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
being managed by some other NSS

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

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

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-members">members</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The members of the group. For platforms or directory services where group
membership is stored in the group objects, not the users. This parameter's
behavior can be configured with `auth_membership`.

([↑ Back to group attributes](#group-attributes))

<h4 id="group-attribute-system">system</h4>

Whether the group is a system group with lower GID.

Default: `false`

Allowed values:

* `true`
* `false`
* `yes`
* `no`

([↑ Back to group attributes](#group-attributes))


<h3 id="group-providers">Providers</h3>

<h4 id="group-provider-aix">aix</h4>

Group management for AIX.

* Required binaries: `/usr/sbin/lsgroup`, `/usr/bin/mkgroup`, `/usr/sbin/rmgroup`, `/usr/bin/chgroup`
* Confined to: `operatingsystem == aix`
* Default for: `["operatingsystem", "aix"] == `

<h4 id="group-provider-directoryservice">directoryservice</h4>

Group management using DirectoryService on OS X.

* Required binaries: `/usr/bin/dscl`
* Confined to: `operatingsystem == darwin`
* Default for: `["operatingsystem", "darwin"] == `

<h4 id="group-provider-groupadd">groupadd</h4>

Group management via `groupadd` and its ilk. The default for most platforms.

* Required binaries: `groupadd`, `groupdel`, `groupmod`

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
* Default for: `["operatingsystem", "[:freebsd, :dragonfly]"] == `

<h4 id="group-provider-windows_adsi">windows_adsi</h4>

Local group management for Windows. Group members can be both users and groups.
Additionally, local groups can contain domain users.

* Confined to: `operatingsystem == windows`
* Default for: `["operatingsystem", "windows"] == `

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
      <td> </td>
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



---------

host
-----

* [Attributes](#host-attributes)
* [Providers](#host-providers)

<h3 id="host-description">Description</h3>

The host's IP address, IPv4 or IPv6.

<h3 id="host-attributes">Attributes</h3>

<pre><code>host { 'resource title':
  <a href="#host-attribute-name">name</a>         =&gt; <em># <strong>(namevar)</strong> The host...</em>
  <a href="#host-attribute-ensure">ensure</a>       =&gt; <em># The basic property that the resource should be...</em>
  <a href="#host-attribute-comment">comment</a>      =&gt; <em># A comment that will be attached to the line with </em>
  <a href="#host-attribute-host_aliases">host_aliases</a> =&gt; <em># Any aliases the host might have.  Multiple...</em>
  <a href="#host-attribute-ip">ip</a>           =&gt; <em># The host's IP address, IPv4 or...</em>
  <a href="#host-attribute-target">target</a>       =&gt; <em># The file in which to store service information.  </em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="host-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The host name.

([↑ Back to host attributes](#host-attributes))

<h4 id="host-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to host attributes](#host-attributes))

<h4 id="host-attribute-comment">comment</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A comment that will be attached to the line with a # character.

([↑ Back to host attributes](#host-attributes))

<h4 id="host-attribute-host_aliases">host_aliases</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Any aliases the host might have.  Multiple values must be
specified as an array.

([↑ Back to host attributes](#host-attributes))

<h4 id="host-attribute-ip">ip</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The host's IP address, IPv4 or IPv6.

([↑ Back to host attributes](#host-attributes))

<h4 id="host-attribute-target">target</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The file in which to store service information.  Only used by
those providers that write to disk. On most systems this defaults to `/etc/hosts`.

([↑ Back to host attributes](#host-attributes))


<h3 id="host-providers">Providers</h3>

<h4 id="host-provider-parsed">parsed</h4>



* Confined to: `exists == hosts`




---------

interface
-----

* [Attributes](#interface-attributes)
* [Providers](#interface-providers)

<h3 id="interface-description">Description</h3>

This represents a router or switch interface. It is possible to manage
interface mode (access or trunking, native vlan and encapsulation) and
switchport characteristics (speed, duplex).

<h3 id="interface-attributes">Attributes</h3>

<pre><code>interface { 'resource title':
  <a href="#interface-attribute-name">name</a>                =&gt; <em># <strong>(namevar)</strong> The interface's...</em>
  <a href="#interface-attribute-ensure">ensure</a>              =&gt; <em># The basic property that the resource should be...</em>
  <a href="#interface-attribute-access_vlan">access_vlan</a>         =&gt; <em># Interface static access vlan.  Allowed values:...</em>
  <a href="#interface-attribute-allowed_trunk_vlans">allowed_trunk_vlans</a> =&gt; <em># Allowed list of Vlans that this trunk can...</em>
  <a href="#interface-attribute-description">description</a>         =&gt; <em># Interface...</em>
  <a href="#interface-attribute-device_url">device_url</a>          =&gt; <em># The URL at which the router or switch can be...</em>
  <a href="#interface-attribute-duplex">duplex</a>              =&gt; <em># Interface duplex.  Allowed values:  * `auto` ...</em>
  <a href="#interface-attribute-encapsulation">encapsulation</a>       =&gt; <em># Interface switchport encapsulation.  Allowed...</em>
  <a href="#interface-attribute-etherchannel">etherchannel</a>        =&gt; <em># Channel group this interface is part of....</em>
  <a href="#interface-attribute-ipaddress">ipaddress</a>           =&gt; <em># IP Address of this interface. Note that it might </em>
  <a href="#interface-attribute-mode">mode</a>                =&gt; <em># Interface switchport mode.  Allowed values:  ...</em>
  <a href="#interface-attribute-native_vlan">native_vlan</a>         =&gt; <em># Interface native vlan when trunking.  Allowed...</em>
  <a href="#interface-attribute-speed">speed</a>               =&gt; <em># Interface speed.  Allowed values:  * `auto` ...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="interface-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The interface's name.

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`
* `shutdown`
* `no_shutdown`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-access_vlan">access_vlan</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Interface static access vlan.

Allowed values:

* `/^\d+/`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-allowed_trunk_vlans">allowed_trunk_vlans</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Allowed list of Vlans that this trunk can forward.

Allowed values:

* `all`
* `/./`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-description">description</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Interface description.

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-device_url">device_url</h4>

The URL at which the router or switch can be reached.

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-duplex">duplex</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Interface duplex.

Allowed values:

* `auto`
* `full`
* `half`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-encapsulation">encapsulation</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Interface switchport encapsulation.

Allowed values:

* `none`
* `dot1q`
* `isl`
* `negotiate`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-etherchannel">etherchannel</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Channel group this interface is part of.

Allowed values:

* `/^\d+/`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-ipaddress">ipaddress</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

IP Address of this interface. Note that it might not be possible to set
an interface IP address; it depends on the interface type and device type.

Valid format of ip addresses are:

* IPV4, like 127.0.0.1
* IPV4/prefixlength like 127.0.1.1/24
* IPV6/prefixlength like FE80::21A:2FFF:FE30:ECF0/128
* an optional suffix for IPV6 addresses from this list: `eui-64`, `link-local`

It is also possible to supply an array of values.

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-mode">mode</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Interface switchport mode.

Allowed values:

* `access`
* `trunk`
* `dynamic auto`
* `dynamic desirable`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-native_vlan">native_vlan</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Interface native vlan when trunking.

Allowed values:

* `/^\d+/`

([↑ Back to interface attributes](#interface-attributes))

<h4 id="interface-attribute-speed">speed</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Interface speed.

Allowed values:

* `auto`
* `/^\d+/`

([↑ Back to interface attributes](#interface-attributes))


<h3 id="interface-providers">Providers</h3>

<h4 id="interface-provider-cisco">cisco</h4>

Cisco switch/router provider for interface.




---------

k5login
-----

* [Attributes](#k5login-attributes)

<h3 id="k5login-description">Description</h3>

Manage the `.k5login` file for a user.  Specify the full path to
the `.k5login` file as the name, and an array of principals as the
`principals` attribute.

<h3 id="k5login-attributes">Attributes</h3>

<pre><code>k5login { 'resource title':
  <a href="#k5login-attribute-path">path</a>       =&gt; <em># <strong>(namevar)</strong> The path to the `.k5login` file to manage.  Must </em>
  <a href="#k5login-attribute-ensure">ensure</a>     =&gt; <em># The basic property that the resource should be...</em>
  <a href="#k5login-attribute-mode">mode</a>       =&gt; <em># The desired permissions mode of the `.k5login...</em>
  <a href="#k5login-attribute-principals">principals</a> =&gt; <em># The principals present in the `.k5login` file...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="k5login-attribute-path">path</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The path to the `.k5login` file to manage.  Must be fully qualified.

([↑ Back to k5login attributes](#k5login-attributes))

<h4 id="k5login-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to k5login attributes](#k5login-attributes))

<h4 id="k5login-attribute-mode">mode</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The desired permissions mode of the `.k5login` file. Defaults to `644`.

([↑ Back to k5login attributes](#k5login-attributes))

<h4 id="k5login-attribute-principals">principals</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The principals present in the `.k5login` file. This should be specified as an array.

([↑ Back to k5login attributes](#k5login-attributes))





---------

macauthorization
-----

* [Attributes](#macauthorization-attributes)
* [Providers](#macauthorization-providers)

<h3 id="macauthorization-description">Description</h3>

Manage the Mac OS X authorization database. See the
[Apple developer site](https://developer.apple.com/documentation/Security/Conceptual/Security_Overview/Security_Services/chapter_4_section_5.html)
for more information.

Note that authorization store directives with hyphens in their names have
been renamed to use underscores, as Puppet does not react well to hyphens
in identifiers.

**Autorequires:** If Puppet is managing the `/etc/authorization` file, each
macauthorization resource will autorequire it.

<h3 id="macauthorization-attributes">Attributes</h3>

<pre><code>macauthorization { 'resource title':
  <a href="#macauthorization-attribute-name">name</a>              =&gt; <em># <strong>(namevar)</strong> The name of the right or rule to be managed...</em>
  <a href="#macauthorization-attribute-ensure">ensure</a>            =&gt; <em># The basic property that the resource should be...</em>
  <a href="#macauthorization-attribute-allow_root">allow_root</a>        =&gt; <em># Corresponds to `allow-root` in the authorization </em>
  <a href="#macauthorization-attribute-auth_class">auth_class</a>        =&gt; <em># Corresponds to `class` in the authorization...</em>
  <a href="#macauthorization-attribute-auth_type">auth_type</a>         =&gt; <em># Type --- this can be a `right` or a `rule`. The...</em>
  <a href="#macauthorization-attribute-authenticate_user">authenticate_user</a> =&gt; <em># Corresponds to `authenticate-user` in the...</em>
  <a href="#macauthorization-attribute-comment">comment</a>           =&gt; <em># The `comment` attribute for authorization...</em>
  <a href="#macauthorization-attribute-group">group</a>             =&gt; <em># A group which the user must authenticate as a...</em>
  <a href="#macauthorization-attribute-k_of_n">k_of_n</a>            =&gt; <em># How large a subset of rule mechanisms must...</em>
  <a href="#macauthorization-attribute-mechanisms">mechanisms</a>        =&gt; <em># An array of suitable...</em>
  <a href="#macauthorization-attribute-rule">rule</a>              =&gt; <em># The rule(s) that this right refers...</em>
  <a href="#macauthorization-attribute-session_owner">session_owner</a>     =&gt; <em># Whether the session owner automatically matches...</em>
  <a href="#macauthorization-attribute-shared">shared</a>            =&gt; <em># Whether the Security Server should mark the...</em>
  <a href="#macauthorization-attribute-timeout">timeout</a>           =&gt; <em># The number of seconds in which the credential...</em>
  <a href="#macauthorization-attribute-tries">tries</a>             =&gt; <em># The number of tries...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="macauthorization-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the right or rule to be managed.
Corresponds to `key` in Authorization Services. The key is the name
of a rule. A key uses the same naming conventions as a right. The
Security Server uses a rule's key to match the rule with a right.
Wildcard keys end with a '.'. The generic rule has an empty key value.
Any rights that do not match a specific rule use the generic rule.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-allow_root">allow_root</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Corresponds to `allow-root` in the authorization store. Specifies
whether a right should be allowed automatically if the requesting process
is running with `uid == 0`.  AuthorizationServices defaults this attribute
to false if not specified.

Allowed values:

* `true`
* `false`

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-auth_class">auth_class</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Corresponds to `class` in the authorization store; renamed due
to 'class' being a reserved word in Puppet.

Allowed values:

* `user`
* `evaluate-mechanisms`
* `allow`
* `deny`
* `rule`

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-auth_type">auth_type</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Type --- this can be a `right` or a `rule`. The `comment` type has
not yet been implemented.

Allowed values:

* `right`
* `rule`

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-authenticate_user">authenticate_user</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Corresponds to `authenticate-user` in the authorization store.

Allowed values:

* `true`
* `false`

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-comment">comment</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The `comment` attribute for authorization resources.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-group">group</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A group which the user must authenticate as a member of. This
must be a single group.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-k_of_n">k_of_n</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

How large a subset of rule mechanisms must succeed for successful
authentication. If there are 'n' mechanisms, then 'k' (the integer value
of this parameter) mechanisms must succeed. The most common setting for
this parameter is `1`. If `k-of-n` is not set, then every mechanism ---
that is, 'n-of-n' --- must succeed.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-mechanisms">mechanisms</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

An array of suitable mechanisms.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-rule">rule</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The rule(s) that this right refers to.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-session_owner">session_owner</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether the session owner automatically matches this rule or right.
Corresponds to `session-owner` in the authorization store.

Allowed values:

* `true`
* `false`

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-shared">shared</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether the Security Server should mark the credentials used to gain
this right as shared. The Security Server may use any shared credentials
to authorize this right. For maximum security, set sharing to false so
credentials stored by the Security Server for one application may not be
used by another application.

Allowed values:

* `true`
* `false`

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-timeout">timeout</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The number of seconds in which the credential used by this rule will
expire. For maximum security where the user must authenticate every time,
set the timeout to 0. For minimum security, remove the timeout attribute
so the user authenticates only once per session.

([↑ Back to macauthorization attributes](#macauthorization-attributes))

<h4 id="macauthorization-attribute-tries">tries</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The number of tries allowed.

([↑ Back to macauthorization attributes](#macauthorization-attributes))


<h3 id="macauthorization-providers">Providers</h3>

<h4 id="macauthorization-provider-macauthorization">macauthorization</h4>

Manage Mac OS X authorization database rules and rights.

* Required binaries: `/usr/bin/security`
* Confined to: `operatingsystem == darwin`, `feature == cfpropertylist`
* Default for: `["operatingsystem", "darwin"] == `




---------

mailalias
-----

* [Attributes](#mailalias-attributes)
* [Providers](#mailalias-providers)

<h3 id="mailalias-description">Description</h3>

Creates an email alias in the local alias database.

<h3 id="mailalias-attributes">Attributes</h3>

<pre><code>mailalias { 'resource title':
  <a href="#mailalias-attribute-name">name</a>      =&gt; <em># <strong>(namevar)</strong> The alias...</em>
  <a href="#mailalias-attribute-ensure">ensure</a>    =&gt; <em># The basic property that the resource should be...</em>
  <a href="#mailalias-attribute-file">file</a>      =&gt; <em># A file containing the alias's contents.  The...</em>
  <a href="#mailalias-attribute-recipient">recipient</a> =&gt; <em># Where email should be sent.  Multiple values...</em>
  <a href="#mailalias-attribute-target">target</a>    =&gt; <em># The file in which to store the aliases.  Only...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="mailalias-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The alias name.

([↑ Back to mailalias attributes](#mailalias-attributes))

<h4 id="mailalias-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to mailalias attributes](#mailalias-attributes))

<h4 id="mailalias-attribute-file">file</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A file containing the alias's contents.  The file and the
recipient entries are mutually exclusive.

([↑ Back to mailalias attributes](#mailalias-attributes))

<h4 id="mailalias-attribute-recipient">recipient</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Where email should be sent.  Multiple values
should be specified as an array.  The file and the
recipient entries are mutually exclusive.

([↑ Back to mailalias attributes](#mailalias-attributes))

<h4 id="mailalias-attribute-target">target</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The file in which to store the aliases.  Only used by
those providers that write to disk.

([↑ Back to mailalias attributes](#mailalias-attributes))


<h3 id="mailalias-providers">Providers</h3>

<h4 id="mailalias-provider-aliases">aliases</h4>






---------

maillist
-----

* [Attributes](#maillist-attributes)
* [Providers](#maillist-providers)

<h3 id="maillist-description">Description</h3>

Manage email lists.  This resource type can only create
and remove lists; it cannot currently reconfigure them.

<h3 id="maillist-attributes">Attributes</h3>

<pre><code>maillist { 'resource title':
  <a href="#maillist-attribute-name">name</a>        =&gt; <em># <strong>(namevar)</strong> The name of the email...</em>
  <a href="#maillist-attribute-ensure">ensure</a>      =&gt; <em># The basic property that the resource should be...</em>
  <a href="#maillist-attribute-admin">admin</a>       =&gt; <em># The email address of the...</em>
  <a href="#maillist-attribute-description">description</a> =&gt; <em># The description of the mailing...</em>
  <a href="#maillist-attribute-mailserver">mailserver</a>  =&gt; <em># The name of the host handling email for the...</em>
  <a href="#maillist-attribute-password">password</a>    =&gt; <em># The admin...</em>
  <a href="#maillist-attribute-webserver">webserver</a>   =&gt; <em># The name of the host providing web archives and...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="maillist-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the email list.

([↑ Back to maillist attributes](#maillist-attributes))

<h4 id="maillist-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`
* `purged`

([↑ Back to maillist attributes](#maillist-attributes))

<h4 id="maillist-attribute-admin">admin</h4>

The email address of the administrator.

([↑ Back to maillist attributes](#maillist-attributes))

<h4 id="maillist-attribute-description">description</h4>

The description of the mailing list.

([↑ Back to maillist attributes](#maillist-attributes))

<h4 id="maillist-attribute-mailserver">mailserver</h4>

The name of the host handling email for the list.

([↑ Back to maillist attributes](#maillist-attributes))

<h4 id="maillist-attribute-password">password</h4>

The admin password.

([↑ Back to maillist attributes](#maillist-attributes))

<h4 id="maillist-attribute-webserver">webserver</h4>

The name of the host providing web archives and the administrative interface.

([↑ Back to maillist attributes](#maillist-attributes))


<h3 id="maillist-providers">Providers</h3>

<h4 id="maillist-provider-mailman">mailman</h4>






---------

mcx
-----

* [Attributes](#mcx-attributes)
* [Providers](#mcx-providers)
* [Provider Features](#mcx-provider-features)

<h3 id="mcx-description">Description</h3>

MCX object management using DirectoryService on OS X.

The default provider of this type merely manages the XML plist as
reported by the `dscl -mcxexport` command.  This is similar to the
content property of the file type in Puppet.

The recommended method of using this type is to use Work Group Manager
to manage users and groups on the local computer, record the resulting
puppet manifest using the command `puppet resource mcx`, then deploy it
to other machines.

**Autorequires:** If Puppet is managing the user, group, or computer that these
MCX settings refer to, the MCX resource will autorequire that user, group, or computer.

<h3 id="mcx-attributes">Attributes</h3>

<pre><code>mcx { 'resource title':
  <a href="#mcx-attribute-name">name</a>    =&gt; <em># <strong>(namevar)</strong> The name of the resource being managed. The...</em>
  <a href="#mcx-attribute-ensure">ensure</a>  =&gt; <em># Create or remove the MCX setting.  Allowed...</em>
  <a href="#mcx-attribute-content">content</a> =&gt; <em># The XML Plist used as the value of MCXSettings...</em>
  <a href="#mcx-attribute-ds_name">ds_name</a> =&gt; <em># The name to attach the MCX Setting to. (For...</em>
  <a href="#mcx-attribute-ds_type">ds_type</a> =&gt; <em># The DirectoryService type this MCX setting...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="mcx-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the resource being managed.
The default naming convention follows Directory Service paths:

    /Computers/localhost
    /Groups/admin
    /Users/localadmin

The `ds_type` and `ds_name` type parameters are not necessary if the
default naming convention is followed.

([↑ Back to mcx attributes](#mcx-attributes))

<h4 id="mcx-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Create or remove the MCX setting.

Allowed values:

* `present`
* `absent`

([↑ Back to mcx attributes](#mcx-attributes))

<h4 id="mcx-attribute-content">content</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The XML Plist used as the value of MCXSettings in DirectoryService.
This is the standard output from the system command:

    dscl localhost -mcxexport /Local/Default/<ds_type>/ds_name

Note that `ds_type` is capitalized and plural in the dscl command.

([↑ Back to mcx attributes](#mcx-attributes))

<h4 id="mcx-attribute-ds_name">ds_name</h4>

The name to attach the MCX Setting to. (For example, `localhost`
when `ds_type => computer`.) This setting is not required, as it can be
automatically discovered when the resource name is parseable.  (For
example, in `/Groups/admin`, `group` will be used as the dstype.)

([↑ Back to mcx attributes](#mcx-attributes))

<h4 id="mcx-attribute-ds_type">ds_type</h4>

The DirectoryService type this MCX setting attaches to.

Allowed values:

* `user`
* `group`
* `computer`
* `computerlist`

([↑ Back to mcx attributes](#mcx-attributes))


<h3 id="mcx-providers">Providers</h3>

<h4 id="mcx-provider-mcxcontent">mcxcontent</h4>

MCX Settings management using DirectoryService on OS X.

This provider manages the entire MCXSettings attribute available
to some directory services nodes.  This management is 'all or nothing'
in that discrete application domain key value pairs are not managed
by this provider.

It is recommended to use WorkGroup Manager to configure Users, Groups,
Computers, or ComputerLists, then use 'ralsh mcx' to generate a puppet
manifest from the resulting configuration.

Original Author: Jeff McCune (mccune.jeff@gmail.com)

* Required binaries: `/usr/bin/dscl`
* Confined to: `operatingsystem == darwin`
* Default for: `["operatingsystem", "darwin"] == `

<h3 id="mcx-provider-features">Provider Features</h3>

Available features:

* `manages_content` --- The provider can manage MCXSettings as a string.

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>manages content</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>mcxcontent</td>
      <td> </td>
    </tr>
  </tbody>
</table>



---------

mount
-----

* [Attributes](#mount-attributes)
* [Providers](#mount-providers)
* [Provider Features](#mount-provider-features)

<h3 id="mount-description">Description</h3>

Manages mounted filesystems, including putting mount
information into the mount table. The actual behavior depends
on the value of the 'ensure' parameter.

**Refresh:** `mount` resources can respond to refresh events (via
`notify`, `subscribe`, or the `~>` arrow). If a `mount` receives an event
from another resource **and** its `ensure` attribute is set to `mounted`,
Puppet will try to unmount then remount that filesystem.

**Autorequires:** If Puppet is managing any parents of a mount resource ---
that is, other mount points higher up in the filesystem --- the child
mount will autorequire them.

**Autobefores:**  If Puppet is managing any child file paths of a mount
point, the mount resource will autobefore them.

<h3 id="mount-attributes">Attributes</h3>

<pre><code>mount { 'resource title':
  <a href="#mount-attribute-name">name</a>        =&gt; <em># <strong>(namevar)</strong> The mount path for the...</em>
  <a href="#mount-attribute-ensure">ensure</a>      =&gt; <em># Control what to do with this mount. Set this...</em>
  <a href="#mount-attribute-atboot">atboot</a>      =&gt; <em># Whether to mount the mount at boot.  Not all...</em>
  <a href="#mount-attribute-blockdevice">blockdevice</a> =&gt; <em># The device to fsck.  This is property is only...</em>
  <a href="#mount-attribute-device">device</a>      =&gt; <em># The device providing the mount.  This can be...</em>
  <a href="#mount-attribute-dump">dump</a>        =&gt; <em># Whether to dump the mount.  Not all platform...</em>
  <a href="#mount-attribute-fstype">fstype</a>      =&gt; <em># The mount type.  Valid values depend on the...</em>
  <a href="#mount-attribute-options">options</a>     =&gt; <em># A single string containing options for the...</em>
  <a href="#mount-attribute-pass">pass</a>        =&gt; <em># The pass in which the mount is...</em>
  <a href="#mount-attribute-remounts">remounts</a>    =&gt; <em># Whether the mount can be remounted  `mount -o...</em>
  <a href="#mount-attribute-target">target</a>      =&gt; <em># The file in which to store the mount table....</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="mount-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The mount path for the mount.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Control what to do with this mount. Set this attribute to
`unmounted` to make sure the filesystem is in the filesystem table
but not mounted (if the filesystem is currently mounted, it will be
unmounted).  Set it to `absent` to unmount (if necessary) and remove
the filesystem from the fstab.  Set to `mounted` to add it to the
fstab and mount it. Set to `present` to add to fstab but not change
mount/unmount status.

Allowed values:

* `defined`
* `present`
* `unmounted`
* `absent`
* `mounted`

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-atboot">atboot</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether to mount the mount at boot.  Not all platforms
support this.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-blockdevice">blockdevice</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The device to fsck.  This is property is only valid
on Solaris, and in most cases will default to the correct
value.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-device">device</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The device providing the mount.  This can be whatever
device is supporting by the mount, including network
devices or devices specified by UUID rather than device
path, depending on the operating system.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-dump">dump</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether to dump the mount.  Not all platform support this.
Valid values are `1` or `0` (or `2` on FreeBSD). Default is `0`.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-fstype">fstype</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The mount type.  Valid values depend on the
operating system.  This is a required option.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-options">options</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A single string containing options for the mount, as they would
appear in fstab. For many platforms this is a comma delimited string.
Consult the fstab(5) man page for system-specific details.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-pass">pass</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The pass in which the mount is checked.

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-remounts">remounts</h4>

Whether the mount can be remounted  `mount -o remount`.  If
this is false, then the filesystem will be unmounted and remounted
manually, which is prone to failure.

Allowed values:

* `true`
* `false`

([↑ Back to mount attributes](#mount-attributes))

<h4 id="mount-attribute-target">target</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The file in which to store the mount table.  Only used by
those providers that write to disk.

([↑ Back to mount attributes](#mount-attributes))


<h3 id="mount-providers">Providers</h3>

<h4 id="mount-provider-parsed">parsed</h4>



* Required binaries: `mount`, `umount`

<h3 id="mount-provider-features">Provider Features</h3>

Available features:

* `refreshable` --- The provider can remount the filesystem.

Provider support:

<table>
  <thead>
    <tr>
      <th>Provider</th>
      <th>refreshable</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>parsed</td>
      <td> </td>
    </tr>
  </tbody>
</table>



---------

notify
-----

* [Attributes](#notify-attributes)

<h3 id="notify-description">Description</h3>

Sends an arbitrary message to the agent run-time log.

<h3 id="notify-attributes">Attributes</h3>

<pre><code>notify { 'resource title':
  <a href="#notify-attribute-name">name</a>     =&gt; <em># <strong>(namevar)</strong> An arbitrary tag for your own reference; the...</em>
  <a href="#notify-attribute-message">message</a>  =&gt; <em># The message to be sent to the...</em>
  <a href="#notify-attribute-withpath">withpath</a> =&gt; <em># Whether to show the full object path. Defaults...</em>
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

Whether to show the full object path. Defaults to false.

Default: `false`

Allowed values:

* `true`
* `false`

([↑ Back to notify attributes](#notify-attributes))





---------

package
-----

* [Attributes](#package-attributes)
* [Providers](#package-providers)
* [Provider Features](#package-provider-features)

<h3 id="package-description">Description</h3>

Manage packages.  There is a basic dichotomy in package
support right now:  Some package types (e.g., yum and apt) can
retrieve their own package files, while others (e.g., rpm and sun)
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

    . etc. .

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
Defaults to `keep`.

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

Defaults to `false`.

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
* Default for: `["operatingsystem", "aix"] == `

<h4 id="package-provider-appdmg">appdmg</h4>

Package management which copies application bundles to a target.

* Required binaries: `/usr/bin/hdiutil`, `/usr/bin/curl`, `/usr/bin/ditto`
* Confined to: `operatingsystem == darwin`, `feature == cfpropertylist`

<h4 id="package-provider-apple">apple</h4>

Package management based on OS X's built-in packaging system.  This is
essentially the simplest and least functional package system in existence --
it only supports installation; no deletion or upgrades.  The provider will
automatically add the `.pkg` extension, so leave that off when specifying
the package name.

* Required binaries: `/usr/sbin/installer`
* Confined to: `operatingsystem == darwin`

<h4 id="package-provider-apt">apt</h4>

Package management via `apt-get`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to apt-get.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `/usr/bin/apt-get`, `/usr/bin/apt-cache`, `/usr/bin/debconf-set-selections`
* Default for: `["osfamily", "debian"] == `

<h4 id="package-provider-aptitude">aptitude</h4>

Package management via `aptitude`.

* Required binaries: `/usr/bin/aptitude`, `/usr/bin/apt-cache`

<h4 id="package-provider-aptrpm">aptrpm</h4>

Package management via `apt-get` ported to `rpm`.

* Required binaries: `apt-get`, `apt-cache`, `rpm`

<h4 id="package-provider-blastwave">blastwave</h4>

Package management using Blastwave.org's `pkg-get` command on Solaris.

* Required binaries: `pkgget`
* Confined to: `osfamily == solaris`

<h4 id="package-provider-dnf">dnf</h4>

Support via `dnf`.

Using this provider's `uninstallable` feature will not remove dependent packages. To
remove dependent packages with this provider use the `purgeable` feature, but note this
feature is destructive and should be used with the utmost care.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to dnf.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `dnf`, `rpm`
* Default for: `["operatingsystem", "fedora"] == ["operatingsystemmajrelease", "['22', '23', '24', '25']"]`

<h4 id="package-provider-dpkg">dpkg</h4>

Package management via `dpkg`.  Because this only uses `dpkg`
and not `apt`, you must specify the source of any packages you want
to manage.

* Required binaries: `/usr/bin/dpkg`, `/usr/bin/dpkg-deb`, `/usr/bin/dpkg-query`

<h4 id="package-provider-fink">fink</h4>

Package management via `fink`.

* Required binaries: `/sw/bin/fink`, `/sw/bin/apt-get`, `/sw/bin/apt-cache`, `/sw/bin/dpkg-query`

<h4 id="package-provider-freebsd">freebsd</h4>

The specific form of package management on FreeBSD.  This is an
extremely quirky packaging system, in that it freely mixes between
ports and packages.  Apparently all of the tools are written in Ruby,
so there are plans to rewrite this support to directly use those
libraries.

* Required binaries: `/usr/sbin/pkg_info`, `/usr/sbin/pkg_add`, `/usr/sbin/pkg_delete`
* Confined to: `operatingsystem == freebsd`

<h4 id="package-provider-gem">gem</h4>

Ruby Gem support. If a URL is passed via `source`, then that URL is
appended to the list of remote gem repositories; to ensure that only the
specified source is used, also pass `--clear-sources` via `install_options`.
If source is present but is not a valid URL, it will be interpreted as the
path to a local gem file. If source is not present, the gem will be
installed from the default gem repositories.

This provider supports the `install_options` and `uninstall_options` attributes,
which allow command-line flags to be passed to the gem command.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `gem`

<h4 id="package-provider-hpux">hpux</h4>

HP-UX's packaging system.

* Required binaries: `/usr/sbin/swinstall`, `/usr/sbin/swlist`, `/usr/sbin/swremove`
* Confined to: `operatingsystem == hp-ux`
* Default for: `["operatingsystem", "hp-ux"] == `

<h4 id="package-provider-macports">macports</h4>

Package management using MacPorts on OS X.

Supports MacPorts versions and revisions, but not variants.
Variant preferences may be specified using
[the MacPorts variants.conf file](http://guide.macports.org/chunked/internals.configuration-files.html#internals.configuration-files.variants-conf).

When specifying a version in the Puppet DSL, only specify the version, not the revision.
Revisions are only used internally for ensuring the latest version/revision of a port.

* Confined to: `operatingsystem == darwin`

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

<h4 id="package-provider-openbsd">openbsd</h4>

OpenBSD's form of `pkg_add` support.

This provider supports the `install_options` and `uninstall_options`
attributes, which allow command-line flags to be passed to pkg_add and pkg_delete.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `pkg_info`, `pkg_add`, `pkg_delete`
* Confined to: `operatingsystem == openbsd`
* Default for: `["operatingsystem", "openbsd"] == `

<h4 id="package-provider-opkg">opkg</h4>

Opkg packaging support. Common on OpenWrt and OpenEmbedded platforms

* Required binaries: `opkg`
* Confined to: `operatingsystem == openwrt`
* Default for: `["operatingsystem", "openwrt"] == `

<h4 id="package-provider-pacman">pacman</h4>

Support for the Package Manager Utility (pacman) used in Archlinux.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pacman.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `/usr/bin/pacman`
* Confined to: `operatingsystem == [:archlinux, :manjarolinux]`
* Default for: `["operatingsystem", "[:archlinux, :manjarolinux]"] == `

<h4 id="package-provider-pip">pip</h4>

Python packages via `pip`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pip.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

<h4 id="package-provider-pip3">pip3</h4>

Python packages via `pip3`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pip3.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

<h4 id="package-provider-pkg">pkg</h4>

OpenSolaris image packaging system. See pkg(5) for more information.

* Required binaries: `/usr/bin/pkg`
* Confined to: `osfamily == solaris`
* Default for: `["osfamily", "solaris"] == ["kernelrelease", "['5.11', '5.12']"]`

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
* Default for: `["operatingsystem", "darwin"] == `

<h4 id="package-provider-pkgin">pkgin</h4>

Package management using pkgin, a binary package manager for pkgsrc.

* Required binaries: `pkgin`
* Default for: `["operatingsystem", "[ :smartos, :netbsd ]"] == `

<h4 id="package-provider-pkgng">pkgng</h4>

A PkgNG provider for FreeBSD and DragonFly.

* Required binaries: `/usr/local/sbin/pkg`
* Confined to: `operatingsystem == [:freebsd, :dragonfly]`
* Default for: `["operatingsystem", "[:freebsd, :dragonfly]"] == `

<h4 id="package-provider-pkgutil">pkgutil</h4>

Package management using Peter Bonivart's ``pkgutil`` command on Solaris.

* Confined to: `osfamily == solaris`

<h4 id="package-provider-portage">portage</h4>

Provides packaging support for Gentoo's portage system.

This provider supports the `install_options` and `uninstall_options` attributes, which allows command-line
flags to be passed to emerge.  These options should be specified as a string (e.g. '--flag'), a hash
(e.g. {'--flag' => 'value'}), or an array where each element is either a string or a hash.

* Confined to: `operatingsystem == gentoo`
* Default for: `["operatingsystem", "gentoo"] == `

<h4 id="package-provider-ports">ports</h4>

Support for FreeBSD's ports.  Note that this, too, mixes packages and ports.

* Required binaries: `/usr/local/sbin/portupgrade`, `/usr/local/sbin/portversion`, `/usr/local/sbin/pkg_deinstall`, `/usr/sbin/pkg_info`

<h4 id="package-provider-portupgrade">portupgrade</h4>

Support for FreeBSD's ports using the portupgrade ports management software.
Use the port's full origin as the resource name. eg (ports-mgmt/portupgrade)
for the portupgrade port.

* Required binaries: `/usr/local/sbin/portupgrade`, `/usr/local/sbin/portinstall`, `/usr/local/sbin/portversion`, `/usr/local/sbin/pkg_deinstall`, `/usr/sbin/pkg_info`

<h4 id="package-provider-puppet_gem">puppet_gem</h4>

Puppet Ruby Gem support. This provider is useful for managing
gems needed by the ruby provided in the puppet-agent package.

<h4 id="package-provider-rpm">rpm</h4>

RPM packaging support; should work anywhere with a working `rpm`
binary.

This provider supports the `install_options` and `uninstall_options`
attributes, which allow command-line flags to be passed to rpm.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `rpm`

<h4 id="package-provider-rug">rug</h4>

Support for suse `rug` package manager.

* Required binaries: `/usr/bin/rug`, `rpm`
* Confined to: `operatingsystem == [:suse, :sles]`

<h4 id="package-provider-sun">sun</h4>

Sun's packaging system.  Requires that you specify the source for
the packages you're managing.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to pkgadd.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `/usr/bin/pkginfo`, `/usr/sbin/pkgadd`, `/usr/sbin/pkgrm`
* Confined to: `osfamily == solaris`
* Default for: `["osfamily", "solaris"] == `

<h4 id="package-provider-sunfreeware">sunfreeware</h4>

Package management using sunfreeware.com's `pkg-get` command on Solaris.
At this point, support is exactly the same as `blastwave` support and
has not actually been tested.

* Required binaries: `pkg-get`
* Confined to: `osfamily == solaris`

<h4 id="package-provider-tdnf">tdnf</h4>

Support via `tdnf`.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to tdnf.
These options should be spcified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}), or an
array where each element is either a string or a hash.

* Required binaries: `tdnf`, `rpm`
* Default for: `["operatingsystem", "PhotonOS"] == `

<h4 id="package-provider-up2date">up2date</h4>

Support for Red Hat's proprietary `up2date` package update
mechanism.

* Required binaries: `/usr/sbin/up2date-nox`
* Confined to: `osfamily == redhat`
* Default for: `["osfamily", "redhat"] == ["lsbdistrelease", "[\"2.1\", \"3\", \"4\"]"]`

<h4 id="package-provider-urpmi">urpmi</h4>

Support via `urpmi`.

* Required binaries: `urpmi`, `urpmq`, `rpm`, `urpme`
* Default for: `["operatingsystem", "[:mandriva, :mandrake]"] == `

<h4 id="package-provider-windows">windows</h4>

Windows package management.

This provider supports either MSI or self-extracting executable installers.

This provider requires a `source` attribute when installing the package.
It accepts paths to local files, mapped drives, or UNC paths.

This provider supports the `install_options` and `uninstall_options`
attributes, which allow command-line flags to be passed to the installer.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

If the executable requires special arguments to perform a silent install or
uninstall, then the appropriate arguments should be specified using the
`install_options` or `uninstall_options` attributes, respectively.  Puppet
will automatically quote any option that contains spaces.

* Confined to: `operatingsystem == windows`
* Default for: `["operatingsystem", "windows"] == `

<h4 id="package-provider-yum">yum</h4>

Support via `yum`.

Using this provider's `uninstallable` feature will not remove dependent packages. To
remove dependent packages with this provider use the `purgeable` feature, but note this
feature is destructive and should be used with the utmost care.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to yum.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `yum`, `rpm`
* Default for: `["osfamily", "redhat"] == `

<h4 id="package-provider-zypper">zypper</h4>

Support for SuSE `zypper` package manager. Found in SLES10sp2+ and SLES11.

This provider supports the `install_options` attribute, which allows command-line flags to be passed to zypper.
These options should be specified as a string (e.g. '--flag'), a hash (e.g. {'--flag' => 'value'}),
or an array where each element is either a string or a hash.

* Required binaries: `/usr/bin/zypper`
* Confined to: `operatingsystem == [:suse, :sles, :sled, :opensuse]`
* Default for: `["operatingsystem", "[:suse, :sles, :sled, :opensuse]"] == `

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
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>appdmg</td>
      <td> </td>
      <td> </td>
      <td> </td>
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
      <td> </td>
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
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>aptitude</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>aptrpm</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>blastwave</td>
      <td> </td>
      <td> </td>
      <td> </td>
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
      <td>dnf</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>dpkg</td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
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
      <td>fink</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>freebsd</td>
      <td> </td>
      <td> </td>
      <td> </td>
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
      <td>gem</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>hpux</td>
      <td> </td>
      <td> </td>
      <td> </td>
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
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>openbsd</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>opkg</td>
      <td> </td>
      <td> </td>
      <td> </td>
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
      <td>pacman</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
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
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkgdmg</td>
      <td> </td>
      <td> </td>
      <td> </td>
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
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>pkgutil</td>
      <td> </td>
      <td> </td>
      <td> </td>
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
      <td>portage</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>ports</td>
      <td> </td>
      <td> </td>
      <td> </td>
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
      <td>portupgrade</td>
      <td> </td>
      <td> </td>
      <td> </td>
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
      <td>puppet_gem</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>rpm</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>rug</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
    </tr>
    <tr>
      <td>sun</td>
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
      <td> </td>
    </tr>
    <tr>
      <td>sunfreeware</td>
      <td> </td>
      <td> </td>
      <td> </td>
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
      <td>tdnf</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>up2date</td>
      <td> </td>
      <td> </td>
      <td> </td>
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
      <td>urpmi</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
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
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>zypper</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
    </tr>
  </tbody>
</table>



---------

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





---------

router
-----

* [Attributes](#router-attributes)

<h3 id="router-description">Description</h3>

Manages connected router.

<h3 id="router-attributes">Attributes</h3>

<pre><code>router { 'resource title':
  <a href="#router-attribute-url">url</a> =&gt; <em># <strong>(namevar)</strong> An SSH or telnet URL at which to access the...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="router-attribute-url">url</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

An SSH or telnet URL at which to access the router, in the form
`ssh://user:pass:enable@host/` or `telnet://user:pass:enable@host/`.

([↑ Back to router attributes](#router-attributes))





---------

schedule
-----

* [Attributes](#schedule-attributes)

<h3 id="schedule-description">Description</h3>

Define schedules for Puppet. Resources can be limited to a schedule by using the
[`schedule`](https://docs.puppetlabs.com/puppet/latest/metaparameter.html#schedule)
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

Thus, it is advisable to use wider scheduling (e.g., over a couple of
hours) combined with periods and repetitions.  For instance, if you
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
with the same name as that period (e.g., hourly and daily).
Additionally, a schedule named `puppet` is created and used as the
default, with the following attributes:

    schedule { 'puppet':
      period => hourly,
      repeat => 2,
    }

This will cause resources to be applied every 30 minutes by default.

<h3 id="schedule-attributes">Attributes</h3>

<pre><code>schedule { 'resource title':
  <a href="#schedule-attribute-name">name</a>        =&gt; <em># <strong>(namevar)</strong> The name of the schedule.  This name is used...</em>
  <a href="#schedule-attribute-period">period</a>      =&gt; <em># The period of repetition for resources on this...</em>
  <a href="#schedule-attribute-periodmatch">periodmatch</a> =&gt; <em># Whether periods should be matched by number...</em>
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
that a given resource can be applied (e.g., only at night during
a maintenance window), then use the `range` attribute.

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
factors might prevent it from actually running that often (e.g. if a
Puppet run is still in progress when the next run is scheduled to start,
that next run will be suppressed).

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

Whether periods should be matched by number (e.g., the two times
are in the same hour) or by distance (e.g., the two times are
60 minutes apart).

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
ranges, you may cross midnight (e.g.: range => "22:00 - 04:00").

([↑ Back to schedule attributes](#schedule-attributes))

<h4 id="schedule-attribute-repeat">repeat</h4>

How often a given resource may be applied in this schedule's `period`.
Defaults to 1; must be an integer.

Default: `1`

([↑ Back to schedule attributes](#schedule-attributes))

<h4 id="schedule-attribute-weekday">weekday</h4>

The days of the week in which the schedule should be valid.
You may specify the full day name (Tuesday), the three character
abbreviation (Tue), or a number corresponding to the day of the
week where 0 is Sunday, 1 is Monday, etc. Multiple days can be specified
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





---------

scheduled_task
-----

* [Attributes](#scheduled_task-attributes)
* [Providers](#scheduled_task-providers)

<h3 id="scheduled_task-description">Description</h3>

Installs and manages Windows Scheduled Tasks.  All attributes
except `name`, `command`, and `trigger` are optional; see the description
of the `trigger` attribute for details on setting schedules.

<h3 id="scheduled_task-attributes">Attributes</h3>

<pre><code>scheduled_task { 'resource title':
  <a href="#scheduled_task-attribute-name">name</a>        =&gt; <em># <strong>(namevar)</strong> The name assigned to the scheduled task.  This...</em>
  <a href="#scheduled_task-attribute-ensure">ensure</a>      =&gt; <em># The basic property that the resource should be...</em>
  <a href="#scheduled_task-attribute-arguments">arguments</a>   =&gt; <em># Any arguments or flags that should be passed to...</em>
  <a href="#scheduled_task-attribute-command">command</a>     =&gt; <em># The full path to the application to run, without </em>
  <a href="#scheduled_task-attribute-enabled">enabled</a>     =&gt; <em># Whether the triggers for this task should be...</em>
  <a href="#scheduled_task-attribute-password">password</a>    =&gt; <em># The password for the user specified in the...</em>
  <a href="#scheduled_task-attribute-trigger">trigger</a>     =&gt; <em># One or more triggers defining when the task...</em>
  <a href="#scheduled_task-attribute-user">user</a>        =&gt; <em># The user to run the scheduled task as.  Please...</em>
  <a href="#scheduled_task-attribute-working_dir">working_dir</a> =&gt; <em># The full path of the directory in which to start </em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="scheduled_task-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name assigned to the scheduled task.  This will uniquely
identify the task on the system.

([↑ Back to scheduled_task attributes](#scheduled_task-attributes))

<h4 id="scheduled_task-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to scheduled_task attributes](#scheduled_task-attributes))

<h4 id="scheduled_task-attribute-arguments">arguments</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Any arguments or flags that should be passed to the command. Multiple arguments
should be specified as a space-separated string.

([↑ Back to scheduled_task attributes](#scheduled_task-attributes))

<h4 id="scheduled_task-attribute-command">command</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The full path to the application to run, without any arguments.

([↑ Back to scheduled_task attributes](#scheduled_task-attributes))

<h4 id="scheduled_task-attribute-enabled">enabled</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether the triggers for this task should be enabled. This attribute
affects every trigger for the task; triggers cannot be enabled or
disabled individually.

Default: `true`

Allowed values:

* `true`
* `false`

([↑ Back to scheduled_task attributes](#scheduled_task-attributes))

<h4 id="scheduled_task-attribute-password">password</h4>

The password for the user specified in the 'user' attribute.
This is only used if specifying a user other than 'SYSTEM'.
Since there is no way to retrieve the password used to set the
account information for a task, this parameter will not be used
to determine if a scheduled task is in sync or not.

([↑ Back to scheduled_task attributes](#scheduled_task-attributes))

<h4 id="scheduled_task-attribute-trigger">trigger</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

One or more triggers defining when the task should run. A single trigger is
represented as a hash, and multiple triggers can be specified with an array of
hashes.

A trigger can contain the following keys:

* For all triggers:
    * `schedule` **(Required)** --- What kind of trigger this is.
      Valid values are `daily`, `weekly`, `monthly`, or `once`. Each kind
      of trigger is configured with a different set of keys; see the
      sections below. (`once` triggers only need a start time/date.)
    * `start_time` **(Required)** --- The time of day when the trigger should
      first become active. Several time formats will work, but we
      suggest 24-hour time formatted as HH:MM.
    * `start_date` ---  The date when the trigger should first become active.
      Defaults to the current date. You should format dates as YYYY-MM-DD,
      although other date formats may work. (Under the hood, this uses `Date.parse`.)
    * `minutes_interval` --- The repeat interval in minutes.
    * `minutes_duration` --- The duration in minutes, needs to be greater than the
      minutes_interval.
* For `daily` triggers:
    * `every` --- How often the task should run, as a number of days. Defaults
      to 1. ("2" means every other day, "3" means every three days, etc.)
* For `weekly` triggers:
    * `every` --- How often the task should run, as a number of weeks. Defaults
      to 1. ("2" means every other week, "3" means every three weeks, etc.)
    * `day_of_week` --- Which days of the week the task should run, as an array.
      Defaults to all days. Each day must be one of `mon`, `tues`,
      `wed`, `thurs`, `fri`, `sat`, `sun`, or `all`.
* For `monthly` (by date) triggers:
    * `months` --- Which months the task should run, as an array. Defaults to
      all months. Each month must be an integer between 1 and 12.
    * `on` **(Required)** --- Which days of the month the task should run,
      as an array. Each day must be an integer between 1 and 31.
* For `monthly` (by weekday) triggers:
    * `months` --- Which months the task should run, as an array. Defaults to
      all months. Each month must be an integer between 1 and 12.
    * `day_of_week` **(Required)** --- Which day of the week the task should
      run, as an array with only one element. Each day must be one of `mon`,
      `tues`, `wed`, `thurs`, `fri`, `sat`, `sun`, or `all`.
    * `which_occurrence` **(Required)** --- The occurrence of the chosen weekday
      when the task should run. Must be one of `first`, `second`, `third`,
      `fourth`, or `fifth`.


Examples:

    # Run at 8am on the 1st and 15th days of the month in January, March,
    # May, July, September, and November, starting after August 31st, 2011.
    trigger => {
      schedule   => monthly,
      start_date => '2011-08-31',   # Defaults to current date
      start_time => '08:00',        # Must be specified
      months     => [1,3,5,7,9,11], # Defaults to all
      on         => [1, 15],        # Must be specified
    }

    # Run at 8am on the first Monday of the month for January, March, and May,
    # starting after August 31st, 2011.
    trigger => {
      schedule         => monthly,
      start_date       => '2011-08-31', # Defaults to current date
      start_time       => '08:00',      # Must be specified
      months           => [1,3,5],      # Defaults to all
      which_occurrence => first,        # Must be specified
      day_of_week      => [mon],        # Must be specified
    }

    # Run daily repeating every 30 minutes between 9am and 5pm (480 minutes) starting after August 31st, 2011.
    trigger => {
      schedule         => daily,
      start_date       => '2011-08-31', # Defaults to current date
      start_time       => '8:00',       # Must be specified
      minutes_interval => 30,
      minutes_duration => 480,
    }

([↑ Back to scheduled_task attributes](#scheduled_task-attributes))

<h4 id="scheduled_task-attribute-user">user</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The user to run the scheduled task as.  Please note that not
all security configurations will allow running a scheduled task
as 'SYSTEM', and saving the scheduled task under these
conditions will fail with a reported error of 'The operation
completed successfully'.  It is recommended that you either
choose another user to run the scheduled task, or alter the
security policy to allow v1 scheduled tasks to run as the
'SYSTEM' account.  Defaults to 'SYSTEM'.

Please also note that Puppet must be running as a privileged user
in order to manage `scheduled_task` resources. Running as an
unprivileged user will result in 'access denied' errors.

Default: `system`

([↑ Back to scheduled_task attributes](#scheduled_task-attributes))

<h4 id="scheduled_task-attribute-working_dir">working_dir</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The full path of the directory in which to start the command.

([↑ Back to scheduled_task attributes](#scheduled_task-attributes))


<h3 id="scheduled_task-providers">Providers</h3>

<h4 id="scheduled_task-provider-win32_taskscheduler">win32_taskscheduler</h4>

This provider manages scheduled tasks on Windows.

* Confined to: `operatingsystem == windows`
* Default for: `["operatingsystem", "windows"] == `




---------

selboolean
-----

* [Attributes](#selboolean-attributes)
* [Providers](#selboolean-providers)

<h3 id="selboolean-description">Description</h3>

Manages SELinux booleans on systems with SELinux support.  The supported booleans
are any of the ones found in `/selinux/booleans/`.

<h3 id="selboolean-attributes">Attributes</h3>

<pre><code>selboolean { 'resource title':
  <a href="#selboolean-attribute-name">name</a>       =&gt; <em># <strong>(namevar)</strong> The name of the SELinux boolean to be...</em>
  <a href="#selboolean-attribute-persistent">persistent</a> =&gt; <em># If set true, SELinux booleans will be written to </em>
  <a href="#selboolean-attribute-value">value</a>      =&gt; <em># Whether the SELinux boolean should be enabled or </em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="selboolean-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the SELinux boolean to be managed.

([↑ Back to selboolean attributes](#selboolean-attributes))

<h4 id="selboolean-attribute-persistent">persistent</h4>

If set true, SELinux booleans will be written to disk and persist across reboots.
The default is `false`.

Default: `false`

Allowed values:

* `true`
* `false`

([↑ Back to selboolean attributes](#selboolean-attributes))

<h4 id="selboolean-attribute-value">value</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether the SELinux boolean should be enabled or disabled.

Allowed values:

* `on`
* `off`

([↑ Back to selboolean attributes](#selboolean-attributes))


<h3 id="selboolean-providers">Providers</h3>

<h4 id="selboolean-provider-getsetsebool">getsetsebool</h4>

Manage SELinux booleans using the getsebool and setsebool binaries.

* Required binaries: `/usr/sbin/getsebool`, `/usr/sbin/setsebool`




---------

selmodule
-----

* [Attributes](#selmodule-attributes)
* [Providers](#selmodule-providers)

<h3 id="selmodule-description">Description</h3>

Manages loading and unloading of SELinux policy modules
on the system.  Requires SELinux support.  See man semodule(8)
for more information on SELinux policy modules.

**Autorequires:** If Puppet is managing the file containing this SELinux
policy module (which is either explicitly specified in the `selmodulepath`
attribute or will be found at {`selmoduledir`}/{`name`}.pp), the selmodule
resource will autorequire that file.

<h3 id="selmodule-attributes">Attributes</h3>

<pre><code>selmodule { 'resource title':
  <a href="#selmodule-attribute-name">name</a>          =&gt; <em># <strong>(namevar)</strong> The name of the SELinux policy to be managed....</em>
  <a href="#selmodule-attribute-ensure">ensure</a>        =&gt; <em># The basic property that the resource should be...</em>
  <a href="#selmodule-attribute-selmoduledir">selmoduledir</a>  =&gt; <em># The directory to look for the compiled pp module </em>
  <a href="#selmodule-attribute-selmodulepath">selmodulepath</a> =&gt; <em># The full path to the compiled .pp policy module. </em>
  <a href="#selmodule-attribute-syncversion">syncversion</a>   =&gt; <em># If set to `true`, the policy will be reloaded if </em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="selmodule-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the SELinux policy to be managed.  You should not
include the customary trailing .pp extension.

([↑ Back to selmodule attributes](#selmodule-attributes))

<h4 id="selmodule-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to selmodule attributes](#selmodule-attributes))

<h4 id="selmodule-attribute-selmoduledir">selmoduledir</h4>

The directory to look for the compiled pp module file in.
Currently defaults to `/usr/share/selinux/targeted`.  If the
`selmodulepath` attribute is not specified, Puppet will expect to find
the module in `<selmoduledir>/<name>.pp`, where `name` is the value of the
`name` parameter.

Default: `/usr/share/selinux/targeted`

([↑ Back to selmodule attributes](#selmodule-attributes))

<h4 id="selmodule-attribute-selmodulepath">selmodulepath</h4>

The full path to the compiled .pp policy module.  You only need to use
this if the module file is not in the `selmoduledir` directory.

([↑ Back to selmodule attributes](#selmodule-attributes))

<h4 id="selmodule-attribute-syncversion">syncversion</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

If set to `true`, the policy will be reloaded if the
version found in the on-disk file differs from the loaded
version.  If set to `false` (the default) the only check
that will be made is if the policy is loaded at all or not.

Allowed values:

* `true`
* `false`

([↑ Back to selmodule attributes](#selmodule-attributes))


<h3 id="selmodule-providers">Providers</h3>

<h4 id="selmodule-provider-semodule">semodule</h4>

Manage SELinux policy modules using the semodule binary.

* Required binaries: `/usr/sbin/semodule`




---------

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

([↑ Back to service attributes](#service-attributes))

<h4 id="service-attribute-flags">flags</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Specify a string of flags to pass to the startup script.

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

* Required binaries: `kill`

<h4 id="service-provider-bsd">bsd</h4>

Generic BSD form of `init`-style service management with `rc.d`.

Uses `rc.conf.d` for service enabling and disabling.

* Confined to: `operatingsystem == [:freebsd, :dragonfly]`

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

<h4 id="service-provider-debian">debian</h4>

Debian's form of `init`-style management.

The only differences from `init` are support for enabling and disabling
services via `update-rc.d` and the ability to determine enabled status via
`invoke-rc.d`.

* Required binaries: `/usr/sbin/update-rc.d`, `/usr/sbin/invoke-rc.d`, `/usr/sbin/service`
* Default for: `["operatingsystem", "cumuluslinux"] == ["operatingsystemmajrelease", "['1','2']"]`, `["operatingsystem", "debian"] == ["operatingsystemmajrelease", "['5','6','7']"]`

<h4 id="service-provider-freebsd">freebsd</h4>

Provider for FreeBSD and DragonFly BSD. Uses the `rcvar` argument of init scripts and parses/edits rc files.

* Confined to: `operatingsystem == [:freebsd, :dragonfly]`
* Default for: `["operatingsystem", "[:freebsd, :dragonfly]"] == `

<h4 id="service-provider-gentoo">gentoo</h4>

Gentoo's form of `init`-style service management.

Uses `rc-update` for service enabling and disabling.

* Required binaries: `/sbin/rc-update`
* Confined to: `operatingsystem == gentoo`

<h4 id="service-provider-init">init</h4>

Standard `init`-style service management.

* Confined to: `true == begin
      os = Facter.value(:operatingsystem).downcase
      family = Facter.value(:osfamily).downcase
      !(os == 'debian' || os == 'ubuntu' || family == 'redhat')
  end`

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

* Required binaries: `/bin/launchctl`
* Confined to: `operatingsystem == darwin`, `feature == cfpropertylist`
* Default for: `["operatingsystem", "darwin"] == `

<h4 id="service-provider-openbsd">openbsd</h4>

Provider for OpenBSD's rc.d daemon control scripts

* Required binaries: `/usr/sbin/rcctl`
* Confined to: `operatingsystem == openbsd`
* Default for: `["operatingsystem", "openbsd"] == `

<h4 id="service-provider-openrc">openrc</h4>

Support for Gentoo's OpenRC initskripts

Uses rc-update, rc-status and rc-service to manage services.

* Required binaries: `/sbin/rc-service`, `/sbin/rc-update`
* Default for: `["operatingsystem", "gentoo"] == `, `["operatingsystem", "funtoo"] == `

<h4 id="service-provider-openwrt">openwrt</h4>

Support for OpenWrt flavored init scripts.

Uses /etc/init.d/service_name enable, disable, and enabled.

* Confined to: `operatingsystem == openwrt`
* Default for: `["operatingsystem", "openwrt"] == `

<h4 id="service-provider-rcng">rcng</h4>

RCng service management with rc.d

* Confined to: `operatingsystem == [:netbsd, :cargos]`
* Default for: `["operatingsystem", "[:netbsd, :cargos]"] == `

<h4 id="service-provider-redhat">redhat</h4>

Red Hat's (and probably many others') form of `init`-style service
management. Uses `chkconfig` for service enabling and disabling.

* Required binaries: `/sbin/chkconfig`, `/sbin/service`
* Default for: `["osfamily", "redhat"] == `, `["osfamily", "suse"] == ["operatingsystemmajrelease", "[\"10\", \"11\"]"]`

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

<h4 id="service-provider-service">service</h4>

The simplest form of service support.

<h4 id="service-provider-smf">smf</h4>

Support for Sun's new Service Management Framework.

Starting a service is effectively equivalent to enabling it, so there is
only support for starting and stopping services, which also enables and
disables them, respectively.

By specifying `manifest => "/path/to/service.xml"`, the SMF manifest will
be imported if it does not exist.

* Required binaries: `/usr/sbin/svcadm`, `/usr/bin/svcs`, `/usr/sbin/svccfg`
* Confined to: `osfamily == solaris`
* Default for: `["osfamily", "solaris"] == `

<h4 id="service-provider-src">src</h4>

Support for AIX's System Resource controller.

Services are started/stopped based on the `stopsrc` and `startsrc`
commands, and some services can be refreshed with `refresh` command.

Enabling and disabling services is not supported, as it requires
modifications to `/etc/inittab`. Starting and stopping groups of subsystems
is not yet supported.

* Confined to: `operatingsystem == aix`
* Default for: `["operatingsystem", "aix"] == `

<h4 id="service-provider-systemd">systemd</h4>

Manages `systemd` services using `systemctl`.

Because `systemd` defaults to assuming the `.service` unit type, the suffix
may be omitted.  Other unit types (such as `.path`) may be managed by
providing the proper suffix.

* Required binaries: `systemctl`
* Default for: `["osfamily", "[:archlinux]"] == `, `["osfamily", "redhat"] == ["operatingsystemmajrelease", "7"]`, `["osfamily", "redhat"] == ["operatingsystem", "fedora"]`, `["osfamily", "suse"] == `, `["osfamily", "coreos"] == `, `["operatingsystem", "debian"] == ["operatingsystemmajrelease", "[\"8\", \"stretch/sid\", \"9\", \"buster/sid\"]"]`, `["operatingsystem", "ubuntu"] == ["operatingsystemmajrelease", "[\"15.04\",\"15.10\",\"16.04\",\"16.10\"]"]`, `["operatingsystem", "cumuluslinux"] == ["operatingsystemmajrelease", "[\"3\"]"]`

<h4 id="service-provider-upstart">upstart</h4>

Ubuntu service management with `upstart`.

This provider manages `upstart` jobs on Ubuntu. For `upstart` documentation,
see <http://upstart.ubuntu.com/>.

* Required binaries: `/sbin/start`, `/sbin/stop`, `/sbin/restart`, `/sbin/status`, `/sbin/initctl`
* Confined to: `any == [
    Facter.value(:operatingsystem) == 'Ubuntu',
    (Facter.value(:osfamily) == 'RedHat' and Facter.value(:operatingsystemrelease) =~ /^6\./),
    Facter.value(:operatingsystem) == 'Amazon',
    Facter.value(:operatingsystem) == 'LinuxMint',
  ]`
* Default for: `["operatingsystem", "ubuntu"] == ["operatingsystemmajrelease", "[\"10.04\", \"12.04\", \"14.04\", \"14.10\"]"]`

<h4 id="service-provider-windows">windows</h4>

Support for Windows Service Control Manager (SCM). This provider can
start, stop, enable, and disable services, and the SCM provides working
status methods for all services.

Control of service groups (dependencies) is not yet supported, nor is running
services as a specific user.

* Required binaries: `net.exe`
* Confined to: `operatingsystem == windows`
* Default for: `["operatingsystem", "windows"] == `

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
      <td> </td>
    </tr>
    <tr>
      <td>bsd</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>daemontools</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>debian</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>freebsd</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>gentoo</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>init</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
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
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>openrc</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>openwrt</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>rcng</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>redhat</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>runit</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>service</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>smf</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>src</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
    <tr>
      <td>systemd</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>upstart</td>
      <td> </td>
      <td><em>X</em> </td>
      <td> </td>
      <td> </td>
      <td> </td>
    </tr>
    <tr>
      <td>windows</td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
      <td><em>X</em> </td>
    </tr>
  </tbody>
</table>



---------

ssh_authorized_key
-----

* [Attributes](#ssh_authorized_key-attributes)
* [Providers](#ssh_authorized_key-providers)

<h3 id="ssh_authorized_key-description">Description</h3>

Manages SSH authorized keys. Currently only type 2 keys are supported.

In their native habitat, SSH keys usually appear as a single long line, in
the format `<TYPE> <KEY> <NAME/COMMENT>`. This resource type requires you
to split that line into several attributes. Thus, a key that appears in
your `~/.ssh/id_rsa.pub` file like this...

    ssh-rsa AAAAB3Nza[...]qXfdaQ== nick@magpie.example.com

...would translate to the following resource:

    ssh_authorized_key { 'nick@magpie.example.com':
      ensure => present,
      user   => 'nick',
      type   => 'ssh-rsa',
      key    => 'AAAAB3Nza[...]qXfdaQ==',
    }

To ensure that only the currently approved keys are present, you can purge
unmanaged SSH keys on a per-user basis. Do this with the `user` resource
type's `purge_ssh_keys` attribute:

    user { 'nick':
      ensure         => present,
      purge_ssh_keys => true,
    }

This will remove any keys in `~/.ssh/authorized_keys` that aren't being
managed with `ssh_authorized_key` resources. See the documentation of the
`user` type for more details.

**Autorequires:** If Puppet is managing the user account in which this
SSH key should be installed, the `ssh_authorized_key` resource will autorequire
that user.

<h3 id="ssh_authorized_key-attributes">Attributes</h3>

<pre><code>ssh_authorized_key { 'resource title':
  <a href="#ssh_authorized_key-attribute-name">name</a>    =&gt; <em># <strong>(namevar)</strong> The SSH key comment. This can be anything, and...</em>
  <a href="#ssh_authorized_key-attribute-ensure">ensure</a>  =&gt; <em># The basic property that the resource should be...</em>
  <a href="#ssh_authorized_key-attribute-key">key</a>     =&gt; <em># The public key itself; generally a long string...</em>
  <a href="#ssh_authorized_key-attribute-options">options</a> =&gt; <em># Key options; see sshd(8) for possible values...</em>
  <a href="#ssh_authorized_key-attribute-target">target</a>  =&gt; <em># The absolute filename in which to store the SSH...</em>
  <a href="#ssh_authorized_key-attribute-type">type</a>    =&gt; <em># The encryption type used.  Allowed values:  ...</em>
  <a href="#ssh_authorized_key-attribute-user">user</a>    =&gt; <em># The user account in which the SSH key should be...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="ssh_authorized_key-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The SSH key comment. This can be anything, and doesn't need to match
the original comment from the `.pub` file.

Due to internal limitations, this must be unique across all user accounts;
if you want to specify one key for multiple users, you must use a different
comment for each instance.

([↑ Back to ssh_authorized_key attributes](#ssh_authorized_key-attributes))

<h4 id="ssh_authorized_key-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to ssh_authorized_key attributes](#ssh_authorized_key-attributes))

<h4 id="ssh_authorized_key-attribute-key">key</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The public key itself; generally a long string of hex characters. The `key`
attribute may not contain whitespace.

Make sure to omit the following in this attribute (and specify them in
other attributes):

* Key headers (e.g. 'ssh-rsa') --- put these in the `type` attribute.
* Key identifiers / comments (e.g. 'joe@joescomputer.local') --- put these in
  the `name` attribute/resource title.

([↑ Back to ssh_authorized_key attributes](#ssh_authorized_key-attributes))

<h4 id="ssh_authorized_key-attribute-options">options</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Key options; see sshd(8) for possible values. Multiple values
should be specified as an array.

([↑ Back to ssh_authorized_key attributes](#ssh_authorized_key-attributes))

<h4 id="ssh_authorized_key-attribute-target">target</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The absolute filename in which to store the SSH key. This
property is optional and should only be used in cases where keys
are stored in a non-standard location (i.e.` not in
`~user/.ssh/authorized_keys`).

Default: `absent`

([↑ Back to ssh_authorized_key attributes](#ssh_authorized_key-attributes))

<h4 id="ssh_authorized_key-attribute-type">type</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The encryption type used.

Allowed values:

* `ssh-dss`
* `ssh-rsa`
* `ecdsa-sha2-nistp256`
* `ecdsa-sha2-nistp384`
* `ecdsa-sha2-nistp521`
* `ssh-ed25519`
* `dsa`
* `ed25519`
* `rsa`

([↑ Back to ssh_authorized_key attributes](#ssh_authorized_key-attributes))

<h4 id="ssh_authorized_key-attribute-user">user</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The user account in which the SSH key should be installed. The resource
will autorequire this user if it is being managed as a `user` resource.

([↑ Back to ssh_authorized_key attributes](#ssh_authorized_key-attributes))


<h3 id="ssh_authorized_key-providers">Providers</h3>

<h4 id="ssh_authorized_key-provider-parsed">parsed</h4>

Parse and generate authorized_keys files for SSH.




---------

sshkey
-----

* [Attributes](#sshkey-attributes)
* [Providers](#sshkey-providers)

<h3 id="sshkey-description">Description</h3>

Installs and manages ssh host keys.  By default, this type will
install keys into `/etc/ssh/ssh_known_hosts`. To manage ssh keys in a
different `known_hosts` file, such as a user's personal `known_hosts`,
pass its path to the `target` parameter. See the `ssh_authorized_key`
type to manage authorized keys.

<h3 id="sshkey-attributes">Attributes</h3>

<pre><code>sshkey { 'resource title':
  <a href="#sshkey-attribute-name">name</a>         =&gt; <em># <strong>(namevar)</strong> The host name that the key is associated...</em>
  <a href="#sshkey-attribute-ensure">ensure</a>       =&gt; <em># The basic property that the resource should be...</em>
  <a href="#sshkey-attribute-host_aliases">host_aliases</a> =&gt; <em># Any aliases the host might have.  Multiple...</em>
  <a href="#sshkey-attribute-key">key</a>          =&gt; <em># The key itself; generally a long string of...</em>
  <a href="#sshkey-attribute-target">target</a>       =&gt; <em># The file in which to store the ssh key.  Only...</em>
  <a href="#sshkey-attribute-type">type</a>         =&gt; <em># The encryption type used.  Probably ssh-dss or...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="sshkey-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The host name that the key is associated with.

([↑ Back to sshkey attributes](#sshkey-attributes))

<h4 id="sshkey-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to sshkey attributes](#sshkey-attributes))

<h4 id="sshkey-attribute-host_aliases">host_aliases</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Any aliases the host might have.  Multiple values must be
specified as an array.

([↑ Back to sshkey attributes](#sshkey-attributes))

<h4 id="sshkey-attribute-key">key</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The key itself; generally a long string of uuencoded characters. The `key`
attribute may not contain whitespace.

Make sure to omit the following in this attribute (and specify them in
other attributes):

* Key headers (e.g. 'ssh-rsa') --- put these in the `type` attribute.
* Key identifiers / comments (e.g. 'joescomputer.local') --- put these in
  the `name` attribute/resource title.

([↑ Back to sshkey attributes](#sshkey-attributes))

<h4 id="sshkey-attribute-target">target</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The file in which to store the ssh key.  Only used by
the `parsed` provider.

([↑ Back to sshkey attributes](#sshkey-attributes))

<h4 id="sshkey-attribute-type">type</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The encryption type used.  Probably ssh-dss or ssh-rsa.

Allowed values:

* `ssh-dss`
* `ssh-ed25519`
* `ssh-rsa`
* `ecdsa-sha2-nistp256`
* `ecdsa-sha2-nistp384`
* `ecdsa-sha2-nistp521`
* `dsa`
* `ed25519`
* `rsa`

([↑ Back to sshkey attributes](#sshkey-attributes))


<h3 id="sshkey-providers">Providers</h3>

<h4 id="sshkey-provider-parsed">parsed</h4>

Parse and generate host-wide known hosts files for SSH.




---------

stage
-----

* [Attributes](#stage-attributes)

<h3 id="stage-description">Description</h3>

A resource type for creating new run stages.  Once a stage is available,
classes can be assigned to it by declaring them with the resource-like syntax
and using
[the `stage` metaparameter](https://docs.puppetlabs.com/puppet/latest/metaparameter.html#stage).

Note that new stages are not useful unless you also declare their order
in relation to the default `main` stage.

A complete run stage example:

    stage { 'pre':
      before => Stage['main'],
    }

    class { 'apt-updates':
      stage => 'pre',
    }

Individual resources cannot be assigned to run stages; you can only set stages
for classes.

<h3 id="stage-attributes">Attributes</h3>

<pre><code>stage { 'resource title':
  <a href="#stage-attribute-name">name</a> =&gt; <em># <strong>(namevar)</strong> The name of the stage. Use this as the value for </em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="stage-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the stage. Use this as the value for the `stage` metaparameter
when assigning classes to this stage.

([↑ Back to stage attributes](#stage-attributes))





---------

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
  <a href="#tidy-attribute-type">type</a>    =&gt; <em># Set the mechanism for determining age. Default...</em>
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
of those words (e.g., '1w').

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

Set the mechanism for determining age. Default: atime.

Default: `atime`

Allowed values:

* `atime`
* `mtime`
* `ctime`

([↑ Back to tidy attributes](#tidy-attributes))





---------

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
  <a href="#user-attribute-allowdupe">allowdupe</a>            =&gt; <em># Whether to allow duplicate UIDs. Defaults to...</em>
  <a href="#user-attribute-attribute_membership">attribute_membership</a> =&gt; <em># Whether specified attribute value pairs should...</em>
  <a href="#user-attribute-attributes">attributes</a>           =&gt; <em># Specify AIX attributes for the user in an array...</em>
  <a href="#user-attribute-auth_membership">auth_membership</a>      =&gt; <em># Whether specified auths should be considered the </em>
  <a href="#user-attribute-auths">auths</a>                =&gt; <em># The auths the user has.  Multiple auths should...</em>
  <a href="#user-attribute-comment">comment</a>              =&gt; <em># A description of the user.  Generally the user's </em>
  <a href="#user-attribute-expiry">expiry</a>               =&gt; <em># The expiry date for this user. Must be provided...</em>
  <a href="#user-attribute-forcelocal">forcelocal</a>           =&gt; <em># Forces the management of local accounts when...</em>
  <a href="#user-attribute-gid">gid</a>                  =&gt; <em># The user's primary group.  Can be specified...</em>
  <a href="#user-attribute-groups">groups</a>               =&gt; <em># The groups to which the user belongs.  The...</em>
  <a href="#user-attribute-home">home</a>                 =&gt; <em># The home directory of the user.  The directory...</em>
  <a href="#user-attribute-ia_load_module">ia_load_module</a>       =&gt; <em># The name of the I&A module to use to manage this </em>
  <a href="#user-attribute-iterations">iterations</a>           =&gt; <em># This is the number of iterations of a chained...</em>
  <a href="#user-attribute-key_membership">key_membership</a>       =&gt; <em># Whether specified key/value pairs should be...</em>
  <a href="#user-attribute-keys">keys</a>                 =&gt; <em># Specify user attributes in an array of key ...</em>
  <a href="#user-attribute-loginclass">loginclass</a>           =&gt; <em># The name of login class to which the user...</em>
  <a href="#user-attribute-managehome">managehome</a>           =&gt; <em># Whether to manage the home directory when...</em>
  <a href="#user-attribute-membership">membership</a>           =&gt; <em># If `minimum` is specified, Puppet will ensure...</em>
  <a href="#user-attribute-password">password</a>             =&gt; <em># The user's password, in whatever encrypted...</em>
  <a href="#user-attribute-password_max_age">password_max_age</a>     =&gt; <em># The maximum number of days a password may be...</em>
  <a href="#user-attribute-password_min_age">password_min_age</a>     =&gt; <em># The minimum number of days a password must be...</em>
  <a href="#user-attribute-profile_membership">profile_membership</a>   =&gt; <em># Whether specified roles should be treated as the </em>
  <a href="#user-attribute-profiles">profiles</a>             =&gt; <em># The profiles the user has.  Multiple profiles...</em>
  <a href="#user-attribute-project">project</a>              =&gt; <em># The name of the project associated with a...</em>
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

Whether to allow duplicate UIDs. Defaults to `false`.

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
attribute/value pairs for the user. Defaults to `minimum`.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-attributes">attributes</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Specify AIX attributes for the user in an array of attribute = value pairs.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-auth_membership">auth_membership</h4>

Whether specified auths should be considered the **complete list**
(`inclusive`) or the **minimum list** (`minimum`) of auths the user
has. Defaults to `minimum`.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-auths">auths</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The auths the user has.  Multiple auths should be
specified as an array.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-comment">comment</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A description of the user.  Generally the user's full name.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-expiry">expiry</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The expiry date for this user. Must be provided in
a zero-padded YYYY-MM-DD format --- e.g. 2010-02-19.
If you want to ensure the user account never expires,
you can pass the special value `absent`.

Allowed values:

* `absent`
* `/^\d{4}-\d{2}-\d{2}$/`

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

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-iterations">iterations</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

This is the number of iterations of a chained computation of the
[PBKDF2 password hash](https://en.wikipedia.org/wiki/PBKDF2). This parameter
is used in OS X, and is required for managing passwords on OS X 10.8 and
newer.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-key_membership">key_membership</h4>

Whether specified key/value pairs should be considered the
**complete list** (`inclusive`) or the **minimum list** (`minimum`) of
the user's attributes. Defaults to `minimum`.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-keys">keys</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Specify user attributes in an array of key = value pairs.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-loginclass">loginclass</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The name of login class to which the user belongs.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-managehome">managehome</h4>

Whether to manage the home directory when managing the user.
This will create the home directory when `ensure => present`, and
delete the home directory when `ensure => absent`. Defaults to `false`.

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

Defaults to `minimum`.

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
* Windows passwords can only be managed in cleartext, as there is no Windows API
  for setting the password hash.

[stdlib]: https://github.com/puppetlabs/puppetlabs-stdlib/

Enclose any value that includes a dollar sign ($) in single quotes (') to avoid
accidental variable interpolation.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-password_max_age">password_max_age</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The maximum number of days a password may be used before it must be changed.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-password_min_age">password_min_age</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The minimum number of days a password must be used before it may be changed.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-profile_membership">profile_membership</h4>

Whether specified roles should be treated as the **complete list**
(`inclusive`) or the **minimum list** (`minimum`) of roles
of which the user is a member. Defaults to `minimum`.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-profiles">profiles</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The profiles the user has.  Multiple profiles should be
specified as an array.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-project">project</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The name of the project associated with a user.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-purge_ssh_keys">purge_ssh_keys</h4>

Whether to purge authorized SSH keys for this user if they are not managed
with the `ssh_authorized_key` resource type. Allowed values are:

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
has. Defaults to `minimum`.

Default: `minimum`

Allowed values:

* `inclusive`
* `minimum`

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-roles">roles</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The roles the user has.  Multiple roles should be
specified as an array.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-salt">salt</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

This is the 32-byte salt used to generate the PBKDF2 password used in
OS X. This field is required for managing passwords on OS X >= 10.8.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-shell">shell</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The user's login shell.  The shell must exist and be
executable.

This attribute cannot be managed on Windows systems.

([↑ Back to user attributes](#user-attributes))

<h4 id="user-attribute-system">system</h4>

Whether the user is a system user, according to the OS's criteria;
on most platforms, a UID less than or equal to 500 indicates a system
user. This parameter is only used when the resource is created and will
not affect the UID when the user is present. Defaults to `false`.

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

* Required binaries: `/usr/sbin/lsuser`, `/usr/bin/mkuser`, `/usr/sbin/rmuser`, `/usr/bin/chuser`, `/usr/sbin/lsgroup`, `/bin/chpasswd`
* Confined to: `operatingsystem == aix`
* Default for: `["operatingsystem", "aix"] == `

<h4 id="user-provider-directoryservice">directoryservice</h4>

User management on OS X.

* Required binaries: `/usr/bin/uuidgen`, `/usr/bin/dsimport`, `/usr/bin/dscl`, `/usr/bin/dscacheutil`
* Confined to: `operatingsystem == darwin`, `feature == cfpropertylist`
* Default for: `["operatingsystem", "darwin"] == `

<h4 id="user-provider-hpuxuseradd">hpuxuseradd</h4>

User management for HP-UX. This provider uses the undocumented `-F`
switch to HP-UX's special `usermod` binary to work around the fact that
its standard `usermod` cannot make changes while the user is logged in.
New functionality provides for changing trusted computing passwords and
resetting password expirations under trusted computing.

* Required binaries: `/usr/sam/lbin/usermod.sam`, `/usr/sam/lbin/userdel.sam`, `/usr/sam/lbin/useradd.sam`
* Confined to: `operatingsystem == hp-ux`
* Default for: `["operatingsystem", "hp-ux"] == `

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

<h4 id="user-provider-openbsd">openbsd</h4>

User management via `useradd` and its ilk for OpenBSD. Note that you
will need to install Ruby's shadow password library (package known as
`ruby-shadow`) if you wish to manage user passwords.

* Required binaries: `useradd`, `userdel`, `usermod`, `passwd`
* Confined to: `operatingsystem == openbsd`
* Default for: `["operatingsystem", "openbsd"] == `

<h4 id="user-provider-pw">pw</h4>

User management via `pw` on FreeBSD and DragonFly BSD.

* Required binaries: `pw`
* Confined to: `operatingsystem == [:freebsd, :dragonfly]`
* Default for: `["operatingsystem", "[:freebsd, :dragonfly]"] == `

<h4 id="user-provider-user_role_add">user_role_add</h4>

User and role management on Solaris, via `useradd` and `roleadd`.

* Required binaries: `useradd`, `userdel`, `usermod`, `passwd`, `roleadd`, `roledel`, `rolemod`
* Default for: `["osfamily", "solaris"] == `

<h4 id="user-provider-useradd">useradd</h4>

User management via `useradd` and its ilk.  Note that you will need to
install Ruby's shadow password library (often known as `ruby-libshadow`)
if you wish to manage user passwords.

* Required binaries: `useradd`, `userdel`, `usermod`, `chage`

<h4 id="user-provider-windows_adsi">windows_adsi</h4>

Local user management for Windows.

* Confined to: `operatingsystem == windows`
* Default for: `["operatingsystem", "windows"] == `

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
      <td> </td>
      <td> </td>
      <td> </td>
      <td> </td>
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
      <td> </td>
      <td><em>X</em> </td>
      <td><em>X</em> </td>
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



---------

vlan
-----

* [Attributes](#vlan-attributes)
* [Providers](#vlan-providers)

<h3 id="vlan-description">Description</h3>

Manages a VLAN on a router or switch.

<h3 id="vlan-attributes">Attributes</h3>

<pre><code>vlan { 'resource title':
  <a href="#vlan-attribute-name">name</a>        =&gt; <em># <strong>(namevar)</strong> The numeric VLAN ID.  Allowed values:  ...</em>
  <a href="#vlan-attribute-ensure">ensure</a>      =&gt; <em># The basic property that the resource should be...</em>
  <a href="#vlan-attribute-description">description</a> =&gt; <em># The VLAN's...</em>
  <a href="#vlan-attribute-device_url">device_url</a>  =&gt; <em># The URL of the router or switch maintaining this </em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="vlan-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The numeric VLAN ID.

Allowed values:

* `/^\d+/`

([↑ Back to vlan attributes](#vlan-attributes))

<h4 id="vlan-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to vlan attributes](#vlan-attributes))

<h4 id="vlan-attribute-description">description</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The VLAN's name.

([↑ Back to vlan attributes](#vlan-attributes))

<h4 id="vlan-attribute-device_url">device_url</h4>

The URL of the router or switch maintaining this VLAN.

([↑ Back to vlan attributes](#vlan-attributes))


<h3 id="vlan-providers">Providers</h3>

<h4 id="vlan-provider-cisco">cisco</h4>

Cisco switch/router provider for vlans.




---------

whit
-----

* [Attributes](#whit-attributes)

<h3 id="whit-description">Description</h3>

Whits are internal artifacts of Puppet's current implementation, and
Puppet suppresses their appearance in all logs. We make no guarantee of
the whit's continued existence, and it should never be used in an actual
manifest. Use the `anchor` type from the puppetlabs-stdlib module if you
need arbitrary whit-like no-op resources.

<h3 id="whit-attributes">Attributes</h3>

<pre><code>whit { 'resource title':
  <a href="#whit-attribute-name">name</a> =&gt; <em># <strong>(namevar)</strong> The name of the whit, because it must have...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="whit-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the whit, because it must have one.

([↑ Back to whit attributes](#whit-attributes))





---------

yumrepo
-----

* [Attributes](#yumrepo-attributes)
* [Providers](#yumrepo-providers)

<h3 id="yumrepo-description">Description</h3>

The client-side description of a yum repository. Repository
configurations are found by parsing `/etc/yum.conf` and
the files indicated by the `reposdir` option in that file
(see `yum.conf(5)` for details).

Most parameters are identical to the ones documented
in the `yum.conf(5)` man page.

Continuation lines that yum supports (for the `baseurl`, for example)
are not supported. This type does not attempt to read or verify the
existence of files listed in the `include` attribute.

<h3 id="yumrepo-attributes">Attributes</h3>

<pre><code>yumrepo { 'resource title':
  <a href="#yumrepo-attribute-name">name</a>                         =&gt; <em># <strong>(namevar)</strong> The name of the repository.  This corresponds to </em>
  <a href="#yumrepo-attribute-ensure">ensure</a>                       =&gt; <em># The basic property that the resource should be...</em>
  <a href="#yumrepo-attribute-assumeyes">assumeyes</a>                    =&gt; <em># Determines if yum prompts for confirmation of...</em>
  <a href="#yumrepo-attribute-bandwidth">bandwidth</a>                    =&gt; <em># Use to specify the maximum available network...</em>
  <a href="#yumrepo-attribute-baseurl">baseurl</a>                      =&gt; <em># The URL for this repository.  Allowed values:  * </em>
  <a href="#yumrepo-attribute-cost">cost</a>                         =&gt; <em># Cost of this repository.  Allowed values:  ...</em>
  <a href="#yumrepo-attribute-deltarpm_metadata_percentage">deltarpm_metadata_percentage</a> =&gt; <em># Percentage value that determines when to...</em>
  <a href="#yumrepo-attribute-deltarpm_percentage">deltarpm_percentage</a>          =&gt; <em># Percentage value that determines when to use...</em>
  <a href="#yumrepo-attribute-descr">descr</a>                        =&gt; <em># A human-readable description of the repository...</em>
  <a href="#yumrepo-attribute-enabled">enabled</a>                      =&gt; <em># Whether this repository is enabled.  Allowed...</em>
  <a href="#yumrepo-attribute-enablegroups">enablegroups</a>                 =&gt; <em># Whether yum will allow the use of package groups </em>
  <a href="#yumrepo-attribute-exclude">exclude</a>                      =&gt; <em># List of shell globs. Matching packages will...</em>
  <a href="#yumrepo-attribute-failovermethod">failovermethod</a>               =&gt; <em># The failover method for this repository; should...</em>
  <a href="#yumrepo-attribute-gpgcakey">gpgcakey</a>                     =&gt; <em># The URL for the GPG CA key for this repository.  </em>
  <a href="#yumrepo-attribute-gpgcheck">gpgcheck</a>                     =&gt; <em># Whether to check the GPG signature on packages...</em>
  <a href="#yumrepo-attribute-gpgkey">gpgkey</a>                       =&gt; <em># The URL for the GPG key with which packages from </em>
  <a href="#yumrepo-attribute-http_caching">http_caching</a>                 =&gt; <em># What to cache from this repository.  Allowed...</em>
  <a href="#yumrepo-attribute-include">include</a>                      =&gt; <em># The URL of a remote file containing additional...</em>
  <a href="#yumrepo-attribute-includepkgs">includepkgs</a>                  =&gt; <em># List of shell globs. If this is set, only...</em>
  <a href="#yumrepo-attribute-keepalive">keepalive</a>                    =&gt; <em># Whether HTTP/1.1 keepalive should be used with...</em>
  <a href="#yumrepo-attribute-metadata_expire">metadata_expire</a>              =&gt; <em># Number of seconds after which the metadata will...</em>
  <a href="#yumrepo-attribute-metalink">metalink</a>                     =&gt; <em># Metalink for mirrors.  Allowed values:  * `/.*/` </em>
  <a href="#yumrepo-attribute-mirrorlist">mirrorlist</a>                   =&gt; <em># The URL that holds the list of mirrors for this...</em>
  <a href="#yumrepo-attribute-mirrorlist_expire">mirrorlist_expire</a>            =&gt; <em># Time (in seconds) after which the mirrorlist...</em>
  <a href="#yumrepo-attribute-priority">priority</a>                     =&gt; <em># Priority of this repository from 1-99. Requires...</em>
  <a href="#yumrepo-attribute-protect">protect</a>                      =&gt; <em># Enable or disable protection for this...</em>
  <a href="#yumrepo-attribute-proxy">proxy</a>                        =&gt; <em># URL of a proxy server that Yum should use when...</em>
  <a href="#yumrepo-attribute-proxy_password">proxy_password</a>               =&gt; <em># Password for this proxy.  Allowed values:  ...</em>
  <a href="#yumrepo-attribute-proxy_username">proxy_username</a>               =&gt; <em># Username for this proxy.  Allowed values:  ...</em>
  <a href="#yumrepo-attribute-repo_gpgcheck">repo_gpgcheck</a>                =&gt; <em># Whether to check the GPG signature on repodata.  </em>
  <a href="#yumrepo-attribute-retries">retries</a>                      =&gt; <em># Set the number of times any attempt to retrieve...</em>
  <a href="#yumrepo-attribute-s3_enabled">s3_enabled</a>                   =&gt; <em># Access the repository via S3.  Allowed values:...</em>
  <a href="#yumrepo-attribute-skip_if_unavailable">skip_if_unavailable</a>          =&gt; <em># Should yum skip this repository if unable to...</em>
  <a href="#yumrepo-attribute-sslcacert">sslcacert</a>                    =&gt; <em># Path to the directory containing the databases...</em>
  <a href="#yumrepo-attribute-sslclientcert">sslclientcert</a>                =&gt; <em># Path  to the SSL client certificate yum should...</em>
  <a href="#yumrepo-attribute-sslclientkey">sslclientkey</a>                 =&gt; <em># Path to the SSL client key yum should use to...</em>
  <a href="#yumrepo-attribute-sslverify">sslverify</a>                    =&gt; <em># Should yum verify SSL certificates/hosts at all. </em>
  <a href="#yumrepo-attribute-target">target</a>                       =&gt; <em># The filename to write the yum repository to....</em>
  <a href="#yumrepo-attribute-throttle">throttle</a>                     =&gt; <em># Enable bandwidth throttling for downloads. This...</em>
  <a href="#yumrepo-attribute-timeout">timeout</a>                      =&gt; <em># Number of seconds to wait for a connection...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="yumrepo-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the repository.  This corresponds to the
`repositoryid` parameter in `yum.conf(5)`.

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-assumeyes">assumeyes</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Determines if yum prompts for confirmation of critical actions.

Allowed values:

* `YUM_BOOLEAN`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-bandwidth">bandwidth</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Use to specify the maximum available network bandwidth
in bytes/second. Used with the `throttle` option. If `throttle`
is a percentage and `bandwidth` is `0` then bandwidth throttling
will be disabled. If `throttle` is expressed as a data rate then
this option is ignored.\n

Allowed values:

* `/^\d+[kMG]?$/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-baseurl">baseurl</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The URL for this repository.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-cost">cost</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Cost of this repository.

Allowed values:

* `/^\d+$/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-deltarpm_metadata_percentage">deltarpm_metadata_percentage</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Percentage value that determines when to download deltarpm metadata.
When the deltarpm metadata is larger than this percentage value of the
package, deltarpm metadata is not downloaded.

Allowed values:

* `/^\d+$/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-deltarpm_percentage">deltarpm_percentage</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Percentage value that determines when to use deltas for this repository.
When the delta is larger than this percentage value of the package, the
delta is not used.

Allowed values:

* `/^\d+$/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-descr">descr</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

A human-readable description of the repository.
This corresponds to the name parameter in `yum.conf(5)`.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-enabled">enabled</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether this repository is enabled.

Allowed values:

* `YUM_BOOLEAN`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-enablegroups">enablegroups</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether yum will allow the use of package groups for this
repository.

Allowed values:

* `YUM_BOOLEAN`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-exclude">exclude</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

List of shell globs. Matching packages will never be
considered in updates or installs for this repo.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-failovermethod">failovermethod</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The failover method for this repository; should be either
`roundrobin` or `priority`.

Allowed values:

* `/^roundrobin|priority$/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-gpgcakey">gpgcakey</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The URL for the GPG CA key for this repository.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-gpgcheck">gpgcheck</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether to check the GPG signature on packages installed
from this repository.

Allowed values:

* `YUM_BOOLEAN`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-gpgkey">gpgkey</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The URL for the GPG key with which packages from this
repository are signed.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-http_caching">http_caching</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

What to cache from this repository.

Allowed values:

* `/^(packages|all|none)$/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-include">include</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The URL of a remote file containing additional yum configuration
settings. Puppet does not check for this file's existence or validity.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-includepkgs">includepkgs</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

List of shell globs. If this is set, only packages
matching one of the globs will be considered for
update or install from this repository.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-keepalive">keepalive</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether HTTP/1.1 keepalive should be used with this repository.

Allowed values:

* `YUM_BOOLEAN`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-metadata_expire">metadata_expire</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Number of seconds after which the metadata will expire.

Allowed values:

* `/^([0-9]+[dhm]?|never)$/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-metalink">metalink</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Metalink for mirrors.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-mirrorlist">mirrorlist</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The URL that holds the list of mirrors for this repository.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-mirrorlist_expire">mirrorlist_expire</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Time (in seconds) after which the mirrorlist locally cached
will expire.\n

Allowed values:

* `/^[0-9]+$/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-priority">priority</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Priority of this repository from 1-99. Requires that
the `priorities` plugin is installed and enabled.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-protect">protect</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Enable or disable protection for this repository. Requires
that the `protectbase` plugin is installed and enabled.

Allowed values:

* `YUM_BOOLEAN`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-proxy">proxy</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

URL of a proxy server that Yum should use when accessing this repository.
This attribute can also be set to `'_none_'`, which will make Yum bypass any
global proxy settings when accessing this repository.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-proxy_password">proxy_password</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Password for this proxy.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-proxy_username">proxy_username</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Username for this proxy.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-repo_gpgcheck">repo_gpgcheck</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether to check the GPG signature on repodata.

Allowed values:

* `YUM_BOOLEAN`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-retries">retries</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Set the number of times any attempt to retrieve a file should
 retry before returning an error. Setting this to `0` makes yum
try forever.\n

Allowed values:

* `/^[0-9]+$/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-s3_enabled">s3_enabled</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Access the repository via S3.

Allowed values:

* `YUM_BOOLEAN`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-skip_if_unavailable">skip_if_unavailable</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Should yum skip this repository if unable to reach it.

Allowed values:

* `YUM_BOOLEAN`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-sslcacert">sslcacert</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Path to the directory containing the databases of the
certificate authorities yum should use to verify SSL certificates.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-sslclientcert">sslclientcert</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Path  to the SSL client certificate yum should use to connect
to repositories/remote sites.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-sslclientkey">sslclientkey</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Path to the SSL client key yum should use to connect
to repositories/remote sites.

Allowed values:

* `/.*/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-sslverify">sslverify</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Should yum verify SSL certificates/hosts at all.

Allowed values:

* `YUM_BOOLEAN`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-target">target</h4>

The filename to write the yum repository to.

Default: `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-throttle">throttle</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Enable bandwidth throttling for downloads. This option
can be expressed as a absolute data rate in bytes/sec or a
percentage `60%`. An SI prefix (k, M or G) may be appended
to the data rate values.\n

Allowed values:

* `/^\d+[kMG%]?$/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))

<h4 id="yumrepo-attribute-timeout">timeout</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Number of seconds to wait for a connection before timing
out.

Allowed values:

* `/^\d+$/`
* `absent`

([↑ Back to yumrepo attributes](#yumrepo-attributes))


<h3 id="yumrepo-providers">Providers</h3>

<h4 id="yumrepo-provider-inifile">inifile</h4>

Manage yum repo configurations by parsing yum INI configuration files.

### Fetching instances

When fetching repo instances, directory entries in '/etc/yum/repos.d',
'/etc/yum.repos.d', and the directory optionally specified by the reposdir
key in '/etc/yum.conf' will be checked. If a given directory does not exist it
will be ignored. In addition, all sections in '/etc/yum.conf' aside from
'main' will be created as sections.

### Storing instances

When creating a new repository, a new section will be added in the first
yum repo directory that exists. The custom directory specified by the
'/etc/yum.conf' reposdir property is checked first, followed by
'/etc/yum/repos.d', and then '/etc/yum.repos.d'. If none of these exist, the
section will be created in '/etc/yum.conf'.




---------

zfs
-----

* [Attributes](#zfs-attributes)
* [Providers](#zfs-providers)

<h3 id="zfs-description">Description</h3>

Manage zfs. Create destroy and set properties on zfs instances.

**Autorequires:** If Puppet is managing the zpool at the root of this zfs
instance, the zfs resource will autorequire it. If Puppet is managing any
parent zfs instances, the zfs resource will autorequire them.

<h3 id="zfs-attributes">Attributes</h3>

<pre><code>zfs { 'resource title':
  <a href="#zfs-attribute-name">name</a>           =&gt; <em># <strong>(namevar)</strong> The full name for this filesystem (including the </em>
  <a href="#zfs-attribute-ensure">ensure</a>         =&gt; <em># The basic property that the resource should be...</em>
  <a href="#zfs-attribute-aclinherit">aclinherit</a>     =&gt; <em># The aclinherit property. Valid values are...</em>
  <a href="#zfs-attribute-aclmode">aclmode</a>        =&gt; <em># The aclmode property. Valid values are...</em>
  <a href="#zfs-attribute-atime">atime</a>          =&gt; <em># The atime property. Valid values are `on`...</em>
  <a href="#zfs-attribute-canmount">canmount</a>       =&gt; <em># The canmount property. Valid values are `on`...</em>
  <a href="#zfs-attribute-checksum">checksum</a>       =&gt; <em># The checksum property. Valid values are `on`...</em>
  <a href="#zfs-attribute-compression">compression</a>    =&gt; <em># The compression property. Valid values are `on`, </em>
  <a href="#zfs-attribute-copies">copies</a>         =&gt; <em># The copies property. Valid values are `1`, `2`...</em>
  <a href="#zfs-attribute-dedup">dedup</a>          =&gt; <em># The dedup property. Valid values are `on`...</em>
  <a href="#zfs-attribute-devices">devices</a>        =&gt; <em># The devices property. Valid values are `on`...</em>
  <a href="#zfs-attribute-exec">exec</a>           =&gt; <em># The exec property. Valid values are `on`...</em>
  <a href="#zfs-attribute-logbias">logbias</a>        =&gt; <em># The logbias property. Valid values are...</em>
  <a href="#zfs-attribute-mountpoint">mountpoint</a>     =&gt; <em># The mountpoint property. Valid values are...</em>
  <a href="#zfs-attribute-nbmand">nbmand</a>         =&gt; <em># The nbmand property. Valid values are `on`...</em>
  <a href="#zfs-attribute-primarycache">primarycache</a>   =&gt; <em># The primarycache property. Valid values are...</em>
  <a href="#zfs-attribute-quota">quota</a>          =&gt; <em># The quota property. Valid values are `&lt;size>`...</em>
  <a href="#zfs-attribute-readonly">readonly</a>       =&gt; <em># The readonly property. Valid values are `on`...</em>
  <a href="#zfs-attribute-recordsize">recordsize</a>     =&gt; <em># The recordsize property. Valid values are powers </em>
  <a href="#zfs-attribute-refquota">refquota</a>       =&gt; <em># The refquota property. Valid values are...</em>
  <a href="#zfs-attribute-refreservation">refreservation</a> =&gt; <em># The refreservation property. Valid values are...</em>
  <a href="#zfs-attribute-reservation">reservation</a>    =&gt; <em># The reservation property. Valid values are...</em>
  <a href="#zfs-attribute-secondarycache">secondarycache</a> =&gt; <em># The secondarycache property. Valid values are...</em>
  <a href="#zfs-attribute-setuid">setuid</a>         =&gt; <em># The setuid property. Valid values are `on`...</em>
  <a href="#zfs-attribute-shareiscsi">shareiscsi</a>     =&gt; <em># The shareiscsi property. Valid values are `on`...</em>
  <a href="#zfs-attribute-sharenfs">sharenfs</a>       =&gt; <em># The sharenfs property. Valid values are `on`...</em>
  <a href="#zfs-attribute-sharesmb">sharesmb</a>       =&gt; <em># The sharesmb property. Valid values are `on`...</em>
  <a href="#zfs-attribute-snapdir">snapdir</a>        =&gt; <em># The snapdir property. Valid values are `hidden`, </em>
  <a href="#zfs-attribute-version">version</a>        =&gt; <em># The version property. Valid values are `1`, `2`, </em>
  <a href="#zfs-attribute-volsize">volsize</a>        =&gt; <em># The volsize property. Valid values are...</em>
  <a href="#zfs-attribute-vscan">vscan</a>          =&gt; <em># The vscan property. Valid values are `on`...</em>
  <a href="#zfs-attribute-xattr">xattr</a>          =&gt; <em># The xattr property. Valid values are `on`...</em>
  <a href="#zfs-attribute-zoned">zoned</a>          =&gt; <em># The zoned property. Valid values are `on`...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="zfs-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The full name for this filesystem (including the zpool).

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-aclinherit">aclinherit</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The aclinherit property. Valid values are `discard`, `noallow`, `restricted`, `passthrough`, `passthrough-x`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-aclmode">aclmode</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The aclmode property. Valid values are `discard`, `groupmask`, `passthrough`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-atime">atime</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The atime property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-canmount">canmount</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The canmount property. Valid values are `on`, `off`, `noauto`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-checksum">checksum</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The checksum property. Valid values are `on`, `off`, `fletcher2`, `fletcher4`, `sha256`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-compression">compression</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The compression property. Valid values are `on`, `off`, `lzjb`, `gzip`, `gzip-[1-9]`, `zle`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-copies">copies</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The copies property. Valid values are `1`, `2`, `3`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-dedup">dedup</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The dedup property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-devices">devices</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The devices property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-exec">exec</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The exec property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-logbias">logbias</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The logbias property. Valid values are `latency`, `throughput`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-mountpoint">mountpoint</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The mountpoint property. Valid values are `<path>`, `legacy`, `none`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-nbmand">nbmand</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The nbmand property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-primarycache">primarycache</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The primarycache property. Valid values are `all`, `none`, `metadata`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-quota">quota</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The quota property. Valid values are `<size>`, `none`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-readonly">readonly</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The readonly property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-recordsize">recordsize</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The recordsize property. Valid values are powers of two between 512 and 128k.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-refquota">refquota</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The refquota property. Valid values are `<size>`, `none`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-refreservation">refreservation</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The refreservation property. Valid values are `<size>`, `none`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-reservation">reservation</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The reservation property. Valid values are `<size>`, `none`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-secondarycache">secondarycache</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The secondarycache property. Valid values are `all`, `none`, `metadata`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-setuid">setuid</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The setuid property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-shareiscsi">shareiscsi</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The shareiscsi property. Valid values are `on`, `off`, `type=<type>`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-sharenfs">sharenfs</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The sharenfs property. Valid values are `on`, `off`, share(1M) options

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-sharesmb">sharesmb</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The sharesmb property. Valid values are `on`, `off`, sharemgr(1M) options

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-snapdir">snapdir</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The snapdir property. Valid values are `hidden`, `visible`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-version">version</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The version property. Valid values are `1`, `2`, `3`, `4`, `current`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-volsize">volsize</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The volsize property. Valid values are `<size>`

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-vscan">vscan</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The vscan property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-xattr">xattr</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The xattr property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))

<h4 id="zfs-attribute-zoned">zoned</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The zoned property. Valid values are `on`, `off`.

([↑ Back to zfs attributes](#zfs-attributes))


<h3 id="zfs-providers">Providers</h3>

<h4 id="zfs-provider-zfs">zfs</h4>

Provider for zfs.

* Required binaries: `zfs`




---------

zone
-----

* [Attributes](#zone-attributes)
* [Providers](#zone-providers)

<h3 id="zone-description">Description</h3>

Manages Solaris zones.

**Autorequires:** If Puppet is managing the directory specified as the root of
the zone's filesystem (with the `path` attribute), the zone resource will
autorequire that directory.

<h3 id="zone-attributes">Attributes</h3>

<pre><code>zone { 'resource title':
  <a href="#zone-attribute-name">name</a>         =&gt; <em># <strong>(namevar)</strong> The name of the...</em>
  <a href="#zone-attribute-ensure">ensure</a>       =&gt; <em># The running state of the zone.  The valid states </em>
  <a href="#zone-attribute-autoboot">autoboot</a>     =&gt; <em># Whether the zone should automatically boot....</em>
  <a href="#zone-attribute-clone">clone</a>        =&gt; <em># Instead of installing the zone, clone it from...</em>
  <a href="#zone-attribute-create_args">create_args</a>  =&gt; <em># Arguments to the `zonecfg` create command.  This </em>
  <a href="#zone-attribute-dataset">dataset</a>      =&gt; <em># The list of datasets delegated to the non-global </em>
  <a href="#zone-attribute-id">id</a>           =&gt; <em># The numerical ID of the zone.  This number is...</em>
  <a href="#zone-attribute-inherit">inherit</a>      =&gt; <em># The list of directories that the zone inherits...</em>
  <a href="#zone-attribute-install_args">install_args</a> =&gt; <em># Arguments to the `zoneadm` install command....</em>
  <a href="#zone-attribute-ip">ip</a>           =&gt; <em># The IP address of the zone.  IP addresses...</em>
  <a href="#zone-attribute-iptype">iptype</a>       =&gt; <em># The IP stack type of the zone.  Default...</em>
  <a href="#zone-attribute-path">path</a>         =&gt; <em># The root of the zone's filesystem.  Must be a...</em>
  <a href="#zone-attribute-pool">pool</a>         =&gt; <em># The resource pool for this...</em>
  <a href="#zone-attribute-realhostname">realhostname</a> =&gt; <em># The actual hostname of the...</em>
  <a href="#zone-attribute-shares">shares</a>       =&gt; <em># Number of FSS CPU shares allocated to the...</em>
  <a href="#zone-attribute-sysidcfg">sysidcfg</a>     =&gt; <em># %{The text to go into the `sysidcfg` file when...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="zone-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name of the zone.

([↑ Back to zone attributes](#zone-attributes))

<h4 id="zone-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The running state of the zone.  The valid states directly reflect
the states that `zoneadm` provides.  The states are linear,
in that a zone must be `configured`, then `installed`, and
only then can be `running`.  Note also that `halt` is currently
used to stop zones.

Default: `running`

([↑ Back to zone attributes](#zone-attributes))

<h4 id="zone-attribute-autoboot">autoboot</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Whether the zone should automatically boot.

Default: `true`

Allowed values:

* `true`
* `false`

([↑ Back to zone attributes](#zone-attributes))

<h4 id="zone-attribute-clone">clone</h4>

Instead of installing the zone, clone it from another zone.
If the zone root resides on a zfs file system, a snapshot will be
used to create the clone; if it resides on a ufs filesystem, a copy of the
zone will be used. The zone from which you clone must not be running.

([↑ Back to zone attributes](#zone-attributes))

<h4 id="zone-attribute-create_args">create_args</h4>

Arguments to the `zonecfg` create command.  This can be used to create branded zones.

([↑ Back to zone attributes](#zone-attributes))

<h4 id="zone-attribute-dataset">dataset</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The list of datasets delegated to the non-global zone from the
global zone.  All datasets must be zfs filesystem names which are
different from the mountpoint.

([↑ Back to zone attributes](#zone-attributes))

<h4 id="zone-attribute-id">id</h4>

The numerical ID of the zone.  This number is autogenerated
and cannot be changed.

([↑ Back to zone attributes](#zone-attributes))

<h4 id="zone-attribute-inherit">inherit</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The list of directories that the zone inherits from the global
zone.  All directories must be fully qualified.

([↑ Back to zone attributes](#zone-attributes))

<h4 id="zone-attribute-install_args">install_args</h4>

Arguments to the `zoneadm` install command.  This can be used to create branded zones.

([↑ Back to zone attributes](#zone-attributes))

<h4 id="zone-attribute-ip">ip</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The IP address of the zone.  IP addresses **must** be specified
with an interface, and may optionally be specified with a default router
(sometimes called a defrouter). The interface, IP address, and default
router should be separated by colons to form a complete IP address string.
For example: `bge0:192.168.178.200` would be a valid IP address string
without a default router, and `bge0:192.168.178.200:192.168.178.1` adds a
default router to it.

For zones with multiple interfaces, the value of this attribute should be
an array of IP address strings (each of which must include an interface
and may include a default router).

([↑ Back to zone attributes](#zone-attributes))

<h4 id="zone-attribute-iptype">iptype</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The IP stack type of the zone.

Default: `shared`

Allowed values:

* `shared`
* `exclusive`

([↑ Back to zone attributes](#zone-attributes))

<h4 id="zone-attribute-path">path</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The root of the zone's filesystem.  Must be a fully qualified
file name.  If you include `%s` in the path, then it will be
replaced with the zone's name.  Currently, you cannot use
Puppet to move a zone. Consequently this is a readonly property.

([↑ Back to zone attributes](#zone-attributes))

<h4 id="zone-attribute-pool">pool</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The resource pool for this zone.

([↑ Back to zone attributes](#zone-attributes))

<h4 id="zone-attribute-realhostname">realhostname</h4>

The actual hostname of the zone.

([↑ Back to zone attributes](#zone-attributes))

<h4 id="zone-attribute-shares">shares</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Number of FSS CPU shares allocated to the zone.

([↑ Back to zone attributes](#zone-attributes))

<h4 id="zone-attribute-sysidcfg">sysidcfg</h4>

%{The text to go into the `sysidcfg` file when the zone is first
booted.  The best way is to use a template:

    # $confdir/modules/site/templates/sysidcfg.erb
    system_locale=en_US
    timezone=GMT
    terminal=xterms
    security_policy=NONE
    root_password=<%= password %>
    timeserver=localhost
    name_service=DNS {domain_name=<%= domain %> name_server=<%= nameserver %>}
    network_interface=primary {hostname=<%= realhostname %>
      ip_address=<%= ip %>
      netmask=<%= netmask %>
      protocol_ipv6=no
      default_route=<%= defaultroute %>}
    nfs4_domain=dynamic

And then call that:

    zone { 'myzone':
      ip           => 'bge0:192.168.0.23',
      sysidcfg     => template('site/sysidcfg.erb'),
      path         => '/opt/zones/myzone',
      realhostname => 'fully.qualified.domain.name',
    }

The `sysidcfg` only matters on the first booting of the zone,
so Puppet only checks for it at that time.}

([↑ Back to zone attributes](#zone-attributes))


<h3 id="zone-providers">Providers</h3>

<h4 id="zone-provider-solaris">solaris</h4>

Provider for Solaris Zones.

* Required binaries: `/usr/sbin/zoneadm`, `/usr/sbin/zonecfg`
* Default for: `["osfamily", "solaris"] == `




---------

zpool
-----

* [Attributes](#zpool-attributes)
* [Providers](#zpool-providers)

<h3 id="zpool-description">Description</h3>

Manage zpools. Create and delete zpools. The provider WILL NOT SYNC, only report differences.

Supports vdevs with mirrors, raidz, logs and spares.

<h3 id="zpool-attributes">Attributes</h3>

<pre><code>zpool { 'resource title':
  <a href="#zpool-attribute-pool">pool</a>        =&gt; <em># <strong>(namevar)</strong> The name for this...</em>
  <a href="#zpool-attribute-ensure">ensure</a>      =&gt; <em># The basic property that the resource should be...</em>
  <a href="#zpool-attribute-disk">disk</a>        =&gt; <em># The disk(s) for this pool. Can be an array or a...</em>
  <a href="#zpool-attribute-log">log</a>         =&gt; <em># Log disks for this pool. This type does not...</em>
  <a href="#zpool-attribute-mirror">mirror</a>      =&gt; <em># List of all the devices to mirror for this pool. </em>
  <a href="#zpool-attribute-raid_parity">raid_parity</a> =&gt; <em># Determines parity when using the `raidz...</em>
  <a href="#zpool-attribute-raidz">raidz</a>       =&gt; <em># List of all the devices to raid for this pool...</em>
  <a href="#zpool-attribute-spare">spare</a>       =&gt; <em># Spare disk(s) for this...</em>
  # ...plus any applicable <a href="{{puppet}}/metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="zpool-attribute-pool">pool</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name for this pool.

([↑ Back to zpool attributes](#zpool-attributes))

<h4 id="zpool-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Default: `present`

Allowed values:

* `present`
* `absent`

([↑ Back to zpool attributes](#zpool-attributes))

<h4 id="zpool-attribute-disk">disk</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The disk(s) for this pool. Can be an array or a space separated string.

([↑ Back to zpool attributes](#zpool-attributes))

<h4 id="zpool-attribute-log">log</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Log disks for this pool. This type does not currently support mirroring of log disks.

([↑ Back to zpool attributes](#zpool-attributes))

<h4 id="zpool-attribute-mirror">mirror</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

List of all the devices to mirror for this pool. Each mirror should be a
space separated string:

    mirror => [\"disk1 disk2\", \"disk3 disk4\"],

([↑ Back to zpool attributes](#zpool-attributes))

<h4 id="zpool-attribute-raid_parity">raid_parity</h4>

Determines parity when using the `raidz` parameter.

([↑ Back to zpool attributes](#zpool-attributes))

<h4 id="zpool-attribute-raidz">raidz</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

List of all the devices to raid for this pool. Should be an array of
space separated strings:

    raidz => [\"disk1 disk2\", \"disk3 disk4\"],

([↑ Back to zpool attributes](#zpool-attributes))

<h4 id="zpool-attribute-spare">spare</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

Spare disk(s) for this pool.

([↑ Back to zpool attributes](#zpool-attributes))


<h3 id="zpool-providers">Providers</h3>

<h4 id="zpool-provider-zpool">zpool</h4>

Provider for zpool.

* Required binaries: `zpool`




> **NOTE:** This page was generated from the Puppet source code on 2017-10-04 17:17:52 -0700