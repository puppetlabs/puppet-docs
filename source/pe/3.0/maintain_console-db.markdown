---
layout: default
title: "PE 3.0 » Maintenance » Console"
subtitle: "Maintaining the Console & Databases"
canonical: "/pe/latest/maintain_console-db.html"
---


If PE's console becomes sluggish or begins taking up too much disk space, there are several maintenance tasks that can improve its performance. 

Restarting the Background Tasks
-----

The console uses several worker services to process reports in the background, and it displays a running count of pending tasks in the upper left corner of the interface:

![The background tasks box with one pending task][maint_pending_task]

[maint_pending_task]: ./images/console/maint_pending_task.png

If the number of pending tasks appears to be growing linearly, the background task processes may have died and left invalid PID files. To restart the worker tasks, run:

    $ sudo /etc/init.d/pe-puppet-dashboard-workers restart

The number of pending tasks shown in the console should start decreasing rapidly after restarting the workers. 


Optimizing the Database
-----

PostgreSQL should have `autovacuum=on` set by default. If you're having issues with the database growing too large and unwieldy, make sure this setting did not get turned off. In most cases, this should suffice. In some cases, more heavyweight maintenance measures may be needed (e.g. in cases of data corruption from hardware failures). To help with this, PE provides a rake task that performs advanced database maintenance.

This task, `rake db:raw:optimize[mode]`,  runs in three modes:

  * `reindex` mode will run the REINDEX DATABASE command on the console database.
  * `vacuum` model will run the VACUUM FULL command on the console database.
    * Please note that this requires free space roughly equivalent to the current size of the database on disk.
  * `reindex+vacuum` will run both of the above commands on the console database. This is also the default mode if no mode is specified.

To run the task, change your working directory to `/opt/puppet/share/puppet-dashboard` and make sure your PATH variable contains `/opt/puppet/bin` (or use the full path to the rake binary). Then run the task `rake db:raw:optimize[mode]`. You can disregard any error messages about insufficient privileges to vacuum certain system objects because these objects should not require vacuuming. If you believe they do, you can do so manually by logging in to psql (or your tool of choice) as a database superuser.

The PostgreSQL docs contain more detailed information about [vacuuming](http://www.postgresql.org/docs/9.2/static/routine-vacuuming.html) and [reindexing](http://www.postgresql.org/docs/9.2/static/sql-reindex.html).


Cleaning Old Reports
----------------

Agent node reports will build up over time in the console's database. If you wish to delete the oldest reports for performance, storage, or policy reasons, you can use the `reports:prune` rake task.

For example, to delete reports more than one month old:

    $ sudo /opt/puppet/bin/rake \
    -f /opt/puppet/share/puppet-dashboard/Rakefile \
    RAILS_ENV=production \
    reports:prune upto=1 unit=mon

Although this task **should be run regularly as a cron job,** the actual frequency at which you set it to run will depend on your site's policies.

If you run the `reports:prune` task without any arguments, it will display further usage instructions. The available units of time are `mon`, `yr`, `day`, `min`, `wk`, and `hr`.


Database backups
----------------

You can back up and restore the console's database using the standard [PostgreSQL tool, `pg dump`](http://www.postgresql.org/docs/9.2/static/app-pgdump.html). Best practices recommend hourly local backups and backups to a remote system nightly for the `console`, `console_auth` and `puppetdb` databases, or as dictated by your company policy.

The easiest way to gain access to the PE-configured PostgreSQL database is to use the `pe-postgres` user, via `su - pe-postgres -s '/bin/bash'`. All PostgreSQL-related command should succeed as that user.

Changing the Console's Database User/Password
-----

The console uses a database user account to access its PostgreSQL database. If this user's password is compromised, or if it needs to be changed periodically, do the following:

1. Stop the `pe-httpd` service on the console server:

        $ sudo /etc/init.d/pe-httpd stop
2. On the database server (which may or may not be the same as the console, depending on your deployment's architecture) use the PostgreSQL administration tool of your choice to change the user's password. With the standard `psql` client, you can do this with:

        ALTER USER console PASSWORD '<new password>';
3. Edit `/etc/puppetlabs/puppet-dashboard/database.yml` on the console server and change the `password:` line under "common" (or under "production," depending on your configuration) to contain the new password.
4. Start the `pe-httpd` service on the console server:

        $ sudo /etc/init.d/pe-httpd start
        
You will use the same procedure to change the console_auth database user's password, except you will need to edit both the `/opt/puppet/share/console-auth/db/database.yml` and `/opt/puppet/share/rubycas-server/config.yml` files.

The same procedure is also used for the PuppetDB user's password, except you'll edit `/etc/puppetlabs/puppetdb/conf.d/database.ini` and will restart the `pe-puppetdb` service.



* * * 

- [Next: Troubleshooting the Installer](./trouble_install.html) 
