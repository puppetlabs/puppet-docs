schedule
========

Determine when Puppet runs

* * *

About
-----

Defined schedules for Puppet. The important thing to understand
about how schedules are currently implemented in Puppet is that
they can only be used to stop a resource from being applied, they
never guarantee that it is applied.

Every time Puppet applies its configuration, it will collect the
list of resources whose schedule does not eliminate them from
running right then, but there is currently no system in place to
guarantee that a given resource runs at a given time. If you
specify a very restrictive schedule and Puppet happens to run at a
time within that schedule, then the resources will get applied;
otherwise, that work may never get done.

Thus, it behooves you to use wider scheduling (e.g., over a couple
of hours) combined with periods and repetitions. For instance, if
you wanted to restrict certain resources to only running once,
between the hours of two and 4 AM, then you would use this
schedule:

    schedule { maint:
        range => "2 - 4",
        period => daily,
        repeat => 1
    }

With this schedule, the first time that Puppet runs between 2 and 4
AM, all resources with this schedule will get applied, but they
won't get applied again between 2 and 4 because they will have
already run once that day, and they won't get applied outside that
schedule because they will be outside the scheduled range.

Puppet automatically creates a schedule for each valid period with
the same name as that period (e.g., hourly and daily).
Additionally, a schedule named *puppet* is created and used as the
default, with the following attributes:

    schedule { puppet:
        period => hourly,
        repeat => 2
    }

This will cause resources to be applied every 30 minutes by
default.

Parameters
----------

## name

-   **namevar**

The name of the schedule. This name is used to retrieve the
schedule when assigning it to an object:

    schedule { daily:
        period => daily,
        range => [2, 4]
    }
    
    exec { "/usr/bin/apt-get update":
        schedule => daily
    }

## period

The period of repetition for a resource. Choose from among a fixed
list of *hourly*, *daily*, *weekly*, and *monthly*. The default is
for a resource to get applied every time that Puppet runs, whatever
that period is.

Note that the period defines how often a given resource will get
applied but not when; if you would like to restrict the hours that
a given resource can be applied (e.g., only at night during a
maintenance window) then use the `range` attribute.

If the provided periods are not sufficient, you can provide a value
to the *repeat* attribute, which will cause Puppet to schedule the
affected resources evenly in the period the specified number of
times. Take this schedule:

    schedule { veryoften:
        period => hourly,
        repeat => 6
    }

This can cause Puppet to apply that resource up to every 10
minutes.

At the moment, Puppet cannot guarantee that level of repetition;
that is, it can run up to every 10 minutes, but internal factors
might prevent it from actually running that often (e.g.,
long-running Puppet runs will squash conflictingly scheduled
runs).

See the `periodmatch` attribute for tuning whether to match times
by their distance apart or by their specific value. Valid values
are `hourly`, `daily`, `weekly`, `monthly`, `never`.

## periodmatch

Whether periods should be matched by number (e.g., the two times
are in the same hour) or by distance (e.g., the two times are 60
minutes apart). Valid values are `number`, `distance`.

## range

The earliest and latest that a resource can be applied. This is
always a range within a 24 hour period, and hours must be specified
in numbers between 0 and 23, inclusive. Minutes and seconds can be
provided, using the normal colon as a separator. For instance:

    schedule { maintenance:
        range => "1:30 - 4:30"
    }

This is mostly useful for restricting certain resources to being
applied in maintenance windows or during off-peak hours.

## repeat

How often the application gets repeated in a given period. Defaults
to 1. Must be an integer.


* * * * *

