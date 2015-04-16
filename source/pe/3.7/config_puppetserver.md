---
layout: default
title: "PE 3.7 » Configuration"
subtitle: "Configuring & Tuning Puppet Server"
canonical: "/pe/latest/config_puppetserver.html"
---

We recommend tuning the following settings as needed to improve the performance of your Puppet Server. 

### Tuning JRuby on Puppet Server 

This setting controls the maximum number of JRuby instances to allow on the Puppet Server. The default used in PE 3.7 is the number of CPUs + 2, which is expressed as `$::processorcount` + 2.

For servers with high numbers of CPUs, this default can lead to an over-provisioning of JRuby processes. Each process consumes resources such as RAM, CPU time and open files (controlled by ulimits). With too many JRuby processes, Puppet Server may behave inefficiently or consume more than the available amount of resources.

To increase or decrease the number of JRuby instances, you need to edit your Hiera default `.yaml` file, and tune the `jruby_max_active_instances` by setting the following code:

	puppet_enterprise::master::puppetserver::jruby_max_active_instances: <number of instances>

> **Note**: This setting is only available in PE 3.7.2 and later. 

### Tuning `max threads` on Puppet Server

This sets the maximum number of threads assigned to respond to HTTP and HTTPS requests, effectively changing how many concurrent requests can be made to Puppet Server at one time. The default setting is 100 max threads. This should be increased to 150 max threads for nodes where `$::processorcount` is greater than 32.

To increase the max threads, edit your Hiera default `.yaml` file with the following code:

         puppet_enterprise::master::puppetserver::tk_jetty_max_threads: <number of max threads>

> **Note**: This setting is only available in PE 3.7.2 and later.

### Increasing the ulimit for the `pe-puppet` User
The ulimit controls the number of processes and file handles that the `pe-puppet` user can open/process. To increase the ulimit for the `pe-puppet` user, edit `/etc/security/limits.conf` so that it contains the following: 

     pe-puppet hard	nofile      65535
  
### Tuning Java Args for Puppet Server

You can increase the JVM (Java Virtual Machine) memory that is allocated to Java services running on Puppet Server. This memory allocation is known as the Java heap size.

Instructions for using the PE console to increase the Java heap size are detailed on on the [Configuring Java Arguments for PE](./config_java_args.html#pe-puppet-server-service) page. 

