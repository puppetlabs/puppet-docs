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

To increase the Java heap size for `pe-console-services`:

1. From the console, navigate to the **Classification** page and select the **PE Console** node group.
2. Click **Classes** and scroll down to the `puppet_enterprise::profile::console` class. 
3. Click the **Parameter name** drop-down list and select `java_args`. Replace the parameter value with the JSON string `{"Xmx": "512m", "Xms": "512m"}`. This increases the heap size from the default of 256 MB to 512 MB.
4. Click **Add Parameter**, and then click the commit button.
5. In the command line on the console node, run `puppet agent -t` to start a Puppet run and apply the change. The console will be unavailable briefly while `pe-console-services` restarts.

### PE Puppet Server Service

> **Note:** Ensure that you have sufficient free memory before increasing the memory that is used by a PE service. The increase shown below is only an example.

To increase the Java heap size for `pe-puppetserver`:

1. From the console, navigate to the **Classification** page and select the **PE Master** node group.
2. Click **Classes** and scroll down to the `puppet_enterprise::profile::master` class. 
3. Click the **Parameter name** drop-down list and select `java_args`. Replace the parameter value with the JSON string `{"Xmx": "4096m", "Xms": "4096m"}`. This increases the heap size from the default of 2 GB to 4 GB. 
4. In the command line on each compile master, run `puppet agent -t` to start a Puppet run and apply the change.

* * *

- [Next: Accessing the Console ](./console_accessing.html)