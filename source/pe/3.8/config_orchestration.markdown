---
layout: default
title: "PE 3.8 » Configuration"
subtitle: "Configuring & Tuning Orchestration"
canonical: "/pe/latest/config_orchestration.html"
---

We recommend tuning the following settings as needed to improve the performance of the PE orchestration tools (i.e., ActiveMQ and MCollective).

### Tuning ActiveMQ Heap Usage

The Puppet master runs an ActiveMQ server to route orchestration commands. You can increase the JVM (Java Virtual Machine) memory that is allocated to Java services running on the Puppet master. This memory allocation is known as the Java heap size.

Instructions for using the PE console to increase the Java heap size are detailed on on the [Configuring Java Arguments for PE](./config_java_args.html#pe-puppet-server-service) page.


### Increasing the ulimit for the `pe-activemq` User

The ulimit controls the number of processes and file handles that the `pe-activemq` user can open/process. To increase the ulimit for the `pe-activemq` user, edit `/etc/security/limits.conf` so that it contains the following:

    pe-activemq   soft     nproc  8192
    pe-activemq   hard     nproc  8192
    pe-activemq   soft     nofile 16384
    pe-activemq   hard     nofile 16384

### Additional Orchestration Config Settings

See [Configuring Orchestration](./orchestration_config.html) for additional Orchestration config settings.