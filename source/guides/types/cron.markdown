cron
====

Installs and manages cron jobs.

* * *

Requirements
------------

* A `crontab` executable.

Platforms
---------

Supported on any platform with `crontab`.

Examples
--------

    cron { logrotate:
        command => "/usr/sbin/logrotate",
        user => root,
        hour => 2,
        minute => 0
    }

Note that all cron values can be specified as an array of values:

    cron { logrotate:
        command => "/usr/sbin/logrotate",
        user => root,
        hour => [2, 4]
    }

Or using ranges, or the step syntax `*/2` (although there's no
guarantee that your `cron` daemon supports it):

    cron { logrotate:
        command => "/usr/sbin/logrotate",
        user => root,
        hour => ['2-4'],
        minute => '*/10'
    }


Parameters
----------

All fields except the command and
the user are optional, although specifying no periodic fields would
result in the command being executed every minute. While the name
of the cron job is not part of the actual job, it is used by Puppet
to store and retrieve it.

If you specify a cron job that matches an existing job in every way
except name, then the jobs will be considered equivalent and the
new name will be permanently associated with that job. Once this
association is made and synced to disk, you can then manage the job
normally (e.g., change the schedule of the job).

### `command`

The command to execute in the cron job. The environment provided to
the command varies by local system rules, and it is best to always
provide a fully qualified command. The user's profile is not
sourced when the command is run, so if the user's environment is
desired it should be sourced manually.

All cron parameters support `absent` as a value; this will remove
any existing values for that field.

### `ensure`

The basic property that the resource should be in. Valid values are
`present`, `absent`.

### `environment`

Any environment settings associated with this cron job. They will
be stored between the header and the job in the crontab. There can
be no guarantees that other, earlier settings will not also affect
a given cron job.

Also, Puppet cannot automatically determine whether an existing,
unmanaged environment setting is associated with a given cron job.
If you already have cron jobs with environment settings, then
Puppet will keep those settings in the same place in the file, but
will not associate them with a specific job.

Settings should be specified exactly as they should appear in the
crontab, e.g., `PATH=/bin:/usr/bin:/usr/sbin`.

### `hour`

The hour at which to run the cron job. Optional; if specified, must
be between `0` and `23`, inclusive.

### `minute`

The minute at which to run the cron job. Optional; if specified,
must be between `0` and `59`, inclusive.

### `month`

The month of the year. Optional; if specified must be between `1` and
`12` or the month name (e.g., `December`).

### `monthday`

The day of the month on which to run the command. Optional; if
specified, must be between `1` and `31`.

### `name`

The symbolic name of the cron job. This name is used for human
reference only and is generated automatically for cron jobs found
on the system. This generally won't matter, as Puppet will do its
best to match existing cron jobs against specified jobs (and Puppet
adds a comment to cron jobs it adds), but it is at least possible
that converting from unmanaged jobs to managed jobs might require
manual intervention.

INFO: This is the `namevar` for this resource type.

### `provider`

The specific backend for provider to use. You will seldom need to
specify this -- Puppet will usually discover the appropriate
provider for your platform. Available providers are:

#### `crontab`

Required binaries:

* `crontab`

### `special`

Special schedules.

NOTE: Only supported on FreeBSD.

### `target`

Where the cron job should be stored. For crontab-style entries this
is the same as the user and defaults that way. Other providers
default accordingly.

### `user`

The user to run the command as. This user must be allowed to run
cron jobs, which is not currently checked by Puppet.

The user defaults to whomever Puppet is running as.

### `weekday`

The weekday on which to run the command. Optional; if specified,
must be between `0` and `7`, inclusive, with `0` (or `7`) being Sunday, or
must be the name of the day (e.g., `Tuesday`).
