---
layout: default
title: "Resource tips and examples: Scheduled task on Windows"
toc: false
---

[scheduledtask]: ./type.html#scheduledtask

Puppet can create, edit, and delete scheduled tasks, which are a Windows-only resource type.

Puppet can manage the task name, the enabled/disabled status, the command, any arguments, the working directory, the user and password, and triggers. A complete scheduled task resource looks something like this:

``` puppet
scheduled_task { 'An every-other-day task':
  ensure    => present,
  enabled   => true,
  command   => 'C:\path\to\command.exe',
  arguments => '/flags /to /pass',
  trigger   => {
    schedule   => daily,
    every      => 2,            # Specifies every other day. Defaults to 1 (every day).
    start_date => '2011-08-31', # Defaults to 'today'
    start_time => '08:00',      # Must be specified
    minutes_interval => '60',   # Repeat this task every 60 minutes
    minutes_duration => '300',  # The task will run for a total of five hours
  }
}
```

For more information, see [the reference documentation for the `scheduled_task` type][scheduledtask].

## Errata

### Known issues prior to Puppet 3.8.0

Puppet did not support "every X minutes" type triggers.