---
layout: default
title: "Dashboard Manual: Maintaining"
---

Maintaining Puppet Dashboard
=====

This is a chapter of the [Puppet Dashboard 1.2 manual](./index.html).

#### Navigation

* [Bootstrapping Dashboard](./bootstrapping.html)
* [Upgrading Dashboard](./upgrading.html)
* [Configuring Dashboard](./configuring.html)
* **Maintaining Dashboard**
* [Using Dashboard](./using.html)

* * * 

Overview
--------

Puppet Dashboard exposes most of its functionality through its web UI, but it has a number of routine tasks that have to be performed on the command line by an admin. This chapter is a brief tour of some of these tasks.

Importing Pre-existing Reports
-----

If your puppet master has stored a large number of reports from before your Dashboard came online, you can import them into Dashboard to get a better view into your site's history. If you are running Dashboard on the same server as your puppet master and its reports are stored in `/var/puppet/lib/reports`, you can simply run:

    rake RAILS_ENV=production reports:import

Alternately, you can copy the reports to your Dashboard server and run:

    rake RAILS_ENV=production reports:import REPORT_DIR=/path/to/your/reports

**Note that this task can take a very long time,** depending on the number of reports to be imported. You can, however, safely interrupt and re-run the task, as the importer will automatically skip reports that Dashboard has already imported. 

Cleaning Old Reports
----------------

Reports will build up over time, which can slow Dashboard down. If you wish to delete the oldest reports, for performance, storage, or policy reasons, you can use the `reports:prune` rake task. 

For example, to delete reports older than 1 month:

    rake RAILS_ENV=production reports:prune upto=1 unit=mon

If you run 'rake reports:prune' without any arguments, it will display further usage instructions.

Reading Logs
---------

Dashboard may fail to start or display warnings if it is misconfigured or encounters an error. Details about these errors are recorded to log files that will help diagnose and resolve the problem.

You can find the logs in Dashboard's `log/` directory. You can customize your log rotation in `config/environment.rb` to devote more or less disk space to them.

If you're running Dashboard using Apache and Phusion Passenger, the Apache logs will contain higher-level information, such as severe errors that prevent Passenger from starting the application. 

Database backups
----------------

Although you can back up and restore Dashboard's database with any tools, there are a pair of rake tasks which simplify the process. 

### Dumping the Database

To dump the Puppet Dashboard `production` database to a file called `production.sql`:

    rake RAILS_ENV=production db:raw:dump

Or dump it to a specific file:

    rake RAILS_ENV=production FILE=/my/backup/file.sql db:raw:dump

### Restoring the Database

To restore the Puppet Dashboard from a file called `production.sql` to your `production` environment:

    rake RAILS_ENV=production FILE=production.sql db:raw:restore


* * * 

#### Navigation

* [Bootstrapping Dashboard](./bootstrapping.html)
* [Upgrading Dashboard](./upgrading.html)
* [Configuring Dashboard](./configuring.html)
* **Maintaining Dashboard**
* [Using Dashboard](./using.html)
