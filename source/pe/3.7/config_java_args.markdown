---
layout: default
title: "PE 3.7 » Configuration »  Java Arguments"
subtitle: "Configuring Java Arguments For PE"
canonical: "/pe/latest/config_java_args.html"
---

## Increasing the Java Heap Size For PE Java Services

This section provides instructions for increasing the JVM (Java Virtual Machine) memory that is allocated to Java services in Puppet Enterprise (PE). This memory allocation is known as the Java heap size. It can be adjusted through the PE console as described below. 

> **Are you upgrading from an earlier version?** This page assumes that you have the preconfigured node groups that come by default with PE 3.7. If you are upgrading from an earlier version of PE and do not have the preconfigured groups, see [Preconfigured Node Groups](./console_classes_groups_preconfigured_groups.html).


### PE Console Service

> **Note:** Ensure that you have sufficient free memory before increasing the memory that is used by a PE service. The increase shown below is only an example.

**To increase the Java heap size for `pe-console-services`**:

1. From the console, navigate to the **Classification** page and select the **PE Console** node group.
2. Click **Classes** and scroll down to the `puppet_enterprise::profile::console` class. 
3. Click the **Parameter name** drop-down list and select `java_args`. Replace the parameter value with the JSON string `{"Xmx": "512m", "Xms": "512m"}`. This increases the heap size from the default of 256 MB to 512 MB.
4. Click **Add Parameter**, and then click the commit button.
5. In the command line on the console node, run `puppet agent -t` to start a Puppet run and apply the change. The console will be unavailable briefly while `pe-console-services` restarts.

### PE Puppet Server Service

> **Note:** Ensure that you have sufficient free memory before increasing the memory that is used by a PE service. The increase shown below is only an example.

**To increase the Java heap size for `pe-puppetserver`**:

1. From the console, navigate to the **Classification** page and select the **PE Master** node group.
2. Click **Classes** and scroll down to the `puppet_enterprise::profile::master` class. 
3. Click the **Parameter name** drop-down list and select `java_args`. Replace the parameter value with the JSON string `{"Xmx": "4096m", "Xms": "4096m"}`. This increases the heap size from the default of 2 GB to 4 GB. 
4. In the command line on each compile master, run `puppet agent -t` to start a Puppet run and apply the change.

### PuppetDB

> **Note:** Ensure that you have sufficient free memory before increasing the memory that is used by a PuppetDB. The increase shown below is only an example.

**To increase the Java heap size for PuppetDB**:

1. From the console, navigate to the **Classification** page and select the **PE PuppetDB** node group.
2. Click **Classes** and scroll down to the `puppet_enterprise::profile::puppetdb` class. 
3. Click the **Parameter name** drop-down list and select `java_args`. Replace the parameter value with the JSON string `{"Xmx": "512m", "Xms": "512m"}`. This increases the heap size from the default of 256 MB to 512 MB.
4. Click **Add Parameter**, and then click the commit button.
5. In the command line on the PuppetDB node, run `puppet agent -t` to start a Puppet run and apply the change.

### ActiveMQ Heap Usage (Puppet master Only)

The Puppet master runs an ActiveMQ server to route orchestration commands. By default, its process uses a Java heap size of 512 MB. This is the best value for mid-sized deployments, but can be a problem when building small proof-of-concept deployments on memory-starved VMs. This example provides instructions on increasing the heap size to 1024 MB.

> **Note:** Ensure that you have sufficient free memory before increasing the memory that is used by ActiveMQ. The increase shown below is only an example.

**To increase the ActiveMQ heap size**:

1. From the console, navigate to the **Classification** page and select the PE **ActiveMQ Broker** group.
2. Click **Classes** and locate the `puppet_enterprise::profile::amq::broker` class.
3. Click the **Parameter name** drop-down list, select `heap_mb`, and in the __value__ field, add a new heap size of 1024.
4. Click **Add Parameter**, and then click the commit button.
5. In the command line on the Puppet maseter node, run `puppet agent -t` to start a Puppet run and apply the change.


You can later delete the variable to revert to the default setting.
 


* * *

- [Next: Accessing the Console ](./console_accessing.html)