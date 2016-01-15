---
layout: default
built_from_commit: c0673af42427fbe0b22ff97c8e5fa3244715eeae
title: 'Resource Type: scheduled_task'
canonical: /puppet/latest/reference/types/scheduled_task.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-01-15 16:31:56 +0100

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
  <a href="#scheduled_task-attribute-provider">provider</a>    =&gt; <em># The specific backend to use for this...</em>
  <a href="#scheduled_task-attribute-trigger">trigger</a>     =&gt; <em># One or more triggers defining when the task...</em>
  <a href="#scheduled_task-attribute-user">user</a>        =&gt; <em># The user to run the scheduled task as.  Please...</em>
  <a href="#scheduled_task-attribute-working_dir">working_dir</a> =&gt; <em># The full path of the directory in which to start </em>
  # ...plus any applicable <a href="./metaparameter.html">metaparameters</a>.
}</code></pre>

<h4 id="scheduled_task-attribute-name">name</h4>

_(**Namevar:** If omitted, this attribute's value defaults to the resource's title.)_

The name assigned to the scheduled task.  This will uniquely
identify the task on the system.

([↑ Back to scheduled_task attributes](#scheduled_task-attributes))

<h4 id="scheduled_task-attribute-ensure">ensure</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The basic property that the resource should be in.

Valid values are `present`, `absent`.

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

Valid values are `true`, `false`.

([↑ Back to scheduled_task attributes](#scheduled_task-attributes))

<h4 id="scheduled_task-attribute-password">password</h4>

The password for the user specified in the 'user' attribute.
This is only used if specifying a user other than 'SYSTEM'.
Since there is no way to retrieve the password used to set the
account information for a task, this parameter will not be used
to determine if a scheduled task is in sync or not.

([↑ Back to scheduled_task attributes](#scheduled_task-attributes))

<h4 id="scheduled_task-attribute-provider">provider</h4>

The specific backend to use for this `scheduled_task`
resource. You will seldom need to specify this --- Puppet will usually
discover the appropriate provider for your platform.

Available providers are:

* [`win32_taskscheduler`](#scheduled_task-provider-win32_taskscheduler)

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
      as an array. Each day must beeither an integer between 1 and 31,
      or the special value `last,` which is always the last day of the month.
* For `monthly` (by weekday) triggers:
    * `months` --- Which months the task should run, as an array. Defaults to
      all months. Each month must be an integer between 1 and 12.
    * `day_of_week` **(Required)** --- Which day of the week the task should
      run, as an array with only one element. Each day must be one of `mon`,
      `tues`, `wed`, `thurs`, `fri`, `sat`, `sun`, or `all`.
    * `which_occurrence` **(Required)** --- The occurrence of the chosen weekday
      when the task should run. Must be one of `first`, `second`, `third`,
      `fourth`, `fifth`, or `last`.


Examples:

    # Run at 8am on the 1st, 15th, and last day of the month in January, March,
    # May, July, September, and November, starting after August 31st, 2011.
    trigger => {
      schedule   => monthly,
      start_date => '2011-08-31',   # Defaults to current date
      start_time => '08:00',        # Must be specified
      months     => [1,3,5,7,9,11], # Defaults to all
      on         => [1, 15, last],  # Must be specified
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

([↑ Back to scheduled_task attributes](#scheduled_task-attributes))

<h4 id="scheduled_task-attribute-working_dir">working_dir</h4>

_(**Property:** This attribute represents concrete state on the target system.)_

The full path of the directory in which to start the command.

([↑ Back to scheduled_task attributes](#scheduled_task-attributes))


<h3 id="scheduled_task-providers">Providers</h3>

<h4 id="scheduled_task-provider-win32_taskscheduler">win32_taskscheduler</h4>

This provider manages scheduled tasks on Windows.

* Default for `operatingsystem` == `windows`.




> **NOTE:** This page was generated from the Puppet source code on 2016-01-15 16:31:56 +0100