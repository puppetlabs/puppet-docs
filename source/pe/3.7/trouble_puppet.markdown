---
layout: default
title: "PE 3.7 » Troubleshooting Puppet  Core » "
subtitle: "Tips & Solutions for Working with Puppet"
canonical: "/pe/latest/trouble_puppet.html"
---

Troubleshooting Puppet Core
-----

### Improving Profiling and Debugging of Slow Catalog Compilations

You can get the Puppet master to log additional debug-level messages about how much time each step of its catalog compilation takes by setting `profile` to `true` in an agent's puppet.conf file (or specify `--profile` on the CLI). 

If you’re trying to profile, be sure to check the `--logdest` and `--debug` options on the master — debug must be on, and messages will go to the log destination, which defaults to syslog. If you’re running via Passenger or another Rack server, these options will be set in the config.ru file.

To find the messages, look for the string PROFILE in the master’s logs — each catalog request will get a unique ID, so you can tell which messages are for which request.

### Increase `PassengerMaxPoolSize` to Decrease Response Times on Node Requests

In some cases, if you perform frequent Puppet runs or manage a large number of nodes, Passenger may get backed up with requests. If this happens, you may see some agents reporting a `Could not retrieve catalog from remote server:execution expired` error. To determine if this is indeed a passenger issue, run `/opt/puppet/bin/passenger-status`, and check `Requests in top-level queue`. If this number is significantly higher than the number of workers you have, you may need to increase the `PassengerMaxPoolSize`.  

To increase the `PassengerMaxPoolSize`, navigate to `/etc/puppetlabs/httpd/conf.d/passenger-extra.conf`, and increase that setting as needed. You must then restart the pe-httpd service by running `sudo /etc/init.d/pe-httpd restart`.


* * * 

-  [Next: Orchestration Overview](./orchestration_overview.html)
