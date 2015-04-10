---
layout: default
title: "PE 3.8 » Troubleshooting » Troubleshooting the Console & Database "
subtitle: "Finding Common Problems"
canonical: "/pe/latest/trouble_console-db.html"
---

Below are some common issues that can cause trouble with the databases that support the console.

**Note:** If you will be using your own instance of PostgreSQL (as opposed to the instance PE can install) for the console and PuppetDB, it must be version 9.1 or higher.


Disabling/Enabling Live Management
-------

Live Management is deprecated in PE 3.8 and will be replaced by improved resource management functionality in future releases. For this reason, Live Management is not enabled by default as in previous versions of PE, but you can configure your installation to enable it. Live Management can be disabled/enabled during [upgrades][install_upgrade] or during [normal operations][normal_operations].

[install_upgrading]: ./install_upgrading.html#disabling/enabling-live-management-during-an-upgrade
[normal_operations]: ./console_navigating_live_mgmt.html#disabling/enabling-live-management

Using curl to Troubleshoot Classification Info in the PE Console
--------


In past versions, you could run an external node script to reach the PE console node classifier (NC) to troubleshoot node and group classification information in the console. Due to changes in console authentication, that external node script was removed. However, you can now curl the console to troubleshoot the NC. Consider the following examples:

#### Determine what node groups the NC has and what data they contain

Execute the following curl command from the Puppet master (monolithic install) or from the PE console (split install):

    curl \
    --cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem \
    --cert /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem \
    --key /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem \
    https://$(hostname -f):4433/classifier-api/v1/groups > classifier_groups.json

