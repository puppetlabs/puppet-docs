---
layout: default
built_from_commit: edd3c04ba4892bd59ab1cac02f44d74c9d432ca8
title: 'Resource Type: cron'
canonical: "/puppet/latest/types/cron.html"
---

> **NOTE:** This page was generated from the Puppet source code on 2018-02-14 15:11:50 -0800

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
cron resource that has never been synced, Puppet will defer to the existing
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
  <a href="#cron-attribute-provider">provider</a>    =&gt; <em># The specific backend to use for this `cron...</em>
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

Valid values are `present`, `absent`.

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

<h4 id="cron-attribute-provider">provider</h4>

The specific backend to use for this `cron`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`crontab`](#cron-provider-crontab)

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

* Required binaries: `crontab`.




> **NOTE:** This page was generated from the Puppet source code on 2018-02-14 15:11:50 -0800