---
layout: default
title: Dashboard Manual—2—Upgrading
---

[dbbackups]: <# Link to backups anchor in maintaining page #>

Upgrading Puppet Dashboard
========

Overview
--------

Upgrading Dashboard from a previous version generally consists of the following:

* Stopping the webserver
* Upgrading the Dashboard code itself
* Running any new database migrations
* Restarting the webserver

In addition, there are several tasks you must take into account when upgrading from certain versions. 

Upgrading Code
--------------

### From Packages

<# Undefined. Talk to Mike. #>

### From Git

First, make sure that the `.git` directory and `.gitignore` file are both owned by the Dashboard user:

    # chown -R puppet-dashboard:puppet-dashboard .git*

All subsequent commands will be run as the Dashboard user via sudo, in order to avoid permissions problems. 

Next, fetch data from the remote repository:

    # sudo -u puppet-dashboard git fetch origin

Before checking out the new release, make sure that you haven't made any changes that would be overwritten:

    # sudo -u puppet-dashboard git status

Dashboard's `.gitignore` file should ensure that your configuration files, certificates, temp files, and logs will be untouched by the upgrade, but if the status command shows any new or modified files, you'll need to preserve them. You could just copy them outside the directory, but the easiest path is to use git stash:

    # sudo -u puppet-dashboard git add {list of modified files}
    # sudo -u puppet-dashboard git stash save "Modified files prior to 1.2.0 upgrade"

After that, you're clear to upgrade:
    # sudo -u puppet-dashboard git checkout v1.2.0

(And if you had to stash any edits, you can now apply them:

    # sudo -u puppet-dashboard git stash apply

If they don't apply cleanly, you can abort the commit with `git reset --hard HEAD`, or [read up][mergeconflict] on how to resolve Git merge conflicts.)

[^mergeconflict]: http://book.git-scm.com/3_basic_branching_and_merging.html

### From Tarballs

If you originally installed Dashboard from a source tarball, you'll need to either pick out all of your modified or created files and transplant them into the new installation, or convert your installation to Git; either way, you should back up the entire installation first.

To convert an existing Dashboard installation to a Git repo, do something like the following, replacing {version tag} with the version of Dashboard you originally installed: 

    git init
    rm .gitignore
    wget https://raw.github.com/puppetlabs/puppet-dashboard/{version tag}/.gitignore
    git add .
    git commit -m "conversion commit"
    git branch original
    git remote add upstream git://github.com/puppetlabs/puppet-dashboard.git
    git fetch upstream
    git reset --hard tags/{version tag}
    git merge --no-ff original
    git reset --soft tags/{version tag}
    git stash save "Non-ignored files which were changed after the original installation."
    git checkout tags/v1.2.0
    git stash apply


Running Database Migrations
---------------------------

Puppet Dashboard's database schema changes as features are added and improved, and it needs to be updated after an upgrade. You may want to backup your database before you do this --- see the [database backups][dbbackups] section of this manual for further details.

DB migrations are done with a rake task, and should be automatic and painless between any two official releases of Dashboard.

    # rake db:migrate RAILS_ENV=production 

You'll need to run `db:migrate` once for each environment you use. (And the `db:migrate` task can be safely run multiple times in the same environment, so don't worry about accidentally doing it twice in production.)

After upgrading the code and the database, be sure to restart Dashboard's webserver.


Upgrading From Versions Prior to 1.2.0
--------------------------------------

For reasons of speed and scalability, Dashboard 1.2 introduced a delayed job processing system. Dashboard won't lose any data sent by puppet masters if you don't run these delayed jobs, but they're necessary for analyzing reports and keeping the web UI up-to-date. You'll need to configure and run at least one worker process, and we recommend running exactly one process per CPU core.

Currently, the best way to manage these processes is with the `script/delayed_job` command, which can daemonize as a supervisor process and manage the requested number of workers. To start four workers and the monitor process:

    # env RAILS_ENV=production script/delayed_job -p dashboard -n 4 -m start

See [the delayed jobs section](<# link to anchor in bootstrap page #>) of the bootstrapping chapter for more information.

Upgrading From Versions Prior to 1.1.0
--------------------------------------

In version 1.1.0, Dashboard changed the way it stores reports, and any reports from the 1.0.x series will have to be converted before they can be displayed or analyzed by the new version. 

Since this can potentially take a long time, depending on your installation's report history, it isn't performed when running `rake db:migrate`. Instead, you should run:

    # rake reports:schematize RAILS_ENV=production

This task will convert the most recent reports first, and if it is interrupted, it can be resumed by just re-running the command. 