This will generate a file called `classifier_groups.json`. The JSON file is described in the [groups portion](./nc_groups.html#get-v1groups) of the NC API docs.

#### Determine what data the NC will generate for a given node name

**NOTE**: In the examples below replace `<SOME NODE NAME>` with the FQDN of the node you are interested in.

Execute the following curl command from the Puppet master (monolithic install) or from the PE console (split install):

     curl -X POST -H 'Content-Type: application/json' \
     --cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem \
     --cert /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem \
     --key /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem \
     https://$(hostname -f):4433/classifier-api/v1/classified/nodes/<SOME NODE NAME> > node_classification.json

This will generate a file called `node_classification.json`. The JSON file is described in the [classificatiopn portion](./nc_classification.html#post-v1classifiednodesname) of the NC API docs.

However, note that the above query will only return classification data for nodes that are [statically pinned](./console_classes_groups.html#adding-nodes-statically) to node groups.

To get classification data for [dynamically grouped nodes](./console_classes_groups.html#adding-nodes-dynamically), a JSON object containing facts will need to be submitted during the POST request.

     curl -X POST -H 'Content-Type: application/json' \
     --data '{"fact":{"pe_version": "3.8.0"}}' \
     --cacert /etc/puppetlabs/puppet/ssl/certs/ca.pem \
     --cert /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.cert.pem \
     --key /opt/puppet/share/puppet-dashboard/certs/pe-internal-dashboard.private_key.pem \
     https://$(hostname -f):4433/classifier-api/v1/classified/nodes/<SOME NODE NAME> > node_classification.json

See the [classificatiopn portion](./nc_classification.html#post-v1classifiednodesname) of the NC API docs for more information on how to supply facts when making classification requests.

PostgreSQL is Taking Up Too Much Space
-----

PostgreSQL should have `autovacuum=on` set by default. If you're having memory issues from the database growing too large and unwieldy, make sure this setting did not get turned off. PE also includes a rake task for keeping the databases in good shape. The [console maintenance page](./maintain_console-db.html#optimizing-the-database) has the details.

PostgreSQL Buffer Memory Causes PE Install to Fail
-------

In some cases, when installing PE on machines with large amounts of RAM, the PostgreSQL database will use more shared buffer memory than is available and will not be able to start. This will prevent PE from installing correctly. The following error will be present in `/var/log/pe-postgresql/pgstartup.log`:

    FATAL: could not create shared memory segment: No space left on device
    DETAIL: Failed system call was shmget(key=5432001, size=34427584512,03600).

A suggested workaround is tweak the machine's `shmmax` and `shmall` kernel settings before installing PE. The `shmmax` setting should be set to approximately  50% of the total RAM; the `shmall` setting can be calculated by dividing the new `shmmax` setting by the PAGE_SIZE.  (`PAGE_SIZE` can be confirmed by running `getconf PAGE_SIZE`).

Use the following commands to set the new kernel settings:

    sysctl -w kernel.shmmax=<your shmmax calculation>
    sysctl -w kernel.shmall=<your shmall calculation>

Alternatively, you can also report the issue to the [Puppet Labs customer support portal](https://support.puppetlabs.com/access/unauthenticated).

PuppetDB's Default Port Conflicts with Another Service
-----

By default, PuppetDB communicates over port 8081. In some cases, this may conflict with existing services (e.g., McAfee's ePO). You can work around this issue by installing with an answer file that specifies a different port with `q_puppetdb_port`. For more information on using answer files, take a look at the [documentation for automated installs](./install_automated.html)


Recovering from a Lost Console Admin Password
-----

In RBAC, one of the built-in users is the admin, a superuser with all available read/write privileges. In the event you need to reset the admin password for console access, you'll have to run a utility script located in the [PE 3.8.0 installer tarball](http://puppetlabs.com/misc/pe-files). Note that the PE 3.8 tarball might have moved to the [previous releases page](http://puppetlabs.com/misc/pe-files/previous-releases).

This script uses a series of API calls authenticated with a whitelisted certificate to reset the built-in admin's password.

The script can only be invoked under these conditions:

* It must be run from the command line of the console system. In a split install, it cannot be run from the Puppet master.
* It is not directly executable. It must be invoked using the version of Ruby shipped with PE, using `/opt/puppet/bin/ruby`.
* A console-services whitelisted certificate must be specified in order to run the command. The example command below dynamically specifies the correct certificate.

The reset script:

    q_puppet_enterpriseconsole_auth_password=newpassword q_puppetagent_certname=$(puppet config print certname) /opt/puppet/bin/ruby update-superuser-password.rb


The script is not installed onto the system by default. The two environment arguments in the script come from the [installation answers file](./install_answer_file_reference.html), and have the same meaning and semantics.

Admins have root access to the systems and therefore access to the whitelisted certificates needed to reset the admin password through the API.

`Puppet resource` Generates Ruby Errors After Connecting `puppet apply` to PuppetDB
-----

Users who wish to use `puppet apply` (typically in deployments running masterless puppet), need to get it working with PuppetDB. If they do so by modifying `puppet.conf` to add the parameters `storeconfigs_backend = puppetdb` and `storeconfigs = true` in both the [main] and [master] sections), then `puppet resource` will cease to function and will display a Ruby run error. To avoid this, the correct way to get `puppet apply` connected to PuppetDB is to modify `/etc/puppetlabs/puppet/routes.yaml ` to correctly define the behavior of `puppet apply` without affecting other functions. The PuppetDB manual has [complete information and code samples](/puppetdb/1.6/connect_puppet_apply.html).

The Console Has Too Many Pending Tasks
-----

The console either does not have enough worker processes, or the worker processes have died and need to be restarted.

* [See here to restart the worker processes](./maintain_console-db.html#restarting-the-background-tasks)
* [See here to tune the number of worker processes](./console_config.html#fine-tuning-the-delayedjob-queue)

Old "Pending Tasks" Never Expire
-----

In earlier versions of PE 3.x, failed delayed jobs did not get properly deleted. If a report for a job failed to upload (due to a problem with the report itself), a pending task would be displayed in the console in perpetuity. This has been fixed in PE 3.1. The __Background Tasks__ pane in the console (upper left corner) now displays a red alert icon when a report fails to upload. Clicking the icon displays a view with information about the failure and a backtrace. You can stop the reports from showing the alert by marking them as read with the __Mark all as read__ button.

Note, however, that this will not remove old failed/delayed jobs. You can clean these out by running `/opt/puppet/bin/bundle exec rails runner 'Delayed::Job.delete_all("attempts >= 3")'` on the console node. This command should be run from `/opt/puppet/share/puppet-dashboard`.

Correcting Broken URLs in the Console
----------------

Starting with PE 3.0 and later, group names with periods in them (e.g., group.name) will generate a "page doesn't exist" error. To remove broken groups, you can use the following nodegroup:del rake task:

        $ sudo /opt/puppet/bin/rake -f /opt/puppet/share/puppet-dashboard/Rakefile RAILS_ENV=production nodegroup:del name={bad.group.name.here}

After you remove the broken group names, you can create new groups with valid names and re-add your nodes as needed.

Running a 3.x Master with 2.8.x Agents is not Supported
----------

3.x versions of PE contain changes to the MCollective module that are not compatible with 2.8.x agents. When running a 3.x master with a 2.8.x agent, it is possible that Puppet will still continue to run and check into the console, but this means Puppet is running in a degraded state that is not supported.

* * *

- [Next: Troubleshooting Orchestration](./trouble_orchestration.html)
