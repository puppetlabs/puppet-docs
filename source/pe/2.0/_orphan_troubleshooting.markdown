---
layout: default
title: "PE 2.0 Manual: Troubleshooting"
---

{% include pe_2.0_nav.markdown %}

Troubleshooting
===============


This document explains several common problems that can prevent a Puppet Enterprise site from working as expected. Additional troubleshooting information can be found at the [main Puppet documentation site](http://docs.puppetlabs.com), on the [Puppet Users mailing list](https://groups.google.com/group/puppet-users), and in `#puppet` on freenode.net. 

Furthermore, please feel free to contact Puppet Labs' enterprise technical support:

* To file a support ticket, go to [support.puppetlabs.com](http://support.puppetlabs.com). 
* To reach our support staff via email, contact <support@puppetlabs.com>.
* To speak directly to our support staff, call 1-877-575-9775.

When reporting issues with the installer itself, please run the installer using the `-D` debugging flag and provide a transcript of the installer's output along with your description of the problem. 


## Miscellaneous Issues and Additional Tasks

### Dashboard Has a Very Large Number of Pending Background Tasks

Background tasks are processed by worker processes, which can sometimes die and leave invalid PID files. To restart the worker tasks, run:

    # sudo /etc/init.d/pe-puppet-dashboard-workers restart

This should immediately start reducing the number of pending tasks.

### Change The Port Used By Puppet Dashboard

If you chose to use port 3000 when you installed Puppet Dashboard but later decide you want to use port 80 (or any other port), you will need to stop the `pe-httpd` service and make the following changes: 

* In `/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf`, change the `Listen 3000` and `<VirtualHost *:3000>` directives to use port 80. 
* In `/etc/puppetlabs/puppet/puppet.conf`, change the `reporturl` setting to use your preferred port instead of port 3000.
* In `/etc/puppetlabs/puppet-dashboard/external_node`, change the `BASE="http://localhost:3000"` line to use your preferred port instead of port 3000. 
* Allow access to the new port in your system's firewall rules.

After making these changes, start the `pe-httpd` service again.

### Import Existing Reports Into Puppet Dashboard

If you are upgrading to PE from a self-maintained Puppet environment, you can add value to your older reports by importing the reports into Puppet Dashboard. To run the report importer, first locate the reports directory on your previous puppet master (`puppet master --configprint reportdir`) and copy it to the server running Puppet Dashboard. Then, on the Dashboard server, run the following commands with root privileges: 


included stored reports on the puppet master (that is, if agent nodes were configured with `report = true` and the master was configured with `reports = store`),  can add value to this existing knowledge. 


	cd /opt/puppet/share/puppet-dashboard
	PATH=/opt/puppet/bin:$PATH REPORT_DIR={old reports directory} rake reports:import

If you have a significant number of existing reports, this task can take some time, so plan accordingly.

