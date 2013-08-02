---
layout: default
title: "PE 3.0 » Troubleshooting Puppet  Core » "
subtitle: "Tips & Solutions for Working with Puppet"
canonical: "/pe/latest/trouble_puppet.html"
---

Troubleshooting Puppet Core
-----

### Manifest Compilation and Other Puppet Code Issues with UTF-8 encoding
PE 3 uses an updated version of Ruby, 1.9, that is much stricter about character encodings than the version of Ruby used in PE 2.8. As a result, puppet code that contains UTF-8 characters such as accents or other non-ASCII characters can fail or act unpredictably. There are a number of ways UTF-8 characters can make it into puppet code, including, but not limited to, downloading a Forge module where some piece of metadata (e.g., author's name) contains UTF-8 characters. With apologies to our international customers, the current solution is to strictly limit puppet code to the ASCII character set only, including any code comments or metadata. Puppet Labs is working on cleaning up character encoding issues in Puppet and the various libraries it interfaces with.

### Improving Profiling and Debugging of Slow Catalog Compilations

You can get the puppet master to log additional debug-level messages about how much time each step of its catalog compilation takes by setting `profile` to `true` in an agent's puppet.conf file (or specify `--profile` on the CLI). 

If you’re trying to profile, be sure to check the `--logdest` and `--debug` options on the master — debug must be on, and messages will go to the log destination, which defaults to syslog. If you’re running via Passenger or another Rack server, these options will be set in the config.ru file.

To find the messages, look for the string PROFILE in the master’s logs — each catalog request will get a unique ID, so you can tell which messages are for which request.


* * * 

-  [Next: Orchestration Overview](./orchestration_overview.html)
