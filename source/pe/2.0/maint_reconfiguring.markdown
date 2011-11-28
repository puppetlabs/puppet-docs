---
layout: pe2experimental
title: "PE 2.0 » Maintenance and Troubleshooting » Reconfiguring PE"
---

Reconfiguring Complex Settings
=====

During installation, you make several major decisions that affect the way Puppet Enterprise works. Several of these decisions can be changed after the fact. 

Changing the Console's Port
-----

By default, a new installation of PE will serve the console on port 443. However, previous versions of PE served the console's predecessor on port 3000. If you upgraded and want to change to the more convenient new default, or if you need port 443 for something else and want to shift the console somewhere else, perform the following steps:

* Stop the `pe-httpd` service:

        $ sudo /etc/init.d/pe-httpd stop
* Edit `/etc/puppetlabs/httpd/conf.d/puppetdashboard.conf`, and change the port number in the `Listen 443` and `<VirtualHost *:443>` directives. (These directives will contain the current port, which is not necessarily 443.)
* Edit `/etc/puppetlabs/puppet/puppet.conf`, and change the `reporturl` setting to use your preferred port.
* Edit `/etc/puppetlabs/puppet-dashboard/external_node`, and change the `ENC_BASE_URL` to use your preferred port. 
* Make sure to allow access to the new port in your system's firewall rules.
* Start the `pe-httpd` service:

        $ sudo /etc/init.d/pe-httpd start


