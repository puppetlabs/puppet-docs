---
layout: default
built_from_commit: 569f28bea57644ed05719c92ecf19fcc532111aa
title: 'Resource Type: schedule'
canonical: /puppet/latest/reference/types/schedule.html
---

> **NOTE:** This page was generated from the Puppet source code on 2016-09-22 14:45:05 -0700

schedule
-----

* [Attributes](#schedule-attributes)

<h3 id="schedule-description">Description</h3>

Define schedules for Puppet. Resources can be limited to a schedule by using the
[`schedule`](https://docs.puppetlabs.com/puppet/latest/reference/metaparameter.html#schedule)
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

Valid values are `hourly`, `daily`, `weekly`, `monthly`, `never`.

([↑ Back to schedule attributes](#schedule-attributes))

<h4 id="schedule-attribute-periodmatch">periodmatch</h4>

Whether periods should be matched by number (e.g., the two times
are in the same hour) or by distance (e.g., the two times are
60 minutes apart).

Valid values are `number`, `distance`.

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





> **NOTE:** This page was generated from the Puppet source code on 2016-09-22 14:45:05 -0700