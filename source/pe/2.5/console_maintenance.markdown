---
layout: default
title: "PE 2.5 » Console » Console Maintenance"
subtitle: "Console Maintenance"
canonical: "/pe/latest/maintain_console-db.html"
---

If PE's console becomes sluggish or begins taking up too much space on disk, there are several maintenance tasks that can improve its performance. 

Restarting the Background Tasks
-----

The console uses several worker processes to process reports in the background, and it displays a running count of pending tasks in the upper left corner of the interface:

![The background tasks box with one pending task][maint_pending_task]

[maint_pending_task]: ./images/console/maint_pending_task.png

If the number of pending tasks appears to be growing linearly, the background task processes may have died and left invalid PID files. To restart the worker tasks, run:

    $ sudo /etc/init.d/pe-puppet-dashboard-workers restart

The number of pending tasks shown in the console should start decreasing rapidly after restarting the workers. 


Optimizing the Database
-----

Since the console turns over a lot of data, you can improve its speed and disk consumption by periodically optimizing its MySQL database with the `db:raw:optimize` task.

    $ sudo /opt/puppet/bin/rake \
    -f /opt/puppet/share/puppet-dashboard/Rakefile \
    RAILS_ENV=production \
    db:raw:optimize

If you find you need to optimize the database, we recommend that you do so with a monthly cron job.

Cleaning Old Reports
----------------

Agent node reports will build up over time in the console's database. If you wish to delete the oldest reports, for performance, storage, or policy reasons, you can use the `reports:prune` rake task.

For example, to delete reports more than one month old:

    $ sudo /opt/puppet/bin/rake \
    -f /opt/puppet/share/puppet-dashboard/Rakefile \
    RAILS_ENV=production \
    reports:prune upto=1 unit=mon

Although this task **should be run regularly as a cron job,** the frequency with which it should be run will depend on your site's policies.

If you run the `reports:prune` task without any arguments, it will display further usage instructions. The available units of time are `mon`, `yr`, `day`, `min`, `wk`, and `hr`.


Database backups
----------------

Although you can back up and restore the console's database with any standard MySQL tools, the `db:raw:dump` and `db:raw:restore` rake tasks can simplify the process. 

### Dumping the Database

To dump the console's `production` database to a file called `production.sql`:

    $ sudo /opt/puppet/bin/rake \
    -f /opt/puppet/share/puppet-dashboard/Rakefile \
    RAILS_ENV=production \
    db:raw:dump

Or dump it to a specific file:

    $ sudo /opt/puppet/bin/rake \
    -f /opt/puppet/share/puppet-dashboard/Rakefile \
    RAILS_ENV=production \
    FILE=/my/backup/file.sql db:raw:dump

### Restoring the Database

To restore the console's database from a file called `production.sql` to your `production` environment:

    $ sudo /opt/puppet/bin/rake \
    -f /opt/puppet/share/puppet-dashboard/Rakefile \
    RAILS_ENV=production \
    FILE=production.sql db:raw:restore


* * * 

- [Next: Puppet Overview](./puppet_overview.html) 
