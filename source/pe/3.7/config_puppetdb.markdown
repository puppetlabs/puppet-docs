---
layout: default
title: "PE 3.8 » Configuration"
subtitle: "Configuring & Tuning PuppetDB"
canonical: "/pe/latest/config_PuppetDB.html"
---

We recommend tuning the following settings as needed to improve the performance of PuppetDB.

### Java Args

You can increase the JVM (Java Virtual Machine) memory that is allocated to Java services running on PuppetDB. This memory allocation is known as the Java heap size.

Instructions for using the PE console to increase the Jave heap size are detailed on on the [Configuring Java Arguments for PE](/config_java_args.html#pe-console-service) page.

### Tuning `max threads` for PuppetDB
This sets the maximum number of threads assigned to respond to HTTP and HTTPS requests, effectively changing how many concurrent requests can be made to the PuppetDB at one time. The default setting is 100 max threads. This setting should be increased to 150 max threads for nodes where `$::processorcount` is greater than 32.

To increase the max threads for the PE console and console API, edit your Hiera default `.yaml` file with the following code:

puppet_enterprise::puppetdb::jetty_ini::tk_jetty_max_threads: 150

> **Note**: This setting is only available in PE 3.7.2 and later.
