---
layout: default
title: "Baseline Plugin: Internals"
---

Puppet Dashboard Baseline Plugin --- Internals
====

This chapter contains information about the way the baseline plugin performs its comparisons, and about installing the plugin from source. 

* * * 

The Baseline Maintenance Task
--------

The baseline plugin ships with a rake task (`plugin:puppet:baseline:daily`) that should be run at least daily and preferably closer to hourly. This task:

* Constructs and queues daily comparison jobs, for consumption by Dashboard's `delayed_job` workers (see "Daily Comparisons" below). 
* Modifies node baselines to include any changes that were approved by an admin.
* Creates new baselines for any nodes which don't yet have them. <!-- Anything else I'm forgetting? -->

The package you installed the plugin with should have instated this task as an hourly cron job. 

Daily Comparisons
--------

Dashboard doesn't compare inspections against baselines continuously. It makes a single comparison for each node for each day, and there isn't a one-to-one correspondence between runs of the maintenance task and new sets of difference reports. 

Every time the maintenance task is run, it checks whether baseline comparisons exist yet for every node on recent days. <!-- is there a 7-day limit? --> For each node lacking a comparison, it checks whether any inspection reports arrived during that day; if any did, it picks the latest report of that day and queues up a comparison with the current baseline. 

This means that:

* The maintenance task is idempotent, and can be run as often as you like --- if a node already has a baseline comparison for a given day, it won't create a new one for that day.
* The current day's baseline comparisons will arrive in batches throughout the day if your nodes' puppet inspect runs are staggered and you're running the maintenance task frequently. 

Note that the time marking a new day is configurable as `baseline_day_end` in Dashboard's `config/settings.yml` file. 

Installing the Plugin From Source
-----

This information should only be relevant to developers working on the baseline plugin, and is included here for reasons of completeness.

All prerequisites mentioned in the [bootstrapping chapter](./pb_bootstrapping.html) still apply. To install the baseline plugin from source, clone the module repository into Dashboard's `vendor/plugins` directory as `puppet_baseline`.

    # git clone git@github.com:puppetlabs/dashboard-module-baseline.git puppet_baseline

Chown all files in the repo to the Dashboard user.

    # chown -R puppet-dashboard:puppet-dashboard puppet_baseline

Run the `puppet:plugin:install` rake task as the Dashboard user, passing the
module name as an environment variable.

    sudo -u puppet-dashboard rake puppet:plugin:install PLUGIN=puppet_baseline RAILS_ENV=production

Run `db:migrate` additional times for any additional environments you're using. Then, establish an at-least-daily cron job for running the `puppet:plugin:baseline:daily` rake task with your preferred `RAILS_ENV` value(s). Use the `ext/baseline_plugin_watchdog.sh` file provided with the plugin source, and modify the `DASHBOARD_ROOT` directory if needed; we recommend that this task be put in `/etc/cron.hourly/`.
