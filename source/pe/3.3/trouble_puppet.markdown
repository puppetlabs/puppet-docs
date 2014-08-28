---
layout: default
title: "PE 3.3 » Troubleshooting Puppet  Core » "
subtitle: "Tips & Solutions for Working with Puppet"
canonical: "/pe/latest/trouble_puppet.html"
---

Troubleshooting Puppet Core
-----

### Manifest Compilation and Other Puppet Code Issues with UTF-8 encoding

PE 3 uses an updated version of Ruby, 1.9, that is much stricter about character encodings than the version of Ruby used in PE 2.8. As a result, puppet code that contains non-ASCII characters can fail or act unpredictably. There are a number of ways UTF-8 characters can make it into puppet code, including but not limited to downloading a Forge module where some piece of metadata (e.g. author's name) contains UTF-8 characters. With apologies to our international customers, the current solution is to strictly limit puppet code, including metadata, to the ASCII character set. The only exception is puppet manifest comments, which do support non-ASCII characters. Puppet Labs is working on resolving character encoding issues in Puppet and the various libraries it interfaces with.

### Improving Profiling and Debugging of Slow Catalog Compilations

You can get the puppet master to log additional debug-level messages about how much time each step of its catalog compilation takes by setting `profile` to `true` in an agent's puppet.conf file (or specify `--profile` on the CLI). 

If you're trying to profile, be sure to check the `--logdest` and `--debug` command-line options on the master --- debug must be on, and messages will go to the log destination, which defaults to syslog. If you're running via Passenger or another Rack server, these options must be set as command-line arguments in the config.ru file and not as settings in puppet.conf. The config.ru file for Puppet Enterprise, located at `/var/opt/lib/pe-puppetmaster/config.ru`, contains a commented set of example arguments that enable profiling.

To find the messages, look for the string `PROFILE` in the master's logs --- each catalog request will get a unique ID, so you can tell which messages are for which request. Ensure syslog is configured to record messages logged at debug priority when used as the log destination.

### Increase `PassengerMaxPoolSize` to Decrease Response Times on Node Requests

In some cases, if you perform frequent puppet runs or manage a large number of nodes, Passenger may get backed up with requests. If this happens, you may see some agents reporting a `Could not retrieve catalog from remote server:execution expired` error. To determine if this is indeed a passenger issue, run `/opt/puppet/bin/passenger-status`, and check `Requests in top-level queue`. If this number is significantly higher than the number of workers you have, you may need to increase the `PassengerMaxPoolSize`.  

To increase the `PassengerMaxPoolSize`, navigate to `/etc/puppetlabs/httpd/conf.d/passenger-extra.conf`, and increase that setting as needed. You must then restart the pe-httpd service by running `sudo /etc/init.d/pe-httpd restart`.


* * * 

-  [Next: Orchestration Overview](./orchestration_overview.html)
